# Contributing to DaVinci Resolve NVIDIA Launcher

Thank you for your interest in contributing! This project aims to help Linux users with hybrid GPU systems run DaVinci Resolve smoothly on their NVIDIA GPUs.

## How to Contribute

### Reporting Bugs

If you encounter a bug, please [open an issue](https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues) with:

1. **System Information:**
   - Linux distribution and version
   - NVIDIA driver version (`nvidia-smi`)
   - DaVinci Resolve version
   - GPU model (both iGPU and dGPU)

2. **Description:**
   - What you expected to happen
   - What actually happened
   - Steps to reproduce

3. **Logs:**
   - Output from running the script
   - Contents of `~/.cache/resolve_nvidia_launch.log`
   - Output of `nvidia-smi`

### Suggesting Features

Feature requests are welcome! Please [open an issue](https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/issues) with:

- Clear description of the feature
- Use case: why would this be helpful?
- Proposed implementation (if you have ideas)

### Submitting Pull Requests

1. **Fork the repository**
   ```bash
   gh repo fork yesthatsjames/davinci-resolve-nvidia-launcher --clone
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Test on your system

4. **Test your changes**
   - Verify scripts work on your hardware
   - Check for syntax errors: `shellcheck *.sh`
   - Ensure desktop entry validates: `desktop-file-validate *.desktop`

5. **Commit with clear messages**
   ```bash
   git commit -m "Add feature: brief description"
   ```

6. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   gh pr create --fill
   ```

### Code Style Guidelines

#### Bash Scripts
- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Use meaningful variable names in CAPS for exports
- Add comments for non-obvious logic
- Use functions for reusable code
- Quote variables: `"$VAR"` not `$VAR`
- Use `[[ ]]` instead of `[ ]` for conditionals

#### Example:
```bash
#!/usr/bin/env bash
set -euo pipefail

# Check if NVIDIA driver is loaded
check_nvidia_driver() {
    if ! lsmod | grep -q "^nvidia"; then
        echo "NVIDIA driver not loaded"
        return 1
    fi
    return 0
}
```

### Testing Checklist

Before submitting a PR, ensure:

- [ ] Script runs without errors
- [ ] NVIDIA GPU is actually used by Resolve
- [ ] Works with script in different directories
- [ ] Desktop entry launches correctly
- [ ] No personal/system-specific paths hardcoded
- [ ] Documentation updated if behavior changed
- [ ] CHANGELOG.md updated with your changes

### Documentation

When adding features:
- Update README.md with new instructions
- Add entry to CHANGELOG.md under [Unreleased]
- Update comments in code
- Add troubleshooting section if needed

### Areas for Contribution

Current priorities:

1. **Testing on different distros:**
   - Arch Linux
   - Debian
   - openSUSE
   - Manjaro

2. **Features:**
   - Automatic installation script
   - GUI launcher
   - AMD GPU support
   - Multi-GPU selection
   - Config file support

3. **Documentation:**
   - Video tutorials
   - Screenshots
   - Distribution-specific guides
   - FAQ expansion

4. **Bug fixes:**
   - Edge cases in GPU detection
   - Path detection improvements
   - Error handling

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Help others learn
- Accept constructive criticism
- Focus on what's best for the community
- Show empathy

### Communication

- **GitHub Issues:** Bug reports and feature requests
- **GitHub Discussions:** Questions, ideas, general chat
- **Pull Requests:** Code contributions

### Getting Help

New to contributing? Check out:
- [First Contributions Guide](https://github.com/firstcontributions/first-contributions)
- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)

Questions about the project? Open a [GitHub Discussion](https://github.com/yesthatsjames/davinci-resolve-nvidia-launcher/discussions).

## Recognition

Contributors will be:
- Listed in README.md
- Credited in release notes
- Thanked in commit messages

Thank you for helping make DaVinci Resolve better for Linux users! 🎬🐧
