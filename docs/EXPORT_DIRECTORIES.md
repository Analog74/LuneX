# Export Directory Management

This document explains where to place exported .rbxl directories and how LuneX manages export outputs.

## 📁 Directory Structure for Exports

### 1. Sample Exports (`examples/`)
**Purpose**: Demonstration and documentation  
**Git tracked**: Yes (for key examples)  
**Use case**: Show users what LuneX output looks like

```
examples/
├── MagicMaster.rbxl           # Input: Sample Roblox file
├── _MagicMaster/              # Output: Sample export (tracked)
│   ├── ServerScriptService/
│   ├── ReplicatedStorage/
│   ├── StarterGui/
│   └── default.project.json
├── AnotherGame.rbxl           # Additional samples
└── _AnotherGame/              # Additional sample outputs
```

### 2. User Export Locations (Runtime)
**Purpose**: User-specified output directories  
**Git tracked**: No  
**Use case**: When users run LuneX normally

```bash
# User chooses output location
lunex MyGame.rbxl ./my-projects/exports --mode rojo
# Creates: ./my-projects/exports/_MyGame/

lunex game.rbxl ~/Desktop/rojo-exports/ --mode original  
# Creates: ~/Desktop/rojo-exports/_game/
```

### 3. Development Testing (`temp/`)
**Purpose**: Development and testing  
**Git tracked**: No  
**Use case**: Testing during development

```
temp/
├── test-exports/              # Quick testing exports
│   ├── _TestGame1/
│   ├── _TestGame2/
│   └── _ExperimentalExport/
├── development-outputs/       # Development work
└── benchmark-exports/         # Performance testing
```

## 🎯 Export Naming Convention

LuneX automatically creates export directories with this pattern:
- **Input**: `MyGame.rbxl`
- **Output**: `_MyGame/` (underscore prefix, no extension)

### Examples:
- `RobloxStudio.rbxl` → `_RobloxStudio/`
- `My Amazing Game.rbxl` → `_My Amazing Game/`
- `game-v2.rbxl` → `_game-v2/`

## 🔧 Git Management

### Tracked Export Directories
```gitignore
# Keep key examples for documentation
!examples/_MagicMaster/     # Sample export (tracked)
!examples/_SimpleGame/      # Another sample (if added)
```

### Ignored Export Directories
```gitignore
# Ignore all underscore-prefixed directories
_*/                         # All export outputs

# Ignore specific development locations  
temp/test-exports/          # Development testing
temp/development-outputs/   # Development work

# Ignore user export patterns
exported*/                  # Any "exported" prefixed dirs
*.rbxl.backup              # Backup files
```

## 📖 Usage Patterns

### For End Users
```bash
# Choose your own output directory
lunex MyGame.rbxl ./my-rojo-projects
# Creates: ./my-rojo-projects/_MyGame/
```

### For Development
```bash
# Test in temp directory
lunex TestGame.rbxl ./temp/test-exports --mode rojo
# Creates: ./temp/test-exports/_TestGame/

# Quick development testing
cargo run -- examples/MagicMaster.rbxl temp/development-outputs/
```

### For Examples/Documentation
```bash
# Create new sample exports (commit these)
lunex NewSample.rbxl examples/ --mode rojo --projectjson
# Creates: examples/_NewSample/ (add to Git for documentation)
```

## 🧹 Cleanup Guidelines

### Development Cleanup
```bash
# Clean temporary exports
rm -rf temp/test-exports/*
rm -rf temp/development-outputs/*

# Keep examples
# examples/_MagicMaster/ stays for documentation
```

### User Guidance
- **Users control output location** - LuneX doesn't dictate where exports go
- **Export directories are self-contained** - can be moved/copied freely
- **Include Rojo project files** - use `--projectjson` for Rojo compatibility

## 🎨 Best Practices

### For Developers
1. **Test in `temp/`** - don't clutter the main project
2. **Keep 1-2 sample exports** in `examples/` for documentation
3. **Clean up test exports** regularly
4. **Document any new export patterns** in this file

### For Users
1. **Choose meaningful output directories** - organize your exports
2. **Use `--projectjson`** for Rojo compatibility
3. **Back up important exports** - they're not automatically versioned
4. **Keep export directories intact** - they're designed to be self-contained

## 🔍 Troubleshooting Export Locations

### "Export directory already exists"
```bash
# LuneX will prompt to overwrite or choose new location
# Or manually clean up:
rm -rf path/to/_ExistingExport/
```

### "Permission denied"
```bash
# Ensure write permissions to output directory
chmod u+w /path/to/output/directory
```

### "Export not found"
```bash
# Check if export completed successfully
ls -la /path/to/output/_GameName/
```

---

**See also**: [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
