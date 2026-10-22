# LOG

## 2026-10-22
- **Did:** Wrote CLAUDE.md (scope, engineering rules, layout). Set up the repo skeleton: `failsafe/` package (brain, costmodel, hands), Python `.gitignore` that keeps data out of git, pinned `requirements.txt`, Makefile with dev targets and placeholder pipeline stages.
- **Learned:** The Claude GitHub App has no write access to the repo yet (push returns 403), so commits are local until that is fixed. The Backblaze download host is blocked from the cloud container, so `make data` has to run locally.
- **Next:** Fix GitHub access and push. Choose the drive model. Implement `make data` → `make features`.
