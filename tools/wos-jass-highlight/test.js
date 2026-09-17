const assert = require("assert");
const fs = require("fs");
const path = require("path");
const Module = require("module");

const originalLoad = Module._load;
Module._load = function load(request, parent, isMain) {
    if (request === "vscode") return {};
    return originalLoad(request, parent, isMain);
};

const { extractFunctions, findCallAtPosition } = require("./extension");

const root = path.resolve(__dirname, "..", "..");
const systems1 = fs.readFileSync(path.join(root, "triggers", "Systems", "Systems1.j"), "utf8");
const systems2 = fs.readFileSync(path.join(root, "triggers", "Systems", "Systems2.j"), "utf8");
const definitions = [
    ...extractFunctions(systems1, {}, "triggers/Systems/Systems1.j"),
    ...extractFunctions(systems2, {}, "triggers/Systems/Systems2.j")
];

assert.strictEqual(definitions.length, 417);
assert.strictEqual(
    definitions.find(definition => definition.name === "SR3").signature,
    "function SR3 takes unit c, real x2, real y2 returns real"
);
assert.ok(definitions.some(definition =>
    definition.name === "Add" && definition.parameters.length === 9
));

const names = new Map(definitions.map(definition => [definition.name, [definition]]));
const sample = "set distance = SR3(c, x, y";
const document = {
    offsetAt: () => sample.length,
    getText: () => sample
};

assert.deepStrictEqual(
    findCallAtPosition(document, {}, names),
    { name: "SR3", activeParameter: 2 }
);

console.log("OK: 417 declarations parsed; SR3 and multiline methods are indexed.");
