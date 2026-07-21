import crypto from "node:crypto";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const skillRoot = path.resolve(here, "..");

function parseArgs(argv) {
  const options = { output: null };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--output") options.output = path.resolve(argv[++index]);
    else throw new Error(`Unknown argument: ${arg}`);
  }
  if (!options.output) throw new Error("Usage: node build-share-package.mjs --output <new-directory>");
  return options;
}

async function exists(file) {
  return Boolean(await fs.lstat(file).catch(() => null));
}

async function walkFiles(root, current = root) {
  const output = [];
  const entries = await fs.readdir(current, { withFileTypes: true });
  for (const entry of entries.sort((a, b) => a.name.localeCompare(b.name, "en"))) {
    const absolute = path.join(current, entry.name);
    if (entry.isDirectory()) output.push(...await walkFiles(root, absolute));
    else if (entry.isFile()) output.push(path.relative(root, absolute).split(path.sep).join("/"));
  }
  return output;
}

const options = parseArgs(process.argv.slice(2));
if (await exists(options.output)) throw new Error(`Output already exists; choose a new path: ${options.output}`);
await fs.mkdir(options.output, { recursive: true });

const packagedSkill = path.join(options.output, "meteor-skin");
const excludedNames = new Set([".git", "themes-archive", "theme-staging", ".DS_Store"]);
await fs.cp(skillRoot, packagedSkill, {
  recursive: true,
  preserveTimestamps: true,
  filter(source) {
    return !source.split(path.sep).some((part) => excludedNames.has(part));
  },
});

const templateRoot = path.join(skillRoot, "assets", "distribution");
for (const name of ["INSTALL_FOR_CODEX.md", "Install Meteor Skin on macOS.command", "Install Meteor Skin on Windows.cmd"]) {
  await fs.copyFile(path.join(templateRoot, name), path.join(options.output, name));
}
await fs.chmod(path.join(options.output, "Install Meteor Skin on macOS.command"), 0o755);

const packageInfo = {
  name: "meteor-skin-portable",
  version: "2.3.0",
  builtAt: new Date().toISOString(),
  platforms: ["macos", "windows"],
  defaultTheme: "runtime-selected",
  themeSelection: "Use the first valid theme marked default:true, otherwise the first valid scanned theme.",
  safety: {
    modifiesOfficialApp: false,
    restartRequiresApproval: true,
    destructiveRecursiveDelete: false,
  },
};
await fs.writeFile(path.join(options.output, "PACKAGE.json"), `${JSON.stringify(packageInfo, null, 2)}\n`);

const files = (await walkFiles(options.output)).filter((name) => name !== "SHA256SUMS.txt");
const sums = [];
for (const name of files) {
  const data = await fs.readFile(path.join(options.output, ...name.split("/")));
  sums.push(`${crypto.createHash("sha256").update(data).digest("hex")}  ${name}`);
}
await fs.writeFile(path.join(options.output, "SHA256SUMS.txt"), `${sums.join("\n")}\n`);
console.log(JSON.stringify({ ok: true, output: options.output, files: files.length + 1, packageInfo }, null, 2));
