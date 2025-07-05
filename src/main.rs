use anyhow::{Context, Result};
use rbx_binary::from_reader;
use rbx_dom_weak::{WeakDom, Ustr};
use rfd::FileDialog;
use std::io;
use rbx_types::{Variant, Ref};
use serde_json::json;
use std::fs::{self, File};
use std::io::Write;

fn main() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    // If CLI args are provided (at least 3), use CLI mode
    if args.len() >= 3 {
        let input_path = &args[1];
        let output_dir = &args[2];
        // Get the base name of the input file (without extension)
        let input_file_name = std::path::Path::new(input_path)
            .file_stem()
            .map(|s| s.to_string_lossy().to_string())
            .unwrap_or_else(|| "ExportedPlace".to_string());
        // Create a subfolder in output_dir named after the input file
        let export_dir = std::path::Path::new(output_dir).join(&input_file_name);
        let export_dir_str = export_dir.to_string_lossy();
        let mut mode = "original".to_string();
        let mut want_projectjson = false;
        for arg in &args[3..] {
            if arg.starts_with("--mode=") {
                mode = arg[7..].to_string();
            } else if arg == "--flat" {
                mode = "flat".to_string();
            } else if arg == "--rojo" {
                mode = "rojo".to_string();
            } else if arg == "--projectjson" {
                want_projectjson = true;
            }
        }
        let file = File::open(input_path).context("Failed to open input file")?;
        let dom: WeakDom = from_reader(file).context("Failed to decode rbxl file")?;
        match mode.as_str() {
            "original" => {
                export_tree_original(&dom, &export_dir_str)?;
                if want_projectjson {
                    generate_project_json_original(&dom, &export_dir_str)?;
                }
                println!("Export complete (original structure mode).");
            }
            "flat" => {
                export_flat(&dom, &export_dir_str)?;
                if want_projectjson {
                    generate_project_json_flat(&dom, &export_dir_str)?;
                }
                println!("Export complete (flat mode).");
            }
            "rojo" => {
                export_rojo(&dom, &export_dir_str)?;
                println!("Export complete (Rojo project mode).");
            }
            _ => {
                eprintln!("Unknown mode: {}", mode);
                std::process::exit(1);
            }
        }
        return Ok(());
    }

    // If not enough CLI args, always launch interactive mode (even for global install)
    // --- rbxlx-to-rojo style workflow: prompt for mode, then use GUI for file/folder ---
    println!("Choose export mode:\n1. Export to original folder structure\n2. Export all scripts to a single folder");
    print!("Enter 1 or 2: ");
    io::stdout().flush().unwrap();
    let mut mode = String::new();
    io::stdin().read_line(&mut mode).unwrap();
    let mode = mode.trim();

    if mode != "1" && mode != "2" {
        println!("Invalid choice. Exiting.");
        return Ok(());
    }

    // Pick .rbxl file
    let input_path = FileDialog::new()
        .add_filter("Roblox Place", &["rbxl"])
        .set_title("Select .rbxl file")
        .pick_file()
        .expect("No file selected")
        .to_string_lossy()
        .to_string();

    // Pick output directory
    let output_dir = FileDialog::new()
        .set_title("Select output directory")
        .pick_folder()
        .expect("No folder selected")
        .to_string_lossy()
        .to_string();

    // Get the base name of the input file (without extension)
    let input_file_name = std::path::Path::new(&input_path)
        .file_stem()
        .map(|s| s.to_string_lossy().to_string())
        .unwrap_or_else(|| "ExportedPlace".to_string());
    // Create a subfolder in output_dir named after the input file
    let export_dir = std::path::Path::new(&output_dir).join(&input_file_name);
    let export_dir_str = export_dir.to_string_lossy();

    let file = File::open(&input_path).context("Failed to open input file")?;
    let dom: WeakDom = from_reader(file).context("Failed to decode rbxl file")?;

    let mut want_projectjson = false;
    print!("Generate default.project.json to match this structure? (y/n): ");
    io::stdout().flush().unwrap();
    let mut pj = String::new();
    io::stdin().read_line(&mut pj).unwrap();
    let pj = pj.trim().to_lowercase();
    want_projectjson = pj == "y" || pj == "yes";

    match mode {
        "1" => {
            export_tree_original(&dom, &export_dir_str)?;
            if want_projectjson {
                generate_project_json_original(&dom, &export_dir_str)?;
            }
            println!("Export complete (original structure mode).");
        }
        "2" => {
            export_flat(&dom, &export_dir_str)?;
            if want_projectjson {
                generate_project_json_flat(&dom, &export_dir_str)?;
            }
            println!("Export complete (flat mode).");
        }
        _ => {}
    }
    Ok(())
}

fn export_rojo(dom: &WeakDom, output_dir: &str) -> Result<()> {
    // Create src directory for scripts
    let src_dir = format!("{}/src", output_dir);
    fs::create_dir_all(&src_dir)?;
    // Export the tree as usual, but put scripts in src/
    export_instance_rojo(dom, dom.root_ref(), output_dir, &src_dir)?;
    // Write a minimal default.project.json
    let project_json = serde_json::json!({
        "name": "rbxdom_export",
        "tree": {
            "$className": "DataModel",
            "src": { "$path": "src" }
        }
    });
    let project_path = format!("{}/default.project.json", output_dir);
    let mut f = File::create(&project_path)?;
    f.write_all(serde_json::to_string_pretty(&project_json)?.as_bytes())?;
    Ok(())
}

fn export_instance_rojo(dom: &WeakDom, id: Ref, path: &str, src_dir: &str) -> Result<()> {
    let inst = dom.get_by_ref(id).unwrap();
    let name = &inst.name;
    let class = &inst.class;
    let inst_dir = format!("{}/{}_{}", path, name, id.to_string());
    fs::create_dir_all(&inst_dir)?;

    // Export properties
    let mut prop_map = serde_json::Map::new();
    for (prop, value) in &inst.properties {
        prop_map.insert(prop.to_string(), rbx_value_to_json(value));
    }
    let prop_path = format!("{}/properties.json", inst_dir);
    let mut prop_file = File::create(&prop_path)?;
    prop_file.write_all(serde_json::to_string_pretty(&prop_map)?.as_bytes())?;

    // Export scripts to src/
    if class == "Script" || class == "LocalScript" || class == "ModuleScript" {
        if let Some(Variant::String(value)) = inst.properties.get(&Ustr::from("Source")) {
            let script_path = format!("{}/{}_{}.lua", src_dir, name, id.to_string());
            let mut script_file = File::create(&script_path)?;
            script_file.write_all(value.as_bytes())?;
        }
    }

    // Recurse into children
    for child_id in inst.children() {
        export_instance_rojo(dom, *child_id, &inst_dir, src_dir)?;
    }
    Ok(())
}


/// Exports the DOM to the original folder structure (using instance names, no hashes, with duplicate handling)
fn export_tree_original(dom: &WeakDom, output_dir: &str) -> Result<()> {
    fs::create_dir_all(output_dir)?;
    let root_id = dom.root_ref();
    let mut name_counts = std::collections::HashMap::new();
    export_instance_original(dom, root_id, output_dir, &mut name_counts)?;
    Ok(())
}

/// Helper for export_tree_original: recursively exports each instance, using instance names, handling duplicates
fn export_instance_original(
    dom: &WeakDom,
    id: Ref,
    path: &str,
    name_counts: &mut std::collections::HashMap<String, usize>,
) -> Result<()> {
    let inst = dom.get_by_ref(id).unwrap();
    let mut name = inst.name.to_string();
    // Handle duplicate names in the same folder
    let count = name_counts.entry(name.clone()).or_insert(0);
    if *count > 0 {
        name = format!("{} ({})", name, count);
    }
    *name_counts.get_mut(&inst.name.to_string()).unwrap() += 1;
    let inst_dir = format!("{}/{}", path, name);
    fs::create_dir_all(&inst_dir)?;

    // Export properties
    let mut prop_map = serde_json::Map::new();
    for (prop, value) in &inst.properties {
        prop_map.insert(prop.to_string(), rbx_value_to_json(value));
    }
    let prop_path = format!("{}/properties.json", inst_dir);
    let mut prop_file = File::create(&prop_path)?;
    prop_file.write_all(serde_json::to_string_pretty(&prop_map)?.as_bytes())?;

    // Export scripts
    let class = &inst.class;
    if class == "Script" || class == "LocalScript" || class == "ModuleScript" {
        if let Some(Variant::String(value)) = inst.properties.get(&Ustr::from("Source")) {
            let script_path = format!("{}/{}.lua", inst_dir, class);
            let mut script_file = File::create(&script_path)?;
            script_file.write_all(value.as_bytes())?;
        }
    }

    // Recurse into children, with new name_counts for each folder
    for child_id in inst.children() {
        let mut child_counts = std::collections::HashMap::new();
        export_instance_original(dom, *child_id, &inst_dir, &mut child_counts)?;
    }
    Ok(())
}

/// Exports all scripts to a single flat folder (no subfolders)
fn export_flat(dom: &WeakDom, output_dir: &str) -> Result<()> {
    fs::create_dir_all(output_dir)?;
    let mut script_index = 0;
    export_flat_recurse(dom, dom.root_ref(), output_dir, &mut script_index)?;
    Ok(())
}

fn export_flat_recurse(
    dom: &WeakDom,
    id: Ref,
    output_dir: &str,
    script_index: &mut usize,
) -> Result<()> {
    let inst = dom.get_by_ref(id).unwrap();
    let class = &inst.class;
    let name = &inst.name;
    if class == "Script" || class == "LocalScript" || class == "ModuleScript" {
        if let Some(Variant::String(value)) = inst.properties.get(&Ustr::from("Source")) {
            // Use a unique name: <Class>_<Name>_<index>.lua
            let script_path = format!("{}/{}_{}_{}.lua", output_dir, class, name, *script_index);
            let mut script_file = File::create(&script_path)?;
            script_file.write_all(value.as_bytes())?;
            *script_index += 1;
        }
    }
    for child_id in inst.children() {
        export_flat_recurse(dom, *child_id, output_dir, script_index)?;
    }
    Ok(())
}

/// Generate default.project.json for original structure
fn generate_project_json_original(dom: &WeakDom, output_dir: &str) -> Result<()> {
    // Recursively walk the exported folder tree and build the Rojo tree
    use std::collections::HashMap;
    use std::path::{Path, PathBuf};

    fn build_tree(dom: &WeakDom, id: Ref, path: &Path, output_dir: &Path) -> serde_json::Value {
        let inst = dom.get_by_ref(id).unwrap();
        let mut node = serde_json::Map::new();
        node.insert("$className".to_string(), serde_json::Value::String(inst.class.to_string()));

        // If this instance has scripts, add $path for the folder
        if path.is_dir() {
            let entries = std::fs::read_dir(path).unwrap();
            let mut has_script = false;
            for entry in entries {
                let entry = entry.unwrap();
                let file_type = entry.file_type().unwrap();
                if file_type.is_file() && entry.file_name().to_string_lossy().ends_with(".lua") {
                    has_script = true;
                    break;
                }
            }
            if has_script {
                node.insert("$path".to_string(), serde_json::Value::String(path.strip_prefix(output_dir).unwrap().to_string_lossy().to_string()));
            }
        }

        // Recurse into children
        for child_id in inst.children() {
            let child = dom.get_by_ref(*child_id).unwrap();
            let mut child_path = PathBuf::from(path);
            // Handle duplicate names as in export
            child_path.push(&child.name);
            node.insert(child.name.to_string(), build_tree(dom, *child_id, &child_path, output_dir));
        }
        serde_json::Value::Object(node)
    }

    let root_id = dom.root_ref();
    let tree = build_tree(dom, root_id, Path::new(output_dir), Path::new(output_dir));
    let project_json = serde_json::json!({
        "name": "rbxdom_export",
        "tree": tree
    });
    let project_path = format!("{}/default.project.json", output_dir);
    let mut f = File::create(&project_path)?;
    f.write_all(serde_json::to_string_pretty(&project_json)?.as_bytes())?;
    Ok(())
}

/// Generate default.project.json for flat export
fn generate_project_json_flat(_dom: &WeakDom, output_dir: &str) -> Result<()> {
    // Just map the flat folder as a single node
    let project_json = serde_json::json!({
        "name": "rbxdom_export",
        "tree": {
            "$className": "DataModel",
            "flat": { "$path": "." }
        }
    });
    let project_path = format!("{}/default.project.json", output_dir);
    let mut f = File::create(&project_path)?;
    f.write_all(serde_json::to_string_pretty(&project_json)?.as_bytes())?;
    Ok(())
}

fn export_instance(dom: &WeakDom, id: Ref, path: &str) -> Result<()> {
    let inst = dom.get_by_ref(id).unwrap();
    let name = &inst.name;
    let class = &inst.class;
    let inst_dir = format!("{}/{}_{}", path, name, id.to_string());
    fs::create_dir_all(&inst_dir)?;

    // Export properties
    let mut prop_map = serde_json::Map::new();
    for (prop, value) in &inst.properties {
        prop_map.insert(prop.to_string(), rbx_value_to_json(value));
    }
    let prop_path = format!("{}/properties.json", inst_dir);
    let mut prop_file = File::create(&prop_path)?;
    prop_file.write_all(serde_json::to_string_pretty(&prop_map)?.as_bytes())?;

    // Export scripts
    if class == "Script" || class == "LocalScript" || class == "ModuleScript" {
        if let Some(Variant::String(value)) = inst.properties.get(&Ustr::from("Source")) {
            let script_path = format!("{}/{}.lua", inst_dir, class);
            let mut script_file = File::create(&script_path)?;
            script_file.write_all(value.as_bytes())?;
        }
    }

    // Recurse into children
    for child_id in inst.children() {
        export_instance(dom, *child_id, &inst_dir)?;
    }
    Ok(())
}

fn rbx_value_to_json(value: &Variant) -> serde_json::Value {
    match value {
        Variant::String(value) => json!(value),
        Variant::Bool(value) => json!(value),
        Variant::Int32(value) => json!(value),
        Variant::Float32(value) => json!(value),
        Variant::Float64(value) => json!(value),
        Variant::Color3(value) => json!({"r": value.r, "g": value.g, "b": value.b}),
        Variant::Vector3(value) => json!({"x": value.x, "y": value.y, "z": value.z}),
        Variant::CFrame(value) => json!({"matrix": value}),
        Variant::Ref(value) => json!(value),
        _ => json!(format!("<unsupported: {:?}>", value)),
    }
}
