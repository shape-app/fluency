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

### Xcode Templates

To install project-specific templates with correct copyright headers:

```bash
python3 scripts/install_xcode_templates.py
```

After installation, new Swift files created in Xcode will automatically include the proper copyright notice.
