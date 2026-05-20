#!/bin/zsh
set -e
set -u
set -o pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="$ROOT/Source"
APP="$ROOT/App/TermiPet.app"
BUILD_CONFIGURATION="release"
BUILD_PRODUCTS="$SOURCE/.build/apple/Products/Release"
RESOURCE_BUNDLE_NAME="TermiPetApp_TermiPet.bundle"
RESOURCE_BUNDLE_PATH="$BUILD_PRODUCTS/$RESOURCE_BUNDLE_NAME"
RESOURCE_FILES=(
    "AppLogo.png"
    "StatusBarCat.png"
    "TermiPet.png"
    "bar.png"
    "github.png"
    "instagram.png"
    "twitter.png"
)
CERT_NAME="TermiPetLocal"
KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"

ensure_local_codesign_cert() {
    if security find-certificate -c "$CERT_NAME" "$KEYCHAIN" >/dev/null 2>&1; then
        return 0
    fi

    echo "==> 创建本地自签代码签名证书: $CERT_NAME"
    echo "    （只会在第一次构建时执行，下次重建复用同一证书，辅助功能授权不会丢失）"

    local tmp
    tmp=$(mktemp -d)

    cat > "$tmp/openssl.cnf" <<'EOF'
[req]
distinguished_name = req_dn
prompt = no
x509_extensions = v3_codesign

[req_dn]
CN = TermiPetLocal

[v3_codesign]
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, codeSigning
basicConstraints = critical, CA:false
subjectKeyIdentifier = hash
EOF

    openssl req -x509 -newkey rsa:2048 -nodes \
        -keyout "$tmp/key.pem" -out "$tmp/cert.pem" \
        -days 7300 -config "$tmp/openssl.cnf" >/dev/null 2>&1

    openssl pkcs12 -export -legacy \
        -inkey "$tmp/key.pem" -in "$tmp/cert.pem" \
        -out "$tmp/cert.p12" -password pass:termipet >/dev/null 2>&1 \
        || openssl pkcs12 -export \
            -inkey "$tmp/key.pem" -in "$tmp/cert.pem" \
            -out "$tmp/cert.p12" -password pass:termipet >/dev/null 2>&1

    security import "$tmp/cert.p12" -k "$KEYCHAIN" \
        -P termipet -A -T /usr/bin/codesign >/dev/null

    echo "==> 临时证书文件保留在: $tmp"
}

cd "$SOURCE"
find Sources -name "*.swift" -exec touch {} \;
swift test
swift build -c "$BUILD_CONFIGURATION" --arch arm64 --arch x86_64

if [ ! -x "$BUILD_PRODUCTS/TermiPet" ]; then
    echo "error: built TermiPet executable not found at $BUILD_PRODUCTS/TermiPet" >&2
    exit 1
fi

if [ ! -d "$RESOURCE_BUNDLE_PATH" ]; then
    echo "error: resource bundle not found at $RESOURCE_BUNDLE_PATH" >&2
    exit 1
fi

if [ ! -f "$RESOURCE_BUNDLE_PATH/Contents/Info.plist" ]; then
    echo "error: resource bundle Info.plist not found at $RESOURCE_BUNDLE_PATH/Contents/Info.plist" >&2
    exit 1
fi

for resource_file in "${RESOURCE_FILES[@]}"; do
    if [ ! -f "$RESOURCE_BUNDLE_PATH/Contents/Resources/$resource_file" ]; then
        echo "error: resource bundle missing $resource_file" >&2
        exit 1
    fi
done

if [ -d "$APP" ]; then
    APP_BACKUP="$ROOT/App/TermiPet.app.previous-$(date +%Y%m%d-%H%M%S)"
    echo "==> 移动旧构建到: $APP_BACKUP"
    mv "$APP" "$APP_BACKUP"
fi

mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources/Pets"

cp "$BUILD_PRODUCTS/TermiPet" "$APP/Contents/MacOS/TermiPet"
cp "$SOURCE/AppBundle/Info.plist" "$APP/Contents/Info.plist"
cp "$SOURCE/AppBundle/TermiPet.icns" "$APP/Contents/Resources/TermiPet.icns"

# 复制全部宠物资源到 .app（内置宠物在 PetPackage.builtInPetIds 中标记为不可删除）
mkdir -p "$APP/Contents/Resources/Pets"
for pet_dir in "$ROOT/Pets"/*/; do
    pet_name=$(basename "$pet_dir")
    if [ -f "$pet_dir/pet.json" ]; then
        mkdir -p "$APP/Contents/Resources/Pets/$pet_name"
        rsync -a --exclude ".DS_Store" "$pet_dir" "$APP/Contents/Resources/Pets/$pet_name/"
    fi
done

# 复制资源 bundle
cp -R "$RESOURCE_BUNDLE_PATH" "$APP/Contents/Resources/"

ensure_local_codesign_cert

xattr -cr "$APP" 2>/dev/null || true

if codesign --force --deep --sign "$CERT_NAME" "$APP" 2>/dev/null; then
    echo "==> 使用本地证书签名完成（辅助功能授权将跨构建保留）"
else
    echo "==> 本地证书签名失败，回退到 ad-hoc 签名（每次重建可能需要重新授权）"
    codesign --force --deep --sign - "$APP"
fi

pkill -x TermiPet 2>/dev/null || true
sleep 0.5
open "$APP"
echo "==> 已启动 $APP"
