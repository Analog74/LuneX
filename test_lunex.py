#!/usr/bin/env python3

# Test script to verify LuneX setup
import sys
import os

print("=== LuneX Test Suite ===")
print(f"Python version: {sys.version}")
print(f"Working directory: {os.getcwd()}")

# Test if Lune.py exists
if os.path.exists("Lune.py"):
    print("✓ Lune.py found")
else:
    print("✗ Lune.py not found")

# Test if LuneX.py exists  
if os.path.exists("LuneX.py"):
    print("✓ LuneX.py found")
else:
    print("✗ LuneX.py not found")

# Test Lune.py command line
print("\n=== Testing Lune.py command line ===")
try:
    import subprocess
    result = subprocess.run([sys.executable, "Lune.py"], capture_output=True, text=True)
    if "usage:" in result.stderr.lower() or "usage:" in result.stdout.lower():
        print("✓ Lune.py command line working")
    else:
        print("✗ Lune.py command line issue")
        print("STDOUT:", result.stdout)
        print("STDERR:", result.stderr)
except Exception as e:
    print(f"✗ Error testing Lune.py: {e}")

# Test tkinter
print("\n=== Testing tkinter ===")
try:
    import tkinter as tk
    print("✓ tkinter imported successfully")
    
    # Try creating a basic window (don't show it)
    root = tk.Tk()
    root.withdraw()  # Hide the window
    print("✓ tkinter window creation works")
    root.destroy()
    
except ImportError as e:
    print(f"✗ tkinter import failed: {e}")

# Test binary .rbxl detection and conversion
print("\n=== Testing Binary .rbxl Support ===")
try:
    # Import the conversion function
    sys.path.insert(0, os.getcwd())
    from Lune import convert_rbxl_to_xml
    
    # Test with our sample binary file
    rbxl_file = "samples/MagicMaster.rbxl"
    if os.path.exists(rbxl_file):
        print(f"✓ Found test binary file: {rbxl_file}")
        
        # Test conversion
        print("Testing binary detection and conversion...")
        converted = convert_rbxl_to_xml(rbxl_file)
        
        if converted and os.path.exists(converted):
            print(f"✓ Successfully converted to: {os.path.basename(converted)}")
            
            # Verify the output is valid XML
            try:
                import xml.etree.ElementTree as ET
                tree = ET.parse(converted)
                root = tree.getroot()
                if root.tag == "roblox":
                    print("✓ Generated valid Roblox XML format")
                else:
                    print(f"✗ Unexpected XML root tag: {root.tag}")
            except Exception as e:
                print(f"✗ Invalid XML generated: {e}")
                
        else:
            print("✗ Binary conversion failed")
    else:
        print("✗ No test binary file found at samples/MagicMaster.rbxl")
        
except Exception as e:
    print(f"✗ Error testing binary support: {e}")

# Test external tools availability
print("\n=== Testing External Tools ===")
try:
    import subprocess
    rbx_util_path = "external-tools/rojo-ecosystem/rbx-dom/target/release/rbx-util"
    if os.path.exists(rbx_util_path):
        print("✓ rbx-util binary found")
        try:
            result = subprocess.run([rbx_util_path, "--help"], capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print("✓ rbx-util is functional")
            else:
                print("✗ rbx-util returned error")
        except Exception as e:
            print(f"✗ Error testing rbx-util: {e}")
    else:
        print("✗ rbx-util binary not found")

    rbxlx_to_rojo_path = "external-tools/rojo-ecosystem/rbxlx-to-rojo/target/release/rbxlx-to-rojo"
    if os.path.exists(rbxlx_to_rojo_path):
        print("✓ rbxlx-to-rojo binary found")
    else:
        print("✗ rbxlx-to-rojo binary not found")
except Exception as e:
    print(f"✗ Error testing external tools: {e}")

# Test metadata preservation via parse_instance
print("\n=== Testing Metadata Preservation ===")
try:
    import xml.etree.ElementTree as ET
    from Lune import parse_instance
    
    # Create a test XML element with various property types
    xml_str = '''
    <Item class="Part" name="TestPart">
      <Properties>
        <Vector3 name="Position">1,2,3</Vector3>
        <Vector2 name="Size">4,5</Vector2>
        <Color3 name="BrickColor">0.1,0.2,0.3</Color3>
        <CFrame name="Orientation">1,0,0,0,1,0,0,0,1</CFrame>
        <UDim name="AnchorPoint">0.5,10</UDim>
        <UDim2 name="ScaleSize">
          <UDim name="X">1,20</UDim>
          <UDim name="Y">0.2,40</UDim>
        </UDim2>
        <string name="Name">Example</string>
      </Properties>
    </Item>
    '''
    elem = ET.fromstring(xml_str)
    inst = parse_instance(elem)
    props = inst['Properties']
    # Validate parsing
    assert props['Position'] == [1.0, 2.0, 3.0], f"Position parsed incorrectly: {props['Position']}"
    assert props['Size'] == [4.0, 5.0], f"Size parsed incorrectly: {props['Size']}"
    assert all(isinstance(c, float) for c in props['BrickColor']), "BrickColor values not float"
    assert props['BrickColor'] == [0.1, 0.2, 0.3], f"BrickColor parsed incorrectly: {props['BrickColor']}"
    assert isinstance(props['Orientation'], list) and len(props['Orientation']) == 9, "CFrame parsed incorrectly"
    assert props['AnchorPoint']['scale'] == 0.5 and props['AnchorPoint']['offset'] == 10, "UDim parsed incorrectly"
    assert 'X' in props['ScaleSize'] and props['ScaleSize']['X']['offset'] == 20, "UDim2 X parsed incorrectly"
    assert props['Name'] == 'Example', "String property parsed incorrectly"
    print("✓ Metadata preservation parsing works correctly")
except AssertionError as ae:
    print(f"✗ Metadata preservation assertion failed: {ae}")
except Exception as e:
    print(f"✗ Error testing metadata preservation: {e}")

print("\n=== Test Complete ===")
