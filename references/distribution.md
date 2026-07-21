# Portable distribution

Use this reference when building, inspecting, sharing, or installing a Meteor Skin package.

## Package contract

The generated directory and ZIP contain:

```text
Meteor-Skin-Portable-<version>-<timestamp>/
  INSTALL_FOR_CODEX.md
  Install Meteor Skin on macOS.command
  Install Meteor Skin on Windows.cmd
  PACKAGE.json
  SHA256SUMS.txt
  meteor-skin/
    SKILL.md
    agents/
    scripts/
    references/
    assets/
    styles/
    themes/
    themes-private/
```

Never include `~/.codex/config.toml`, application state, logs, task files, cookies, tokens, credentials, browser data, or files from the official application bundle.

## Build

macOS:

```bash
bash scripts/build-share-package.sh /absolute/output/directory
```

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build-share-package.ps1 -OutputRoot C:\absolute\output
```

The staging directory must not already exist. The builder refuses to overwrite an earlier package. The ZIP keeps the containing folder so extraction produces one self-contained directory.

## Reproducibility

- `PACKAGE.json` records package version, build time, supported platforms, default theme, and safety properties.
- `SHA256SUMS.txt` covers every packaged file except itself.
- A rebuild at a different time has a different package timestamp, but identical source files retain identical individual hashes.
- Validate the source Skill before building, then validate the packaged copy again.
- Run `scripts/injector.mjs --themes` from the packaged copy and confirm the intended built-in/private themes and appearance capabilities.

## Installation behavior

- The package installs the Skill to `~/.codex/skills/meteor-skin`.
- An existing Skill is renamed to a timestamped sibling backup before replacement.
- A legacy `~/.codex/skills/codex-autoskin` folder is reported but never modified automatically; after validating Meteor Skin, the user may archive it manually to avoid duplicate Skill triggers.
- macOS installs a stable runtime under `~/Library/Application Support/CodexDreamSkin/runtime`.
- Windows installs a stable runtime under `%LOCALAPPDATA%\CodexDreamSkin\runtime`.
- Existing runtimes are archived with timestamps; they are not recursively deleted.
- Private themes use durable platform state storage and survive runtime refreshes.
- The installer creates reusable activation and restore entries.
- If an unskinned Codex instance is open, the user must approve the one restart required to expose CDP.
- If CDP is already active, installation/activation hot-reloads without restarting Codex.

## Recipient verification

1. Compare hashes before installation when the package crossed an untrusted transport.
2. Read `INSTALL_FOR_CODEX.md` or ask Codex to read it.
3. Run the platform installer.
4. Confirm the generated activation entry exists.
5. Confirm `injector.mjs --themes` reports the expected default theme and `appearance` value.
6. Verify light and dark appearances from Codex Settings → Appearance.
7. Verify home, chat, settings, and one dialog using `qa-inventory.md`.

## Updating a distributed package

- Increase the package/Skill version when schema or runtime behavior changes.
- Keep old single-mode themes valid.
- Add migrations as additive schema support; never rewrite a recipient's manually authored private theme without explicit approval.
- Archive previous Skill/runtime/theme directories before replacement.
- Rebuild checksums after every change.
