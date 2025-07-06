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

print("\n=== Test Complete ===")
