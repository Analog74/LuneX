import argparse
import os
import sys
import json
import xml.etree.ElementTree as ET
import zipfile
import tempfile
import shutil
from pathlib import Path
try:
    import template_engine
    from template_engine import render_template
    TEMPLATE_ENGINE_AVAILABLE = True
except ImportError:
    TEMPLATE_ENGINE_AVAILABLE = False

def _report_progress(percentage, message):
    """Prints progress in a structured format for the GUI to parse."""
    # Format: PROGRESS:percentage:message
    print(f"PROGRESS:{int(percentage)}:{message}")
    sys.stdout.flush() # Ensure the GUI gets the message immediately

# --- ROBLOX FILE PARSING ---

import converters
def convert_rbxl_to_xml(rbxl_path):
    """
    Convert .rbxl (binary) to .rbxlx (XML) format.
    Uses external tools or provides conversion guidance.
    """
    print(f"Processing {rbxl_path}...")
    _report_progress(1, "Analyzing file format...")
    
    # Check if it's already XML
    try:
        with open(rbxl_path, 'rb') as f:
            header = f.read(200)
            # Check for XML markers
            if b'<?xml' in header[:50]:
                print("✅ File is already in XML format (.rbxlx)")
                _report_progress(15, "File is already XML.")
                return rbxl_path
            # Check for binary signatures - Roblox binary files start with "<roblox!"
            elif header[:8] == b'<roblox!' or b'RBLX' in header[:16]:
                print("🔍 Detected binary .rbxl file format")
                # Continue to conversion logic below
            else:
                # Try to parse as XML anyway, might be UTF-8 encoded
                try:
                    with open(rbxl_path, 'r', encoding='utf-8') as f:
                        first_line = f.readline(100)
                        if '<?xml' in first_line or '<roblox' in first_line:
                            print("✅ File is XML format (UTF-8 encoded)")
                            _report_progress(15, "File is already XML.")
                            return rbxl_path
                except:
                    pass
                print("🔍 Unknown file format, treating as binary")
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return None
    
    print("🔄 Detected binary .rbxl file - attempting conversion...")
    _report_progress(5, "Binary format detected. Starting conversion...")
    
    # Try external conversion tools
    converted_path = converters._try_external_converters(rbxl_path)
    if converted_path:
        return converted_path
    
    # Try Python-based conversion
    converted_path = _try_python_conversion(rbxl_path)
    if converted_path:
        return converted_path
    
    # If all conversion attempts fail, provide helpful guidance
    converters._show_conversion_help(rbxl_path)
    _report_progress(-1, "Automatic conversion failed. See console for help.")
    return None

def _try_external_converters(rbxl_path):
    """Try to use external command-line converters."""
    import subprocess
    import platform
    
    print("🔍 Searching for external conversion tools...")
    
    # Check for rbx-util first (from our project)
    rbx_util_path = os.path.join(os.path.dirname(__file__), "external-tools", "rojo-ecosystem", "rbx-dom", "target", "release", "rbx-util")
    
    if os.path.exists(rbx_util_path):
        print(f"✅ Found rbx-util in project: {rbx_util_path}")
        
        xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
        
        try:
            _report_progress(10, "Running rbx-util converter...")
            print(f"🔄 Converting {os.path.basename(rbxl_path)} to XML...")
            result = subprocess.run([
                rbx_util_path, 'convert', rbxl_path, xml_path
            ], capture_output=True, text=True, timeout=120)
            
            if result.returncode == 0 and os.path.exists(xml_path):
                print(f"✅ Successfully converted using rbx-util")
                print(f"📄 Created: {os.path.basename(xml_path)}")
                _report_progress(15, "Conversion successful with rbx-util.")
                return xml_path
            else:
                print(f"❌ rbx-util conversion failed")
                if result.stderr:
                    print(f"   Error: {result.stderr.strip()}")
                if result.stdout:
                    print(f"   Output: {result.stdout.strip()}")
        except Exception as e:
            print(f"❌ Error running rbx-util: {e}")
    
    # Check for rbxlx-to-rojo (alternative method)
    rbxlx_to_rojo_path = os.path.join(os.path.dirname(__file__), "external-tools", "rojo-ecosystem", "rbxlx-to-rojo", "target", "release", "rbxlx-to-rojo")
    
    if os.path.exists(rbxlx_to_rojo_path):
        print(f"✅ Found rbxlx-to-rojo in project: {rbxlx_to_rojo_path}")
        # Note: rbxlx-to-rojo creates full project structure, not just conversion
        # We could use this but it would require different handling
    
    # List of other possible system converters to try
    converters = [
        ('rbx-util', ['convert', rbxl_path]),  # System-installed rbx-util
        ('rbxlx-to-rojo', [rbxl_path]),       # System-installed rbxlx-to-rojo
        ('rojo', ['rbxl-to-rbxlx', rbxl_path]), # Rojo might have this
    ]
    
    for converter_name, args in converters:
        try:
            # Check if the converter exists
            result = subprocess.run([converter_name, '--help'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0 or 'usage' in result.stdout.lower() or 'usage' in result.stderr.lower():
                print(f"✅ Found system converter: {converter_name}")
                
                xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
                
                if converter_name == 'rbx-util':
                    full_args = [converter_name] + args + [xml_path]
                elif converter_name == 'rbxlx-to-rojo':
                    # rbxlx-to-rojo works differently - creates project structure
                    temp_dir = rbxl_path.replace('.rbxl', '_temp')
                    full_args = [converter_name, rbxl_path, temp_dir]
                else:
                    full_args = [converter_name] + args + [xml_path]
                    
                print(f"🔄 Running: {' '.join(full_args[:3])}...")
                
                result = subprocess.run(full_args, 
                                      capture_output=True, text=True, timeout=60)
                
                if result.returncode == 0:
                    if converter_name == 'rbxlx-to-rojo':
                        # Look for XML file in temp directory
                        for file in os.listdir(temp_dir):
                            if file.endswith('.rbxlx'):
                                xml_path = os.path.join(temp_dir, file)
                                break
                    
                    if os.path.exists(xml_path):
                        print(f"✅ Successfully converted using {converter_name}")
                        return xml_path
                    else:
                        print(f"❌ Conversion failed with {converter_name} - output file not found")
                else:
                    print(f"❌ Conversion failed with {converter_name}")
                    if result.stderr:
                        print(f"   Error: {result.stderr.strip()}")
                        
        except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
            continue
    
    print("⚠️  No external converters found or working")
    return None

def _try_python_conversion(rbxl_path):
    """Try Python-based binary conversion libraries."""
    print("🐍 Attempting Python-based conversion...")
    
    # Try different Python libraries
    conversion_attempts = [
        _try_roblox_py,
        _try_pyrobloxlib,
        _try_basic_binary_parse
    ]
    
    for attempt_func in conversion_attempts:
        try:
            result = attempt_func(rbxl_path)
            if result:
                return result
        except Exception as e:
            print(f"❌ Conversion attempt failed: {e}")
            continue
    
    return None

def _try_roblox_py(rbxl_path):
    """Try using roblox-py or similar library."""
    try:
        # Try multiple possible import names
        roblox_lib = None
        for lib_name in ['roblox', 'robloxpy', 'pyroblox']:
            try:
                roblox_lib = __import__(lib_name)
                print(f"📦 Using library: {lib_name}")
                break
            except ImportError:
                continue
        
        if not roblox_lib:
            return None
        
        xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
        
        # Try to read and convert
        with open(rbxl_path, 'rb') as f:
            binary_data = f.read()
        
        # This would depend on the specific library's API
        # Most libraries have different methods, so this is a generic attempt
        if hasattr(roblox_lib, 'from_binary'):
            dom = roblox_lib.from_binary(binary_data)
            xml_data = roblox_lib.to_xml(dom)
        elif hasattr(roblox_lib, 'parse_binary'):
            dom = roblox_lib.parse_binary(binary_data)
            xml_data = dom.to_xml()
        else:
            return None
        
        with open(xml_path, 'w', encoding='utf-8') as f:
            f.write(xml_data)
        
        print(f"✅ Python conversion successful")
        return xml_path
        
    except ImportError:
        return None
    except Exception as e:
        print(f"❌ Python library conversion failed: {e}")
        return None

def _try_pyrobloxlib(rbxl_path):
    """Try using pyrobloxlib."""
    try:
        import pyrobloxlib
        
        xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
        
        # Attempt conversion with pyrobloxlib
        with open(rbxl_path, 'rb') as f:
            binary_data = f.read()
        
        # This is speculative - actual API may differ
        if hasattr(pyrobloxlib, 'convert_binary_to_xml'):
            xml_data = pyrobloxlib.convert_binary_to_xml(binary_data)
            with open(xml_path, 'w', encoding='utf-8') as f:
                f.write(xml_data)
            print(f"✅ pyrobloxlib conversion successful")
            return xml_path
        
        return None
        
    except ImportError:
        return None
    except Exception:
        return None

def _try_basic_binary_parse(rbxl_path):
    """Basic binary format analysis - can identify but not fully convert."""
    try:
        with open(rbxl_path, 'rb') as f:
            # Read first few bytes to identify format
            header = f.read(16)
            
            # Roblox binary files typically start with specific signatures
            if len(header) >= 8:
                # Check for known Roblox binary signatures
                if header[:4] == b'<rob' or header[:8] == b'<roblox>':
                    print("🔍 Confirmed Roblox binary format")
                    # For now, just log that we detected the format
                    # Full parsing would require implementing the binary specification
                    return None
                elif header[:4] in [b'RBLX', b'RBX1', b'RBX2']:
                    print("🔍 Detected newer Roblox binary format")
                    return None
        
        return None
        
    except Exception:
        return None

def _show_conversion_help(rbxl_path):
    """Show helpful conversion guidance to the user."""
    print("\n" + "="*70)
    print("🔧 BINARY .RBXL CONVERSION REQUIRED")
    print("="*70)
    print("LuneX can process your file, but it's in binary format.")
    print("Here are your options to convert it:\n")
    
    print("🎮 OPTION 1: Use Roblox Studio (Easiest)")
    print("   1. Open your .rbxl file in Roblox Studio")
    print("   2. File → Publish to Roblox As... → Save to File")
    print("   3. Choose 'Roblox XML Place (*.rbxlx)' format")
    print("   4. Save with .rbxlx extension")
    print("   5. Run LuneX again with the .rbxlx file\n")
    
    print("🛠️  OPTION 2: Install External Converter")
    print("   Install a Rust-based converter (recommended):")
    print("   1. Install Rust: https://rustup.rs/")
    print("   2. Run: cargo install rbx-binary-to-xml")
    print("   3. Run LuneX again (will auto-detect the converter)\n")
    
    print("🐍 OPTION 3: Python Libraries")
    print("   Try installing Python conversion libraries:")
    print("   pip install roblox-binary-parser")
    print("   pip install rbxl-parser\n")
    
    print("⚡ OPTION 4: Use Archived Rust Version")
    print("   This project includes a working Rust implementation:")
    print("   cd _archive/rbxdom_rust_exporter/")
    print("   cargo run your_file.rbxl output_directory\n")
    
    print("="*70)
    print(f"📁 Your file: {rbxl_path}")
    print("🔄 After conversion, run LuneX again with the .rbxlx file")
    print("="*70)

def parse_roblox_xml(xml_path):
    """
    Parse a Roblox XML file and extract the instance tree.
    """
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
        
        # Find the main game/DataModel element
        game_elements = root.findall('.//Item[@class="DataModel"]')
        if not game_elements:
            game_elements = root.findall('.//Item')
        
        if not game_elements:
            raise ValueError("Could not find DataModel in XML file")
        
        game_element = game_elements[0]
        return parse_instance(game_element)
    
    except ET.ParseError as e:
        raise ValueError(f"Invalid XML format: {e}")
    except Exception as e:
        raise ValueError(f"Error parsing XML: {e}")

def parse_instance(element):
    """
    Recursively parse a Roblox instance element.
    """
    instance = {
        'ClassName': element.get('class', 'Instance'),
        'Name': '',
        'Properties': {},
        'Children': []
    }
    
    # Parse properties
    for prop in element.findall('./Properties/*'):
        prop_name = prop.get('name', '')
        prop_type = prop.tag

        if prop_type == 'string':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'bool':
            instance['Properties'][prop_name] = prop.text == 'true'
        elif prop_type == 'int':
            instance['Properties'][prop_name] = int(prop.text or '0')
        elif prop_type == 'float':
            instance['Properties'][prop_name] = float(prop.text or '0.0')
        elif prop_type == 'Content':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type in ('Vector3', 'Vector2'):
            try:
                vals = [float(x) for x in prop.text.split(',')]
            except Exception:
                vals = []
            instance['Properties'][prop_name] = vals
        elif prop_type == 'Color3':
            try:
                vals = [float(x) for x in prop.text.split(',')]
            except Exception:
                vals = []
            instance['Properties'][prop_name] = vals
        elif prop_type == 'CFrame':
            try:
                vals = [float(x) for x in prop.text.split(',')]
            except Exception:
                vals = []
            instance['Properties'][prop_name] = vals
        elif prop_type == 'UDim':
            try:
                s, o = prop.text.split(',')
                ud = {'scale': float(s), 'offset': int(o)}
            except Exception:
                ud = {}
            instance['Properties'][prop_name] = ud
        elif prop_type == 'UDim2':
            dims = {}
            for child in prop.findall('./UDim'):
                name = child.get('name')
                try:
                    s, o = child.text.split(',')
                    dims[name] = {'scale': float(s), 'offset': int(o)}
                except Exception:
                    dims[name] = {}
            instance['Properties'][prop_name] = dims
        elif prop_type == 'Enum':
            try:
                instance['Properties'][prop_name] = int(prop.text)
            except Exception:
                instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'BrickColor':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'BinaryString':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'Tags':
            instance['Properties'][prop_name] = [tag.text for tag in prop.findall('./tag')]
        elif prop_type == 'ContentId':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'ProtectedString':
            instance['Properties'][prop_name] = prop.text or ''
        elif prop_type == 'SharedString':
            instance['Properties'][prop_name] = prop.text or ''
        else:
            print(f"Warning: Unknown property type '{prop_type}' for property '{prop_name}'")
            instance['Properties'][prop_name] = prop.text or ''
    
    # Get name from properties or attribute
    instance['Name'] = instance['Properties'].get('Name', element.get('name', 'Unknown'))
    
    # Parse children
    for child in element.findall('./Item'):
        instance['Children'].append(parse_instance(child))
    
    return instance

def is_script_instance(instance):
    """
    Check if an instance is a script (LocalScript, ServerScript, ModuleScript).
    """
    script_types = ['Script', 'LocalScript', 'ModuleScript']
    return instance['ClassName'] in script_types

def get_script_content(instance):
    """
    Extract script content from an instance.
    """
    return instance['Properties'].get('Source', '')

def sanitize_filename(name):
    """
    Sanitize a name for use as a filename.
    """
    # Replace invalid characters
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        name = name.replace(char, '_')
    
    # Remove leading/trailing spaces and dots
    name = name.strip('. ')
    
    # Ensure it's not empty
    if not name:
        name = 'Unnamed'
    
    return name

# --- CORE EXPORT LOGIC ---

def export_rojo_ready(input_file, output_dir, template_dir=None):
    """
    Exports the .rbxl file to a Rojo-compatible project structure.
    """
    # If a custom template directory is provided, update template_engine loader
    if template_dir:
        template_engine.env.loader.searchpath = [template_dir]

    _report_progress(0, "Starting Rojo-Ready export...")
    print(f"--- Starting Rojo-Ready Export ---")
    print(f"Input file: {input_file}")
    print(f"Output directory: {output_dir}")

    # Convert .rbxl to .rbxlx (XML format)
    xml_file = convert_rbxl_to_xml(input_file)
    if xml_file is None:
        print("Error: Could not convert .rbxl to .rbxlx (XML) format")
        # The error is already reported by the conversion function
        return

    # Parse the XML and extract the instance tree
    try:
        _report_progress(20, "Parsing XML file...")
        root_instance = parse_roblox_xml(xml_file)
        print(f"Successfully parsed Roblox file: {root_instance['Name']}")
        _report_progress(35, f"Successfully parsed {root_instance['Name']}")
    except Exception as e:
        print(f"Error parsing file: {e}")
        _report_progress(-1, f"XML Parsing failed: {e}")
        return
    
    # Create the project structure based on the instance tree
    src_path = Path(output_dir) / "src"
    src_path.mkdir(parents=True, exist_ok=True)
    
    # Services to map to Rojo structure
    rojo_services = {
        'ReplicatedStorage': 'ReplicatedStorage',
        'ServerScriptService': 'ServerScriptService',
        'ServerStorage': 'ServerStorage',
        'StarterPlayer': 'StarterPlayer',
        'StarterGui': 'StarterGui',
        'StarterPack': 'StarterPack',
        'Lighting': 'Lighting',
        'Workspace': 'Workspace'
    }
    
    project_tree = {"$className": "DataModel"}
    
    # Process each service in the DataModel
    services_to_process = [child for child in root_instance['Children'] if child['Name'] in rojo_services]
    total_services = len(services_to_process)
    services_processed = 0

    for child in services_to_process:
        service_name = child['Name']
        
        if service_name in rojo_services:
            service_dir = src_path / rojo_services[service_name]
            service_dir.mkdir(exist_ok=True)
            
            # Add to project.json tree
            project_tree[service_name] = {
                "$className": child['ClassName'],
                "$path": f"src/{rojo_services[service_name]}"
            }
            
            # Process service contents
            process_instance_rojo(child, service_dir)
            print(f"Exported {service_name}")

        services_processed += 1
        progress = 35 + int(60 * (services_processed / total_services))
        _report_progress(progress, f"Exporting service: {service_name}...")
    
    # Create default.project.json
    project_json_path = Path(output_dir) / "default.project.json"
    project_data = {
        "name": Path(output_dir).name,
        "tree": project_tree
    }
    # Try rendering with template
    if TEMPLATE_ENGINE_AVAILABLE:
        try:
            content = template_engine.render_template('default_project.json.j2', project_data)
            with open(project_json_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"📄 Created (templated): {project_json_path.name}")
        except Exception:
            with open(project_json_path, 'w', encoding='utf-8') as f:
                json.dump(project_data, f, indent=2)
            print(f"📄 Created: {project_json_path.name}")
    else:
        with open(project_json_path, 'w', encoding='utf-8') as f:
            json.dump(project_data, f, indent=2)
        print(f"📄 Created: {project_json_path.name}")

    print(f"Successfully created a Rojo-ready project at: {output_dir}")
    _report_progress(100, "Export complete!")
    print("--- Export Complete ---")

def process_instance_rojo(instance, parent_path):
    """
    Process an instance for Rojo export structure.
    """
    parent_path = Path(parent_path)
    
    for child in instance['Children']:
        child_name = sanitize_filename(child['Name'])
        
        if is_script_instance(child):
            # Export script file
            script_ext = get_script_extension(child['ClassName'])
            script_path = parent_path / f"{child_name}.{script_ext}"
            
            script_content = get_script_content(child)
            with open(script_path, "w", encoding='utf-8') as f:
                f.write(script_content)
            
            print(f"  Created script: {script_path}")
            
        elif child['Children']:  # Has children - create directory
            child_dir = parent_path / child_name
            child_dir.mkdir(exist_ok=True)
            
            # Create init.meta.json for the folder
            init_meta = child_dir / "init.meta.json"
            metadata = {
                "className": child['ClassName'],
                "properties": {k: v for k, v in child['Properties'].items() if k != 'Name'}
            }
            with open(init_meta, "w") as f:
                json.dump(metadata, f, indent=2)
            
            # Recursively process children
            process_instance_rojo(child, child_dir)
            print(f"  Created folder: {child_dir}")
            
        else:
            # Export other objects as metadata
            meta_path = parent_path / f"{child_name}.meta.json"
            metadata = {
                "className": child['ClassName'],
                "properties": child['Properties']
            }
            with open(meta_path, "w") as f:
                json.dump(metadata, f, indent=2)

def get_script_extension(class_name):
    """
    Get the appropriate file extension for a script type.
    """
    extensions = {
        'Script': 'server.lua',
        'LocalScript': 'client.lua',
        'ModuleScript': 'lua'
    }
    return extensions.get(class_name, 'lua')


def export_scripts_only(input_file, output_dir, create_project_json, template_dir=None):
    """
    Exports only the scripts from the .rbxl file to a single directory.
    """
    # If a custom template directory is provided, update template_engine loader
    if template_dir:
        template_engine.env.loader.searchpath = [template_dir]

    _report_progress(0, "Starting Scripts-Only export...")
    print(f"--- Starting Scripts-Only Export ---")
    print(f"Input file: {input_file}")
    print(f"Output directory: {output_dir}")
    print(f"Create default.project.json: {create_project_json}")

    # Convert .rbxl to .rbxlx (XML format)
    xml_file = convert_rbxl_to_xml(input_file)
    if xml_file is None:
        print("Error: Could not convert .rbxl to .rbxlx (XML) format")
        return

    # Parse the XML and extract the instance tree
    _report_progress(20, "Parsing XML file...")
    root_instance = parse_roblox_xml(xml_file)
    _report_progress(35, "XML Parsed. Extracting scripts...")
    
    # For debugging: print the entire instance tree
    # import pprint
    # pprint.pprint(root_instance)

    os.makedirs(output_dir, exist_ok=True)
    
    # Recursively process instances and extract scripts
    scripts_found = []
    def find_scripts(instance):
        if is_script_instance(instance):
            scripts_found.append(instance)
        for child in instance['Children']:
            find_scripts(child)
    
    find_scripts(root_instance)
    
    total_scripts = len(scripts_found)
    scripts_processed = 0

    for instance in scripts_found:
        # For scripts, create a .lua file with the script content
        script_content = get_script_content(instance)
        script_name = f"{sanitize_filename(instance['Name'])}.lua"
        with open(os.path.join(output_dir, script_name), "w") as lua_file:
            lua_file.write(script_content)
        
        # Create a metadata file for the script
        metadata_name = f"{sanitize_filename(instance['Name'])}.meta.json"
        metadata_path = os.path.join(output_dir, metadata_name)
        metadata = {
            "Name": instance['Name'],
            "ClassName": instance['ClassName'],
            "Properties": instance['Properties']
        }
        with open(metadata_path, "w") as meta_file:
            json.dump(metadata, meta_file, indent=2)
        
        scripts_processed += 1
        progress = 35 + int(60 * (scripts_processed / total_scripts))
        _report_progress(progress, f"Exporting script: {instance['Name']}...")

    if create_project_json:
        project_json_path = os.path.join(output_dir, "default.project.json")
        project_data = {
            "name": "scripts-only-project",
            "tree": {
                "$className": "DataModel",
                "ServerScriptService": {
                    "$path": "src"
                }
            }
        }
        # Render using template if available
        if TEMPLATE_ENGINE_AVAILABLE:
            try:
                content = template_engine.render_template('default_project.json.j2', project_data)
                with open(project_json_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print("📄 Created (templated): default.project.json")
            except Exception:
                with open(project_json_path, "w", encoding='utf-8') as f:
                    json.dump(project_data, f, indent=2)
                print("📄 Created: default.project.json")
        else:
            with open(project_json_path, "w", encoding='utf-8') as f:
                json.dump(project_data, f, indent=2)
            print("📄 Created: default.project.json")

        print("Successfully created default.project.json.")

    print(f"Successfully exported scripts to: {output_dir}")
    _report_progress(100, "Export complete!")
    print("--- Export Complete ---")

def process_batch(input_dir, output_dir, mode, create_project_json=False):
    """
    Process a batch of .rbxl/.rbxlx files in a directory.
    Each file is exported into a subdirectory named after the file.
    """
    print(f"--- Starting batch export from directory: {input_dir} ---")
    for filename in os.listdir(input_dir):
        if not filename.lower().endswith(('.rbxl', '.rbxlx')):
            continue
        src_path = os.path.join(input_dir, filename)
        name_no_ext = os.path.splitext(filename)[0]
        dest_subdir = os.path.join(output_dir, name_no_ext)
        os.makedirs(dest_subdir, exist_ok=True)
        print(f"\nProcessing file: {filename}")
        if mode == "rojo":
            export_rojo_ready(src_path, dest_subdir)
        else:
            export_scripts_only(src_path, dest_subdir, create_project_json)
    print(f"--- Batch export complete. Results in: {output_dir} ---")


def main():
    """
    Main function to parse arguments and trigger the correct export mode.
    """
    parser = argparse.ArgumentParser(
        description="Lune: A command-line tool for converting .rbxl files."
    )
    
    parser.add_argument(
        "input", 
        help="The path to the input .rbxl file."
    )
    parser.add_argument(
        "output", 
        help="The path to the output directory."
    )
    parser.add_argument(
        "--mode", 
        choices=["rojo", "scripts-only"], 
        default="rojo",
        help="The export mode to use."
    )
    parser.add_argument(
        "--project-json",
        action="store_true",
        help="Generate a default.project.json file (used with --mode=scripts-only)."
    )
    parser.add_argument(
        "--templates",
        help="Path to custom Jinja2 templates directory",
        default=None
    )

    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)
        
    args = parser.parse_args()
    template_dir = args.templates

    # Basic validation
    if not os.path.exists(args.input):
        print(f"Error: Input path not found at '{args.input}'")
        sys.exit(1)

    # Batch processing if input is a directory
    if os.path.isdir(args.input):
        process_batch(args.input, args.output, args.mode, args.project_json)
        return

    if args.mode == "rojo":
        export_rojo_ready(args.input, args.output, template_dir)
    elif args.mode == "scripts-only":
        export_scripts_only(args.input, args.output, args.project_json, template_dir)

if __name__ == "__main__":
    main()
