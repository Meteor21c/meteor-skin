#!/bin/bash
set -euo pipefail

[ "$(uname -s)" = "Darwin" ] || { echo "This installer is for macOS." >&2; exit 1; }
SOURCE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_ROOT="$HOME/.codex/skills"
TARGET_ROOT="$SKILLS_ROOT/codex-autoskin"
STAMP="$(date -u '+%Y%m%dT%H%M%SZ')-$$"

mkdir -p "$SKILLS_ROOT"
SOURCE_REAL="$(cd "$SOURCE_ROOT" && pwd -P)"
TARGET_REAL=""
if [ -d "$TARGET_ROOT" ]; then TARGET_REAL="$(cd "$TARGET_ROOT" && pwd -P)"; fi
if [ "$SOURCE_REAL" != "$TARGET_REAL" ]; then
  if [ -e "$TARGET_ROOT" ]; then
    BACKUP_ROOT="$SKILLS_ROOT/codex-autoskin.backup-$STAMP"
    mv "$TARGET_ROOT" "$BACKUP_ROOT"
    echo "Previous Skill archived for recovery: $BACKUP_ROOT"
  fi
  cp -R "$SOURCE_ROOT" "$TARGET_ROOT"
fi

chmod +x "$TARGET_ROOT"/*.command "$TARGET_ROOT"/scripts/*.sh 2>/dev/null || true
echo "Installed Skill: $TARGET_ROOT"
bash "$TARGET_ROOT/scripts/autoskin-macos.sh" install

STATE_ROOT="$HOME/Library/Application Support/CodexDreamSkin"
RUNTIME="$STATE_ROOT/runtime"
if [ -x "$RUNTIME/scripts/activate-dream-skin.sh" ]; then
  . "$RUNTIME/scripts/lib/mac-common.sh"
  INSTALLED_PORT="$(dream_installed_port)"
  if dream_cdp_ready "$INSTALLED_PORT"; then
    bash "$RUNTIME/scripts/activate-dream-skin.sh" --port "$INSTALLED_PORT" --layout fullscreen
  else
    echo "AutoSkin is installed but Codex was left unchanged. Use the generated desktop entry when ready."
  fi
fi
