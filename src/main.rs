use anyhow::{Context, Result};
use rbx_binary::from_reader;
use rbx_dom_weak::{WeakDom, Ustr};

use rbx_types::{Variant, Ref};
use serde_json::json;
use std::fs::{self, File};
use std::io::Write;

fn main() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 3 || args.len() > 4 {
        eprintln!("Usage: {} <input.rbxl> <output_dir> [--rojo]", args[0]);
        std::process::exit(1);
    }
    let input_path = &args[1];
    let output_dir = &args[2];
    let mut use_rojo = args.get(3).map(|s| s == "--rojo").unwrap_or(false);

    // If not specified, prompt the user interactively
    if args.len() == 3 {
        use std::io::{self, Write};
        print!("Do you want to export as a Rojo project? (y/n): ");
        io::stdout().flush().unwrap();
        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let input = input.trim().to_lowercase();
        if input == "y" || input == "yes" {
            use_rojo = true;
        }
    }

    let file = File::open(input_path).context("Failed to open input file")?;
    let dom: WeakDom = from_reader(file).context("Failed to decode rbxl file")?;

    if use_rojo {
        export_rojo(&dom, output_dir)?;
        println!("Export complete (Rojo project mode).");
    } else {
        export_tree(&dom, output_dir)?;
        println!("Export complete.");
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

fn export_tree(dom: &WeakDom, output_dir: &str) -> Result<()> {
    fs::create_dir_all(output_dir)?;
    let root_id = dom.root_ref();
    export_instance(dom, root_id, output_dir)?;
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
