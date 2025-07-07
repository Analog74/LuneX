# LuneX - Roblox Export Tool

> **Professional .rbxl export utility within the Roblox Projects repository ecosystem**

A comprehensive tool for exporting Roblox `.rbxl` and `.rbxlx` files to organized project structures, with a modern GUI and powerful CLI. Perfect for modern development workflows with Rojo integration.

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

- **📊 Real-Time Progress** - Watch the export happen with a live progress bar.
- **📂 Recent Files Menu** - Quickly access your recently opened files.
- **🖱️ Drag & Drop & Multi-Select** - Drag files directly or select multiple files for batch export.
- **🖥️ Graphical Interface** - Intuitive GUI for file selection and export options
- **⌨️ Command-line Interface** - Powerful CLI for automation and scripting  
- **📁 Multiple Export Modes** - Rojo-ready projects or scripts-only extraction
- **🔧 Binary .rbxl Support** - Automatic conversion of binary files using rbx-dom ecosystem
- **🧠 Smart Configuration** - Remembers directories and settings automatically
- **🔧 Quality of Life** - Default directories, persistent preferences, cross-platform support

## 🚀 Quick Start

### 1. Setup

LuneX uses a virtual environment to manage dependencies. First, set it up:

```bash
# 1. Create the virtual environment
python3 -m venv venv

# 2. Activate it
# On macOS/Linux
source venv/bin/activate
# On Windows
.\venv\Scripts\activate

# 3. Install required packages
pip install -r requirements.txt
```

### 2. Running the GUI (Recommended)

Once the setup is complete, run the application:

```bash
python3 LuneX.py
```

The GUI provides:
- Drag & Drop or File browser for `.rbxl`/`.rbxlx` selection (supports multi-select)
- Batch export of multiple files in one operation
- Export mode selection (Rojo-ready or Scripts-only)
- Directory management with memory
- One-click export with automatic folder opening

### 3. Using the Command Line

Ensure the virtual environment is active (`source venv/bin/activate`) before running CLI commands.

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

## ⚙️ Configuration

LuneX automatically manages preferences in `config/lunex_config.json`:

```json
{
  "last_source_dir": "/path/to/last/source",
  "last_dest_dir": "/path/to/last/destination", 
  "default_source_dir": "/path/to/default/source",
  "default_dest_dir": "/path/to/default/destination",
  "last_export_mode": "rojo",
  "recent_files": [
    "/path/to/your/file.rbxl",
    "/path/to/another/file.rbxlx"
  ]
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
├── venv/                   # 🐍 Python Virtual Environment
├── config/
│   └── lunex_config.json   # 📋 User Configuration (Auto-generated)
├── LuneX.py                # 🖥️ GUI Application (Main Entry)
├── Lune.py                 # ⚙️ Core Export Engine (CLI)
├── test_lunex.py           # 🧪 Validation & Testing
├── requirements.txt        # 📦 Python Dependencies
├── README.md               # 📖 User Documentation (This file)
├── CHANGELOG.md            # 📝 Version History
├── DEVELOPMENT.md          # 🔨 Development Tracking
└── INTEGRATION.md          # 🔗 Repository Integration Guide
```

## 📋 Requirements

- **Python 3.7+** (Cross-platform compatibility)
- **tkinter** (GUI framework - usually included with Python)
- **tkinterdnd2** (For GUI drag-and-drop functionality)

All Python dependencies are listed in `requirements.txt` and can be installed using the setup instructions.

## 🧪 Testing

Activate the virtual environment first (`source venv/bin/activate`).

```bash
python3 test_lunex.py
```

This validates:
- Required files (Lune.py, LuneX.py)
- Python/tkinter functionality  
- Command-line interface
- Configuration system

## 📈 Development Status

**Current Version**: v1.2.0 (GUI Polish & UX)

**✅ Completed:**
- Real-time progress indicators
- Recent files menu
- Enhanced error recovery and user guidance
- Drag & Drop file interface
- GUI and CLI interfaces
- Robust binary `.rbxl` to `.rbxlx` conversion
- Core file parsing and XML processing pipeline
- Configuration management in a dedicated `config/` directory
- Virtual environment setup with `requirements.txt`
- Export mode selection
- Directory persistence
- Cross-platform support
- Repository integration

**📅 Planned:**
- Advanced metadata preservation
- Custom template system
- Batch processing
- Further modularization and code cleanup

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

## Roblox API Dump Integration

See [docs/ROBLOX_API_DUMP_INTEGRATION.md](docs/ROBLOX_API_DUMP_INTEGRATION.md) for details on how to use the new Roblox API dump integration for querying, documentation, and tooling.

---

## Quick Start

- Python module: `library/roblox_api_dump.py`
- Example usage and extension ideas included in the docs.

---

This enables advanced Roblox API introspection and automation for your development workflow.

## Roblox API Automation

- Run `make docs` to generate Markdown documentation from the API dump.
- Run `make test` to test API dump integration and see sample queries.
- You can also run the VS Code task "Generate Roblox API Docs" for doc generation.

See `docs/ROBLOX_API_DUMP_INTEGRATION.md` for full details.

## 🏷️ Project Tags

`utility` `development-tool` `roblox` `export` `rojo` `gui` `cli` `python` `cross-platform` `repository-utility`

---

**🎯 Repository Integration**: LuneX serves as a core utility for the entire Roblox Projects repository, enabling consistent .rbxl export workflows across all game projects, frameworks, and components.

*Last Updated: July 6, 2025 | Version: 1.2.0 | Status: Active Development*
