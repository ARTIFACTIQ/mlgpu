#!/bin/bash
# mlgpu installer
# Usage: curl -fsSL https://raw.githubusercontent.com/artifactiq/mlgpu/main/install.sh | bash

set -e

REPO="artifactiq/mlgpu"
INSTALL_DIR="/usr/local/bin"
TEMP_DIR=$(mktemp -d)

echo "╔════════════════════════════════════════════╗"
echo "║  mlgpu - Apple Silicon GPU Monitor         ║"
echo "║  for ML Training                           ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check for Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    echo "⚠️  Warning: mlgpu is designed for Apple Silicon Macs."
    echo "   Some features may not work on Intel Macs."
    echo ""
fi

# Check for required tools
command -v curl >/dev/null 2>&1 || { echo "❌ curl is required but not installed."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "❌ python3 is required but not installed."; exit 1; }

echo "📦 Downloading mlgpu..."
curl -fsSL "https://raw.githubusercontent.com/${REPO}/main/mlgpu" -o "${TEMP_DIR}/mlgpu"

echo "🔧 Installing to ${INSTALL_DIR}..."
chmod +x "${TEMP_DIR}/mlgpu"

# Try to install to /usr/local/bin, fall back to ~/bin if no permission
if [ -w "$INSTALL_DIR" ]; then
    mv "${TEMP_DIR}/mlgpu" "${INSTALL_DIR}/mlgpu"
else
    echo "   Need sudo permission to install to ${INSTALL_DIR}"
    sudo mv "${TEMP_DIR}/mlgpu" "${INSTALL_DIR}/mlgpu"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ mlgpu installed successfully!"
echo ""
echo "Usage:"
echo "   mlgpu              # Start monitoring"
echo "   mlgpu --help       # Show all options"
echo "   mlgpu --json       # JSON output for scripting"
echo ""
echo "Quick start:"
echo "   mlgpu -l ./train.log -i 50000    # Monitor PyTorch training"
echo "   mlgpu -p ~/Project.mlproj        # Monitor Create ML"
echo ""
echo "More info: https://github.com/${REPO}"
