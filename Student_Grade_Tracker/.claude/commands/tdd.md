---
description: Implement next pending task from docs/PLAN.md using strict TDD. Failing test first, then implement. One task at a time.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: "[task number or task name]"
---
Use the builder agent to implement: $ARGUMENTS

Strict order — no skipping:
1. Read docs/PLAN.md
2. Find the task: $ARGUMENTS
3. Write FAILING pytest test first
4. Run: pytest src/tests/ -v
5. Confirm it FAILS ❌
6. Write minimum code to pass
7. Run: pytest src/tests/ -v
8. Confirm it PASSES ✅
9. Run: black src/ && isort src/
10. Mark task done in docs/PLAN.md

Stop if tests cannot be made to pass.
Never skip the failing test step.