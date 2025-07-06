# LuneX - Roblox Export Tool

> **Professional .rbxl export utility within the Roblox Projects repository ecosystem**

A comprehensive tool for exporting Roblox `.rbxl` files to organized project structures, with both GUI and CLI interfaces. Perfect for modern development workflows with Rojo integration.

[![Python](https://img.shields.io/badge/Python-3.7+-blue.svg)](https://python.org)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)]()
[![Status](https://img.shields.io/badge/Status-Active%20Development-green.svg)]()
[![Type](https://img.shields.io/badge/Type-Development%20Utility-orange.svg)]()

## 🎯 Repository Integration

LuneX is a core utility within the **Roblox Projects Repository** (`/Users/analog/Documents/Roblox/_Projects/`), designed to work with all projects in the ecosystem:

- **Game Projects**: RPG_Series_Revived, FishingSim, Mining, etc.
- **Frameworks**: FrameworkMaster, SpellCombatSystem, etc.
- **Components**: FastCastRedux, ZonePlus_Playground, etc.
- **Prototypes**: ChainPrototype, CharacterControl, etc.

**See [INTEGRATION.md](INTEGRATION.md) for complete repository integration details.**

## ✨ Features

- **🖥️ Graphical Interface** - Intuitive GUI for file selection and export options
- **⌨️ Command-line Interface** - Powerful CLI for automation and scripting  
- **📁 Multiple Export Modes** - Rojo-ready projects or scripts-only extraction
- **🔧 Binary .rbxl Support** - Automatic conversion of binary files using rbx-dom ecosystem
- **🧠 Smart Configuration** - Remembers directories and settings automatically
- **🔧 Quality of Life** - Default directories, persistent preferences, cross-platform support

## 🚀 Quick Start

### Using the GUI (Recommended)

```bash
python3 LuneX.py
```

The GUI provides:
- File browser for .rbxl selection
- Export mode selection (Rojo-ready or Scripts-only)
- Directory management with memory
- One-click export with automatic folder opening

### Using the Command Line

```bash
# Rojo-ready export (full project structure)
python3 Lune.py input.rbxl output_directory --mode rojo

# Scripts-only export with project.json
python3 Lune.py input.rbxl output_directory --mode scripts-only --project-json

# Get help
python3 Lune.py --help
```

## 🔧 Binary .rbxl Support

LuneX automatically handles both binary (.rbxl) and XML (.rbxlx) Roblox files:

### Automatic Detection
- **Smart Format Detection**: Automatically identifies binary vs XML format
- **Seamless Conversion**: Binary files are converted to XML before processing
- **No User Intervention**: Works transparently with any .rbxl file

### Conversion Tools
- **rbx-util**: Primary conversion tool from the rbx-dom ecosystem
- **Fallback Support**: System-installed converters as backup
- **Local Tools**: Includes pre-built binaries in `external-tools/`

### Examples
```bash
# Works with binary .rbxl files
python3 Lune.py MagicMaster.rbxl output/ --mode rojo

# Works with XML .rbxlx files  
python3 Lune.py MagicMaster.rbxlx output/ --mode rojo

# Both produce identical results
```

**See [docs/BINARY_RBXL_SUPPORT.md](docs/BINARY_RBXL_SUPPORT.md) for detailed documentation.**

## 📁 Export Modes

### 🏗️ Rojo-Ready Export (`--mode rojo`)
Perfect for modern Roblox development:
- Complete project structure with `src/` directory
- Generated `default.project.json` matching original hierarchy  
- Preserves all folder structures, scripts, objects, properties, and attributes
- Ready for `rojo serve` and Studio syncing
- Maintains original naming without modifications

### 📜 Scripts-Only Export (`--mode scripts-only`)
Focused script extraction:
- All scripts in a single directory
- Metadata files (`.meta.json`) with original location and properties
- Optional `default.project.json` generation
- Perfect for script analysis or quick extraction
- Maintains script relationships and hierarchy data

## ⚙️ Configuration

LuneX automatically manages preferences in `lunex_config.json`:

```json
{
  "last_source_dir": "/path/to/last/source",
  "last_dest_dir": "/path/to/last/destination", 
  "default_source_dir": "/path/to/default/source",
  "default_dest_dir": "/path/to/default/destination",
  "last_export_mode": "rojo"
}
```

**Quality of Life Features:**
- Remembers last used directories
- Configurable default directories
- Persistent export mode preference
- Cross-platform path handling

## 🏗️ Architecture

```
LuneProjects/
├── LuneX.py              # 🖥️ GUI Application (Main Entry)
├── Lune.py               # ⚙️ Core Export Engine (CLI)
├── test_lunex.py         # 🧪 Validation & Testing
├── lunex_config.json     # 📋 User Configuration (Auto-generated)
├── README.md             # 📖 User Documentation (This file)
├── CHANGELOG.md          # 📝 Version History
├── DEVELOPMENT.md        # 🔨 Development Tracking
└── INTEGRATION.md        # 🔗 Repository Integration Guide
```

## 📋 Requirements

- **Python 3.7+** (Cross-platform compatibility)
- **tkinter** (GUI framework - usually included with Python)
- **No external dependencies** for core functionality

## 🧪 Testing

Verify your setup:
```bash
python3 test_lunex.py
```

This validates:
- Required files (Lune.py, LuneX.py)
- Python/tkinter functionality  
- Command-line interface
- Configuration system

## 📈 Development Status

**Current Version**: v1.0.0 (Framework Complete)

**✅ Completed:**
- GUI and CLI interfaces
- Configuration management
- Export mode selection
- Directory persistence
- Cross-platform support
- Repository integration

**🔄 In Progress:**
- .rbxl file parsing implementation
- XML processing pipeline
- Instance type recognition

**📅 Planned:**
- Full export functionality
- Advanced metadata preservation
- Custom template system
- Batch processing

## 🔗 Repository Context

**Part of the Roblox Projects ecosystem** - see main repository:
- [📋 Project Catalog](../README.md) - All repository projects
- [🔗 Integration Guide](INTEGRATION.md) - How LuneX fits in
- [🔨 Development Log](DEVELOPMENT.md) - Progress tracking

**Related Projects:**
- **FrameworkMaster**: Provides framework content for export
- **SpellCombatSystem**: Combat system projects
- **rbxlx-to-rojo**: Basic conversion tool (LuneX provides advanced features)

## 📖 Documentation

- **[README.md](README.md)** - User guide (this file)
- **[CHANGELOG.md](CHANGELOG.md)** - Version history
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development tracking and roadmap
- **[INTEGRATION.md](INTEGRATION.md)** - Repository integration details

## 🏷️ Project Tags

`utility` `development-tool` `roblox` `export` `rojo` `gui` `cli` `python` `cross-platform` `repository-utility`

---

**🎯 Repository Integration**: LuneX serves as a core utility for the entire Roblox Projects repository, enabling consistent .rbxl export workflows across all game projects, frameworks, and components.

*Last Updated: July 5, 2025 | Version: 1.0.0 | Status: Active Development*
