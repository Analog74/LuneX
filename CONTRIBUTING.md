# Contributing to Framework74

Welcome! This guide will help you get started with contributing to the Framework74 system.

## Repository Structure
- All code, assets, and documentation are organized by purpose (see `docs/FRAMEWORK74_STRUCTURE.md`).
- Never create files in the root; always use a relevant subfolder.

## Adding Assets, Scripts, or Modules
1. Place new assets in the appropriate `/assets/` subfolder and update `/database/project-metadata.json` (use `scripts/auto_index_metadata.py`).
2. Add new scripts to `/scripts/` or tag directories as appropriate.
3. For new frameworks or modules, use `/frameworks/<your-module>/`.
4. Document your addition in the relevant `README.md` or doc file.

## Quality and Integrity
- After any major change, run `scripts/post_update_check.sh` to validate structure and log metadata changes.
- Use the integrity test (`tests/test_framework74_integrity.py`) to check for missing directories or invalid metadata.

## Documentation
- See `docs/AI_INTEGRATION.md`, `ASSET_MANAGEMENT.md`, and `CREATIVE_JOURNEY.md` for best practices.
- All new systems and integration points should be documented.

## Collaboration
- Use tags to mark scripts as open-source or restricted.
- Add entries to the creative journey log for major milestones or inspiration.

Thank you for helping build a modular, secure, and future-ready system!
