#!/usr/bin/env python3
"""
Script: update_copilot_instructions_index.py

Scans the .github/copilot-instructions.md directory for all .instructions.md files and updates copilot-instructions-index.md with their titles and descriptions.
"""
import os
import re
import yaml

INSTRUCTIONS_DIR = ".github/copilot-instructions.md"
INDEX_FILE = os.path.join(INSTRUCTIONS_DIR, "copilot-instructions-index.md")


def extract_yaml_frontmatter(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    match = re.match(r"---\n(.*?)---\n", content, re.DOTALL)
    if match:
        return yaml.safe_load(match.group(1))
    return {}

def main():
    files = [f for f in os.listdir(INSTRUCTIONS_DIR) if f.endswith(".instructions.md") and f != "copilot-instructions-index.md"]
    index_lines = [
        "# Copilot Chat Modes Index\n",
        "This file lists all available Copilot instruction files (chat modes) in the `.github/copilot-instructions.md/` directory. Each mode can be used to customize Copilot's behavior for different workflows.\n",
        "## Available Chat Modes\n"
    ]
    for filename in sorted(files):
        path = os.path.join(INSTRUCTIONS_DIR, filename)
        meta = extract_yaml_frontmatter(path)
        title = meta.get("title", filename)
        desc = meta.get("description", "No description provided.")
        index_lines.append(f"### {title}\n- **File:** {filename}\n- **Description:** {desc}\n")
    index_lines.append("---\n\nTo add a new chat mode, create a new `.instructions.md` file in this directory with a YAML frontmatter including a `description` and (optionally) a `title`. Reference this file when starting a Copilot process to use your custom mode.\n")
    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        f.writelines(line if line.endswith("\n") else line+"\n" for line in index_lines)
    print(f"Updated {INDEX_FILE} with {len(files)} chat modes.")

if __name__ == "__main__":
    main()
