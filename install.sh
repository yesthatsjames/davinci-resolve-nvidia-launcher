#!/usr/bin/env bash
# DaVinci Resolve NVIDIA Launcher - Installation Script
# Automatically installs the launcher scripts and desktop entry

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  DaVinci Resolve NVIDIA Launcher - Installer  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Don't run this script as root/sudo${NC}"
    echo "Run as your normal user: ./install.sh"
    exit 1
fi

# Check for NVIDIA GPU
echo -e "${YELLOW}🔍 Checking system requirements...${NC}"
if ! command -v nvidia-smi &> /dev/null; then
    echo -e "${RED}❌ nvidia-smi not found${NC}"
    echo "Please install NVIDIA drivers first."
    exit 1
fi

if ! nvidia-smi &>/dev/null; then
    echo -e "${RED}❌ NVIDIA GPU not detected${NC}"
    echo "Please ensure NVIDIA drivers are installed and working."
    exit 1
fi

echo -e "${GREEN}✅ NVIDIA GPU detected:${NC}"
nvidia-smi --query-gpu=name,driver_version --format=csv,noheader

# Check for DaVinci Resolve
echo ""
echo -e "${YELLOW}🔍 Checking for DaVinci Resolve...${NC}"
RESOLVE_PATHS=(
    "/opt/resolve/bin/resolve"
    "/opt/DaVinci_Resolve/resolve"
    "$HOME/DaVinci_Resolve/resolve"
    "/opt/resolve/resolve"
)

RESOLVE_FOUND=false
for path in "${RESOLVE_PATHS[@]}"; do
    if [ -x "$path" ]; then
        echo -e "${GREEN}✅ Found DaVinci Resolve: ${path}${NC}"
        RESOLVE_FOUND=true
        break
    fi
done

if [ "$RESOLVE_FOUND" = false ]; then
    echo -e "${YELLOW}⚠️  DaVinci Resolve not found in common locations${NC}"
    echo "Installation will continue, but you may need to adjust paths manually."
fi

# Installation options
echo ""
echo -e "${BLUE}Select installation type:${NC}"
echo "1) User installation (recommended) - Install to ~/.local/bin"
echo "2) System installation - Install to /usr/local/bin (requires sudo)"
echo "3) Custom path"
echo "4) Cancel"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        INSTALL_DIR="$HOME/.local/bin"
        DESKTOP_DIR="$HOME/.local/share/applications"
        USE_SUDO=false
        ;;
    2)
        INSTALL_DIR="/usr/local/bin"
        DESKTOP_DIR="/usr/share/applications"
        USE_SUDO=true
        ;;
    3)
        read -p "Enter installation directory: " INSTALL_DIR
        DESKTOP_DIR="$HOME/.local/share/applications"
        USE_SUDO=false
        ;;
    4)
        echo "Installation cancelled."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Create directories if they don't exist
echo ""
echo -e "${YELLOW}📁 Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$DESKTOP_DIR"

# Install scripts
echo ""
echo -e "${YELLOW}📦 Installing launcher scripts...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$USE_SUDO" = true ]; then
    sudo cp "$SCRIPT_DIR/launch-resolve-nvidia.sh" "$INSTALL_DIR/"
    sudo cp "$SCRIPT_DIR/launch-resolve-nvidia-simple.sh" "$INSTALL_DIR/"
    sudo chmod +x "$INSTALL_DIR/launch-resolve-nvidia.sh"
    sudo chmod +x "$INSTALL_DIR/launch-resolve-nvidia-simple.sh"
else
    cp "$SCRIPT_DIR/launch-resolve-nvidia.sh" "$INSTALL_DIR/"
    cp "$SCRIPT_DIR/launch-resolve-nvidia-simple.sh" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/launch-resolve-nvidia.sh"
    chmod +x "$INSTALL_DIR/launch-resolve-nvidia-simple.sh"
fi

echo -e "${GREEN}✅ Scripts installed to: ${INSTALL_DIR}${NC}"

# Install desktop entry
echo ""
echo -e "${YELLOW}🖥️  Installing desktop entry...${NC}"

DESKTOP_FILE="$DESKTOP_DIR/davinci-resolve-nvidia.desktop"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=DaVinci Resolve (NVIDIA GPU)
Comment=Launch DaVinci Resolve with NVIDIA GPU
Exec=$INSTALL_DIR/launch-resolve-nvidia-simple.sh
Icon=/opt/resolve/graphics/DV_Resolve.png
Terminal=false
Categories=AudioVideo;Video;
StartupNotify=true
Path=/opt/resolve
EOF

chmod +x "$DESKTOP_FILE"
echo -e "${GREEN}✅ Desktop entry installed to: ${DESKTOP_FILE}${NC}"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" &>/dev/null || true
fi

# Add to PATH if needed
if [ "$USE_SUDO" = false ] && [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}📝 Note: $INSTALL_DIR is not in your PATH${NC}"
    echo ""
    echo "Add it by running:"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi

# Installation complete
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Installation Complete! 🎉           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}You can now:${NC}"
echo ""
echo -e "1. ${GREEN}Launch from application menu:${NC}"
echo "   Look for 'DaVinci Resolve (NVIDIA GPU)'"
echo ""
echo -e "2. ${GREEN}Launch from terminal:${NC}"
echo "   ${INSTALL_DIR}/launch-resolve-nvidia.sh"
echo ""
echo -e "3. ${GREEN}Monitor GPU usage:${NC}"
echo "   watch -n 1 nvidia-smi"
echo ""
echo -e "${YELLOW}💡 First time setup:${NC}"
echo "1. Launch DaVinci Resolve using the NVIDIA launcher"
echo "2. Go to Preferences > Memory and GPU"
echo "3. Verify NVIDIA GPU is selected"
echo "4. Set GPU Processing Mode to 'CUDA'"
echo ""
echo -e "${BLUE}Need help? Check:${NC}"
echo "- README.md for documentation"
echo "- TROUBLESHOOTING.md for common issues"
echo "- GitHub issues: https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues"
echo ""
