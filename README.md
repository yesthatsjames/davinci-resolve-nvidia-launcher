# DaVinci Resolve NVIDIA GPU Launcher

Force DaVinci Resolve to use your NVIDIA GPU instead of integrated graphics on Linux systems with hybrid GPU setups (laptops with both Intel/AMD iGPU and NVIDIA dGPU).

## Problem

On hybrid GPU Linux systems, DaVinci Resolve may default to using the integrated GPU, causing:
- Out of memory errors
- Poor performance
- Rendering failures
- GPU acceleration disabled

## Solution

These scripts set the proper environment variables to force DaVinci Resolve to use your NVIDIA GPU exclusively.

## Files

**Scripts:**
- **launch-resolve-nvidia.sh** - Interactive launcher with GPU checks and diagnostics
- **launch-resolve-nvidia-simple.sh** - Minimal launcher for desktop entries
- **install.sh** - Automated installation script
- **davinci-resolve-nvidia.desktop** - Desktop entry example

**Documentation:**
- **README.md** - This file
- **TROUBLESHOOTING.md** - Comprehensive troubleshooting guide
- **CONTRIBUTING.md** - Contribution guidelines
- **CHANGELOG.md** - Version history
- **LICENSE** - MIT License

## Requirements

- Linux system with NVIDIA GPU
- NVIDIA proprietary drivers installed
- DaVinci Resolve installed (typically in `/opt/resolve/`)
- `nvidia-smi` working

## Installation

### Automated Install (Recommended)

```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/yesthatsjames/davinci-resolve-nvidia-launcher/main/install.sh | bash
```

Or clone and run:
```bash
git clone https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher.git
cd davinci-resolve-nvidia-launcher
./install.sh
```

The installer will:
- Check for NVIDIA drivers and DaVinci Resolve
- Let you choose installation location (user or system-wide)
- Install launcher scripts
- Create desktop entry
- Configure everything automatically

### Manual Install

```bash
# 1. Download the simple launcher
wget https://raw.githubusercontent.com/yesthatsjames/davinci-resolve-nvidia-launcher/main/launch-resolve-nvidia-simple.sh

# 2. Make it executable
chmod +x launch-resolve-nvidia-simple.sh

# 3. Move to a directory in your PATH
sudo mv launch-resolve-nvidia-simple.sh /usr/local/bin/

# 4. Launch Resolve
launch-resolve-nvidia-simple.sh
```

### Desktop Entry Install

```bash
# 1. Download the desktop entry
wget https://raw.githubusercontent.com/yesthatsjames/davinci-resolve-nvidia-launcher/main/davinci-resolve-nvidia.desktop

# 2. Edit the Exec path to point to your script location
nano davinci-resolve-nvidia.desktop

# 3. Install to your applications directory
cp davinci-resolve-nvidia.desktop ~/.local/share/applications/

# 4. Update desktop database
update-desktop-database ~/.local/share/applications/
```

Now you can launch DaVinci Resolve from your application menu with NVIDIA GPU enabled!

### Full Launcher Install

For the interactive version with diagnostics:

```bash
# Download and make executable
wget https://raw.githubusercontent.com/yesthatsjames/davinci-resolve-nvidia-launcher/main/launch-resolve-nvidia.sh
chmod +x launch-resolve-nvidia.sh

# Run it
./launch-resolve-nvidia.sh
```

## How It Works

The scripts set these critical environment variables before launching Resolve:

```bash
__NV_PRIME_RENDER_OFFLOAD=1          # Enable NVIDIA PRIME render offload
__GLX_VENDOR_LIBRARY_NAME=nvidia     # Use NVIDIA GLX library
__VK_LAYER_NV_optimus=NVIDIA_only    # Vulkan: NVIDIA only
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json  # Vulkan ICD
RESOLVE_DISABLE_OPENCL=1             # Force CUDA instead of OpenCL
CUDA_VISIBLE_DEVICES=0               # Only show NVIDIA GPU
```

## Verification

After launching Resolve:

1. Monitor GPU usage in real-time:
   ```bash
   watch -n 1 nvidia-smi
   ```

2. In DaVinci Resolve:
   - Go to **Preferences** > **Memory and GPU**
   - Verify NVIDIA GPU is selected
   - Set **GPU Processing Mode** to **CUDA**
   - Disable Intel/AMD GPU if shown

## Troubleshooting

Having issues? Check the **[comprehensive troubleshooting guide](TROUBLESHOOTING.md)** for solutions to:

- GPU detection issues
- Out of memory errors
- Performance problems
- Installation issues
- Desktop entry problems
- Driver issues
- DaVinci Resolve specific errors

**Quick fixes:**

### "NVIDIA driver may not be loaded"
```bash
sudo modprobe nvidia nvidia_modeset nvidia_uvm
```

### Resolve still uses iGPU
1. Run from terminal to verify environment variables
2. In Resolve: Preferences > Memory and GPU > Disable Intel GPU
3. Set GPU Processing Mode to CUDA

### Out of memory errors
- Lower timeline resolution: Playback > Timeline Resolution > Quarter
- Generate optimized media or proxies
- Monitor GPU: `watch -n 1 nvidia-smi`

**For detailed solutions, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**

## Tested On

- Pop!_OS 22.04
- Ubuntu 22.04 / 24.04
- Fedora 39+
- DaVinci Resolve 18.x / 19.x / 20.x
- NVIDIA drivers 525+

## Contributing

Issues and pull requests welcome! If this helped you, please star the repo.

## License

MIT License - feel free to use and modify.

## Acknowledgments

Created to solve persistent GPU detection issues on Linux hybrid GPU systems running DaVinci Resolve.
