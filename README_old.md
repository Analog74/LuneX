# 🚀 LuneX - Professional Roblox Export Tool

> **Enhanced with smart defaults, organized workflows, and flexible templating**

LuneX is a powerful command-line tool for exporting Roblox place files (.rbxl) into organized project structures perfect for modern development workflows. Built with Rust for performance and reliability.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-1.70+-orange.svg)](https://www.rust-lang.org)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux-lightgrey)](https://github.com/Analog74/LuneX/releases)
[![CI](https://github.com/Analog74/LuneX/workflows/LuneX%20Export/badge.svg)](https://github.com/Analog74/LuneX/actions)

## ✨ Key Features

- **� Smart Defaults** - Works great out of the box with sensible defaults
- **📁 Organized Output** - Professional directory structure with auto-organization
- **📄 Template System** - Multiple project.json templates for different project types
- **🔄 Multiple Export Modes** - Rojo, Flat, and Original structure modes
- **🤖 Interactive Mode** - Guided workflow with intelligent suggestions
- **⚡ CLI Mode** - Powerful command-line interface for automation
- **🔧 Auto-generates** `default.project.json` for Rojo integration
- **🚀 Fast & lightweight** - no external dependencies for binaries

## 🏗️ Project Structure

LuneX automatically creates and manages a professional project structure:

```
YourProject/
├── exports/                    # 🎯 Default export location
│   ├── _GameName1/            # Auto-organized by game name
│   ├── _GameName2/
│   └── _Library/
├── samples/                   # 📦 Sample .rbxl files
│   ├── MagicMaster.rbxl
│   └── YourGame.rbxl
└── templates/                 # 📄 Project.json templates
    ├── default.project.json
    ├── game-template.project.json
    ├── library-template.project.json
    └── simple-template.project.json
```

## 🚀 Quick Start

### Interactive Mode (Recommended for first-time users)
```bash
lunex
```
Follow the guided prompts to:
1. Choose export mode (Rojo/Flat/Original)
2. Select sample file or browse for your .rbxl
3. Pick output location and template
4. Export with professional organization

### CLI Mode (Great for automation)
```bash
# Basic export (Rojo mode to exports/_GameName/)
lunex MyGame.rbxl

# Flat export to a custom directory
lunex MyGame.rbxl --output=my_exports --flat

# Use a specific template
lunex MyGame.rbxl --template=game-template.project.json
```

## 📖 Usage Guide

LuneX can be run in interactive mode for a guided setup or via the command line for automation. The CLI has been updated to provide a more detailed overview of its functionality.

### CLI Reference

```
🚀 LuneX - Professional Roblox Export Tool
   Enhanced with smart defaults, templates, and organized output

📖 USAGE:
   LuneX [OPTIONS]                    # Interactive mode
   LuneX <input.rbxl> [OPTIONS]       # CLI mode

📂 DIRECTORY STRUCTURE:
   /exports/     - Default export location (auto-organized)
   /samples/     - Sample .rbxl files (auto-discovered)
   /templates/   - Project.json templates

🔧 OPTIONS:
   --help, -h                Show this help message
   --mode=<type>             Export mode: rojo, flat, original
   --rojo                    Rojo mode (default)
   --flat                    Flat mode (all scripts in one folder)
   --original                Original mode (preserve hierarchy)
   --output=<path>           Custom output directory
   --template=<name>         Use specific template
   --projectjson             Enable project.json (default)
   --no-projectjson          Disable project.json

📄 TEMPLATES:
   default.project.json      - Standard Roblox services
   game-template.project.json - Full game project
   library-template.project.json - Module/library project
   simple-template.project.json - Minimal structure

💡 EXAMPLES:
   LuneX                                    # Interactive mode
   LuneX game.rbxl                         # Default: Rojo to exports/
   LuneX game.rbxl --flat                  # Flat export
   LuneX game.rbxl --template=game-template.project.json
   LuneX game.rbxl --output=my_project --original

🎯 SMART DEFAULTS:
   • Mode: Rojo (best for development)
   • Output: exports/_GameName/
   • Templates: Auto-detected or smart generation
   • Project.json: Always enabled for Rojo mode

Visit: https://github.com/Analog74/LuneX for more information
```

## 🔧 Export Modes

### 🏗️ Rojo Mode (Default - Recommended)
Perfect for modern Roblox development with Rojo integration.
- Exports scripts to `src/` directory
- Generates project.json for Rojo
- Organizes by Roblox services (ReplicatedStorage, ServerScriptService, etc.)
- Ready for `rojo serve` and syncing

### 📄 Flat Mode
All scripts in a single directory with unique names.
- Great for quick script extraction
- Easy browsing and searching
- Filename pattern: `<ScriptType>_<Name>_<Index>.lua`

### 🗂️ Original Mode
Preserves the exact Roblox instance hierarchy.
- Maintains parent-child relationships
- Exports properties as JSON
- Perfect for analysis and reverse engineering

## 📄 Template System

LuneX includes several pre-made templates and supports custom templates:

### Built-in Templates

| Template | Best For | Description |
|----------|----------|-------------|
| `default.project.json` | General games | Standard Roblox services |
| `game-template.project.json` | Full games | Complete game structure with all services |
| `library-template.project.json` | Libraries/Modules | Module-focused organization |
| `simple-template.project.json` | Simple projects | Minimal structure |

### Using Templates
```bash
# Use specific template
LuneX game.rbxl --template=game-template.project.json

# Auto-generate based on game structure
LuneX game.rbxl  # (default behavior)
```

## 📖 Command Reference

### Basic Usage
```bash
LuneX [OPTIONS]                    # Interactive mode
LuneX <input.rbxl> [OPTIONS]       # CLI mode
```

### Options
| Option | Description | Example |
|--------|-------------|---------|
| `--help`, `-h` | Show help message | `LuneX --help` |
| `--mode=<type>` | Export mode: rojo, flat, original | `--mode=flat` |
| `--rojo` | Use Rojo mode (default) | `--rojo` |
| `--flat` | Use Flat mode | `--flat` |
| `--original` | Use Original mode | `--original` |
| `--output=<path>` | Custom output directory | `--output=my_exports` |
| `--template=<name>` | Use specific template | `--template=game-template.project.json` |
| `--projectjson` | Enable project.json (default) | `--projectjson` |
| `--no-projectjson` | Disable project.json | `--no-projectjson` |

### Examples
```bash
# Interactive mode with guided setup
LuneX

# Basic export with smart defaults
LuneX MyGame.rbxl

# Flat export to custom location
LuneX MyGame.rbxl --output=scripts --flat

# Game template with Rojo mode
LuneX MyGame.rbxl --template=game-template.project.json

# Original structure without project.json
LuneX MyGame.rbxl --original --no-projectjson
```
sudo cp releases/LuneX-macos-<version> /usr/local/bin/lunex
### Installation

You can install LuneX by downloading a pre-built binary or by building it from the source.

### Download Pre-built Binary (Recommended)

**macOS:**
```bash
# Download, unzip, and move to /usr/local/bin
curl -L -o LuneX.zip https://github.com/Analog74/LuneX/releases/latest/download/LuneX-macos-latest.zip
unzip LuneX.zip && chmod +x LuneX
sudo mv LuneX /usr/local/bin/lunex
```

**Windows/Linux:**
Pre-built binaries for Windows and Linux are available on the [Releases](https://github.com/Analog74/LuneX/releases) page.

### Build from Source

If you prefer, you can build LuneX from the source code.

```bash
# Clone the repository
git clone https://github.com/Analog74/LuneX.git
cd LuneX

# Build the release binary
cargo build --release

# Optionally, move the binary to a location in your PATH
sudo cp target/release/LuneX /usr/local/bin/lunex  # macOS/Linux
```

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

### VS Code Task

A pre-configured VS Code task is available to automate builds and exports:

```bash
# Run the LuneX: Export task (Cmd+Shift+B)
# Enter the version tag when prompted (e.g., v0.2.0)
# Outputs are placed in the `releases/` directory
```

### CI/CD Integration

A GitHub Actions workflow is included at `.github/workflows/lunex-export.yml`. It triggers on version tags (`v*`), builds the LuneX binary, runs the export script, and uploads release artifacts.

To test the workflow locally:
```bash
git tag v0.1.0
git push origin v0.1.0
```
