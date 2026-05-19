#!/bin/zsh
set -e
set -u
set -o pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/App/TermiPet.app"
DIST="$ROOT/dist"
VERSION="${1:-0.1.1}"
ZIP_PATH="$DIST/TermiPet-v${VERSION}-macOS.zip"

if [ ! -d "$APP" ]; then
    echo "error: app bundle not found at $APP" >&2
    echo "Run zsh Scripts/build-plugin.sh first." >&2
    exit 1
fi

if [ ! -d "$APP/Contents/Resources/TermiPetApp_TermiPet.bundle" ]; then
    echo "error: resource bundle missing at $APP/Contents/Resources/TermiPetApp_TermiPet.bundle" >&2
    exit 1
fi

mkdir -p "$DIST"

if [ -e "$ZIP_PATH" ]; then
    echo "error: release archive already exists at $ZIP_PATH" >&2
    echo "Move it aside manually before packaging again." >&2
    exit 1
fi

echo "==> Creating $ZIP_PATH"
ditto -c -k --keepParent --norsrc --noextattr "$APP" "$ZIP_PATH"
shasum -a 256 "$ZIP_PATH"
