import fs from "node:fs/promises";
import path from "node:path";

function parseArgs(argv) {
  const options = { desktop: null, runtime: null };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--desktop") options.desktop = path.resolve(argv[++index]);
    else if (arg === "--runtime") options.runtime = path.resolve(argv[++index]);
    else throw new Error(`Unknown argument: ${arg}`);
  }
  if (!options.desktop || !options.runtime) {
    throw new Error("Usage: node create-macos-entrypoints.mjs --desktop <dir> --runtime <dir>");
  }
  return options;
}

function shellQuote(value) {
  return `'${String(value).replace(/'/g, `'"'"'`)}'`;
}

const options = parseArgs(process.argv.slice(2));
await fs.mkdir(options.desktop, { recursive: true });
const activate = path.join(options.runtime, "scripts", "activate-dream-skin.sh");
const restore = path.join(options.runtime, "scripts", "meteor-skin-macos.sh");
const files = [
  {
    name: "Start Meteor Skin.command",
    body: `#!/bin/bash\nset -euo pipefail\nbash ${shellQuote(activate)}\nprintf '\\nMeteor Skin is ready. Press Return to close this window. '\nread -r _\n`,
  },
  {
    name: "Restore Meteor Skin Appearance.command",
    body: `#!/bin/bash\nset -euo pipefail\nbash ${shellQuote(restore)} restore\nprintf '\\nThe live skin was removed. Press Return to close this window. '\nread -r _\n`,
  },
];
for (const file of files) {
  const output = path.join(options.desktop, file.name);
  await fs.writeFile(output, file.body, { mode: 0o755 });
  await fs.chmod(output, 0o755);
  console.log(output);
}
