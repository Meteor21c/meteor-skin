#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/lib/mac-common.sh"
dream_resolve_node ""

OUTPUT_ROOT="${1:-$(pwd)/dist}"
STAMP="$(date -u '+%Y%m%dT%H%M%SZ')"
PACKAGE_NAME="Meteor-Skin-Portable-2.3.0-$STAMP"
PACKAGE_DIR="$OUTPUT_ROOT/$PACKAGE_NAME"
ZIP_PATH="$OUTPUT_ROOT/$PACKAGE_NAME.zip"
mkdir -p "$OUTPUT_ROOT"
[ ! -e "$PACKAGE_DIR" ] || dream_die "output already exists: $PACKAGE_DIR"
[ ! -e "$ZIP_PATH" ] || dream_die "archive already exists: $ZIP_PATH"

"$NODE_BIN" "$SCRIPT_DIR/build-share-package.mjs" --output "$PACKAGE_DIR"
/usr/bin/ditto -c -k --norsrc --noextattr --noqtn --noacl --keepParent "$PACKAGE_DIR" "$ZIP_PATH"
echo "$ZIP_PATH"
