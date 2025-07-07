# test_game74_integrity.py
# Integrity test suite for Game74

import os
import json

def test_asset_index():
    index_path = os.path.join(os.path.dirname(__file__), '../modules/asset_index/asset_index.json')
    assert os.path.exists(index_path), "Asset index missing!"
    with open(index_path) as f:
        data = json.load(f)
    assert "assets" in data, "Asset index missing 'assets' key!"
    assert isinstance(data["assets"], list), "Assets should be a list!"

def test_character_sheet():
    sheet_path = os.path.join(os.path.dirname(__file__), '../modules/character/CharacterSheet.json')
    assert os.path.exists(sheet_path), "CharacterSheet.json missing!"
    with open(sheet_path) as f:
        data = json.load(f)
    assert "Name" in data and "Level" in data, "CharacterSheet missing keys!"

test_asset_index()
test_character_sheet()
print("All Game74 integrity tests passed.")
