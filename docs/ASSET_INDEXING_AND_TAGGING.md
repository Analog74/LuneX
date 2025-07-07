# Asset Indexing & Tagging Guide (Framework74)

## Asset Indexing
- All assets (media, 3d, gui, etc.) should be referenced in a JSON index (e.g., `/database/project-metadata.json`).
- Each asset entry includes: path, type, tags, and usage notes.
- Example entry:
```json
{
  "path": "/assets/gui/sample_ui.png",
  "type": "gui",
  "tags": ["sample", "ui", "open-source"],
  "used_by": ["sample-game-system"],
  "notes": "Demo UI for prototype."
}
```

## Tagging Scripts/Utilities
- Place open-source safe scripts in `/tags/open-source/`.
- Place internal/restricted scripts in `/tags/restricted/`.
- Add a `tags` field in the script's metadata or header comment.
- Document all tagged scripts in `/database/project-metadata.json` for searchability.

## Continuous Improvement
- Regularly review and update asset and script tags.
- Expand tagging for new categories as needed.
