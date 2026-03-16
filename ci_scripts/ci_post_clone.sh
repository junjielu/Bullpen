#!/bin/sh
set -e

echo "=== Installing Mise ==="
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

echo "=== Installing Tuist via Mise ==="
mise install

echo "=== Generating Xcode project ==="
mise exec -- tuist install --path ../
mise exec -- tuist generate -p ../ --no-open

echo "=== Project generated successfully ==="
