import crypto from "node:crypto";
import fs from "node:fs/promises";
import path from "node:path";

function parseArgs(argv) {
  if (argv.length !== 2 || argv[0] !== "--package") {
    throw new Error("Usage: node verify-share-package.mjs --package <directory>");
  }
  return path.resolve(argv[1]);
}

const packageRoot = parseArgs(process.argv.slice(2));
const required = [
  "INSTALL_FOR_CODEX.md",
  "Install AutoSkin on macOS.command",
  "Install AutoSkin on Windows.cmd",
  "PACKAGE.json",
  "SHA256SUMS.txt",
  "codex-autoskin/SKILL.md",
  "codex-autoskin/scripts/activate-dream-skin.sh",
  "codex-autoskin/scripts/activate-dream-skin.ps1",
];
for (const name of required) {
  const stat = await fs.stat(path.join(packageRoot, ...name.split("/"))).catch(() => null);
  if (!stat) throw new Error(`Package is missing: ${name}`);
}

const info = JSON.parse(await fs.readFile(path.join(packageRoot, "PACKAGE.json"), "utf8"));
if (!info.platforms?.includes("macos") || !info.platforms?.includes("windows")) {
  throw new Error("PACKAGE.json does not declare both platforms");
}
if (info.safety?.modifiesOfficialApp !== false || info.safety?.restartRequiresApproval !== true ||
    info.safety?.destructiveRecursiveDelete !== false) {
  throw new Error("PACKAGE.json safety contract is incomplete");
}

const checksumLines = (await fs.readFile(path.join(packageRoot, "SHA256SUMS.txt"), "utf8"))
  .split(/\r?\n/).filter(Boolean);
for (const line of checksumLines) {
  const match = /^([a-f0-9]{64})  (.+)$/.exec(line);
  if (!match) throw new Error(`Invalid checksum line: ${line}`);
  const file = path.join(packageRoot, ...match[2].split("/"));
  const digest = crypto.createHash("sha256").update(await fs.readFile(file)).digest("hex");
  if (digest !== match[1]) throw new Error(`Checksum mismatch: ${match[2]}`);
}

const forbidden = [
  new RegExp(["rm", "\\s+-", "rf\\b"].join("")),
  new RegExp(["fs", "\\.rm\\([^\\n]*", "recursive\\s*:\\s*true"].join("")),
  new RegExp(["Remove", "-Item[^\\n]*-", "Recurse"].join(""), "i"),
  new RegExp(["\\b(?:rd|rmdir|del)", "\\s+\\/", "s\\b"].join(""), "i"),
];
const inspectExtensions = new Set([".sh", ".command", ".mjs", ".js", ".ps1", ".cmd"]);
for (const line of checksumLines) {
  const name = /^([a-f0-9]{64})  (.+)$/.exec(line)[2];
  if (!name.startsWith("codex-autoskin/")) continue;
  if (!inspectExtensions.has(path.extname(name).toLowerCase())) continue;
  const content = await fs.readFile(path.join(packageRoot, ...name.split("/")), "utf8");
  for (const pattern of forbidden) {
    if (pattern.test(content)) throw new Error(`Forbidden recursive deletion in ${name}: ${pattern}`);
  }
}

console.log(JSON.stringify({ ok: true, packageRoot, filesVerified: checksumLines.length, version: info.version }, null, 2));
