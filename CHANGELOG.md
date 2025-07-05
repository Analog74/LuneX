# Changelog

All notable changes to LuneX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-07-05

### 🎉 Major Release: Professional Project Reorganization

#### Added
- **Professional Project Structure**: Complete reorganization following Rust/Cargo conventions
- **Comprehensive Documentation Suite**: 
  - Enhanced README.md with badges, quick start, and clear structure
  - Detailed INSTALLATION.md with platform-specific instructions
  - Complete CONTRIBUTING.md with development guidelines
  - EXPORT_DIRECTORIES.md for export management
- **Industry-Standard Layout**: Source code, documentation, examples, and scripts properly organized
- **Enhanced Property Extraction**: Improved logging and error tracking for missing properties
- **Cross-Platform Support**: Clear documentation for macOS, Windows, and Linux
- **Community-Ready Features**: GitHub integration, contribution guidelines, issue templates

#### Changed
- **Project Structure**: Reorganized into standard Rust project layout
  - `src/` - Source code following Cargo conventions
  - `docs/` - Comprehensive documentation
  - `examples/` - Sample files and outputs
  - `scripts/` - Build and release automation
  - `assets/` - Configuration files
- **Documentation**: Complete rewrite with professional presentation
- **Build System**: Updated GitHub Actions and scripts for new structure
- **Export Management**: Clear guidelines for where to place export outputs

#### Technical Improvements
- **Property Extraction**: Enhanced to capture all available properties with detailed error logging
- **Build Optimization**: Streamlined build process with better error handling
- **Release Automation**: Professional release system with compressed archives and checksums

This release transforms LuneX from a development project into a professional, community-ready open-source tool.

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
