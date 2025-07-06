# Rojo Ecosystem Integration for LuneX

This directory contains cloned repositories from the Rojo ecosystem that provide critical functionality for handling Roblox binary and XML files.

## 🗂️ Repository Overview

### 📦 rbx-dom
**Purpose**: Core binary/XML parsing library  
**Language**: Rust  
**Key Libraries**:
- `rbx_binary` - Parse .rbxl/.rbxm binary files
- `rbx_xml` - Parse .rbxlx/.rbxmx XML files  
- `rbx_dom_weak` - Weakly-typed DOM implementation
- `rbx_types` - Roblox value types (Vector3, Color3, etc.)

### 🔄 rbxlx-to-rojo  
**Purpose**: Direct competitor/reference implementation  
**Language**: Rust + Lua  
**Features**:
- Handles both .rbxl and .rbxlx files
- Generates Rojo project structures
- Similar goals to LuneX but in Rust

### 🎨 tarmac
**Purpose**: Asset management tool  
**Language**: Rust  
**Features**:
- Upload images/assets to Roblox
- Generate asset lookup tables
- Spritesheet packing

### 🔧 vscode-rojo
**Purpose**: VS Code extension  
**Language**: TypeScript  
**Features**:
- Integration with Rojo workflow
- Project management
- Build automation

## 🚀 Integration Strategy

### Phase 1: Binary Conversion (CURRENT)
1. **Build rbx-dom tools** as subprocess fallbacks
2. **Extract key patterns** from rbxlx-to-rojo implementation  
3. **Create Python wrapper** that can call Rust tools when needed

### Phase 2: Asset Management (FUTURE)
1. **Study tarmac implementation** for asset handling
2. **Add asset extraction** to LuneX
3. **Implement upload capabilities**

### Phase 3: IDE Integration (FUTURE)  
1. **Study vscode-rojo patterns** for VS Code integration
2. **Create LuneX VS Code extension**
3. **Add project management features**

## 🔧 Building the Tools

### Build rbx-dom utilities:
```bash
cd rbx-dom
cargo build --release --bin rbx_util
```

### Build rbxlx-to-rojo:
```bash
cd rbxlx-to-rojo  
cargo build --release --features cli
```

### Use as subprocess in LuneX:
```python
# Example integration
import subprocess
result = subprocess.run([
    'rbxlx-to-rojo', 
    'input.rbxl', 
    'output-dir'
], capture_output=True)
```

## 📚 Key Learnings Applied to LuneX

### Binary File Detection:
```rust
// From rbxlx-to-rojo/src/cli.rs:114-122
match file_path.extension().map(|extension| extension.to_string_lossy()) {
    Some(Cow::Borrowed("rbxmx")) | Some(Cow::Borrowed("rbxlx")) => {
        rbx_xml::from_reader_default(file_source).map_err(Problem::XMLDecodeError)
    }
    Some(Cow::Borrowed("rbxm")) | Some(Cow::Borrowed("rbxl")) => {
        rbx_binary::from_reader_default(file_source).map_err(Problem::BinaryDecodeError)
    }
    _ => Err(Problem::InvalidFile),
}
```

### Script Classification:
```rust
// From rbxlx-to-rojo/src/lib.rs:67-71
let extension = match child.class.as_str() {
    "Script" => ".server",
    "LocalScript" => ".client", 
    "ModuleScript" => "",
    _ => unreachable!(),
};
```

### Property Extraction:
```rust
// From rbxlx-to-rojo/src/lib.rs:73-77
let source = match child.properties.get("Source").expect("no Source") {
    Variant::String(value) => value,
    _ => unreachable!(),
}.as_bytes();
```

## 📄 License Compatibility

- **rbx-dom**: MIT License ✅ Compatible
- **rbxlx-to-rojo**: MPL-2.0 ✅ Compatible  
- **tarmac**: MIT License ✅ Compatible
- **vscode-rojo**: MPL-2.0 ✅ Compatible

All licenses are compatible with our MIT-licensed LuneX project.

## 🔗 References

- [rbx-dom documentation](https://dom.rojo.space)
- [Rojo project website](https://rojo.space)
- [Roblox Open Source Discord](https://discord.gg/wH5ncNS)
