# Changelog

All notable changes to this template. Format based on
[Keep a Changelog](https://keepachangelog.com); versions follow
[Semantic Versioning](https://semver.org).

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
