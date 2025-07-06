# Changelog

All notable changes to LuneX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Binary .rbxl file support
- Asset file extraction (images, sounds, meshes) 
- Advanced filtering and selection options
- Batch processing capabilities
- Enhanced metadata extraction

## [0.1.0] - 2025-07-06

### Added
- Initial implementation of LuneX Roblox export tool
- GUI application (LuneX.py) with tkinter interface
- Core export engine (Lune.py) with CLI support
- .rbxlx XML file parsing and processing
- Rojo-ready export functionality with proper project structure
- Scripts-only export mode with metadata preservation
- Configuration persistence system (lunex_config.json)
- Directory memory and default directory settings
- Cross-platform compatibility (macOS, Windows, Linux)
- Comprehensive test suite and sample files
- Full documentation suite

### Features
- **File Selection**: Browse dialog for .rbxl/.rbxlx files
- **Export Modes**: 
  - Rojo-ready: Full project structure with default.project.json
  - Scripts-only: All scripts in single directory with metadata
- **Configuration**: 
  - Remembers last used directories
  - Configurable default source/destination paths
  - Persistent export mode preferences
- **Script Processing**:
  - Proper file extensions (.server.lua, .client.lua, .lua)
  - Content extraction and metadata preservation
  - Service mapping (ReplicatedStorage, ServerScriptService, etc.)

### Technical Details
- **Languages**: Python 3.7+
- **Dependencies**: tkinter (standard library), xml.etree.ElementTree
- **File Formats**: .rbxlx (XML), .rbxl (planned)
- **Export Formats**: Rojo project structure, flat script export
- **Platforms**: macOS, Windows, Linux

### Known Limitations
- Currently supports .rbxlx (XML) files only
- Binary .rbxl conversion not yet implemented
- Asset files (images, sounds) not yet supported
- .rbxl file parsing implementation
- XML processing pipeline for Roblox files
- Instance type recognition system
- Enhanced export functionality

## [1.0.0] - 2025-07-05

### 🎉 Major Release: LuneX Python Framework Complete

#### Added
- **Complete GUI Application** (`LuneX.py`): Professional tkinter interface with file selection, export options, and directory management
- **Core Export Engine** (`Lune.py`): Command-line interface with full argument parsing and export modes
- **Smart Configuration**: Persistent user preferences with `lunex_config.json`
- **Export Modes**: 
  - Rojo-ready: Complete project structure with default.project.json
  - Scripts-only: Single directory with metadata files
- **Quality of Life Features**:
  - Last-used directory memory
  - Configurable default source/destination directories
  - Cross-platform file system integration
- **Development Tools**: Test suite and validation scripts
- **Repository Integration**: Proper documentation and tracking within Roblox Projects ecosystem

#### Technical Features
- Python 3.7+ compatibility with tkinter GUI framework
- Modular architecture separating GUI from core engine
- Cross-platform support (Windows, macOS, Linux)
- Robust error handling and user feedback
- Configuration persistence and directory management
- Command-line automation capabilities

#### Framework Architecture
- `LuneX.py`: GUI application with professional interface
- `Lune.py`: Core export engine with CLI interface  
- `test_lunex.py`: Validation and testing suite
- `DEVELOPMENT.md`: Development tracking and roadmap
- Repository-level documentation and project cataloging

### Changed
- **Complete Rewrite**: Transitioned from Rust CLI to Python GUI/CLI hybrid
- **Architecture**: Separated user interface from core processing logic
- **Documentation**: Updated for new Python-based implementation
- **Integration**: Properly positioned as utility within larger repository ecosystem

This release establishes LuneX as a complete, user-friendly tool ready for .rbxl parsing implementation.

## [0.1.3] - 2025-07-05

### Changed
- **BREAKING**: Export folders now have underscore prefix (e.g., `_DataModel` instead of `DataModel`)
- Updated documentation with comprehensive installation instructions for all platforms
- Added troubleshooting section to README
- Improved cross-platform installation guide

### Added
- **Release Management**: Comprehensive release system with compressed archives
  - Pre-built macOS binary in multiple formats (.zip, .gz)
  - Complete source code archives (.tar.gz, .zip)
  - SHA256 checksums for integrity verification
  - Automated release creation script (`create_release.sh`)
  - GitHub Actions workflow for automated releases
- Platform-specific installation notes
- Detailed dependency and build instructions
- Cross-compilation target support setup
- `releases/` directory with proper archive structure

### Fixed
- Export folder naming now consistent with underscore prefix
- Global installation process documented
- Release distribution and download process

## [0.1.2] - Previous Release

### Added
- Interactive GUI mode with file/folder dialogs
- CLI automation support
- Multiple export modes (original, flat, rojo)
- Rojo project.json generation
- Cross-platform compatibility (macOS, Windows, Linux)

### Features
- Export Roblox .rbxl files to folder structures
- Handle duplicate instance names
- Preserve all properties including complex types
- Smart launcher script support
