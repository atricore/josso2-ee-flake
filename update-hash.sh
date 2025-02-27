#!/usr/bin/env bash
        set -e

        BUILD_NUMBER="1"
        NEW_HASH="16r6xnq0d0yvl5sgwic265bmm38xk8irwqbzz5y5vig0d2s4zwai"

        echo "Build    # $BUILD_NUMBER"
        echo "Nix hash # $NEW_HASH"

        ZIP_FILE="./tmp/josso-ee-2.6.3-SNAPSHOT-server-unix.tar.gz"

        if [ ! -f "$ZIP_FILE" ]; then
          echo "Error: File $ZIP_FILE not found"
          exit 1
        fi

        ZIP_FILE=$(realpath "$ZIP_FILE")
        ZIP_FILE_NAME=$(basename "$ZIP_FILE")

        echo "Calculating hash for $ZIP_FILE..."
        NEW_BUILD_ID=$(echo "$NEW_HASH" | cut -c1-8)
        echo "New hash: $NEW_HASH"
        echo "New build ID: $NEW_BUILD_ID"

        # Update the flake.nix file with the new hash
        sed -i "s|sha256 = \"[^\"]*\"|sha256 = \"$NEW_HASH\"|" flake.nix

        # Update the file path in flake.nix
        # Create file:// URL with invalidateCache parameter
        FILE_URL="file://$ZIP_FILE?invalidateCache=$BUILD_NUMBER"

        echo "Configuring FILE in flake: $FILE_URL"
        # Escape for sed
        ESCAPED_URL=$(echo "$FILE_URL" | sed 's/[\/&]/\\&/g')

        # Update the path in the config
        sed -i "s|filePath = \"[^\"]*\"|filePath = \"$ESCAPED_URL\"|" flake.nix
        sed -i "s|jossoUpdate = \"[^\"]*\"|jossoUpdate = \"$BUILD_NUMBER\"|" flake.nix

        echo "Updated flake.nix with the new hash and file path"
        echo "Run 'nix build' to build the package with the new version"
