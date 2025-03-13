#!/bin/bash
set -e

VERSION=$1
ARCH=$(dpkg --print-architecture)

# mkdir package directory
PACKAGE_DIR="sing-box-package"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/bin"

# copy binary
cp bin/sing-box "$PACKAGE_DIR/usr/bin/"

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
