# Codex AutoSkin portable package

This package installs a reversible Codex desktop skin and the `codex-autoskin` Skill. It does not modify, replace, patch, or re-sign the official Codex/ChatGPT application bundle.

## If you are Codex

1. Read `codex-autoskin/SKILL.md` completely.
2. Detect the operating system.
3. On macOS, run `Install AutoSkin on macOS.command` from this package.
4. On Windows, run `Install AutoSkin on Windows.cmd` from this package.
5. If Codex is already open without the required debugging port, explain that one restart is required and obtain explicit user approval. Never restart silently.
6. Verify the installed skin after launch. The runtime selects a valid theme marked `default: true`, or the first valid scanned theme. For an adaptive theme, Codex Settings → Appearance controls its light/dark branch.
7. Preserve user tasks, authentication, private themes, and the official application package.

## If you are the user

- macOS: double-click `Install AutoSkin on macOS.command`.
- Windows: double-click `Install AutoSkin on Windows.cmd`.
- The installer creates a reusable desktop/start-menu activation entry.
- If Codex is already open, the installer asks before restarting it.
- Existing Skill/runtime folders are archived for recovery instead of being deleted.

After installation, use Codex Settings → Appearance to switch light/dark mode. Use the generated `Start Codex AutoSkin` entry whenever the skin needs to be activated again.
