# My personal MLOps Framework

This project follows a rigorous engineering standard divided into the following cross-cutting phases:
1. **ETL / ELT (Data Engineering):** Extraction, transformation, enrichment, and AI-assisted synthetic data generation.
2. **Quality Control & Validation (Testing & ML Quality):** 
   - Software: `pytest`, `ruff`, `black`.
   - Data: Schema and contract validation.
   - Models: Behavioral testing (MFT, INV, DIR).
   - Parity: Mitigation of Training-Serving Skew.
3. **Version Control & Model Registry:** Traceability with MLflow/DVC.
4. **Deployment & APIs:** FastAPI, Pydantic, and Docker.
5. **CI/CD, Orchestration & Monitoring:** GitHub Actions, Prefect/dbt, and drift observability.
