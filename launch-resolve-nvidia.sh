#!/usr/bin/env bash
# DaVinci Resolve NVIDIA GPU Launcher
# Purpose: Force DaVinci Resolve to use NVIDIA GPU instead of Intel iGPU

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎬 DaVinci Resolve - NVIDIA GPU Launcher${NC}"
echo "=================================================="

# Check if NVIDIA driver is loaded
if ! lsmod | grep -q "^nvidia"; then
    echo -e "${YELLOW}⚠️  NVIDIA driver may not be loaded${NC}"
    echo "If Resolve fails, run: sudo modprobe nvidia nvidia_modeset nvidia_uvm"
    echo "Continuing anyway..."
fi

# Check NVIDIA GPU status
if ! nvidia-smi &>/dev/null; then
    echo -e "${RED}❌ nvidia-smi failed. Check NVIDIA driver installation.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ NVIDIA driver loaded${NC}"
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader

# Find DaVinci Resolve executable
RESOLVE_PATHS=(
    "/opt/resolve/bin/resolve"
    "/opt/DaVinci_Resolve/resolve"
    "$HOME/DaVinci_Resolve/resolve"
    "/opt/resolve/resolve"
)

RESOLVE_BIN=""
for path in "${RESOLVE_PATHS[@]}"; do
    if [ -x "$path" ]; then
        RESOLVE_BIN="$path"
        break
    fi
done

if [ -z "$RESOLVE_BIN" ]; then
    echo -e "${RED}❌ DaVinci Resolve not found in common locations.${NC}"
    echo "Please specify path manually:"
    read -p "Enter full path to resolve binary: " RESOLVE_BIN
    if [ ! -x "$RESOLVE_BIN" ]; then
        echo -e "${RED}❌ Invalid path or file not executable${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Found DaVinci Resolve: ${RESOLVE_BIN}${NC}"

# Set environment variables to force NVIDIA GPU
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json

# Additional DaVinci Resolve optimizations
export RESOLVE_DISABLE_OPENCL=1  # Use CUDA only, not OpenCL
export CUDA_VISIBLE_DEVICES=0     # Only show NVIDIA GPU (device 0)

# Optional: Set GPU memory management
# Uncomment if you experience memory issues
# export VK_MEMORY_FORCE_DEVICE_LOCAL=1

echo -e "${YELLOW}🚀 Launching DaVinci Resolve with NVIDIA GPU...${NC}"
echo ""
echo "Environment variables set:"
echo "  __NV_PRIME_RENDER_OFFLOAD=1"
echo "  __GLX_VENDOR_LIBRARY_NAME=nvidia"
echo "  __VK_LAYER_NV_optimus=NVIDIA_only"
echo "  CUDA_VISIBLE_DEVICES=0"
echo "  RESOLVE_DISABLE_OPENCL=1"
echo ""
echo -e "${GREEN}GPU Info:${NC}"
nvidia-smi --query-gpu=name,memory.free,memory.used,temperature.gpu --format=csv,noheader

echo ""
echo -e "${YELLOW}Starting DaVinci Resolve...${NC}"
echo "=================================================="

# Launch Resolve and redirect output to log file
LOG_FILE="$HOME/.cache/resolve_nvidia_launch.log"
mkdir -p "$HOME/.cache"

"$RESOLVE_BIN" > "$LOG_FILE" 2>&1 &
RESOLVE_PID=$!

echo -e "${GREEN}✅ DaVinci Resolve launched (PID: $RESOLVE_PID)${NC}"
echo "Log file: $LOG_FILE"
echo ""
echo "To monitor GPU usage in real-time, run:"
echo "  watch -n 1 nvidia-smi"
echo ""
echo "If you still see 'out of memory' errors:"
echo "1. Go to DaVinci Resolve > Preferences > Memory and GPU"
echo "2. Set 'GPU Processing Mode' to 'CUDA'"
echo "3. Uncheck any Intel GPU options"
echo "4. Set 'GPU Configuration' to use only NVIDIA GPU"
echo "5. Restart DaVinci Resolve with this script"

# Optional: Keep script running to monitor
echo ""
read -p "Press Enter to exit launcher (Resolve will keep running)..."

exit 0
