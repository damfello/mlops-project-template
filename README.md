# mlops-project-template

My standard [Copier](https://copier.readthedocs.io) template for MLOps projects:
a runnable **walking skeleton** (data → validation → features → training →
evaluation → API) with testing, CI, Docker and experiment tracking from day one,
plus optional components you switch on as the project grows.

Engineering standards: [`template/docs/mlops_blueprint.md`](template/docs/mlops_blueprint.md)

## Create a project

Requirements: [uv](https://docs.astral.sh/uv/getting-started/installation/) and git.

```bash
uvx copier copy --trust gh:damfello/mlops-project-template my-project
```

Copier asks for the project name, Python version and which optional components
to enable, then prints the next steps.

## Update an existing project

```bash
cd my-project
uvx copier update --trust          # applies template changes since the project's version
git diff                           # review, resolve conflicts, run `uv run poe check`, commit
```

Enable a component later, e.g. Prefect:

```bash
uvx copier update --trust --data use_prefect=true
```

## What you get

| Base (always)                                   | Optional (ask at creation / update)          |
|-------------------------------------------------|----------------------------------------------|
| `src/` package organised by ML stage            | **DVC** – data & pipeline versioning         |
| Pydantic config (YAML + env vars)               | **dbt + DuckDB** – SQL transformations/tests |
| Data contracts (pandera)                        | **Prefect** – orchestration & scheduling     |
| Tests: unit / data / model (MFT·INV·DIR) / integration | **docker compose** – API + MLflow server |
| MLflow tracking (local SQLite)                  | **Evidently** – data drift reports           |
| FastAPI serving + multi-stage Docker image      |                                              |
| ruff, pytest, pre-commit, Poe tasks             |                                              |
| GitHub Actions CI (lint, tests, Docker build) + Dependabot |                                              |
| ADRs, CLAUDE.md, MLOps blueprint                |                                              |

## Repository layout

```
├── copier.yml                 # questions + template settings
├── template/                  # the files rendered into each project (*.jinja are templated)
├── scripts/test_template.sh   # render + verify a project (base | all)
├── .github/workflows/         # CI for the template itself
└── CHANGELOG.md
```

## Developing the template

```bash
scripts/test_template.sh base     # render with defaults: pre-commit, lint, tests, pipeline
scripts/test_template.sh all      # same with every optional component
scripts/test_template.sh update   # render the previous tag and `copier update` to HEAD
PYTHON=3.12 scripts/test_template.sh base   # another Python version
```

Release process (semantic versioning — projects update to tags):

1. Update `CHANGELOG.md`.
2. Commit, then `git tag vX.Y.Z && git push --tags`.
   - **MAJOR**: breaking changes for existing projects (e.g. moved files)
   - **MINOR**: new features or optional components
   - **PATCH**: fixes
