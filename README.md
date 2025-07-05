
# LuneX (formerly rbxdom_rust_exporter)

A modern, robust Rust-based Roblox `.rbxl` place file exporter. Extracts all scripts and properties (including complex types) from `.rbxl` files. User-friendly, portable, and compatible with the latest crate APIs. Supports Rojo-compatible export mode and is installable as a console tool named `LuneX`.

## Features
- Extracts all scripts and properties from `.rbxl` files
- Handles complex property types (Color3, Vector3, CFrame, etc)
- Rojo-compatible export mode (`--rojo`)
- Interactive prompt if `--rojo` not specified
- Installs and runs as a single binary: `LuneX`
- Ready for use with the LuneX launcher script

## Usage

```sh
cargo install --path . --force
# or after install:
LuneX <input.rbxl> <output_dir> [--rojo]
```

If you want the binary to be called `LuneX` and run as `LuneX` from the console, this is now the default (see Cargo.toml for `[[bin]]`).

### Rojo Mode

If you pass `--rojo` or answer `y` to the prompt, scripts are exported to a `src/` directory and a minimal `default.project.json` is generated for Rojo compatibility.

## Installation as `LuneX`

The binary is now installed as `LuneX` by default. If you need to copy it manually:

```sh
cp ~/.cargo/bin/LuneX /your/desired/path/LuneX
chmod +x /your/desired/path/LuneX
```

## License

MIT

---

This project uses the excellent [rbx-dom](https://github.com/rojo-rbx/rbx-dom) and [rbx-types](https://github.com/rojo-rbx/rbx-dom) crates.
