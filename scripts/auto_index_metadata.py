"""
Auto Index Metadata Script for Framework74
Scans assets and tagged scripts, updates /database/project-metadata.json
"""
import os
import json

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(ROOT, 'assets')
TAGS_DIR = os.path.join(ROOT, 'tags')
DB_PATH = os.path.join(ROOT, 'database', 'project-metadata.json')

metadata = {"assets": [], "scripts": []}

# Index assets
def index_assets():
    for subdir, _, files in os.walk(ASSETS_DIR):
        for file in files:
            rel_path = os.path.relpath(os.path.join(subdir, file), ROOT)
            asset_type = os.path.basename(subdir)
            metadata["assets"].append({
                "path": f"/{rel_path}",
                "type": asset_type,
                "tags": [],
                "used_by": [],
                "notes": ""
            })

# Index tagged scripts
def index_scripts():
    for tag_type in ['open-source', 'restricted']:
        tag_path = os.path.join(TAGS_DIR, tag_type)
        if not os.path.exists(tag_path):
            continue
        for file in os.listdir(tag_path):
            if file.endswith('.py'):
                rel_path = os.path.relpath(os.path.join(tag_path, file), ROOT)
                metadata["scripts"].append({
                    "path": f"/{rel_path}",
                    "tag": tag_type,
                    "notes": ""
                })

index_assets()
index_scripts()

# Write to project-metadata.json
with open(DB_PATH, 'w') as f:
    json.dump(metadata, f, indent=2)

print("Metadata index updated.")
