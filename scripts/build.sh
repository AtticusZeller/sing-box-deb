#!/bin/bash

# Exit on error
set -e



# Get the latest tag
LATEST_TAG=$1
DEB_ARCH=${2:-$(dpkg --print-architecture)}

if [ -z "$LATEST_TAG" ]; then
  echo "Usage: $0 <tag> [amd64|arm64]"
  exit 1
fi

case "$DEB_ARCH" in
  amd64)
    TARGET_GOARCH=amd64
    ;;
  arm64)
    TARGET_GOARCH=arm64
    ;;
  *)
    echo "Unsupported architecture: $DEB_ARCH"
    echo "Supported architectures: amd64, arm64"
    exit 1
    ;;
esac

echo "Latest tag found: $LATEST_TAG"
echo "Target architecture: $DEB_ARCH"

# Clone the repository with the latest tag
git clone https://github.com/SagerNet/sing-box --depth 1 --branch "$LATEST_TAG"
cd sing-box

# Set variables (converted from Makefile)
TAGS="with_quic,with_wireguard,with_clash_api,with_gvisor"
GOHOSTOS=$(go env GOHOSTOS)
VERSION=$(go run ./cmd/internal/read_tag)
export CGO_ENABLED=0
export GOOS=$GOHOSTOS
export GOARCH=$TARGET_GOARCH

# Build parameters
PARAMS=(-v -trimpath -ldflags "-X 'github.com/sagernet/sing-box/constant.Version=$VERSION' -s -w -buildid=")
MAIN_PARAMS=("${PARAMS[@]}" -tags "$TAGS")
MAIN="./cmd/sing-box"

# Build the project
echo "Building sing-box version $VERSION..."
go build "${MAIN_PARAMS[@]}" "$MAIN"

# Copy the binary to the root directory
cd ..
mkdir -p bin
cp sing-box/sing-box "./bin/sing-box-${DEB_ARCH}"

echo "Build completed successfully!"
echo "The binary is located at: $(pwd)/bin/sing-box-${DEB_ARCH}"

# Clean up
rm -rf sing-box/
