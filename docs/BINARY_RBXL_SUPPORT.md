# Binary .rbxl Support Documentation

## Overview

LuneX now provides robust support for binary .rbxl (Roblox place) files through integration with the Rojo ecosystem's open-source tools. This document outlines the implementation, usage, and capabilities.

## Features

### Automatic Format Detection
- **Smart Detection**: Automatically detects whether input files are binary (.rbxl) or XML (.rbxlx) format
- **Header Analysis**: Uses file signature analysis (`<roblox!` for binary, `<?xml` for XML)
- **Fallback Parsing**: Attempts multiple detection methods for edge cases

### Binary Conversion
- **Primary Tool**: Uses `rbx-util` from the rbx-dom project for reliable conversion
- **Fallback Support**: Falls back to other system-installed converters if available
- **Temporary Files**: Automatically manages converted XML files during processing

### Integration Strategy
- **Local Tools**: Includes pre-built conversion tools in `external-tools/rojo-ecosystem/`
- **System Tools**: Can also use system-installed converters
- **Cross-Platform**: Works on macOS, Linux, and Windows

## External Tools

### rbx-dom (Primary)
- **Location**: `external-tools/rojo-ecosystem/rbx-dom/`
- **Binary**: `target/release/rbx-util`
- **Purpose**: Binary ↔ XML conversion for Roblox files
- **License**: MIT
- **Usage**: `rbx-util convert input.rbxl output.rbxlx`

### rbxlx-to-rojo (Alternative)
- **Location**: `external-tools/rojo-ecosystem/rbxlx-to-rojo/`
- **Binary**: `target/release/rbxlx-to-rojo`
- **Purpose**: Convert Roblox files to full Rojo project structure
- **License**: MPL-2.0
- **Usage**: `rbxlx-to-rojo input.rbxl output_dir/`

### tarmac (Future)
- **Location**: `external-tools/rojo-ecosystem/tarmac/`
- **Purpose**: Asset management for Rojo projects
- **Status**: Cloned, ready for future integration

### vscode-rojo (Future)
- **Location**: `external-tools/rojo-ecosystem/vscode-rojo/`
- **Purpose**: VS Code extension source for reference
- **Status**: Cloned, ready for future integration

## Usage Examples

### Basic Binary Conversion
```bash
# Convert binary .rbxl to Rojo project
python3 Lune.py MagicMaster.rbxl output/

# The tool will automatically:
# 1. Detect binary format
# 2. Convert to XML using rbx-util
# 3. Parse and export to Rojo structure
```

### XML Files (No Conversion Needed)
```bash
# Process XML .rbxlx directly
python3 Lune.py MagicMaster.rbxlx output/

# The tool will automatically:
# 1. Detect XML format
# 2. Skip conversion
# 3. Parse and export directly
```

### With Export Modes
```bash
# Scripts-only mode with binary file
python3 Lune.py --mode scripts-only MagicMaster.rbxl output/

# Full Rojo mode with project.json
python3 Lune.py --mode rojo --project-json MagicMaster.rbxl output/
```

## Implementation Details

### File Detection Logic
```python
def convert_rbxl_to_xml(rbxl_path):
    # 1. Read file header (first 200 bytes)
    # 2. Check for XML markers (<?xml)
    # 3. Check for binary signatures (<roblox!, RBLX)
    # 4. Try UTF-8 parsing as fallback
    # 5. Proceed with appropriate handling
```

### Conversion Pipeline
1. **Detection**: Identify file format using header analysis
2. **Conversion**: Use rbx-util or fallback converters for binary files
3. **Validation**: Verify converted XML is valid
4. **Processing**: Continue with normal LuneX export pipeline
5. **Cleanup**: Remove temporary files (optional)

### Error Handling
- **Missing Tools**: Provides helpful installation guidance
- **Conversion Failures**: Clear error messages and troubleshooting tips
- **File Permissions**: Handles read/write permission issues
- **Timeout Protection**: Prevents hanging on large files

## Testing

### Automated Tests
Run the test suite to verify all functionality:
```bash
python3 test_lunex.py
```

Tests include:
- Binary format detection
- Conversion functionality
- External tool availability
- XML validation
- End-to-end export pipeline

### Manual Testing
```bash
# Test with sample binary file
python3 Lune.py samples/MagicMaster.rbxl test_output/manual_test/

# Verify output structure
ls -la test_output/manual_test/
cat test_output/manual_test/default.project.json
```

## Troubleshooting

### Common Issues

#### "rbx-util not found"
**Solution**: Rebuild the external tools:
```bash
cd external-tools/rojo-ecosystem/rbx-dom/
cargo build --release
```

#### "Conversion failed"
**Potential Causes**:
- Corrupted .rbxl file
- Insufficient disk space
- File permissions
- Very large files (>100MB)

**Solutions**:
- Verify file integrity
- Check available disk space
- Run with elevated permissions if needed
- Use alternative conversion tools

#### "Unknown file format"
**Solution**: The file might be corrupted or use an unsupported format. Try:
1. Re-export from Roblox Studio
2. Check file size (should be >0 bytes)
3. Try opening in Roblox Studio first

### Debug Mode
For detailed conversion information, the tool provides verbose output:
- 🔍 Detection status
- 🔄 Conversion progress
- ✅ Success indicators
- ❌ Error details

## Future Enhancements

### Planned Features
1. **Direct Python Bindings**: Eliminate subprocess calls for better performance
2. **Asset Management**: Integrate tarmac for handling game assets
3. **Batch Processing**: Support multiple files at once
4. **Progress Indicators**: Show progress for large file conversions
5. **Validation Mode**: Verify .rbxl file integrity without conversion

### Integration Opportunities
1. **VS Code Extension**: Use vscode-rojo codebase as reference
2. **Web Interface**: Create browser-based conversion tool
3. **GitHub Actions**: Automated conversion workflows
4. **Docker Support**: Containerized conversion environment

## License Compatibility

All integrated tools use permissive licenses compatible with LuneX:
- **rbx-dom**: MIT License
- **rbxlx-to-rojo**: MPL-2.0 License  
- **tarmac**: MIT License
- **vscode-rojo**: MIT License

## Support

For issues with binary .rbxl support:
1. Run the test suite: `python3 test_lunex.py`
2. Check external tool status
3. Verify file format with: `file samples/MagicMaster.rbxl`
4. Review conversion logs for error details

## Changelog

### v1.1.0 (Current)
- ✅ Added robust binary .rbxl detection
- ✅ Integrated rbx-util conversion tool
- ✅ Implemented fallback conversion methods
- ✅ Added comprehensive error handling
- ✅ Created automated test suite
- ✅ Documented integration strategy

### Future Versions
- Planned: Direct Python bindings
- Planned: Asset management integration
- Planned: Batch processing support
