# Changelog

All notable changes to LuneX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-07-05

### Changed
- **BREAKING**: Export folders now have underscore prefix (e.g., `_DataModel` instead of `DataModel`)
- Updated documentation with comprehensive installation instructions for all platforms
- Added troubleshooting section to README
- Improved cross-platform installation guide

### Added
- Pre-built macOS binary in releases directory
- Platform-specific installation notes
- Detailed dependency and build instructions
- Cross-compilation target support setup

### Fixed
- Export folder naming now consistent with underscore prefix
- Global installation process documented

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
