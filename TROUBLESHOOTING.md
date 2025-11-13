# Troubleshooting Guide

Common issues and solutions for the DaVinci Resolve NVIDIA Launcher.

## Table of Contents
- [GPU Detection Issues](#gpu-detection-issues)
- [Out of Memory Errors](#out-of-memory-errors)
- [Performance Issues](#performance-issues)
- [Installation Problems](#installation-problems)
- [Desktop Entry Issues](#desktop-entry-issues)
- [Driver Issues](#driver-issues)
- [DaVinci Resolve Specific](#davinci-resolve-specific)

---

## GPU Detection Issues

### "NVIDIA driver may not be loaded"

**Symptoms:** Script shows warning about NVIDIA driver not being loaded.

**Solution:**
```bash
# Load NVIDIA kernel modules manually
sudo modprobe nvidia nvidia_modeset nvidia_uvm

# Verify modules are loaded
lsmod | grep nvidia
```

**Permanent fix:**
```bash
# Add modules to load on boot
echo -e "nvidia\nnvidia_modeset\nnvidia_uvm" | sudo tee /etc/modules-load.d/nvidia.conf
```

### "nvidia-smi failed"

**Symptoms:** `nvidia-smi` command doesn't work or shows errors.

**Check driver installation:**
```bash
# Check if NVIDIA driver is installed
dpkg -l | grep nvidia-driver  # Ubuntu/Debian
rpm -qa | grep nvidia-driver  # Fedora/RHEL

# Check driver version
cat /proc/driver/nvidia/version
```

**Reinstall drivers (Ubuntu/Pop!_OS):**
```bash
# Remove old drivers
sudo apt purge nvidia-*
sudo apt autoremove

# Install fresh drivers
sudo apt update
sudo apt install nvidia-driver-535  # or latest version

# Reboot
sudo reboot
```

**Reinstall drivers (Fedora):**
```bash
sudo dnf install akmod-nvidia
sudo akmods --force
sudo reboot
```

### Resolve still uses Intel iGPU

**Symptoms:** DaVinci Resolve runs but doesn't use NVIDIA GPU.

**Verify environment variables:**
```bash
# Launch from terminal to see variables
./launch-resolve-nvidia.sh

# Should show:
# __NV_PRIME_RENDER_OFFLOAD=1
# __GLX_VENDOR_LIBRARY_NAME=nvidia
```

**Check Resolve preferences:**
1. Open DaVinci Resolve
2. Go to **Preferences** > **Memory and GPU**
3. **Manual GPU selection:**
   - Disable Intel GPU
   - Enable only NVIDIA GPU
4. Set **GPU Processing Mode** to **CUDA**
5. Restart Resolve with the launcher

**Monitor GPU usage:**
```bash
# Run this while using Resolve
watch -n 1 nvidia-smi

# You should see:
# - GPU utilization increasing during renders
# - Memory usage going up when loading media
```

---

## Out of Memory Errors

### "Out of GPU memory" in Resolve

**Symptoms:** Resolve shows GPU memory errors, playback stutters, or crashes.

**Quick fixes:**

1. **Lower timeline resolution:**
   - Playback > Timeline Resolution > Quarter or Eighth

2. **Use optimized media:**
   - Right-click clips > Generate Optimized Media
   - Uses ProRes or DNxHR (less GPU memory)

3. **Use proxy files:**
   - Right-click clips > Generate Proxy Media
   - Edit with proxies, deliver with originals

4. **Close other GPU apps:**
   ```bash
   # Kill other GPU processes
   nvidia-smi
   # Note PID of other apps
   kill <PID>
   ```

5. **Reduce cache sizes:**
   - Preferences > Memory and GPU
   - Reduce "Cached Frames" setting

**Check available memory:**
```bash
nvidia-smi --query-gpu=memory.free,memory.used,memory.total --format=csv
```

**For 4GB or less GPU memory:**
```bash
# Edit launch script and add:
export VK_MEMORY_FORCE_DEVICE_LOCAL=1
```

### System RAM issues

**Symptoms:** System runs out of RAM, swap usage high.

**Solutions:**
```bash
# Check RAM usage
free -h

# Check swap
swapon --show

# Add more swap if needed (temporary)
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## Performance Issues

### Slow playback / choppy timeline

**Render cache settings:**
1. Playback > Render Cache > Smart
2. Wait for red/yellow bars to turn blue

**GPU decode acceleration:**
- Preferences > Decode Options
- Enable "Use hardware acceleration for decoding" for all formats

**Timeline proxy mode:**
- Playback > Timeline Proxy Mode > Quarter Resolution

### Slow exports/renders

**Check GPU usage during render:**
```bash
watch -n 1 nvidia-smi
```

**If GPU usage is low (<50%):**
1. Preferences > Memory and GPU
2. Set "GPU Configuration" to Manual
3. Enable only NVIDIA GPU
4. Set Processing Mode to CUDA
5. Restart Resolve

**Optimize render settings:**
- Deliver page > Video tab
- Use hardware encoding: H.264/H.265 (NVIDIA)
- Enable "Use optimized media" if available

---

## Installation Problems

### "Command not found" after installation

**PATH not updated:**
```bash
# Add to PATH (bash)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Add to PATH (zsh)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
which launch-resolve-nvidia.sh
```

### Permission denied

**Scripts not executable:**
```bash
chmod +x ~/. local/bin/launch-resolve-nvidia*.sh
```

### Can't find DaVinci Resolve

**Custom Resolve location:**
```bash
# Edit the script
nano ~/.local/bin/launch-resolve-nvidia-simple.sh

# Change this line:
/opt/resolve/bin/resolve "$@" &

# To your actual path, e.g.:
/home/username/DaVinci_Resolve/resolve "$@" &
```

---

## Desktop Entry Issues

### Launcher doesn't appear in menu

**Update desktop database:**
```bash
update-desktop-database ~/.local/share/applications/
```

**Check desktop file:**
```bash
desktop-file-validate ~/.local/share/applications/davinci-resolve-nvidia.desktop
```

**Fix icon path:**
```bash
# If icon doesn't show, edit desktop entry
nano ~/.local/share/applications/davinci-resolve-nvidia.desktop

# Update Icon path to actual location:
Icon=/opt/resolve/graphics/DV_Resolve.png
```

### Launcher appears but doesn't work

**Enable logging:**
```bash
# Edit desktop entry
nano ~/.local/share/applications/davinci-resolve-nvidia.desktop

# Change these lines:
Exec=/path/to/launch-resolve-nvidia.sh
Terminal=true  # Show terminal to see errors
```

**Check logs:**
```bash
cat ~/.cache/resolve_nvidia_launch.log
```

---

## Driver Issues

### "Kernel module not loaded"

**After driver update:**
```bash
sudo modprobe nvidia
sudo modprobe nvidia_modeset
sudo modprobe nvidia_uvm

# Rebuild kernel modules
sudo dkms autoinstall
```

### Black screen on boot after driver install

**Boot to recovery mode:**
1. Hold Shift during boot
2. Select "Advanced options"
3. Select "Recovery mode"

**Remove NVIDIA drivers:**
```bash
sudo apt purge nvidia-*
sudo apt install --reinstall ubuntu-desktop
sudo reboot
```

**Try different driver version:**
```bash
# Ubuntu - use driver manager
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall

# Or install specific version
sudo apt install nvidia-driver-525
```

### Driver version mismatch

**Symptoms:** `nvidia-smi` shows different version than expected.

**Solution:**
```bash
# Check kernel headers match kernel version
uname -r
dpkg -l | grep linux-headers

# Install matching headers
sudo apt install linux-headers-$(uname -r)

# Rebuild NVIDIA modules
sudo dkms autoinstall
sudo reboot
```

---

## DaVinci Resolve Specific

### Resolve crashes on startup

**Check dependencies:**
```bash
# Ubuntu/Debian
sudo apt install libssl1.1 ocl-icd-libopencl1

# Fedora
sudo dnf install compat-openssl11 ocl-icd
```

**Run from terminal to see errors:**
```bash
/opt/resolve/bin/resolve
```

### Audio playback issues

**PulseAudio compatibility:**
```bash
# Install PulseAudio support
sudo apt install pulseaudio

# Restart PulseAudio
systemctl --user restart pulseaudio
```

### Database errors

**Reset Resolve database:**
```bash
# Backup first!
cp -r ~/.local/share/DaVinciResolve ~/.local/share/DaVinciResolve.backup

# Reset
rm -rf ~/.local/share/DaVinciResolve/Resolve\ Disk\ Database/
```

### Can't import certain video formats

**Install additional codecs:**
```bash
# Ubuntu
sudo apt install ffmpeg

# Fedora
sudo dnf install ffmpeg

# Generate optimized media for unsupported formats
```

---

## Getting More Help

### Enable detailed logging

**Create debug launch script:**
```bash
#!/usr/bin/env bash
set -x  # Print all commands
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export RESOLVE_DISABLE_OPENCL=1
export CUDA_VISIBLE_DEVICES=0

/opt/resolve/bin/resolve 2>&1 | tee ~/resolve_debug.log
```

### Gather system information

**For bug reports:**
```bash
# System info
uname -a
lsb_release -a

# GPU info
nvidia-smi
lspci | grep -i nvidia

# Driver info
cat /proc/driver/nvidia/version
modinfo nvidia

# Resolve version
/opt/resolve/bin/resolve --version

# Environment
env | grep -i nvidia
env | grep -i cuda
```

### Report issues

**Before opening an issue:**
1. Check existing issues: https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues
2. Gather system information (above)
3. Include reproduction steps
4. Attach logs if available

**Open new issue:**
- Bug report: https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues/new
- Include: system info, error messages, logs

---

## Common Error Messages

### "Failed to initialize CUDA"
- **Cause:** NVIDIA driver not loaded or incompatible
- **Fix:** Reinstall NVIDIA drivers, ensure CUDA toolkit installed

### "No GPU detected"
- **Cause:** Environment variables not set correctly
- **Fix:** Verify script is setting variables correctly, check `env | grep -i nvidia`

### "Unsupported GPU configuration"
- **Cause:** Resolve doesn't support your GPU
- **Fix:** Check Resolve system requirements, update drivers

### "OpenCL device not found"
- **Cause:** OpenCL not installed or configured
- **Fix:** Install `ocl-icd-libopencl1`, or use CUDA only (script does this)

### "Permission denied accessing /dev/nvidia0"
- **Cause:** User not in video group
- **Fix:** `sudo usermod -aG video $USER` then logout/login

---

## Still Need Help?

- **GitHub Discussions:** https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/discussions
- **GitHub Issues:** https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues
- **DaVinci Resolve Forum:** https://forum.blackmagicdesign.com/
