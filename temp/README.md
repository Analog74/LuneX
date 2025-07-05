# Temporary Files and Development Exports

This directory contains temporary files and development exports that are not tracked in Git.

## Directory Structure

```
temp/
├── test-exports/           # Quick testing exports (not tracked)
├── development-outputs/    # Development work exports (not tracked)
├── .cleanup_instructions.md
├── REORGANIZATION_COMPLETE.md
├── REORGANIZATION_SUMMARY.md
└── README.md              # This file
```

## Usage

### For Development Testing
```bash
# Test exports during development
cargo run -- examples/MagicMaster.rbxl temp/test-exports/ --mode rojo
```

### For Quick Experiments
```bash
# Quick testing without cluttering main directories
lunex TestGame.rbxl temp/development-outputs/
```

## Cleanup

These directories are automatically ignored by Git. You can safely delete their contents:

```bash
# Clean all test exports
rm -rf temp/test-exports/*
rm -rf temp/development-outputs/*
```

The organizational files (`.cleanup_instructions.md`, etc.) are preserved for project history.

---

**Note**: For permanent sample exports, use the `examples/` directory instead.

## Gitignore

Temporary file types (*.tmp, *.temp, *.bak, *.backup) are ignored by git but the folder structure is tracked.
