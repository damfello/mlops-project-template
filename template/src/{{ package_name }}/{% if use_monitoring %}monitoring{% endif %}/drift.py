"""Data drift report with Evidently.

Compares a REFERENCE dataset (what the model was trained on) with a CURRENT
dataset (what the model sees now). In this template the test split plays the
role of "current"; in production you would point it at recent inference data.

    uv run poe drift      ->  reports/drift_report.html
"""

from __future__ import annotations

from pathlib import Path

import pandas as pd
from evidently import Report
from evidently.presets import DataDriftPreset
from loguru import logger

from ..config import get_settings, load_config
from ..data.ingest import TARGET_COLUMN


def drift_report(
    reference: pd.DataFrame, current: pd.DataFrame, output_path: Path
) -> Path:
    report = Report([DataDriftPreset()])
    snapshot = report.run(current_data=current, reference_data=reference)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    snapshot.save_html(str(output_path))
    logger.info("Drift report -> {}", output_path)
    return output_path


def main() -> None:
    cfg = load_config(get_settings().config_path)
    reference = pd.read_csv(cfg.data.train_path).drop(columns=[TARGET_COLUMN])
    current = pd.read_csv(cfg.data.test_path).drop(columns=[TARGET_COLUMN])
    drift_report(reference, current, Path("reports/drift_report.html"))


if __name__ == "__main__":
    main()
