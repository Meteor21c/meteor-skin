---
name: meteor-skin
description: Apply, create, package, install, verify, theme-switch, repair, update, or safely restore a decorative skin for the Windows or macOS Codex desktop app. Use for custom image-based Codex themes, adaptive light/dark skins, portable Meteor Skin packages, post-update recovery, activation troubleshooting, visual contrast repair, or rollback without modifying the official app or app.asar.
---

# Meteor Skin

Apply a reversible renderer skin through loopback Chromium DevTools Protocol. Never patch, replace, re-sign, or take ownership of files inside the official Windows package or macOS app bundle.

## Core rules

- Treat themes as data. Put public themes in `themes/<name>/` and private/share-bundle themes in `themes-private/<name>/`.
- Modify a theme through `theme.json` and strictly scoped `extra.css`; do not hardcode theme names into the engine.
- Preserve tasks, authentication, plugins, pets, settings, and native control behavior.
- Never restart an open Codex instance without explicit user approval. If CDP is already active, hot-reload without restarting.
- Never use recursive destructive deletion. Archive an old runtime/theme/Skill by renaming it; remove only explicit files or empty lock directories.
- Keep decorative layers `pointer-events: none`; real Codex controls must remain the top hit target.
- Inject only the main `app://-/index.html` renderer. Keep `initialRoute` and compact auxiliary windows clean and transparent.

## Workflow

1. Detect the OS, installed Codex application, Node.js runtime, saved port, current CDP state, injector state, and watcher state. On macOS prefer `scripts/meteor-skin-macos.sh doctor`; on Windows use the stable runtime and PowerShell helpers.
2. For theme creation or editing, read `THEME-SPEC.md` completely. Use `modes.light` / `modes.dark` for an adaptive theme; the official Codex Settings → Appearance switch selects the active branch.
3. Install once:
   - macOS: `scripts/meteor-skin-macos.sh install` (`scripts/autoskin-macos.sh` is a legacy compatibility wrapper).
   - Windows: `scripts/install-dream-skin.ps1`, or `quickstart.ps1` for the guided flow.
   - A shared package uses `scripts/install-shared-package.sh` or `scripts/install-shared-package.ps1` and installs the Skill plus stable runtime.
4. Activate safely:
   - macOS: `scripts/activate-dream-skin.sh`.
   - Windows: `scripts/activate-dream-skin.ps1`.
   - These scripts hot-reload an active skin and ask before the one restart needed for an already-open unskinned Codex.
5. Switch Meteor Skin theme/layout with `scripts/set-theme.mjs <theme> [banner|fullscreen]`. This is separate from the official light/dark Appearance setting. Both choices persist.
6. Verify with the platform wrapper and `references/qa-inventory.md`. Treat DOM checks as diagnostics; require real screenshots for visual signoff.
7. Restore live official appearance with the platform restore script. Full uninstall archives the installed runtime for recovery instead of recursively deleting it.

## Portable packages

Read `references/distribution.md` before building or installing a shared package.

- macOS build: `scripts/build-share-package.sh [output-directory]`.
- Windows build: `scripts/build-share-package.ps1 -OutputRoot <directory>`.
- The package contains the Skill, bundled private themes, platform installers, Codex-readable instructions, package metadata, and SHA-256 checksums.
- Do not include credentials, Codex configuration, logs, state files, task data, or authentication material.

## Appearance and component coverage

- A single-mode theme keeps the legacy `tokens` behavior.
- An adaptive theme adds partial overrides in `modes.light` and `modes.dark`; mode-specific tokens, card glass settings, composer copy, and brand metadata inherit from the base theme.
- Prefer semantic native-surface tokens and runtime marker classes over hashed classes, language-specific selectors, or broad `* { color: ... }` rules.
- Verify home, chat, sidebar, composer, project selector, account card, menus, model picker, diff, environment surfaces, settings, dialogs, links, disabled states, and destructive actions in both appearances.

## Resources

- `THEME-SPEC.md`: schema, adaptive modes, crop, semantic tokens, glass/layout controls, and theme acceptance.
- `references/distribution.md`: package structure, installation contract, reproducibility, and checksum verification.
- `references/qa-inventory.md`: cross-platform functional, visual, contrast, lifecycle, and safety matrix.
- `references/runtime-notes.md`: CDP, stable runtime, watcher, platform discovery, logs, and recovery behavior.
- `scripts/injector.mjs`: theme validation, adaptive CSS generation, injection, verification, and reporting.
- `assets/renderer-inject.js`: idempotent DOM markers, appearance observation, chrome, cleanup, and state API.
- `styles/dream/style.css`: theme-independent structure and semantic native surfaces.
