# auto_index_metadata.py
# Script to auto-index assets and scripts for Game74

import os
import json

INDEX_PATH = os.path.join(os.path.dirname(__file__), '../modules/asset_index/asset_index.json')
ASSETS_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../assets'))

index = {"assets": []}
for root, dirs, files in os.walk(ASSETS_ROOT):
    for file in files:
        rel_path = os.path.relpath(os.path.join(root, file), ASSETS_ROOT)
        ext = os.path.splitext(file)[1].lower()
        asset_type = "other"
        if ext in ['.fbx', '.obj', '.rbxm', '.rbxlx']:
            asset_type = "3d"
        elif ext in ['.png', '.jpg', '.jpeg', '.bmp']:
            asset_type = "gui"
        index["assets"].append({"id": file, "type": asset_type, "path": rel_path})

with open(INDEX_PATH, 'w') as f:
    json.dump(index, f, indent=2)
