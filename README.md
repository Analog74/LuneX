# rbxdom-rust-exporter

A robust, user-friendly, and portable Rust-based Roblox `.rbxl` place file exporter. This tool extracts all scripts and properties (including complex types) from `.rbxl` files, outputting them as JSON and Lua files for easy inspection, backup, or migration.

## Features
- Exports all properties of every instance in a Roblox place file
- Extracts all scripts (Script, LocalScript, ModuleScript) as `.lua` files
- Handles complex property types (Color3, Vector3, CFrame, etc.)
- Outputs a directory tree mirroring the Roblox hierarchy
- Ready for use with automation tools like `LuneX`

## Usage

```sh
cargo run --release -- <input.rbxl> <output_dir>
```

- `<input.rbxl>`: Path to your Roblox place file
- `<output_dir>`: Directory to export the contents to

Example:
```sh
cargo run --release -- ../MagicMaster.rbxl ./exported
```

## Requirements
- Rust (https://rustup.rs)
- Roblox `.rbxl` file

## Installation
Clone this repo and build with Cargo:
```sh
git clone https://github.com/Analog74/rbxdom-rust-exporter.git
cd rbxdom-rust-exporter
cargo build --release
```

## License
MIT

---

This project uses the excellent [rbx-dom](https://github.com/rojo-rbx/rbx-dom) and [rbx-types](https://github.com/rojo-rbx/rbx-dom) crates.
