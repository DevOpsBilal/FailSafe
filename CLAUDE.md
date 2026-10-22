# FailSafe

Predictive hardware maintenance pipeline.

- **Brain:** predict hard-drive failures from Backblaze Drive Stats SMART data. One drive model, chronological train/test split, per-drive evaluation, lead time in days. Compare a threshold rule, logistic regression, Isolation Forest and XGBoost.
- **Cost model:** parametric. Compare disk checkpointing, in-memory checkpointing and predictive action, including detection time and the cost of false alarms.
- **Hands:** Kubernetes (kind) demo. Cordon + Eviction API with a PodDisruptionBudget; the worker hands state over via … *(unfinished, waiting on the rest of this sentence)*

## How to work with me

- **I'm a beginner learning Python.** Explain every piece of code in plain English, line by line, with analogies.
- **Build in small steps.** Before writing code, tell me what you'll do and why, then ask me to predict the result. Only after that, write and run the code.
- **Never commit raw data files.** Commit only code and small result files. Raw Backblaze data stays local and must be covered by `.gitignore`.
- **Keep a short `LOG.md`.** At the end of each session, add an entry with:
  - what we did
  - what I learned
  - what's next
