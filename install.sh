#!/bin/zsh
set -e
set -u
set -o pipefail

API_URL="https://api.github.com/repos/bleeeet/TermiPet/releases/latest"
ASSET_GLOB="TermiPet-v*-macOS.zip"
APP_PATH="/Applications/TermiPet.app"
BACKUP_DIR="$HOME/Library/Application Support/TermiPet/InstallBackups"

info() {
    printf "==> %s\n" "$1"
}

fail() {
    printf "TermiPet install failed: %s\n" "$1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

macos_major_version() {
    sw_vers -productVersion | awk -F. '{ print $1 }'
}

require_command curl
require_command awk
require_command unzip
require_command ditto
require_command xattr

if [ "$(uname -s)" != "Darwin" ]; then
    fail "TermiPet only supports macOS."
fi

if [ "$(macos_major_version)" -lt 14 ]; then
    fail "TermiPet requires macOS 14.0 or later."
fi

WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/termipet-install.XXXXXX")"
ZIP_PATH="$WORK_DIR/TermiPet.zip"

info "Fetching latest TermiPet release"
ASSET_URL="$(
    curl -fsSL "$API_URL" |
    awk -F'"' '/browser_download_url/ && /TermiPet-v.*-macOS\.zip/ { print $4; exit }'
)"

if [ -z "$ASSET_URL" ]; then
    fail "could not find a release asset matching $ASSET_GLOB."
fi

info "Downloading $ASSET_URL"
curl -fL "$ASSET_URL" -o "$ZIP_PATH"

info "Unpacking TermiPet"
unzip -q "$ZIP_PATH" -d "$WORK_DIR"
APP_SOURCE="$(find "$WORK_DIR" -name "TermiPet.app" -type d -print -quit)"

if [ -z "$APP_SOURCE" ]; then
    fail "downloaded archive did not contain TermiPet.app."
fi

if pgrep -x TermiPet >/dev/null 2>&1; then
    info "Closing the running TermiPet app"
    osascript -e 'tell application "TermiPet" to quit' >/dev/null 2>&1 || true
    sleep 1
fi

if [ -d "$APP_PATH" ]; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_PATH="$BACKUP_DIR/TermiPet-$(date +%Y%m%d-%H%M%S).app"
    info "Moving existing app to $BACKUP_PATH"
    if [ -w "/Applications" ]; then
        mv "$APP_PATH" "$BACKUP_PATH"
    else
        sudo mv "$APP_PATH" "$BACKUP_PATH"
    fi
fi

info "Installing TermiPet to $APP_PATH"
if [ -w "/Applications" ]; then
    ditto "$APP_SOURCE" "$APP_PATH"
else
    sudo ditto "$APP_SOURCE" "$APP_PATH"
fi

info "Clearing macOS quarantine attributes"
xattr -cr "$APP_PATH" 2>/dev/null || true

info "Launching TermiPet"
open "$APP_PATH"

info "Done. Temporary files are in $WORK_DIR"
