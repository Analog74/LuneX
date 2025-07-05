# Contributing to LuneX

Thank you for your interest in contributing to LuneX! This guide will help you get started.

## Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Analog74/LuneX.git
   cd LuneX/Utilities/development
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

## Project Structure

- `../Utilities/development/src/main.rs` - Main application code
- `../Utilities/development/Cargo.toml` - Rust dependencies and configuration
- `../Documents/README.md` - Main documentation
- `../Documents/CHANGELOG.md` - Version history
- `../.github/workflows/` - Automated CI/CD
- `../temp/` - Temporary files and scripts

## Making Changes

1. **Fork the repository** on GitHub
2. **Create a feature branch:** `git checkout -b feature/your-feature-name`
3. **Make your changes** in `../Utilities/development/src/main.rs`
4. **Test your changes:** `cargo test && cargo build`
5. **Commit your changes:** `git commit -m "Add: your feature description"`
6. **Push to your fork:** `git push origin feature/your-feature-name`
7. **Create a Pull Request** on GitHub

## Code Guidelines

- **Rust Style**: Follow standard Rust formatting (`cargo fmt`)
- **Documentation**: Add comments for complex logic
- **Testing**: Ensure existing functionality still works
- **Cross-platform**: Test on macOS, Windows, or Linux if possible

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
