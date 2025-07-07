"""
Framework74 Integrity Test Suite
Checks directory structure, metadata validity, and tagging.
"""
import os
import json
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REQUIRED_DIRS = [
    'ai/awesome-copilot', 'ai/custom-prompts', 'ai/chat-modes', 'ai/instructions', 'ai/logs', 'ai/agents',
    'assets/media', 'assets/3d', 'assets/gui', 'assets/tutorials', 'assets/social', 'assets/project-specific',
    'database', 'docs', 'external-tools', 'frameworks', 'scripts', 'src', 'tests', 'tags/open-source', 'tags/restricted'
]
REQUIRED_JSON = [
    'database/gui-solutions.json',
    'database/best-practices.json',
    'database/project-metadata.json'
]
REQUIRED_TAGS = [
    'tags/open-source',
    'tags/restricted'
]

def check_dirs():
    missing = []
    for d in REQUIRED_DIRS:
        if not os.path.isdir(os.path.join(ROOT, d)):
            missing.append(d)
    return missing

def check_json():
    invalid = []
    for f in REQUIRED_JSON:
        path = os.path.join(ROOT, f)
        try:
            with open(path) as jf:
                json.load(jf)
        except Exception:
            invalid.append(f)
    return invalid

def check_tags():
    empty = []
    for d in REQUIRED_TAGS:
        tag_dir = os.path.join(ROOT, d)
        if not any(f.endswith('.py') for f in os.listdir(tag_dir)):
            empty.append(d)
    return empty

def main():
    errors = False
    missing_dirs = check_dirs()
    if missing_dirs:
        print('Missing directories:', missing_dirs)
        errors = True
    invalid_json = check_json()
    if invalid_json:
        print('Invalid JSON files:', invalid_json)
        errors = True
    empty_tags = check_tags()
    if empty_tags:
        print('No scripts found in tag directories:', empty_tags)
        errors = True
    if not errors:
        print('Framework74 structure and metadata integrity: OK')
    sys.exit(1 if errors else 0)

if __name__ == '__main__':
    main()
