"""
Script: generate_roblox_api_docs.py
Generates Markdown documentation for all Roblox classes and their members from the API dump.
"""
import sys
from pathlib import Path
from library.roblox_api_dump import RobloxAPIDump

def generate_docs(api_dump_path, output_path):
    api = RobloxAPIDump(api_dump_path)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(f"# Roblox API Reference\n\n")
        for class_name in sorted(api.list_classes()):
            cls = api.get_class(class_name)
            superclass = cls.get('Superclass', 'None')
            f.write(f"## {class_name}\n")
            f.write(f"**Superclass:** `{superclass}`\n\n")
            if 'Tags' in cls and cls['Tags']:
                f.write(f"**Tags:** {', '.join(cls['Tags'])}\n\n")
            members = api.get_members(class_name)
            if not members:
                f.write("_No members._\n\n")
                continue
            f.write("| Name | Type | Category | Tags |\n")
            f.write("|------|------|----------|------|\n")
            for member in members:
                name = member.get('Name', '-')
                mtype = member.get('MemberType', '-')
                cat = member.get('Category', '-')
                tags = ', '.join(member.get('Tags', []))
                f.write(f"| `{name}` | {mtype} | {cat} | {tags} |\n")
            f.write("\n")
    print(f"Documentation generated at {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_roblox_api_docs.py <API-Dump.json> <output.md>")
        sys.exit(1)
    generate_docs(sys.argv[1], sys.argv[2])
