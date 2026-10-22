# FailSafe

Predictive hardware maintenance pipeline.

- **Brain:** predict hard-drive failures from Backblaze Drive Stats SMART data. One drive model, chronological train/test split, per-drive evaluation, lead time in days. Compare a threshold rule, logistic regression, Isolation Forest and XGBoost.
- **Cost model:** parametric. Compare disk checkpointing, in-memory checkpointing and predictive action, including detection time and the cost of false alarms.
- **Hands:** Kubernetes (kind) demo. Cordon + Eviction API with a PodDisruptionBudget; the worker hands state over via etcd.

## Engineering rules

- Never commit raw data files. Commit only code and small result files.
- Keep a short `LOG.md`: what we did each session, what I learned, what's next.

## Layout

- `failsafe/brain/`: data loading, features, models, evaluation
- `failsafe/costmodel/`: parametric cost comparison
- `failsafe/hands/`: node flagging, cordon/evict, etcd state handover
- `k8s/`: kind config and manifests (worker, PodDisruptionBudget, etcd)
- `tests/`: pytest
- `results/`: small committed outputs (metrics, plots)
- `data/`, `models/`: local only, gitignored

## Commands

`make help` lists targets. `make setup` creates `.venv` from `requirements.txt`; `make test` and `make lint` run pytest and ruff. Pipeline stages: `data` → `features` → `train` → `evaluate` → `cost`; demo: `cluster-up` → `demo` → `cluster-down`.
