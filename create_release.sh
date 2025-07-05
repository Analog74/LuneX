#!/bin/bash
# Release creation script for LuneX
# Usage: ./create_release.sh <version> [<description>]

set -e

VERSION=$1
DESCRIPTION=${2:-"Release $VERSION"}
RELEASE_DIR="releases"

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [<description>]"
    echo "Example: $0 v0.1.4 'Bug fixes and improvements'"
    exit 1
fi

echo "Creating release $VERSION..."

# Build the binary
echo "Building release binary..."
cargo build --release

# Create release directory if it doesn't exist
mkdir -p "$RELEASE_DIR"

# Copy binary with version tag
BINARY_NAME="LuneX-macos-$VERSION"
cp target/release/LuneX "$RELEASE_DIR/$BINARY_NAME"

# Create compressed archives
echo "Creating compressed archives..."
cd "$RELEASE_DIR"

# Create zip
zip "$BINARY_NAME.zip" "$BINARY_NAME"

# Create gzip
gzip -c "$BINARY_NAME" > "$BINARY_NAME.gz"

# Return to root directory
cd ..

# Create source archives
echo "Creating source code archives..."
git archive --format=tar.gz --prefix="LuneX-$VERSION/" "$VERSION" -o "$RELEASE_DIR/LuneX-$VERSION-source.tar.gz"
git archive --format=zip --prefix="LuneX-$VERSION/" "$VERSION" -o "$RELEASE_DIR/LuneX-$VERSION-source.zip"

# Generate checksums
echo "Generating checksums..."
cd "$RELEASE_DIR"
shasum -a 256 LuneX-macos-$VERSION* LuneX-$VERSION-source* > "CHECKSUMS-$VERSION.txt"
cd ..

echo "Release $VERSION created successfully!"
echo "Files created:"
echo "  - $RELEASE_DIR/$BINARY_NAME (raw binary)"
echo "  - $RELEASE_DIR/$BINARY_NAME.zip (compressed binary)"
echo "  - $RELEASE_DIR/$BINARY_NAME.gz (gzipped binary)"
echo "  - $RELEASE_DIR/LuneX-$VERSION-source.tar.gz (source archive)"
echo "  - $RELEASE_DIR/LuneX-$VERSION-source.zip (source archive)"
echo "  - $RELEASE_DIR/CHECKSUMS-$VERSION.txt (checksums)"
echo ""
echo "Next steps:"
echo "1. Test the binary: $RELEASE_DIR/$BINARY_NAME"
echo "2. Update CHANGELOG.md"
echo "3. Commit and push changes"
echo "4. Create GitHub release with these files"
echo "5. Update global installation: sudo cp $RELEASE_DIR/$BINARY_NAME /usr/local/bin/lunex"
