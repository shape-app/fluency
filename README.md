# Fluency

WIP

## Development Setup

### Pre-commit Hooks

This project uses pre-commit to automatically format code before commits.

**Setup:**
```bash
pip install pre-commit
pre-commit install
```

**What it does:**
- Formats Swift code with SwiftLint
- Fixes trailing whitespace and file endings
- Validates YAML/JSON files
- Checks for merge conflicts

**Manual run:**
```bash
pre-commit run --all-files
```