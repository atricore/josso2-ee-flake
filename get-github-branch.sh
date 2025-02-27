#!/usr/bin/env bash
# This script determines the current git branch for versioning

set -e

VERSION_FILE="josso-version.nix"

# Extract the default version from the version file as fallback
DEFAULT_VERSION=$(grep -oP 'version = "\K[^"]+' "$VERSION_FILE")

# Check if we're in a git repository
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Get the current branch name
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  # If we got a branch name, use it; otherwise use the default
  if [ -n "$BRANCH" ] && [ "$BRANCH" != "HEAD" ]; then
    echo "$BRANCH"
  else
    echo "$DEFAULT_VERSION"
  fi
else
  # Not in a git repository, use the default version
  echo "$DEFAULT_VERSION"
fi
