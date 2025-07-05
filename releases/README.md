# LuneX Releases

This directory contains pre-built binaries and source code archives for LuneX releases.

## Release v0.1.3 (Latest)

### Binaries
- `LuneX-macos-v0.1.3` - Raw macOS binary (ARM64/Intel universal)
- `LuneX-macos-v0.1.3.zip` - Compressed macOS binary (recommended)
- `LuneX-macos-v0.1.3.gz` - GZipped macOS binary (smaller)

### Source Code
- `LuneX-v0.1.3-source.tar.gz` - Complete source code archive (tar.gz)
- `LuneX-v0.1.3-source.zip` - Complete source code archive (zip)

### Installation

#### macOS Binary Installation
```bash
# Download and extract
wget https://github.com/your-username/LuneProjects/releases/download/v0.1.3/LuneX-macos-v0.1.3.zip
unzip LuneX-macos-v0.1.3.zip

# Install globally
chmod +x LuneX-macos-v0.1.3
sudo mv LuneX-macos-v0.1.3 /usr/local/bin/lunex
```

#### Build from Source
```bash
# Download source
wget https://github.com/your-username/LuneProjects/releases/download/v0.1.3/LuneX-v0.1.3-source.tar.gz
tar -xzf LuneX-v0.1.3-source.tar.gz
cd LuneX-v0.1.3

# Build and install
cargo build --release
sudo cp target/release/LuneX /usr/local/bin/lunex
```

## Release History

### v0.1.3 (2025-07-05)
- **BREAKING**: Export folders now have underscore prefix (_DataModel, _MagicMaster, etc.)
- Added comprehensive installation instructions for all platforms
- Added troubleshooting section and platform-specific notes
- Improved documentation and release management

### v0.1.2 (Previous)
- Interactive GUI mode with file/folder dialogs
- CLI automation support
- Multiple export modes (original, flat, rojo)
- Cross-platform compatibility

## Download Links

For the latest releases, visit: https://github.com/your-username/LuneProjects/releases

### Verification

You can verify the integrity of downloaded files using checksums:

```bash
# Generate checksums for verification
shasum -a 256 LuneX-macos-v0.1.3.zip
shasum -a 256 LuneX-v0.1.3-source.tar.gz
```

## Platform Support

- **macOS**: Native binary available (ARM64/Intel universal)
- **Windows**: Build from source or use WSL
- **Linux**: Build from source (pre-built binaries coming soon)

## Dependencies

### Pre-built Binaries
- No external dependencies required

### Building from Source
- Rust toolchain (1.70.0 or later)
- See main README.md for detailed build instructions
