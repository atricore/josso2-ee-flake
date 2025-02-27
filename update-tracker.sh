#!/usr/bin/env bash
# This script manages the update number for JOSSO EE builds

set -e

UPDATE_FILE=".josso-update-number"
VERSION_FILE="josso-version.nix"

# Extract the current hash from the version file
CURRENT_HASH=$(grep -oP 'sha256 = "\K[^"]+' "$VERSION_FILE")

# Create the update file if it doesn't exist
if [ ! -f "$UPDATE_FILE" ]; then
  echo '{"updateNumber": 1, "lastHash": "'"$CURRENT_HASH"'"}' > "$UPDATE_FILE"
  echo "Created new update tracker with initial update number 1"
  exit 0
fi

# Read the last hash and update number
LAST_HASH=$(grep -oP '"lastHash":\s*"\K[^"]+' "$UPDATE_FILE")
UPDATE_NUMBER=$(grep -oP '"updateNumber":\s*\K\d+' "$UPDATE_FILE")

# If the hash has changed, increment the update number
if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
  let UPDATE_NUMBER++
  echo '{"updateNumber": '"$UPDATE_NUMBER"', "lastHash": "'"$CURRENT_HASH"'"}' > "$UPDATE_FILE"
  echo "Hash changed, incremented update number to $UPDATE_NUMBER"
else
  echo "Hash unchanged, update number remains $UPDATE_NUMBER"
fi

# Return the current update number for use in the build
echo "$UPDATE_NUMBER"
