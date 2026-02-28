---
applyTo: "**/*.py"
---

## Python Coding Standard

- Follow the PEP 8 style guide for Python.
- Always prioritize readability and clarity.
- Ensure functions have descriptive names and include type hints.
- Maintain proper indentation (use 4 spaces for each level of indentation).
- Target the "ruff" linter, the "ty" typechecker and the "uv" package manager.
- Prefer `pathlib` over `os.path` for file system operations.
- Use `typing` module for generics (e.g. `List`, `Dict`) to maintain compatibility with older Python versions.
