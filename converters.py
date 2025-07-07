import os
import subprocess
import platform


def _try_external_converters(rbxl_path):
    """Try to use external command-line converters."""
    rbx_util_path = os.path.join(os.path.dirname(__file__), "external-tools", "rojo-ecosystem", "rbx-dom", "target", "release", "rbx-util")
    if os.path.exists(rbx_util_path):
        xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
        result = subprocess.run([rbx_util_path, 'convert', rbxl_path, xml_path], capture_output=True, text=True, timeout=120)
        if result.returncode == 0 and os.path.exists(xml_path):
            return xml_path
    # Fallback system converters
    converters = [
        ('rbx-util', ['convert', rbxl_path]),
        ('rbxlx-to-rojo', [rbxl_path]),
        ('rojo', ['rbxl-to-rbxlx', rbxl_path]),
    ]
    for name, args in converters:
        try:
            help_res = subprocess.run([name, '--help'], capture_output=True, text=True, timeout=5)
            if help_res.returncode == 0:
                xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
                full_args = [name] + args + ([xml_path] if name != 'rbxlx-to-rojo' else [])
                result = subprocess.run(full_args, capture_output=True, text=True, timeout=60)
                if result.returncode == 0 and os.path.exists(xml_path):
                    return xml_path
        except Exception:
            continue
    return None


def _show_conversion_help(rbxl_path):
    print("\n" + "="*70)
    print("🔧 BINARY .RBXL CONVERSION REQUIRED")
    print("="*70)
    print("Your file is binary; please convert it to .rbxlx using one of these options:")
    print("1. Use Roblox Studio: File -> Publish to Roblox As... -> Save as .rbxlx")
    print("2. Install rbx-util: cargo install rbx-binary-to-xml")
    print(f"   File: {rbxl_path}")
    print("="*70)


def _try_python_conversion(rbxl_path):
    """Try Python-based conversion libraries."""
    try:
        import roblox_py
        with open(rbxl_path, 'rb') as f:
            data = f.read()
        dom = roblox_py.from_binary(data)
        xml = roblox_py.to_xml(dom)
        xml_path = rbxl_path.replace('.rbxl', '_converted.rbxlx')
        with open(xml_path, 'w', encoding='utf-8') as f:
            f.write(xml)
        return xml_path
    except ImportError:
        return None
    except Exception:
        return None

# Expose functions
__all__ = [
    '_try_external_converters',
    '_show_conversion_help',
    '_try_python_conversion',
]
