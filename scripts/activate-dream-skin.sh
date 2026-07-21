#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib/mac-common.sh"

PORT="$(dream_installed_port)"
APP_PATH=""
NODE_PATH=""
THEME=""
LAYOUT="fullscreen"
ALLOW_RESTART=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --port) [ "$#" -ge 2 ] || dream_die "--port requires a value"; PORT="$2"; shift 2 ;;
    --app) [ "$#" -ge 2 ] || dream_die "--app requires a value"; APP_PATH="$2"; shift 2 ;;
    --node) [ "$#" -ge 2 ] || dream_die "--node requires a value"; NODE_PATH="$2"; shift 2 ;;
    --theme) [ "$#" -ge 2 ] || dream_die "--theme requires a value"; THEME="$2"; shift 2 ;;
    --layout) [ "$#" -ge 2 ] || dream_die "--layout requires a value"; LAYOUT="$2"; shift 2 ;;
    --restart-existing) ALLOW_RESTART=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--theme NAME] [--layout fullscreen|banner] [--restart-existing] [--port PORT]"
      exit 0 ;;
    *) dream_die "unknown argument: $1" ;;
  esac
done

dream_require_macos
dream_validate_port "$PORT"
dream_resolve_app "$APP_PATH"
dream_resolve_node "$NODE_PATH"

echo "[1/4] Checking Codex and AutoSkin status..."
START_ARGS=(--port "$PORT" --app "$APP_BUNDLE" --node "$NODE_BIN")
if ! dream_cdp_ready "$PORT" && [ -n "$(dream_main_pids)" ]; then
  if [ "$ALLOW_RESTART" -ne 1 ]; then
    if [ -t 0 ]; then
      printf 'Codex is open without AutoSkin. Restart Codex now? [y/N] '
      read -r answer
      case "$answer" in
        y|Y|yes|YES|Yes) ALLOW_RESTART=1 ;;
        *) dream_die "activation cancelled; Codex was left open and unchanged" ;;
      esac
    else
      dream_die "Codex is open without AutoSkin. Rerun interactively or pass --restart-existing after user approval."
    fi
  fi
  START_ARGS+=(--restart-existing)
fi

echo "[2/4] Starting or hot-reloading AutoSkin..."
"$SCRIPT_DIR/start-dream-skin.sh" "${START_ARGS[@]}"

if [ -n "$THEME" ]; then
  echo "[3/4] Applying theme '$THEME' ($LAYOUT)..."
  "$NODE_BIN" "$SCRIPT_DIR/set-theme.mjs" --port "$PORT" "$THEME" "$LAYOUT" >/dev/null
else
  echo "[3/4] Keeping the saved theme and layout..."
fi

echo "[4/4] Verifying the live skin..."
"$NODE_BIN" "$SCRIPT_DIR/injector.mjs" --verify --port "$PORT" --timeout-ms 12000 >/dev/null
echo "Codex AutoSkin is active on port $PORT."
/usr/bin/osascript -e 'display notification "AutoSkin is active. Use Codex Settings → Appearance for light/dark mode." with title "Codex AutoSkin"' >/dev/null 2>&1 || true
