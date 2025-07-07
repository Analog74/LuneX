# Copilot Chat Modes

This file describes how to configure and use Copilot chat modes for process tracking and workflow customization in this project.

## Available Chat Modes

### 1. Thought Logging Mode
- Defined in `.github/copilot-instructions.md/copilot-thought-logging.instructions.md`
- Four-phase process: Initialization, Planning, Execution, Summary
- Tracks all actions in `Copilot-Processing.md`
- Strict enforcement: no phase skipping, combining, or verbose output

## How to Switch Modes

- To use a mode, reference its instruction file in your request or workflow.
- You may add new instruction files in `.github/copilot-instructions.md/` for additional modes.
- Edit or extend the instruction files to customize behavior.

## Best Practices

- Remove `Copilot-Processing.md` after process completion to avoid committing it.
- Review and update instruction files as your workflow evolves.

---

For more details, see the instruction files in `.github/copilot-instructions.md/`.
