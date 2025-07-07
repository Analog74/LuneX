"""
Metadata Changelog Script for Framework74
Appends a changelog entry every time project-metadata.json is changed.
"""
import os
import json
from datetime import datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(ROOT, 'database', 'project-metadata.json')
CHANGELOG_PATH = os.path.join(ROOT, 'database', 'project-metadata-changelog.log')

# Read current metadata
with open(DB_PATH, 'r') as f:
    metadata = f.read()

entry = {
    'timestamp': datetime.utcnow().isoformat(),
    'user': os.getenv('USER', 'unknown'),
    'summary': 'project-metadata.json updated',
    'content': metadata[:500] + ('...' if len(metadata) > 500 else '')
}

with open(CHANGELOG_PATH, 'a') as log:
    log.write(json.dumps(entry) + '\n')

print("Changelog entry added.")
