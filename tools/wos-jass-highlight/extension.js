const vscode = require("vscode");

const DEFAULT_SYSTEM_FILES = [
    "triggers/Systems/Systems1.j",
    "triggers/Systems/Systems2.j"
];

let decorationType;
let statusBar;
let output;
let systemFunctions = new Map();
let fileWatchers = [];
let scanTimer;

function getConfig() {
    const config = vscode.workspace.getConfiguration("wosJassHighlight");
    return {
        systemFiles: config.get("systemFiles", DEFAULT_SYSTEM_FILES),
        color: config.get("color", "#4EC950")
    };
}

function normalizePath(value) {
    return value.replace(/\\/g, "/").toLowerCase();
}

function isJassDocument(document) {
    return document && (
        document.languageId === "jass" ||
        /\.(?:j|jass)$/i.test(document.uri.fsPath)
    );
}

function isSystemDocument(document) {
    if (!document || document.uri.scheme !== "file") {
        return false;
    }

    const documentPath = normalizePath(document.uri.fsPath);
    return getConfig().systemFiles.some(relativePath =>
        documentPath.endsWith("/" + normalizePath(relativePath))
    );
}

function createDecoration() {
    if (decorationType) {
        decorationType.dispose();
    }

    decorationType = vscode.window.createTextEditorDecorationType({
        color: getConfig().color,
        fontWeight: "bold",
        rangeBehavior: vscode.DecorationRangeBehavior.ClosedClosed
    });
}

function extractFunctions(text, uri, relativePath) {
    const result = [];
    const declaration = /^[ \t]*(?:(?:private|public|static|stub|constant|readonly)[ \t]+)*(function|method)[ \t]+([A-Za-z_][A-Za-z0-9_]*)[ \t]+takes[ \t]+([\s\S]*?)[ \t]+returns[ \t]+([A-Za-z_][A-Za-z0-9_]*)(?:[ \t]*\/\/[ \t]*(.*))?[ \t\r]*$/gmi;
    let match;

    while ((match = declaration.exec(text)) !== null) {
        const name = match[2];
        const declarationStart = match.index;
        const lineNumber = (text.slice(0, declarationStart).match(/\n/g) || []).length;
        const firstLine = match[0].split(/\r?\n/, 1)[0];
        const nameStart = firstLine.indexOf(name);
        const takes = match[3]
            .replace(/\/\*[\s\S]*?\*\//g, " ")
            .replace(/\s+/g, " ")
            .trim();
        const parameters = takes.toLowerCase() === "nothing"
            ? []
            : takes.split(",").map(parameter => parameter.trim());
        const signature = match[0]
            .replace(/\s*\/\/[^\r\n]*/, "")
            .replace(/\/\*[\s\S]*?\*\//g, " ")
            .replace(/\s+/g, " ")
            .trim();

        result.push({
            name,
            kind: match[1].toLowerCase(),
            signature,
            parameters,
            returns: match[4],
            description: (match[5] || "").trim(),
            uri,
            relativePath,
            line: lineNumber,
            character: Math.max(0, nameStart)
        });
    }

    return result;
}

async function readSystemFile(uri) {
    const openDocument = vscode.workspace.textDocuments.find(
        document => document.uri.toString() === uri.toString()
    );

    if (openDocument) {
        return openDocument.getText();
    }

    const data = await vscode.workspace.fs.readFile(uri);
    return Buffer.from(data).toString("utf8");
}

async function scanSystemFiles() {
    const nextFunctions = new Map();
    const config = getConfig();
    const folders = vscode.workspace.workspaceFolders;

    if (!folders || folders.length === 0) {
        systemFunctions = nextFunctions;
        statusBar.text = "WOS JASS: NO WORKSPACE";
        statusBar.show();
        return;
    }

    output.clear();
    output.appendLine("=== WOS JASS Highlight ===");

    for (const folder of folders) {
        for (const relativePath of config.systemFiles) {
            const parts = relativePath.replace(/\\/g, "/").split("/");
            const uri = vscode.Uri.joinPath(folder.uri, ...parts);

            try {
                const text = await readSystemFile(uri);
                const found = extractFunctions(text, uri, relativePath);
                output.appendLine(`${relativePath}: ${found.length} declarations`);

                for (const definition of found) {
                    const definitions = nextFunctions.get(definition.name) || [];
                    definitions.push(definition);
                    nextFunctions.set(definition.name, definitions);
                }
            } catch (error) {
                output.appendLine(`${relativePath}: ERROR: ${String(error)}`);
            }
        }
    }

    systemFunctions = nextFunctions;
    statusBar.text = `$(symbol-function) WOS: ${systemFunctions.size}`;
    statusBar.tooltip = `${systemFunctions.size} system functions loaded`;
    statusBar.show();
    refreshAllEditors();
}

function scheduleScan(delay = 120) {
    if (scanTimer) {
        clearTimeout(scanTimer);
    }
    scanTimer = setTimeout(() => {
        scanTimer = undefined;
        scanSystemFiles();
    }, delay);
}

function getRanges(document) {
    const ranges = [];
    const regex = /\b[A-Za-z_][A-Za-z0-9_]*\b/g;
    const text = document.getText();
    let match;

    while ((match = regex.exec(text)) !== null) {
        if (!systemFunctions.has(match[0])) {
            continue;
        }

        ranges.push(new vscode.Range(
            document.positionAt(match.index),
            document.positionAt(match.index + match[0].length)
        ));
    }

    return ranges;
}

function updateEditor(editor) {
    if (!editor || !isJassDocument(editor.document)) {
        return;
    }
    editor.setDecorations(decorationType, getRanges(editor.document));
}

function refreshAllEditors() {
    for (const editor of vscode.window.visibleTextEditors) {
        updateEditor(editor);
    }
}

function getWord(document, position) {
    const range = document.getWordRangeAtPosition(position, /[A-Za-z_][A-Za-z0-9_]*/);
    if (!range) {
        return undefined;
    }
    return { range, name: document.getText(range) };
}

function definitionMarkdown(definition) {
    const markdown = new vscode.MarkdownString();
    markdown.appendMarkdown("**WOS system function**\n\n");
    markdown.appendCodeblock(definition.signature, "jass");
    if (definition.description) {
        markdown.appendMarkdown(`\n${definition.description}\n`);
    }
    markdown.appendMarkdown(`\nSource: \`${definition.relativePath}:${definition.line + 1}\``);
    return markdown;
}

class SystemHoverProvider {
    provideHover(document, position) {
        const word = getWord(document, position);
        const definitions = word && systemFunctions.get(word.name);
        if (!definitions || definitions.length === 0) {
            return undefined;
        }

        return new vscode.Hover(
            definitions.map(definitionMarkdown),
            word.range
        );
    }
}

class SystemDefinitionProvider {
    provideDefinition(document, position) {
        const word = getWord(document, position);
        const definitions = word && systemFunctions.get(word.name);
        if (!definitions) {
            return undefined;
        }

        return definitions.map(definition => new vscode.Location(
            definition.uri,
            new vscode.Position(definition.line, definition.character)
        ));
    }
}

class SystemCompletionProvider {
    provideCompletionItems() {
        const items = [];

        for (const [name, definitions] of systemFunctions) {
            const definition = definitions[0];
            const item = new vscode.CompletionItem(
                name,
                definition.kind === "method"
                    ? vscode.CompletionItemKind.Method
                    : vscode.CompletionItemKind.Function
            );
            item.detail = definition.signature;
            item.documentation = definitionMarkdown(definition);
            item.sortText = `0_${name}`;
            items.push(item);
        }

        return items;
    }
}

function findCallAtPosition(document, position, availableFunctions = systemFunctions) {
    const offset = document.offsetAt(position);
    const text = document.getText().slice(0, offset);
    let depth = 0;

    for (let index = text.length - 1; index >= 0; index -= 1) {
        const character = text[index];
        if (character === ")") {
            depth += 1;
        } else if (character === "(") {
            if (depth > 0) {
                depth -= 1;
                continue;
            }

            const before = text.slice(0, index);
            const nameMatch = /([A-Za-z_][A-Za-z0-9_]*)\s*$/.exec(before);
            if (!nameMatch || !availableFunctions.has(nameMatch[1])) {
                return undefined;
            }

            const argumentText = text.slice(index + 1);
            let nested = 0;
            let activeParameter = 0;
            for (const argumentCharacter of argumentText) {
                if (argumentCharacter === "(") nested += 1;
                else if (argumentCharacter === ")") nested = Math.max(0, nested - 1);
                else if (argumentCharacter === "," && nested === 0) activeParameter += 1;
            }

            return { name: nameMatch[1], activeParameter };
        }
    }

    return undefined;
}

class SystemSignatureHelpProvider {
    provideSignatureHelp(document, position) {
        const call = findCallAtPosition(document, position);
        const definitions = call && systemFunctions.get(call.name);
        if (!definitions || definitions.length === 0) {
            return undefined;
        }

        const help = new vscode.SignatureHelp();
        help.activeSignature = 0;
        help.activeParameter = call.activeParameter;
        help.signatures = definitions.map(definition => {
            const signature = new vscode.SignatureInformation(
                definition.signature,
                definition.description || `From ${definition.relativePath}`
            );
            signature.parameters = definition.parameters.map(
                parameter => new vscode.ParameterInformation(parameter)
            );
            return signature;
        });
        return help;
    }
}

function disposeWatchers() {
    for (const watcher of fileWatchers) {
        watcher.dispose();
    }
    fileWatchers = [];
}

function createWatchers() {
    disposeWatchers();
    const folders = vscode.workspace.workspaceFolders || [];

    for (const folder of folders) {
        for (const relativePath of getConfig().systemFiles) {
            const watcher = vscode.workspace.createFileSystemWatcher(
                new vscode.RelativePattern(folder, relativePath.replace(/\\/g, "/"))
            );
            watcher.onDidChange(() => scheduleScan());
            watcher.onDidCreate(() => scheduleScan());
            watcher.onDidDelete(() => scheduleScan());
            fileWatchers.push(watcher);
        }
    }
}

async function activate(context) {
    output = vscode.window.createOutputChannel("WOS JASS Highlight");
    statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
    statusBar.text = "WOS JASS: loading...";
    statusBar.show();

    context.subscriptions.push(output, statusBar);
    createDecoration();
    createWatchers();
    await scanSystemFiles();

    const selector = [
        { language: "jass" },
        { scheme: "file", pattern: "**/*.j" },
        { scheme: "file", pattern: "**/*.jass" }
    ];

    context.subscriptions.push(
        vscode.languages.registerHoverProvider(selector, new SystemHoverProvider()),
        vscode.languages.registerDefinitionProvider(selector, new SystemDefinitionProvider()),
        vscode.languages.registerCompletionItemProvider(selector, new SystemCompletionProvider()),
        vscode.languages.registerSignatureHelpProvider(
            selector,
            new SystemSignatureHelpProvider(),
            "(",
            ","
        ),
        vscode.commands.registerCommand("wosJassHighlight.refresh", scanSystemFiles),
        vscode.window.onDidChangeActiveTextEditor(updateEditor),
        vscode.window.onDidChangeVisibleTextEditors(refreshAllEditors),
        vscode.workspace.onDidChangeTextDocument(event => {
            if (isSystemDocument(event.document)) {
                scheduleScan();
            }
            for (const editor of vscode.window.visibleTextEditors) {
                if (editor.document === event.document) {
                    updateEditor(editor);
                }
            }
        }),
        vscode.workspace.onDidSaveTextDocument(document => {
            if (isSystemDocument(document)) {
                scheduleScan(0);
            }
        }),
        vscode.workspace.onDidChangeConfiguration(event => {
            if (!event.affectsConfiguration("wosJassHighlight")) {
                return;
            }
            createDecoration();
            createWatchers();
            scheduleScan(0);
        }),
        vscode.workspace.onDidChangeWorkspaceFolders(() => {
            createWatchers();
            scheduleScan(0);
        }),
        { dispose: disposeWatchers }
    );
}

function deactivate() {
    if (scanTimer) clearTimeout(scanTimer);
    if (decorationType) decorationType.dispose();
    disposeWatchers();
}

module.exports = {
    activate,
    deactivate,
    extractFunctions,
    findCallAtPosition
};
