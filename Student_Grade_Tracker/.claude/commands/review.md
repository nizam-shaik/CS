---
description: Full code review using reviewer agent. Fresh context. Reports issues only — never fixes. Run after every feature.
allowed-tools: Read, Grep, Glob, Bash
---
Use the reviewer agent for a full review of src/

Steps:
1. Run: pytest src/tests/ -v
2. Capture test results
3. Read all files in src/
4. Check against review checklist in CLAUDE.md
5. Save findings to docs/REVIEW.md

Checklist:
- Type hints on all functions
- No bare except blocks
- No DB calls in routers
- Services layer respected
- Docstrings present
- Tests exist for every endpoint

Severity: HIGH / MEDIUM / LOW
Never fix. Report only.