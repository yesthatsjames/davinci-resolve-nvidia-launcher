#!/usr/bin/env bash
# Simple DaVinci Resolve NVIDIA launcher
# Use this for desktop launchers or automated scripts

# Force NVIDIA GPU
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export RESOLVE_DISABLE_OPENCL=1
export CUDA_VISIBLE_DEVICES=0

# Launch Resolve (run in background so script doesn't block)
/opt/resolve/bin/resolve "$@" &
