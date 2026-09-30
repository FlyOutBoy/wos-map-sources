'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { decodeWos2BotExport } = require('./wos2_bot_decoder.js');

// Diagnostic fallback for reports produced by an incompatible map-side codec.
// It decrypts the payload for inspection but deliberately does not claim that
// the report is authentic or server-acceptable.
const MOD1 = 1000003;
const RADIX = 87;
const PLAIN = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz _-.|=,:;!?/()[]{}+*@#%&'";
const CIPHER = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz _-.,:;!?/()[]{}+*@#%&'<>";
const K0 = 731921;
const K1 = 284117;
const K2 = 619403;
const K3 = 93761;
const K4 = 508217;
const K5 = 346891;

function posMod(value, base) {
  const result = value % base;
  return result < 0 ? result + base : result;
}

function decodePayloadUnchecked(text, inputPath) {
  const header = /WOS2E\|v=1\|id=([0-9A-Za-z_-]{1,80})\|alg=R87M2(?:\|map_version=([^|"\)\r\n]+))?/.exec(text);
  const fileNameMatch = /WOS2_bot_match_([0-9A-Za-z_-]{1,80})(?:_sent)?\.txt$/i.exec(path.basename(inputPath));
  const matchId = header ? header[1] : (fileNameMatch ? fileNameMatch[1] : '');
  const mapVersion = header && header[2] ? header[2] : 'unknown';
  if (!matchId) throw new Error('WOS2E header was not found and match ID could not be read from the file name');

  const keyB = posMod(K1 + K3 * 5 + K5 + 29011, 1000033);
  const keyD = posMod(K5 + K2 * 2 - K3 + 49009, 1000033);
  let context = posMod(K0 + K3 + 19081, MOD1);
  for (const character of matchId) {
    let code = PLAIN.indexOf(character) + 1;
    if (code <= 0) code = 1;
    context = posMod(context * 127 + code * 31 + K2, MOD1);
  }

  const records = [...text.matchAll(/D\|s=(\d+)\|c=([^|\r\n]+)\|t=([0-9A-Z]{8})/g)];
  if (records.length === 0) throw new Error('The container has no data records');

  return {
    matchId,
    mapVersion,
    lines: records.map((record, expectedSequence) => {
    const sequence = Number(record[1]);
    if (sequence !== expectedSequence) {
      throw new Error(`Invalid sequence: expected line ${expectedSequence}`);
    }
    const cipher = record[2];
    let stream = posMod(context + keyB + sequence * 389 + 71, MOD1);
    let plain = '';
    for (let position = 0; position < cipher.length; position += 1) {
      const cipherIndex = CIPHER.indexOf(cipher[position]);
      if (cipherIndex < 0) {
        throw new Error(`Line ${sequence}: ciphertext contains an invalid character`);
      }
      stream = posMod(stream * 109 + 1021 + position * 17 + sequence * 13, MOD1);
      const shift = posMod(stream + keyD, RADIX);
      plain += PLAIN[posMod(cipherIndex - shift, RADIX)];
    }
    return plain;
    }),
  };
}

function headerLine(result) {
  return `HEADER|version=1|match_id=${result.matchId}|algorithm=R87M2|map_version=${result.mapVersion || 'unknown'}`;
}

function decodedPathFor(inputPath, suffix) {
  const parsed = path.parse(inputPath);
  return path.join(parsed.dir, `${parsed.name}${suffix}.txt`);
}

const inputPath = process.argv[2];
if (!inputPath) {
  console.error('REJECTED: input file was not specified.');
  process.exitCode = 2;
} else {
  try {
    const reportText = fs.readFileSync(inputPath, 'utf8');
    const result = decodeWos2BotExport(reportText);
    const outputPath = decodedPathFor(inputPath, '_decoded');
    fs.writeFileSync(outputPath, `${headerLine(result)}\r\n${result.lines.join('\r\n')}\r\n`, 'utf8');

    console.log('ACCEPTED: the server decoder accepts this report.');
    console.log(`Match ID: ${result.matchId}`);
    console.log(`Map version: ${result.mapVersion || 'unknown'}`);
    console.log(`Players: ${result.match.players}`);
    console.log(`Round score: ${result.match.team1_rounds}-${result.match.team2_rounds}`);
    console.log(`Decoded file: ${outputPath}`);
    console.log('');
    console.log(result.lines.join('\n'));
  } catch (error) {
    console.error(`SERVER REJECTED: ${error.message}`);
    console.error('The report does not pass the server authentication checks.');
    try {
      const reportText = fs.readFileSync(inputPath, 'utf8');
      const diagnostic = decodePayloadUnchecked(reportText, inputPath);
      const outputPath = decodedPathFor(inputPath, '_decoded_UNVERIFIED');
      fs.writeFileSync(outputPath, `${headerLine(diagnostic)}\r\n${diagnostic.lines.join('\r\n')}\r\n`, 'utf8');
      console.log('');
      console.log('DECODED FOR INSPECTION ONLY: authentication was NOT verified.');
      console.log(`Diagnostic file: ${outputPath}`);
      console.log(`Map version: ${diagnostic.mapVersion}`);
      console.log('');
      console.log(diagnostic.lines.join('\n'));
    } catch (fallbackError) {
      console.error(`DECODE FAILED: ${fallbackError.message}`);
      process.exitCode = 1;
    }
  }
}
