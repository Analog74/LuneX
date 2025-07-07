# Roblox API Dump Integration

This project now includes integration with the official Roblox API Dump (`API-Dump.json`).

## Features
- Load and parse the full Roblox API dump
- Query classes, properties, functions, events, and tags
- Easily extend for documentation generation, code completion, or validation

## Usage

1. Place your `API-Dump.json` file in a known location (e.g., `/Users/analog/Downloads/API-Dump.json`).
2. Use the provided Python module to load and query the API dump:

```python
from library.roblox_api_dump import RobloxAPIDump
api = RobloxAPIDump('/Users/analog/Downloads/API-Dump.json')

# List all classes
print(api.list_classes())

# Get all members of a class
print(api.get_members('Instance'))

# Find a specific member
print(api.find_member('Instance', 'Name'))

# Find all deprecated members
deprecated = api.find_by_tag('Deprecated')
for class_name, member in deprecated:
    print(f"{class_name}: {member['Name']}")
```

## API Dump Documentation Generation

You can now auto-generate Markdown documentation for all Roblox classes and their members using the provided script:

```
python generate_roblox_api_docs.py /Users/analog/Downloads/API-Dump.json docs/ROBLOX_API_REFERENCE.md
```

This will create a browsable reference in `docs/ROBLOX_API_REFERENCE.md`.

See `generate_roblox_api_docs.py` for details and customization.

## Automation

- **Generate docs:**
  - `make docs` or run the VS Code task "Generate Roblox API Docs"
- **Test API integration:**
  - `make test` or run `python test_roblox_api_dump.py`

See `Makefile` for more automation options.

## Extending
- You can use this module to auto-generate documentation, validate scripts, or power editor tooling.
- For documentation generation, see the `docs/` folder for examples or extend this script to output Markdown/HTML.

---

For more details, see the source in `library/roblox_api_dump.py`.
