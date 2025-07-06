# 📋 Project Standards - LuneProjects

## 🎯 Repository Organization

### Directory Structure
```
LuneProjects/                          # Main Repository Root
├── Utilities/                         # Development Tools
│   ├── LuneX/                        # Roblox Export Tool
│   ├── [ToolName]/                   # Other utilities
│   └── shared/                       # Shared utility code
├── Games/                            # Game Projects  
│   ├── [GameName]/                   # Individual games
│   └── templates/                    # Game templates
├── Libraries/                        # Reusable Libraries
│   ├── [LibraryName]/               # Individual libraries
│   └── shared/                       # Shared library code
├── Templates/                        # Project Templates
│   ├── utility-templates/
│   ├── game-templates/
│   └── library-templates/
└── docs/                            # Repository Documentation
    ├── CATALOG.md                   # Project catalog
    ├── DEVELOPMENT_LOG.md           # Development tracking
    ├── PROJECT_STANDARDS.md         # This file
    └── [project]/                   # Project-specific docs
```

### Naming Conventions

#### Projects
- **PascalCase** for project names: `LuneX`, `MagicMaster`
- **kebab-case** for directories: `magic-master/`, `lune-x/`
- **Descriptive names** that indicate purpose

#### Files
- **snake_case** for Python files: `lune_x.py`, `test_suite.py`
- **PascalCase** for main executables: `LuneX.py`, `Lune.py`
- **UPPERCASE** for documentation: `README.md`, `CHANGELOG.md`

#### Versioning
- **Semantic Versioning**: `v{major}.{minor}.{patch}`
- **Development tags**: `dev-{feature-name}`
- **Experimental tags**: `exp-{experiment-name}`

## 🏷️ Tagging & Classification System

### Project Types
- `utility-*` - Development tools and utilities
- `game-*` - Game projects and demos
- `library-*` - Reusable code libraries
- `template-*` - Project templates and boilerplates

### Status Classifications
| Status | Emoji | Description |
|--------|-------|-------------|
| Complete | ✅ | Finished, documented, ready for use |
| Active | 🔄 | Currently in development |
| Paused | ⏸️ | Temporarily on hold |
| Experimental | 🧪 | Testing new concepts |
| Archived | 📦 | No longer maintained |
| Planning | 📋 | In planning phase |

### Priority Levels
- **P1**: Critical features or fixes
- **P2**: Important enhancements
- **P3**: Nice-to-have features
- **P4**: Future considerations

## 📝 Documentation Standards

### Required Documentation
Each project must include:
1. **README.md** - Project overview, usage, installation
2. **CHANGELOG.md** - Version history and changes
3. **docs/** directory with detailed documentation
4. Inline code comments for complex logic

### README Template
```markdown
# Project Name

Brief description of what the project does.

## Features
- Feature 1
- Feature 2

## Quick Start
Installation and basic usage instructions.

## Documentation
Link to detailed documentation.

## Status
Current development status and version.
```

### Changelog Format
```markdown
# Changelog

## [Version] - Date
### Added
- New features

### Changed  
- Changes to existing features

### Fixed
- Bug fixes

### Removed
- Removed features
```

## 💻 Code Standards

### Python Projects
- **PEP 8** style guidelines
- **Type hints** where beneficial
- **Docstrings** for all functions and classes
- **Error handling** with meaningful messages
- **Configuration files** in JSON or YAML format

### Lua Projects (Roblox)
- **CamelCase** for functions and variables
- **PascalCase** for classes/modules
- **Indentation**: 4 spaces (or 1 tab)
- **Comments** for complex logic

### File Organization
```python
# Standard Python file structure
"""
Module docstring explaining purpose.
"""

# Standard library imports
import os
import sys

# Third-party imports
import requests

# Local imports
from .utils import helper_function

# Constants
DEFAULT_CONFIG = "config.json"

# Classes
class ExampleClass:
    """Class docstring."""
    pass

# Functions
def main_function():
    """Function docstring."""
    pass

# Main execution
if __name__ == "__main__":
    main_function()
```

## 🔄 Development Workflow

### Branch Strategy
- **main** - Stable, production-ready code
- **develop** - Integration branch for new features
- **feature/feature-name** - Individual feature development
- **hotfix/issue-name** - Critical bug fixes

### Commit Messages
```
type(scope): brief description

Detailed description if needed.

Fixes #issue-number
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Release Process
1. Complete feature development
2. Update documentation
3. Update CHANGELOG.md
4. Tag release version
5. Update project catalog

## 🧪 Testing Standards

### Required Testing
- **Unit tests** for core functionality
- **Integration tests** for key workflows
- **Manual testing** checklist
- **Cross-platform testing** where applicable

### Test Organization
```
tests/
├── unit/           # Unit tests
├── integration/    # Integration tests
├── fixtures/       # Test data
└── README.md       # Testing documentation
```

## 📊 Progress Tracking

### Development Log Updates
- Daily progress updates for active projects
- Weekly summary reports
- Monthly milestone reviews
- Quarterly roadmap updates

### Metrics Tracking
- Lines of code
- Features completed
- Bugs fixed
- Documentation coverage
- Test coverage

### Issue Management
- GitHub Issues for bug tracking
- Project boards for sprint planning
- Milestone tracking for releases
- Labels for categorization

## 🔧 Tool Integration

### Development Tools
- **VS Code** - Primary IDE
- **Git** - Version control
- **Python** - Primary language for utilities
- **Rojo** - Roblox development sync

### Documentation Tools
- **Markdown** - All documentation
- **GitHub Pages** - Documentation hosting
- **Mermaid** - Diagrams and flowcharts

### Quality Assurance
- **Linting** - Code quality checking
- **Formatting** - Consistent code style
- **Testing** - Automated test suites

---

**Document Version**: 1.0  
**Last Updated**: 2025-07-06  
**Next Review**: 2025-08-06
