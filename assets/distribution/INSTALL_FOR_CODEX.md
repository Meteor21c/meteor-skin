# Meteor Skin portable package

This package installs a reversible Codex desktop skin and the `meteor-skin` Skill. It does not modify, replace, patch, or re-sign the official Codex/ChatGPT application bundle.

## If you are Codex

1. Read `meteor-skin/SKILL.md` completely.
2. Detect the operating system.
3. On macOS, run `Install Meteor Skin on macOS.command` from this package.
4. On Windows, run `Install Meteor Skin on Windows.cmd` from this package.
5. If Codex is already open without the required debugging port, explain that one restart is required and obtain explicit user approval. Never restart silently.
6. Verify the installed skin after launch. The runtime selects a valid theme marked `default: true`, or the first valid scanned theme. For an adaptive theme, Codex Settings → Appearance controls its light/dark branch.
7. Preserve user tasks, authentication, private themes, and the official application package.

## If you are the user

- macOS: double-click `Install Meteor Skin on macOS.command`.
- Windows: double-click `Install Meteor Skin on Windows.cmd`.
- The installer creates a reusable desktop/start-menu activation entry.
- If Codex is already open, the installer asks before restarting it.
- Existing Skill/runtime folders are archived for recovery instead of being deleted.

After installation, use Codex Settings → Appearance to switch light/dark mode. Use the generated `Start Meteor Skin` entry whenever the skin needs to be activated again.
