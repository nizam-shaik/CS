# Student Grade Tracker — Project Constitution

## Project Overview
A beginner-level REST API to manage students and their grades.
Built entirely by Claude via Agentic SDLC.
Zero business logic written by humans.

## Tech Stack
- **Runtime:** Python 3.11+
- **Framework:** FastAPI
- **Database:** SQLite via SQLAlchemy (sync)
- **Schemas:** Pydantic v2
- **Testing:** pytest + httpx
- **Formatting:** Black + isort
- **Server:** Uvicorn

## Project Structure
src/
├── main.py           ← FastAPI app entry point
├── database.py       ← SQLite connection + session
├── models.py         ← SQLAlchemy ORM models
├── schemas.py        ← Pydantic request/response
├── routers/
│   ├── students.py   ← student CRUD endpoints
│   └── grades.py     ← grade CRUD endpoints
├── services/
│   ├── students.py   ← student business logic
│   └── grades.py     ← grade business logic
└── tests/
├── test_students.py
└── test_grades.py

## Domain
- **Student:** id, name, email, created_at
- **Grade:** id, student_id, subject, score, created_at

## Build Commands
- Run server:   uvicorn src.main:app --reload
- Run tests:    pytest src/tests/ -v
- Format:       black src/ && isort src/
- Type check:   mypy src/
- Install:      pip install -r requirements.txt

## Coding Standards — NON NEGOTIABLE
1. ALL functions must have type hints
2. NO bare except — catch specific exceptions only
3. NO direct DB calls in routers — use services layer
4. EVERY endpoint must have a pytest test
5. EVERY function must have a docstring
6. Use Pydantic v2 BaseModel for all schemas
7. Return typed responses — never return raw dicts
8. One responsibility per function

## Agent Instructions
- Planner   → read only, produce docs/PLAN.md, no code
- Builder   → TDD strictly, one task at a time
- Reviewer  → fresh context, report only, never fix

## Git Conventions
- Commits: feat|fix|chore|test|docs: description
- Never commit broken tests
- One feature per commit