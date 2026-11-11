# Changelog

All notable changes to this template. Format based on
[Keep a Changelog](https://keepachangelog.com); versions follow
[Semantic Versioning](https://semver.org).

## [0.2.0] - 2026-11-11

### Added
- Tests generated for optional components: Prefect flow (`tests/integration/test_flow.py`)
  and Evidently drift report (`tests/unit/test_drift.py`).
- CLI tests for `pipelines/run.py`.
- Coverage quality gate: tests fail below 85 % coverage.
- Dependabot in generated projects (uv, GitHub Actions, Docker base images; monthly).
- Template CI: matrix Python 3.12 / 3.13 × base / all components, pre-commit run on the
  generated project, Docker smoke test checks that the model is loaded, and a job that
  renders the previous tag and runs `copier update` to verify upgrades.
- `scripts/test_template.sh update` profile.

### Changed
- `httpx` → `httpx2` for FastAPI's TestClient (removes deprecation warning).
- MLflow model logged with an explicit signature (float features in, class
  probabilities out) and `predict_proba` as pyfunc method (removes integer-schema warning).

### Fixed
- `scripts/test_template.sh` is executable in git.

## [0.1.0] - 2026-11-11

### Added
- Copier-based template (`copier.yml`, `template/` subdirectory) with questions for
  name, package, Python version (3.12 / 3.13) and optional components.
- Walking-skeleton package organised by ML stage: data (ingest + pandera contracts),
  features (shared by training and serving), training (MLflow), evaluation
  (quality gate), serving (FastAPI), pipelines (CLI).
- Test suite: unit, data contracts, behavioural model tests (MFT / INV / DIR),
  integration (API + end-to-end pipeline), training-serving parity test.
- uv dependency groups (`dev`, `serving`, `training`, `notebooks`); multi-stage
  Docker image with serving dependencies only, non-root user and healthcheck.
- Poe the Poet task runner (cross-platform), ruff, pre-commit, GitHub Actions CI.
- Docs: MLOps blueprint, ADR template + ADR-0001, CLAUDE.md, notebooks guidelines.
- Optional components: DVC, dbt + DuckDB, Prefect, docker compose + MLflow server,
  Evidently drift reports.
- `.gitattributes` forcing LF line endings.

### Changed
- Replaced the previous flat template (empty placeholder files, `src/` without a
  package, single dependency list) with the structure above.
- `black` replaced by `ruff format`.
