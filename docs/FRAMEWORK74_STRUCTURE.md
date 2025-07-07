# Framework74 Repository Structure Proposal

## Overview
This document proposes a modular, scalable, and AI-ready folder structure for the Framework74 system, supporting:
- Third-party libraries/tools (cross-platform)
- Native scripts, modules, frameworks
- Asset/media management
- AI systems, custom prompts, chat modes, instructions
- Database/JSON usage for GUIs/utilities reference
- Documentation and journey tracking

## Proposed Structure

```
/ai/
  /awesome-copilot/           # Cloned Copilot customizations
  /custom-prompts/            # Your own reusable prompts
  /chat-modes/                # Custom chat modes for AI
  /instructions/              # Custom instructions for Copilot/AI
  /logs/                      # AI usage logs, chat transcripts, etc.
  /agents/                    # Custom AI agent scripts/configs

/assets/
  /media/                     # Images, graphics, audio, video
  /3d/                        # 3D models, meshes, textures
  /gui/                       # GUI assets, templates, components
  /tutorials/                 # Video, markdown, or code tutorials
  /social/                    # Social media, branding, marketing
  /project-specific/          # Per-project asset folders

/database/
  /gui-solutions.json         # Reference DB for GUIs/utilities
  /best-practices.json        # Catalog of known solutions/methods
  /project-metadata.json      # Project journey, tracking, tags

/docs/
  FRAMEWORK74_STRUCTURE.md    # This file
  AI_INTEGRATION.md           # How AI is used, tracked, extended
  ASSET_MANAGEMENT.md         # Asset storage, tagging, referencing
  CREATIVE_JOURNEY.md         # Project journey, inspiration, ideas
  ...                         # Other documentation

/external-tools/              # Third-party libraries/tools
  /<tool-or-lib>/             # Each tool/library in its own folder

/frameworks/                  # Native frameworks, modules, templates
  /<framework-name>/

/scripts/                     # Utility scripts, helpers

/src/                         # Main source code

/tests/                       # Test suites

/tags/
  /open-source/               # Scripts/utilities safe to open source
  /restricted/                # Internal/restricted scripts
```

## Notes
- Never create files in the root; always use a relevant subfolder.
- Tag scripts/utilities for open-source or restricted use in `/tags/`.
- Store all AI, chat, and prompt customizations in `/ai/`.
- Use `/database/` for JSON catalogs and references.
- Expand `/assets/` and `/docs/` as creative needs grow.
- Document all new systems and integration points.

---

This structure is designed for modularity, security, and future expansion, supporting both AI-driven and traditional workflows.
