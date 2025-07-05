# LuneX Installation Guide

This guide provides detailed installation instructions for LuneX on all supported platforms.

## Option 1: Download Pre-built Binary (Recommended)

### macOS (Intel/Apple Silicon)
1. Download the latest release from [GitHub Releases](https://github.com/Analog74/LuneX/releases)
   - **Recommended**: `LuneX-macos-v0.1.3.zip` (compressed)
   - **Alternative**: `LuneX-macos-v0.1.3.gz` (smaller)
2. Extract and install:
```bash
# Download (replace URL with actual GitHub release URL)
curl -L -o LuneX-macos.zip https://github.com/Analog74/LuneX/releases/download/v0.1.3/LuneX-macos-v0.1.3.zip
unzip LuneX-macos.zip

# Install globally
chmod +x LuneX-macos-v0.1.3
sudo mv LuneX-macos-v0.1.3 /usr/local/bin/lunex
```

### Windows
**Note:** Pre-built Windows binaries are not currently provided due to cross-compilation complexity. Please use Option 2 (Build from Source) or WSL.

For Windows users, we recommend:
1. **Build from source** (see Option 2 below), or
2. **Use WSL (Windows Subsystem for Linux)** and follow the Linux instructions

### Linux
1. Build from source (see Option 2) - pre-built Linux binaries coming soon
2. Or use the source archive for easier building:
```bash
curl -L -o LuneX-source.tar.gz https://github.com/Analog74/LuneX/releases/download/v0.1.3/LuneX-v0.1.3-source.tar.gz
tar -xzf LuneX-source.tar.gz
cd LuneX-v0.1.3
cargo build --release
sudo cp target/release/LuneX /usr/local/bin/lunex
```

## Option 2: Build from Source

### Prerequisites
First, install the Rust toolchain:

**Windows:**
1. Download and run [rustup-init.exe](https://rustup.rs/)
2. Follow the installation prompts
3. Restart your terminal/command prompt

**macOS:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

**Linux (Ubuntu/Debian):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

### Build and Install
1. Clone this repository:
```bash
git clone https://github.com/Analog74/LuneX.git
cd LuneX
```

2. Build the release binary:
```bash
cargo build --release
```

3. Install globally:

**macOS/Linux:**
```bash
sudo cp target/release/LuneX /usr/local/bin/lunex
```

**Windows (run as Administrator):**
```cmd
copy target\release\LuneX.exe C:\Tools\LuneX\lunex.exe
```
(Or place it in any directory that's in your PATH)

### Verify Installation
After installation, verify LuneX is working:
```bash
lunex --help
```

If installed correctly, running `lunex` should start the interactive mode.

## Platform-Specific Notes

### Windows
- **File Dialogs:** LuneX uses native Windows file dialogs in interactive mode
- **Path Separators:** LuneX automatically handles Windows path separators
- **Antivirus:** Some antivirus software may flag the binary initially. This is a false positive common with Rust binaries

### macOS
- **Gatekeeper:** You may need to allow the binary in System Preferences > Security & Privacy if downloaded
- **Apple Silicon:** The binary works on both Intel and Apple Silicon Macs

### Linux
- **Desktop Environment:** File dialogs work with most desktop environments (GNOME, KDE, XFCE, etc.)
- **Dependencies:** The binary is statically linked and should work on most distributions

## Troubleshooting

### "Command not found" error
- Ensure the binary is in your PATH
- Try running with the full path to the binary
- On Windows, make sure the PATH environment variable includes the directory containing `lunex.exe`

### File dialog doesn't appear (Interactive mode)
- Make sure you're running from a terminal that supports GUI applications
- On Linux, ensure you have a desktop environment running
- Try the CLI mode instead: `lunex input.rbxl output_folder`

### "Permission denied" errors
- On macOS/Linux: ensure the binary is executable (`chmod +x lunex`)
- Make sure you have write permissions to the output directory

### Build failures when compiling from source
- Ensure you have the latest Rust toolchain: `rustup update`
- On Linux, you may need build essentials: `sudo apt install build-essential`
- On Windows, ensure you have the Microsoft C++ Build Tools installed

## For Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and contribution guidelines.
