#!/bin/zsh
# post_update_check.sh - Run integrity and metadata checks after updates
python3 ../tests/test_game74_integrity.py
python3 ../scripts/auto_index_metadata.py
