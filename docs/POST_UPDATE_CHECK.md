# Post-Update Check Process (Framework74)

## Purpose
Automate integrity and changelog checks after any significant update to the project structure or metadata.

## How to Use
- Run `scripts/post_update_check.sh` after adding, removing, or editing assets, scripts, or metadata.
- The script will:
  1. Run the integrity test suite
  2. Log the current state of project-metadata.json
- If the integrity test fails, the script will stop and report errors.

## Best Practices
- Make this check part of your workflow for all major updates.
- Review the changelog and test output regularly.
