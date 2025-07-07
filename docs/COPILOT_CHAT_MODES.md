# Chat Modes Configuration for Copilot

This file describes how to configure and use chat modes for Copilot in this workspace.

## Overview

Chat modes allow you to control Copilot's behavior and process tracking for different workflows. The process is defined in `.github/copilot-instructions.md/copilot-thought-logging.instructions.md` and consists of four phases:

1. Initialization
2. Planning
3. Execution
4. Summary

## How to Use

- To start a tracked Copilot process, follow the instructions in the `copilot-thought-logging.instructions.md` file.
- Each phase is executed in order and tracked in `Copilot-Processing.md` at the workspace root.
- You can edit the process or add notes in `Copilot-Processing.md` as needed.
- Remove `Copilot-Processing.md` when the process is complete to avoid committing it to the repository.

## Customization

- You may edit `.github/copilot-instructions.md/copilot-thought-logging.instructions.md` to change the process or add new chat modes.
- For new workflows, create additional instruction files in the same directory and reference them in your documentation.

## Enforcement

- Copilot will strictly follow the instructions in the active mode file.
- No phase skipping, combining, or verbose output is allowed.

---

For more details, see the instructions file or contact the project maintainer.
