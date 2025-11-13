# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-13

### Added
- Initial release of DaVinci Resolve NVIDIA GPU launcher
- Interactive launcher script with GPU diagnostics (`launch-resolve-nvidia.sh`)
- Simple launcher script for desktop entries (`launch-resolve-nvidia-simple.sh`)
- Desktop entry file template (`davinci-resolve-nvidia.desktop`)
- Comprehensive README with installation and usage instructions
- MIT License
- Support for NVIDIA PRIME render offload
- Automatic NVIDIA driver detection
- GPU status reporting
- Multiple Resolve installation path detection
- Log file creation for troubleshooting
- Environment variables for optimal CUDA performance:
  - `__NV_PRIME_RENDER_OFFLOAD=1`
  - `__GLX_VENDOR_LIBRARY_NAME=nvidia`
  - `__VK_LAYER_NV_optimus=NVIDIA_only`
  - `VK_ICD_FILENAMES` for Vulkan support
  - `RESOLVE_DISABLE_OPENCL=1` to force CUDA
  - `CUDA_VISIBLE_DEVICES=0` to hide iGPU

### Features
- Works on hybrid GPU systems (Intel/AMD iGPU + NVIDIA dGPU)
- Tested on Pop!_OS, Ubuntu, and Fedora
- Compatible with DaVinci Resolve 18.x, 19.x, and 20.x
- Color-coded terminal output for easy reading
- Real-time GPU monitoring suggestions
- In-app configuration instructions

## [Unreleased]

### Planned
- Automatic installation script
- Support for AMD GPU forcing
- Configuration file for custom settings
- GUI launcher option
- System tray integration
- Automatic driver loading if needed
- Multi-GPU selection support
- Performance profiling mode
- Integration with system monitors

---

## Version History

### Version Numbering
- **Major version** (X.0.0): Breaking changes or major new features
- **Minor version** (0.X.0): New features, backwards compatible
- **Patch version** (0.0.X): Bug fixes and minor improvements

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.

### Support
- Report bugs via [GitHub Issues](https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues)
- For questions, start a [GitHub Discussion](https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/discussions)
