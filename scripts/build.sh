#!/bin/bash

# Exit on error
set -e



# Get the latest tag
LATEST_TAG=$1
echo "Latest tag found: $LATEST_TAG"

# Clone the repository with the latest tag
git clone https://github.com/SagerNet/sing-box --depth 1 --branch "$LATEST_TAG"
cd sing-box

# Set variables (converted from Makefile)
TAGS="with_quic,with_wireguard,with_clash_api,with_gvisor"
GOHOSTOS=$(go env GOHOSTOS)
GOHOSTARCH=$(go env GOHOSTARCH)
export CGO_ENABLED=0
export GOOS=$GOHOSTOS
export GOARCH=$GOHOSTARCH
VERSION=$(go run ./cmd/internal/read_tag)

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
cp sing-box/sing-box ./bin

echo "Build completed successfully!"
echo "The binary is located at: $(pwd)/bin/sing-box"

# Clean up
rm -rf sing-box/
