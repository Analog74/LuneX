# Contributing to LuneX

Thank you for your interest in contributing to LuneX! This guide will help you get started.

## Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Analog74/LuneX.git
   cd LuneX
   ```

2. **Install Rust** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   ```

3. **Build and test:**
   ```bash
   cargo build
   cargo test
   cargo run -- --help
   ```

## Project Architecture

### Main Components
- **Main source code:** `src/main.rs`
- **Dependencies:** Uses `rbx-dom` and `rbx-types` crates for Roblox file parsing
- **GUI dialogs:** Provided by `rfd` crate for native file dialogs
- **Build system:** Standard Rust/Cargo

### Key Features
- Interactive file selection using native OS dialogs
- CLI automation support for scripting
- Multiple export modes (original, flat, rojo)
- Cross-platform compatibility (macOS, Windows, Linux)

## Project Structure

```
LuneX/
├── src/                    # Main source code
│   └── main.rs            # Application entry point
├── examples/              # Example files
├── docs/                  # Documentation
├── scripts/               # Build/release scripts
├── assets/                # Configuration files
├── tests/                 # Test files
├── Cargo.toml             # Rust project config
└── Cargo.lock             # Dependency lock
```

## Making Changes

1. **Fork the repository** on GitHub
2. **Create a feature branch:** `git checkout -b feature/your-feature-name`
3. **Make your changes** in `src/main.rs`
4. **Test your changes:** `cargo test && cargo build`
5. **Commit your changes:** `git commit -m "Add: your feature description"`
6. **Push to your fork:** `git push origin feature/your-feature-name`
7. **Create a Pull Request** on GitHub

## Development Guidelines

### Code Style
- **Rust Style**: Follow standard Rust formatting (`cargo fmt`)
- **Linting**: Run `cargo clippy` to catch common issues
- **Documentation**: Add comments for complex logic
- **Testing**: Ensure existing functionality still works

### Cross-Platform Considerations
- **File paths**: Use standard Rust path handling
- **File dialogs**: Test on different desktop environments where possible
- **Path separators**: LuneX automatically handles platform differences
- **Native dialogs**: The `rfd` crate provides native dialogs on each platform

### Testing
- **Unit tests**: Add tests for new functionality
- **Integration tests**: Test with actual .rbxl files
- **Platform testing**: Verify on macOS, Windows, or Linux if possible
- **CLI testing**: Test both interactive and CLI modes

## Areas for Contribution

- **Cross-platform builds** - Windows and Linux binary support
- **Error handling** - Better error messages and recovery
- **Performance** - Optimization for large Roblox files
- **Features** - New export modes or file formats
- **Documentation** - Examples, tutorials, videos
- **Testing** - Unit tests and integration tests

## Release Process

Releases are automated via GitHub Actions when tags are pushed:
```bash
cd ../Utilities/development
./create_release.sh v0.1.5 "Description of changes"
git push --tags
```

## Questions or Help?

- **Open an issue** for bugs or feature requests
- **Start a discussion** for questions or ideas
- **Check existing issues** to see if someone else has the same question

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to LuneX! 🚀
