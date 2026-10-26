var File = Java.type('java.io.File');
var System = Java.type('java.lang.System');
var ImageIO = Java.type('javax.imageio.ImageIO');
var IIOImage = Java.type('javax.imageio.IIOImage');
var ImageWriteParam = Java.type('javax.imageio.ImageWriteParam');
var BufferedImage = Java.type('java.awt.image.BufferedImage');
var RenderingHints = Java.type('java.awt.RenderingHints');
var AlphaComposite = Java.type('java.awt.AlphaComposite');
var BLPEncodingType = Java.type('com.hiveworkshop.blizzard.blp.BLPEncodingType');
var ImageWriter = Java.type('javax.imageio.ImageWriter');
var ImageWriterSpi = Java.type('javax.imageio.spi.ImageWriterSpi');

function alphaRange(image) {
    var min = 255, max = 0;
    for (var y = 0; y < image.getHeight(); y++) {
        for (var x = 0; x < image.getWidth(); x++) {
            var a = (image.getRGB(x, y) >>> 24) & 255;
            if (a < min) min = a;
            if (a > max) max = a;
        }
    }
    return { min: min, max: max };
}

ImageIO.scanForPlugins();
var sourceFile = new File(System.getProperty('wos.input'));
var targetFile = new File(System.getProperty('wos.output'));
var targetWidth = parseInt(System.getProperty('wos.width'), 10);
var targetHeight = parseInt(System.getProperty('wos.height'), 10);
var source = ImageIO.read(sourceFile);
if (source == null) throw new Error('Не удалось декодировать BLP: ' + sourceFile);
var sourceAlphaStats = alphaRange(source);
var sourceAlpha = sourceAlphaStats.min + '..' + sourceAlphaStats.max;

// Premultiplied alpha не даёт цвету из прозрачного края растекаться при уменьшении.
var premultiplied = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_ARGB_PRE);
var graphics = premultiplied.createGraphics();
graphics.setComposite(AlphaComposite.Src);
graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
graphics.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
graphics.drawImage(source, 0, 0, targetWidth, targetHeight, null);
graphics.dispose();

// Кодировщик BLP ожидает обычный ARGB. Переводим обратно уже после
// корректного alpha-aware уменьшения, иначе полупрозрачные цвета темнеют.
var resized = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_ARGB);
var straightPixels = premultiplied.getRGB(0, 0, targetWidth, targetHeight, null, 0, targetWidth);
resized.setRGB(0, 0, targetWidth, targetHeight, straightPixels, 0, targetWidth);

// Мягкий вариант края полезен для части старых эффектов: он подавляет цветовой
// ореол возле почти прозрачных пикселей, не затемняя всю текстуру.
var softened = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_ARGB);
softened.setRGB(0, 0, targetWidth, targetHeight, straightPixels, 0, targetWidth);
for (var sy = 0; sy < targetHeight; sy++) {
    for (var sx = 0; sx < targetWidth; sx++) {
        var sp = softened.getRGB(sx, sy);
        var sa = (sp >>> 24) & 255;
        var sf = 1.0 - 0.30 * (1.0 - sa / 255.0);
        softened.setRGB(sx, sy, (sa << 24) |
            (Math.round(((sp >>> 16) & 255) * sf) << 16) |
            (Math.round(((sp >>> 8) & 255) * sf) << 8) |
            Math.round((sp & 255) * sf));
    }
}

// Стандартный JPEG-кодировщик Java умеет оптимизировать таблицы Хаффмана,
// но BLP-модуль сам эту настройку не включает. Оборачиваем его, чтобы итог
// занимал меньше места без потери качества.
var jpegDelegate = null;
var OptimizedWriter = Java.extend(ImageWriter, {
    canWriteRasters: function() { return jpegDelegate.canWriteRasters(); },
    setOutput: function(output) { jpegDelegate.setOutput(output); },
    getDefaultWriteParam: function() {
        var p = jpegDelegate.getDefaultWriteParam();
        if (p.setOptimizeHuffmanTables) p.setOptimizeHuffmanTables(true);
        return p;
    },
    addIIOWriteWarningListener: function(listener) { jpegDelegate.addIIOWriteWarningListener(listener); },
    getDefaultStreamMetadata: function(p) { return jpegDelegate.getDefaultStreamMetadata(p); },
    getDefaultImageMetadata: function(t, p) { return jpegDelegate.getDefaultImageMetadata(t, p); },
    convertStreamMetadata: function(m, p) { return jpegDelegate.convertStreamMetadata(m, p); },
    convertImageMetadata: function(m, t, p) { return jpegDelegate.convertImageMetadata(m, t, p); },
    write: function(m, i, p) { jpegDelegate.write(m, i, p); },
    dispose: function() { jpegDelegate.dispose(); }
});
var optimizedSpi;
var OptimizedSpi = Java.extend(ImageWriterSpi, {
    canEncodeImage: function(type) { return true; },
    createWriterInstance: function(extension) {
        jpegDelegate = ImageIO.getImageWritersByFormatName('jpeg').next();
        return new OptimizedWriter(optimizedSpi);
    },
    getDescription: function(locale) { return 'Optimized JPEG bridge'; }
});
optimizedSpi = new OptimizedSpi();

function writeCandidate(image, file, quality) {
    var writers = ImageIO.getImageWritersByFormatName('BLP');
    if (!writers.hasNext()) throw new Error('Не найден модуль записи BLP.');
    var writer = writers.next();
    var parameters = writer.getDefaultWriteParam();
    parameters.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
    parameters.setJPEGSpi(optimizedSpi);
    parameters.setCompressionQuality(quality);
    parameters.setAutoMipmap(true);
    var metadata = writer.getDefaultStreamMetadata(parameters);
    metadata.setVersion(1);
    metadata.setEncoding(BLPEncodingType.JPEG, 8);
    metadata.setMipmaps(true);
    metadata.setWidth(targetWidth);
    metadata.setHeight(targetHeight);
    var output = ImageIO.createImageOutputStream(file);
    try {
        writer.setOutput(output);
        writer.write(metadata, new IIOImage(image, null, null), parameters);
    } finally {
        output.close();
        writer.dispose();
    }
}

function visualError(reference, candidate) {
    var error = 0.0;
    for (var y = 0; y < targetHeight; y++) {
        for (var x = 0; x < targetWidth; x++) {
            var a = reference.getRGB(x, y), b = candidate.getRGB(x, y);
            var alphaA = (a >>> 24) & 255, alphaB = (b >>> 24) & 255;
            error += Math.abs(alphaA - alphaB) * 3.0;
            // Почти невидимые пиксели не должны влиять на выбор цветового режима.
            if (alphaA > 31) {
                error += Math.abs(((a >>> 16) & 255) - ((b >>> 16) & 255));
                error += Math.abs(((a >>> 8) & 255) - ((b >>> 8) & 255));
                error += Math.abs((a & 255) - (b & 255));
            }
        }
    }
    return error;
}

// Некоторые старые эффектные BLP содержат цвет уже с учётом прозрачности,
// а другие — обычный прямой RGB. Проверяем три варианта и выбираем лучший.
var straightFile = new File(targetFile.getPath() + '.straight.blp');
var softFile = new File(targetFile.getPath() + '.soft.blp');
var premulFile = new File(targetFile.getPath() + '.premul.blp');
var adaptiveFile = new File(targetFile.getPath() + '.adaptive.blp');
var chosenMode = '';
var chosenQuality = 85;
var maximumBytes = parseInt(System.getProperty('wos.maxbytes', '102400'), 10);
try {
    writeCandidate(resized, straightFile, 0.85);
    var chosen = straightFile;
    var chosenImage = resized;
    var chosenError = 0.0;
    chosenMode = 'обычный';

    // Для полностью непрозрачных текстур варианты обработки края одинаковы,
    // поэтому не тратим время на два лишних кодирования.
    if (sourceAlphaStats.min < 255) {
        writeCandidate(softened, softFile, 0.85);
        writeCandidate(premultiplied, premulFile, 0.85);
        var straightDecoded = ImageIO.read(straightFile);
        var softDecoded = ImageIO.read(softFile);
        var premulDecoded = ImageIO.read(premulFile);
        if (straightDecoded == null || softDecoded == null || premulDecoded == null) throw new Error('Не удалось проверить созданные BLP.');
        var straightError = visualError(premultiplied, straightDecoded);
        var softError = visualError(premultiplied, softDecoded);
        var premulError = visualError(premultiplied, premulDecoded);
        chosenError = straightError;
        if (softError < chosenError) {
            chosen = softFile; chosenImage = softened; chosenError = softError; chosenMode = 'мягкий край';
        }
        if (premulError < chosenError) {
            chosen = premulFile; chosenImage = premultiplied; chosenMode = 'защита края';
        }
    }

    // Безопасные 85% уже сильно уменьшают файл. Для тяжёлых текстур пробуем
    // следующие ступени, пока результат не станет легче исходника и, по
    // возможности, не войдёт примерно в 100 КБ.
    if (chosen.length() > maximumBytes || chosen.length() >= sourceFile.length()) {
        writeCandidate(chosenImage, adaptiveFile, 0.75);
        chosen = adaptiveFile;
        chosenQuality = 75;
    }
    if (chosen.length() > maximumBytes || chosen.length() >= sourceFile.length()) {
        if (adaptiveFile.exists() && !adaptiveFile.delete()) throw new Error('Не удалось заменить адаптивный BLP.');
        writeCandidate(chosenImage, adaptiveFile, 0.55);
        chosen = adaptiveFile;
        chosenQuality = 55;
    }
    if (chosen.length() > maximumBytes || chosen.length() >= sourceFile.length()) {
        if (adaptiveFile.exists() && !adaptiveFile.delete()) throw new Error('Не удалось заменить адаптивный BLP.');
        writeCandidate(chosenImage, adaptiveFile, 0.45);
        chosen = adaptiveFile;
        chosenQuality = 45;
    }
    if (targetFile.exists() && !targetFile.delete()) throw new Error('Не удалось заменить временный BLP.');
    if (!chosen.renameTo(targetFile)) throw new Error('Не удалось сохранить выбранный BLP.');
    print('Размер: ' + source.getWidth() + 'x' + source.getHeight() + ' -> ' + targetWidth + 'x' + targetHeight +
        '; прозрачность: ' + sourceAlpha + '; качество: ' + chosenQuality + '%; режим: ' + chosenMode +
        '; вес: ' + sourceFile.length() + ' -> ' + targetFile.length() + ' байт');
} finally {
    if (straightFile.exists()) straightFile.delete();
    if (softFile.exists()) softFile.delete();
    if (premulFile.exists()) premulFile.delete();
    if (adaptiveFile.exists()) adaptiveFile.delete();
}