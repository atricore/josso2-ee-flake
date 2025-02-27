#!/usr/bin/env bash
# This script updates the JOSSO EE package with a new zip file

set -e

VERSION_FILE="josso-version.nix"

# Check arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-new-zip-file>"
  exit 1
fi

ZIP_FILE="$1"

# Check if the zip file exists
if [ ! -f "$ZIP_FILE" ]; then
  echo "Error: File $ZIP_FILE not found"
  exit 1
fi

# Get the hash of the new file
echo "Calculating hash for $ZIP_FILE..."
NEW_HASH=$(nix-prefetch-url "file://$ZIP_FILE" 2>/dev/null)

if [ -z "$NEW_HASH" ]; then
  echo "Error: Failed to calculate hash for $ZIP_FILE"
  exit 1
fi

echo "New hash: $NEW_HASH"

# Update the version file with the new hash
sed -i "s|sha256 = \"[^\"]*\"|sha256 = \"$NEW_HASH\"|" "$VERSION_FILE"

echo "Updated $VERSION_FILE with the new hash"
echo "Run the update-tracker.sh script to update the build number"
echo "Then run 'nix build' to build the package with the new version"
