# LOG

## 2026-10-22
- **Did:** Wrote CLAUDE.md (scope, engineering rules, layout). Set up the repo skeleton: `failsafe/` package (brain, costmodel, hands), Python `.gitignore` that keeps data out of git, pinned `requirements.txt`, Makefile with dev targets and placeholder pipeline stages.
- **Learned:** The Claude GitHub App has no write access to the repo yet (push returns 403), so commits are local until that is fixed. The Backblaze download host is blocked from the cloud container, so `make data` has to run locally.
- **Next:** Fix GitHub access and push. Choose the drive model. Implement `make data` → `make features`.

## 2026-10-22 (NVSentinel)
- **Did:** Cloned NVIDIA/NVSentinel and tried its local fault injection demo on kind in the cloud container. Wrote up the result and how a custom monitor talks to it in `docs/nvsentinel-demo.md`.
- **Learned:** It does not run here. Inside kind, runc can't lower `oom_score_adj`, so no pod can start. The proxy also blocks ghcr.io blob downloads, quay.io, registry.k8s.io and nvcr.io. A custom monitor sends `HealthEvent` protobufs over gRPC on the node-local socket `/var/run/nvsentinel/nvsentinel.sock`, with a projected ServiceAccount token as the bearer. fault-quarantine also needs a CEL rule that matches the event.
- **Next:** Run `./demo.sh` on a local machine. Decide whether the Hands part becomes an NVSentinel custom monitor (FailSafe prediction → HealthEvent) or keeps its own cordon/evict.
