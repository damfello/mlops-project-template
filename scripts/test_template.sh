#!/usr/bin/env bash
# Render the template and verify the generated project works.
#
#   scripts/test_template.sh             # defaults (base components only)
#   scripts/test_template.sh all         # every optional component enabled
#   scripts/test_template.sh update      # render the previous tag, then `copier update` to HEAD
#
# Env vars: OUT_DIR (where to render), PYTHON (3.12 | 3.13, default 3.13)
# Used locally and by .github/workflows/template-ci.yml (same commands).
set -euo pipefail

PROFILE="${1:-base}"
PYTHON="${PYTHON:-3.13}"
TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$(mktemp -d)}/demo-${PROFILE}-py${PYTHON/./}"

if [[ -e "$OUT_DIR" ]]; then
  echo ">> ${OUT_DIR} already exists; remove it or set another OUT_DIR"; exit 1
fi

COMMON=(--trust --defaults --data python_version="$PYTHON")
OPTIONAL=()
if [[ "$PROFILE" == "all" ]]; then
  OPTIONAL=(--data use_dvc=true --data use_dbt=true --data use_prefect=true
            --data use_compose=true --data use_monitoring=true)
fi

commit_all() {
  git add -A
  git -c user.email=ci@example.com -c user.name=ci commit -qm "$1" --no-verify
}

if [[ "$PROFILE" == "update" ]]; then
  PREVIOUS_TAG="$(git -C "$TEMPLATE_DIR" describe --tags --abbrev=0 HEAD^ 2>/dev/null || true)"
  if [[ -z "$PREVIOUS_TAG" ]]; then
    echo ">> No previous tag found: nothing to update from. Skipping."
    exit 0
  fi
  echo ">> Rendering ${PREVIOUS_TAG}, then updating to HEAD"
  uvx copier copy "${COMMON[@]}" --vcs-ref="$PREVIOUS_TAG" \
    --data project_name="Demo update" "$TEMPLATE_DIR" "$OUT_DIR"
  cd "$OUT_DIR" && git init -q -b main && commit_all "scaffold ${PREVIOUS_TAG}"
  uvx copier update "${COMMON[@]}" --vcs-ref=HEAD --conflict=inline
  if grep -rIl --exclude-dir=.git '^<<<<<<< ' . ; then
    echo ">> Update produced conflicts"; exit 1
  fi
  git add -A
else
  echo ">> Rendering template (${PROFILE}, Python ${PYTHON}) into ${OUT_DIR}"
  uvx copier copy "${COMMON[@]}" --vcs-ref=HEAD \
    --data project_name="Demo ${PROFILE}" "${OPTIONAL[@]}" \
    "$TEMPLATE_DIR" "$OUT_DIR"
  cd "$OUT_DIR" && git init -q -b main && git add -A
fi

echo ">> Installing"
uv sync

echo ">> Pre-commit hooks (format, lint, lockfile, notebooks...)"
uv run pre-commit run --all-files

echo ">> Lint + tests"
uv run poe check

echo ">> End-to-end pipeline"
uv run poe pipeline

if [[ "$PROFILE" == "all" ]]; then
  echo ">> Optional components"
  uv run poe dbt-build
  uv run poe drift
  uv run poe flow
  commit_all init
  uv run dvc repro
fi

echo ">> OK: ${OUT_DIR}"
