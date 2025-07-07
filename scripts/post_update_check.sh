#!/bin/zsh
# Post-update check for Framework74
python3 tests/test_framework74_integrity.py || exit 1
python3 scripts/metadata_changelog.py
