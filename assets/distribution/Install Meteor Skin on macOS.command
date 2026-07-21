#!/bin/bash
set -euo pipefail
PACKAGE_ROOT="$(cd "$(dirname "$0")" && pwd)"
bash "$PACKAGE_ROOT/meteor-skin/scripts/install-shared-package.sh"
printf '\nInstallation finished. Press Return to close this window. '
read -r _
