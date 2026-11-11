#!/usr/bin/env bash
# Render the template and verify the generated project works.
#
#   scripts/test_template.sh            # defaults (base components only)
#   scripts/test_template.sh all        # every optional component enabled
#
# Used locally and by .github/workflows/template-ci.yml (same commands).
set -euo pipefail

PROFILE="${1:-base}"
TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$(mktemp -d)}/demo-${PROFILE}"

EXTRA=()
if [[ "$PROFILE" == "all" ]]; then
  EXTRA=(--data use_dvc=true --data use_dbt=true --data use_prefect=true
         --data use_compose=true --data use_monitoring=true)
fi

echo ">> Rendering template (${PROFILE}) into ${OUT_DIR}"
uvx copier copy --trust --defaults --vcs-ref=HEAD \
  --data project_name="Demo ${PROFILE}" "${EXTRA[@]}" \
  "$TEMPLATE_DIR" "$OUT_DIR"

cd "$OUT_DIR"
git init -q -b main
git add -A

echo ">> Installing"
uv sync

echo ">> Lint + tests"
uv run poe check

echo ">> End-to-end pipeline"
uv run poe pipeline

if [[ "$PROFILE" == "all" ]]; then
  echo ">> Optional components"
  uv run poe dbt-build
  uv run poe drift
  uv run poe flow
  git add -A && git -c user.email=ci@example.com -c user.name=ci commit -qm init
  uv run dvc repro
fi

echo ">> OK: ${OUT_DIR}"
