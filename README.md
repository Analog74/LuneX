# LuneX

## Features
- Export Roblox .rbxl files to Rojo-compatible folder structures
- Interactive GUI file/folder picker (macOS/Windows/Linux)
- CLI automation: `LuneX <input.rbxl> <output_dir> [--mode original|flat|rojo] [--projectjson]`
- Handles duplicate instance names, generates `default.project.json` if desired
- Two export modes: original folder structure or flat single folder

## Usage
### Interactive (recommended)
Just run:
```
LuneX
```
- Choose export mode (1 or 2) in the terminal
- Select your .rbxl file and output directory using Finder/Explorer dialogs
- The export will be placed in a folder named after your .rbxl file (without extension) inside the output directory
- Optionally generate a Rojo `default.project.json`

### CLI/Automation
```
LuneX <input.rbxl> <output_dir> [--mode original|flat|rojo] [--projectjson]
```
- The export will be placed in a folder named after your .rbxl file (without extension) inside the output directory

## Requirements
- Rust toolchain (for building)
- macOS, Windows, or Linux

## Development
- All code is in `src/main.rs`
- See commit history for recent changes

## License
MIT

---


---

## Building from Source

See `SOURCE_BUILD.txt` in the repo root for up-to-date instructions on building from source and using the prebuilt binary.

---

### Rojo Mode

If you pass `--rojo` or answer `y` to the prompt, scripts are exported to a `src/` directory and a minimal `default.project.json` is generated for Rojo compatibility.

## Installation as `LuneX`

The binary is now installed as `LuneX` by default. If you need to copy it manually:

```sh
cp ~/.cargo/bin/LuneX /your/desired/path/LuneX
chmod +x /your/desired/path/LuneX
```

## How LuneX Compares to rbxlx-to-rojo

**LuneX** is a modern, robust Rust-based exporter for Roblox `.rbxl` place files. Unlike the classic `rbxlx-to-rojo` tool, which only works with XML-based `.rbxlx` files and often loses complex property data, LuneX:

- Works directly with binary `.rbxl` files (the native Roblox format).
- Extracts all scripts and all properties, including complex types (Color3, Vector3, CFrame, etc), not just basic ones.
- Preserves the full hierarchy and all instance data, making it ideal for backup, migration, or inspection.
- Can export in a Rojo-compatible format (with `src/` and `default.project.json`) for seamless integration with modern Roblox development workflows.
- Is portable, fast, and installable as a single binary (`LuneX`).

**In summary:** LuneX is a more complete, future-proof, and user-friendly solution for extracting and converting Roblox place files compared to older tools like `rbxlx-to-rojo`.

## Smart Launcher Script

LuneX now supports both interactive (popup) and CLI automation modes with a single command:

- **Interactive mode:** If you run `LuneX` (or `lunex`) with no arguments, it will open macOS file/folder pickers for you to select your `.rbxl` file and export destination. This is user-friendly and ideal for manual use.
- **CLI automation mode:** If you run `LuneX <input.rbxl> <output_dir> [--rojo]`, it will run directly with those arguments, making it suitable for scripting and automation.

### How it works
- The `/usr/local/bin/LuneX` script checks if you provided arguments. If not, it shows popups and then calls the Rust binary (`/usr/local/bin/LuneX-bin`).
- The Rust binary (`LuneX-bin`) is the actual exporter and can be used directly for advanced workflows.

#### Example smart launcher script:
```zsh
#!/bin/zsh
LUNEX_BIN="/usr/local/bin/LuneX-bin"
if [ $# -ge 2 ]; then
    exec "$LUNEX_BIN" "$@"
else
    SOURCE=$(osascript -e 'POSIX path of (choose file with prompt "Select your Roblox .rbxl file")')
    echo "SOURCE: $SOURCE"
    if [ -z "$SOURCE" ]; then
      echo "No source file selected."
      exit 1
    fi
    DEST=$(osascript -e 'POSIX path of (choose folder with prompt "Select export destination folder")')
    echo "DEST: $DEST"
    if [ -z "$DEST" ]; then
      echo "No destination folder selected."
      exit 1
    fi
    cd "$DEST"
    # Get the base name of the .rbxl file, without extension
    BASENAME=$(basename "$SOURCE" .rbxl)
    OUTDIR="$(pwd)/$BASENAME"
    echo "Running: $LUNEX_BIN \"$SOURCE\" \"$OUTDIR\""
    "$LUNEX_BIN" "$SOURCE" "$OUTDIR" | tee luneX.log
    echo "All scripts and properties exported to: $OUTDIR"
fi
```

This makes LuneX easy for both beginners and power users.

## License

MIT

---

This project uses the excellent [rbx-dom](https://github.com/rojo-rbx/rbx-dom) and [rbx-types](https://github.com/rojo-rbx/rbx-dom) crates.
