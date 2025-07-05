# LuneX

A powerful Rust-based tool for exporting Roblox .rbxl files to Rojo-compatible folder structures.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-1.70+-orange.svg)](https://www.rust-lang.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux-lightgrey)](https://github.com/Analog74/LuneX/releases)

## ✨ Features

- 🎮 **Export Roblox .rbxl files** to Rojo-compatible folder structures
- 🖱️ **Interactive GUI** file/folder picker (cross-platform)
- ⚡ **CLI automation** support for scripts and workflows
- 📁 **Multiple export modes**: original, flat, rojo
- 🔧 **Auto-generates** `default.project.json` for Rojo
- 🔄 **Handles duplicates** intelligently
- 🚀 **Fast & lightweight** - no external dependencies for binaries

## 🚀 Quick Start

### Download Pre-built Binary (Recommended)

**macOS:**
```bash
curl -L -o LuneX.zip https://github.com/Analog74/LuneX/releases/latest/download/LuneX-macos-latest.zip
unzip LuneX.zip && chmod +x LuneX
sudo mv LuneX /usr/local/bin/lunex
```

**Windows/Linux:** Build from source (see below)

### Build from Source

```bash
# Clone repository
git clone https://github.com/Analog74/LuneX.git
cd LuneX

# Build release binary
cargo build --release

# Install (optional)
sudo cp target/release/LuneX /usr/local/bin/lunex  # macOS/Linux
```

## 📖 Usage

### Interactive Mode (Recommended)
```bash
lunex
# Follow prompts to select .rbxl file and export options
```

### CLI Mode
```bash
lunex MyGame.rbxl ./output --mode rojo --projectjson
lunex game.rbxl export/ --mode original
```

### Command Options
- `--mode original|flat|rojo` - Export structure type
- `--projectjson` - Generate Rojo project file

## 📁 Project Structure

```
LuneX/
├── src/                    # 🦀 Source code
│   └── main.rs            # Main application
├── examples/              # 📋 Example files
│   ├── MagicMaster.rbxl   # Sample Roblox file
│   └── _MagicMaster/      # Sample export output
├── docs/                  # 📚 Documentation
│   ├── CONTRIBUTING.md    # Development guide
│   ├── INSTALLATION.md    # Detailed install instructions
│   └── EXPORT_DIRECTORIES.md # Export management guide
├── scripts/               # 🔧 Build scripts
│   └── create_release.sh  # Release automation
├── assets/                # ⚙️ Configuration files
│   └── default.project.json
├── tests/                 # 🧪 Test files
├── temp/                  # 🗂️ Temporary exports & dev files
│   ├── test-exports/      # Development testing (not tracked)
│   └── development-outputs/ # Quick experiments (not tracked)
├── README.md              # 📖 This file
├── CHANGELOG.md           # 📝 Version history
├── LICENSE                # ⚖️ MIT License
├── Cargo.toml             # 📦 Rust project config
└── Cargo.lock             # 🔒 Dependency lock
```

**Export Locations**: See [docs/EXPORT_DIRECTORIES.md](docs/EXPORT_DIRECTORIES.md) for details on where to place exported .rbxl directories.

## 🛠️ Development

### Prerequisites
- Rust 1.70+ ([Install Rust](https://rustup.rs/))
- Git

### Setup
```bash
git clone https://github.com/Analog74/LuneX.git
cd LuneX
cargo build
cargo test
cargo run -- --help
```

### Contributing
See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for development guidelines.

## 📋 Requirements

- **For binaries**: No dependencies required
- **For building**: Rust toolchain
- **Platforms**: macOS, Windows, Linux

## 🔧 Platform Notes

- **macOS**: Native file dialogs, Apple Silicon supported
- **Windows**: Native dialogs, may require allowing in antivirus
- **Linux**: Works with most desktop environments (GNOME, KDE, XFCE)

## 📄 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Detailed setup instructions
- **[Contributing Guide](docs/CONTRIBUTING.md)** - Development setup
- **[Export Directories](docs/EXPORT_DIRECTORIES.md)** - Where to place exports
- **[Changelog](CHANGELOG.md)** - Version history

## 🤝 Contributing

Contributions welcome! Please read [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Credits

Built with the excellent [rbx-dom](https://github.com/rojo-rbx/rbx-dom) and [rbx-types](https://github.com/rojo-rbx/rbx-dom) crates.

---

⭐ **Star this project if you find it useful!**  
🐛 **[Report Issues](https://github.com/Analog74/LuneX/issues)**  
💬 **[Discussions](https://github.com/Analog74/LuneX/discussions)**
