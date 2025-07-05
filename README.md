# LuneX

## Features
- Export Roblox .rbxl files to Rojo-compatible folder structures
- Interactive GUI file/folder picker (macOS/Windows/Linux)
- CLI automation: `LuneX <input.rbxl> <output_dir> [--mode original|flat|rojo] [--projectjson]`
- Handles duplicate instance names, generates `default.project.json` if desired
- Two export modes: original folder structure (no DataModel folder; children exported at root) or flat single folder

## Usage
### Interactive (recommended)
Just run:
```
LuneX
```
- Choose export mode (1 or 2) in the terminal
- Select your .rbxl file and output directory using Finder/Explorer dialogs
- The export will be placed in a folder named after your .rbxl file (with underscore prefix, without extension) inside the output directory
- In original mode, the top-level DataModel folder is omitted; children of DataModel are exported directly at the root of your export folder
- Optionally generate a Rojo `default.project.json`

### CLI/Automation
```
LuneX <input.rbxl> <output_dir> [--mode original|flat|rojo] [--projectjson]
```
- The export will be placed in a folder named after your .rbxl file (with underscore prefix, without extension) inside the output directory
- In original mode, the top-level DataModel folder is omitted; children of DataModel are exported directly at the root of your export folder

## Requirements
- No external dependencies required for pre-built binaries
- For building from source: Rust toolchain (see Installation section below)
- Supported platforms: macOS, Windows, Linux

## Installation

### Option 1: Download Pre-built Binary (Recommended)

#### macOS (Intel/Apple Silicon)
1. Download the latest `LuneX-macos` binary from the [Releases](https://github.com/your-username/LuneProjects/releases) page
2. Make it executable and install globally:
```bash
chmod +x LuneX-macos
sudo mv LuneX-macos /usr/local/bin/lunex
```

#### Windows
**Note:** Pre-built Windows binaries are not currently provided due to cross-compilation complexity. Please use Option 2 (Build from Source) or WSL.

For Windows users, we recommend:
1. **Build from source** (see Option 2 below), or
2. **Use WSL (Windows Subsystem for Linux)** and follow the Linux instructions

#### Linux
1. Download the latest `LuneX-linux` binary from the [Releases](https://github.com/your-username/LuneProjects/releases) page *(coming soon)*
2. Make it executable and install globally:
```bash
chmod +x LuneX-linux
sudo mv LuneX-linux /usr/local/bin/lunex
```

### Option 2: Build from Source

#### Prerequisites
First, install the Rust toolchain:

**Windows:**
1. Download and run [rustup-init.exe](https://rustup.rs/)
2. Follow the installation prompts
3. Restart your terminal/command prompt

**macOS:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

**Linux (Ubuntu/Debian):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

#### Build and Install
1. Clone this repository:
```bash
git clone https://github.com/your-username/LuneProjects.git
cd LuneProjects
```

2. Build the release binary:
```bash
cargo build --release
```

3. Install globally:

**macOS/Linux:**
```bash
sudo cp target/release/LuneX /usr/local/bin/lunex
```

**Windows (run as Administrator):**
```cmd
copy target\release\LuneX.exe C:\Tools\LuneX\lunex.exe
```
(Or place it in any directory that's in your PATH)

### Verify Installation
After installation, verify LuneX is working:
```bash
lunex --help
```

If installed correctly, running `lunex` should start the interactive mode.

## Requirements
## Platform-Specific Notes

### Windows
- **File Dialogs:** LuneX uses native Windows file dialogs in interactive mode
- **Path Separators:** LuneX automatically handles Windows path separators
- **Antivirus:** Some antivirus software may flag the binary initially. This is a false positive common with Rust binaries

### macOS
- **Gatekeeper:** You may need to allow the binary in System Preferences > Security & Privacy if downloaded
- **Apple Silicon:** The binary works on both Intel and Apple Silicon Macs

### Linux
- **Desktop Environment:** File dialogs work with most desktop environments (GNOME, KDE, XFCE, etc.)
- **Dependencies:** The binary is statically linked and should work on most distributions

## Troubleshooting

### "Command not found" error
- Ensure the binary is in your PATH
- Try running with the full path to the binary
- On Windows, make sure the PATH environment variable includes the directory containing `lunex.exe`

### File dialog doesn't appear (Interactive mode)
- Make sure you're running from a terminal that supports GUI applications
- On Linux, ensure you have a desktop environment running
- Try the CLI mode instead: `lunex input.rbxl output_folder`

### "Permission denied" errors
- On macOS/Linux: ensure the binary is executable (`chmod +x lunex`)
- Make sure you have write permissions to the output directory

### Build failures when compiling from source
- Ensure you have the latest Rust toolchain: `rustup update`
- On Linux, you may need build essentials: `sudo apt install build-essential`
- On Windows, ensure you have the Microsoft C++ Build Tools installed

## Development

### Project Structure
- All main code is in `src/main.rs`
- Uses `rbx-dom` and `rbx-types` crates for Roblox file parsing
- GUI file dialogs provided by `rfd` crate
- See commit history for recent changes

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on your platform
5. Submit a pull request

### Cross-Platform Notes
- The project is designed to work on macOS, Windows, and Linux
- File dialogs are handled by the `rfd` crate which provides native dialogs on each platform
- Path handling automatically adapts to each platform's conventions
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
    # Get the base name of the .rbxl file, without extension, with underscore prefix
    BASENAME="_$(basename "$SOURCE" .rbxl)"
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
