#!/bin/bash
# Legacy compatibility entry point. New integrations should call
# meteor-skin-macos.sh; this wrapper preserves existing installations.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/meteor-skin-macos.sh" "$@"
