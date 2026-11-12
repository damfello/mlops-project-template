# New MLOps Project – Setup Guide

Step-by-step guide to start a project from this template on **Ubuntu (WSL2)**.

## 0. Prerequisites (once per machine)

| Tool | Check | Install / fix |
|---|---|---|
| WSL2 + Ubuntu | `wsl -l -v` (PowerShell) → VERSION 2 | `wsl --install -d Ubuntu` |
| git + identity | `git config --global user.name` | `git config --global user.name "..."` and `user.email` |
| GitHub SSH key | `ssh -T git@github.com` → "Hi <user>!" | `ssh-keygen -t ed25519`, add `~/.ssh/id_ed25519.pub` to GitHub |
| uv | `uv --version` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` · update: `uv self update` |
| Docker | `docker run --rm hello-world` | Docker Desktop → Settings → Resources → WSL Integration → Ubuntu |
| VS Code | `code --version` (from Ubuntu) | Install VS Code on Windows + the **WSL** extension |

Work inside the Linux filesystem (`~/projects/...`), never in `/mnt/c/...` (slow).

## 1. Generate the project

```bash
cd ~/projects
uvx copier copy --trust gh:damfello/mlops-project-template <project-name>
```

Or without questions (defaults: no optional components, setup runs). Keep the
description short and quoted:

```bash
uvx copier copy --trust --defaults --data project_name="My Project" --data description="One-line description" gh:damfello/mlops-project-template my-project
```

Interactively, Copier asks for:

- **Name, slug, package** – the package name is used in imports (`from <package> import ...`).
- **Python version** – 3.13 unless a library requires 3.12.
- **Optional components** – enable only what the project needs *now*; the rest can be
  added later with `copier update` (see §6). Record each choice in an ADR.
- **Run setup now?** – keep **Yes**: it runs `git init`, `uv sync` (creates `.venv` and
  `uv.lock`), `pre-commit install` and the first commit for you.

## 2. Verify and open in VS Code

```bash
cd <project-name>
uv run poe check        # lint + tests: must be green
uv run poe pipeline     # optional: example pipeline end-to-end
code .
```

In VS Code:

- Bottom-left must show **WSL: Ubuntu**.
- `Ctrl+Shift+P` → **Python: Select Interpreter** → `.venv`.
- Notebooks: **Select Kernel** → Python Environments → `.venv` (no kernel registration needed).
- Extensions (install them "in WSL: Ubuntu"): Python, Ruff, Jupyter.

No need to activate the environment: `uv run <command>` always uses `.venv`.

## 3. Publish on GitHub

1. github.com → **New repository** → same name → **empty**
   (no README, no .gitignore, no license: the template already created them).
2. Then:

```bash
git remote add origin git@github.com:<user>/<project-name>.git
git push -u origin main
```

3. GitHub → **Actions**: the CI (lint, tests, Docker build) must be green.

## 4. Define the project

- `CLAUDE.md` → replace the **Project context** section (problem, users, data,
  success metrics, scope).
- `docs/adr/` → write `0002-...md` for the first real decision (copy `0000-adr-template.md`).
- Replace the example step by step, keeping tests green at every step:
  ingest → data contract → features → model → behavioural tests → API schema.

## 5. Daily workflow

```bash
git switch -c feat/<topic>     # one branch per change
uv add <package>               # add a dependency (pyproject + uv.lock)
uv add --group training <pkg>  # ...or into a group (dev, serving, training, notebooks)
uv run poe check               # before every commit (pre-commit also runs on commit)
git commit -m "feat: ..."      # conventional commits: feat, fix, docs, chore, refactor, test
git push -u origin feat/<topic>  # open a PR, merge when CI is green
uv run poe                     # list all tasks (serve, mlflow-ui, docker-build, ...)
```

## 6. Keep the project up to date with the template

```bash
uvx copier update --trust                         # to the latest template tag
uvx copier update --trust --data use_prefect=true # enable a component later
git diff                                          # review; resolve conflicts if any
uv sync && uv run poe check
git commit -am "chore: update from template vX.Y.Z"
```

## Troubleshooting

| Problem | Fix |
|---|---|
| `uv sync --locked` fails in CI | `uv lock` locally and commit `uv.lock` |
| pre-commit modified files and the commit stopped | `git add -A` and commit again |
| `docker: command not found` in Ubuntu | Enable WSL integration in Docker Desktop |
| Everything shows as modified on Windows | Line endings: `.gitattributes` handles it; work in WSL |
| `ERROR: git has no identity` during `copier copy` | Copier removed the half-created project. Set `user.name` and `user.email` (§0) and run `copier copy` again |
| Project created with setup = No (no `.git`, no `.venv`) | Run the setup manually: `git init -b main && uv sync && uv run pre-commit install && git add -A && git commit -m "chore: scaffold from mlops-project-template"` |
