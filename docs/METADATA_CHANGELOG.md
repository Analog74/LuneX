# Metadata Changelog Process (Framework74)

## Purpose
Track all changes to `/database/project-metadata.json` for auditability and collaboration.

## How It Works
- Every time the metadata file is updated (manually or by script), run `scripts/metadata_changelog.py`.
- The script appends a timestamped entry to `/database/project-metadata-changelog.log`.
- Each entry includes a summary, user, and a snippet of the new content.

## Best Practices
- Always log changes after editing project-metadata.json.
- Review the changelog regularly for unexpected or manual edits.
- Use the changelog for debugging, audits, and team communication.
