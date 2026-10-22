# FailSafe

Predictive hardware maintenance pipeline.

- **Brain:** predict hard-drive failures from Backblaze Drive Stats SMART data. One drive model, chronological train/test split, per-drive evaluation, lead time in days. Compare a threshold rule, logistic regression, Isolation Forest and XGBoost.
- **Cost model:** parametric. Compare disk checkpointing, in-memory checkpointing and predictive action, including detection time and the cost of false alarms.
- **Hands:** Kubernetes (kind) demo. Cordon + Eviction API with a PodDisruptionBudget; the worker hands state over via etcd.

## Engineering rules

- Python 3.11+, DuckDB for raw data, pandas for small tables.
- Code in `src/`, tests in `tests/`, results in `results/`. Raw data never committed.
- Reproducible: one command per stage (Makefile).
- Every reported metric must come from a run. Never invent numbers.
- Small focused commits with clear messages. Keep `LOG.md` updated.

## Layout

- `src/failsafe/brain/`: data loading, features, models, evaluation
- `src/failsafe/costmodel/`: parametric cost comparison
- `src/failsafe/hands/`: node flagging, cordon/evict, etcd state handover
- `k8s/`: kind config and manifests (worker, PodDisruptionBudget, etcd)
- `tests/`: pytest
- `results/`: small committed outputs (metrics, plots)
- `data/`, `models/`: local only, gitignored

## Commands

`make help` lists targets. `make setup` creates `.venv` from `requirements.txt`; `make test` and `make lint` run pytest and ruff. Pipeline stages: `data` → `features` → `train` → `evaluate` → `cost`; demo: `cluster-up` → `demo` → `cluster-down`.
