#!/bin/bash
set -e

VERSION=$1
ARCH=${2:-$(dpkg --print-architecture)}

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <tag> [amd64|arm64]"
  exit 1
fi

case "$ARCH" in
  amd64 | arm64)
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    echo "Supported architectures: amd64, arm64"
    exit 1
    ;;
esac

BINARY="bin/sing-box-${ARCH}"
if [ ! -f "$BINARY" ]; then
  echo "Missing binary: $BINARY"
  echo "Run scripts/build.sh $VERSION $ARCH first."
  exit 1
fi

# mkdir package directory
PACKAGE_DIR="sing-box-package-${ARCH}"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/bin"

# copy binary
cp "$BINARY" "$PACKAGE_DIR/usr/bin/sing-box"

# control
cat >"$PACKAGE_DIR/DEBIAN/control" <<EOF
Package: sing-box
Version: ${VERSION#v}
Section: net
Priority: optional
Architecture: $ARCH
Maintainer: SagerNet
Description: The universal proxy platform.
EOF

chmod 755 "$PACKAGE_DIR/usr/bin/sing-box"
chmod -R 755 "$PACKAGE_DIR/DEBIAN"
find "$PACKAGE_DIR" -type d -exec chmod 755 {} \;

dpkg-deb --build "$PACKAGE_DIR"
mv "${PACKAGE_DIR}.deb" "sing-box_${VERSION#v}_${ARCH}.deb"
