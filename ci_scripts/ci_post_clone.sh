#!/bin/bash
set -e

echo "=== Installing Tuist ==="
curl -Ls https://install.tuist.io | bash
export PATH="$HOME/.tuist/bin:$PATH"

echo "=== Generating Xcode project ==="
cd "$CI_PRIMARY_REPOSITORY_PATH"
tuist install 2>/dev/null || true
tuist generate --no-open

echo "=== Project generated successfully ==="
