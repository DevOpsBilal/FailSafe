# LOG

## 2026-10-22
- **Did:** Wrote CLAUDE.md (scope, engineering rules, layout). Set up the repo skeleton: `failsafe/` package (brain, costmodel, hands), Python `.gitignore` that keeps data out of git, pinned `requirements.txt`, Makefile with dev targets and placeholder pipeline stages.
- **Learned:** The Claude GitHub App has no write access to the repo yet (push returns 403), so commits are local until that is fixed. The Backblaze download host is blocked from the cloud container, so `make data` has to run locally.
- **Did (later):** Added the engineering rules to CLAUDE.md and moved the package to `src/failsafe`. Switched to `xgboost-cpu` (plain `xgboost` on macOS) and added DuckDB. Pinned numpy 2.4.6 and xgboost 3.2.0, because the newest releases need Python 3.12. Fixed GitHub access and pushed.
- **Learned:** xgboost-cpu has no macOS wheels. This session's network policy still blocks `zenodo.org` and `*.backblazeb2.com` after they were added to the allowed domains, so the change likely only applies to new sessions.
- **Did (later still):** Raised the rule to Python 3.12+ and moved to the latest numpy 2.5.4 and xgboost-cpu/xgboost 3.4.1. Finished the `src/` layout: `failsafe` is now an installable package (`pip install -e .` in `make setup`), so nothing relies on `PYTHONPATH`.
- **Next:** In a new session, download the NCSA Delta GPU dataset (Zenodo record 15287639) and write `docs/delta_dataset_report.md`. Choose the drive model. Implement `make data` → `make features`.
