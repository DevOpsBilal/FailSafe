# NVSentinel local fault injection demo: notes

Checked 2026-10-22 against NVIDIA/NVSentinel `3fba923`, chart `v1.28.0`.

## Does it run in the Claude Code cloud container?

No. There are two separate blockers.

1. **kind cannot start pods.** `dockerd` starts (`sudo dockerd`) and the kind node
   container runs, but `kubeadm init` times out. The kubelet logs show
   `runc create failed: ... can't get final child's PID from pipe: EOF`.
   Running runc by hand inside the node shows the real error:
   `nsexec: failed to update /proc/self/oom_score_adj: Permission denied`.
   The sandbox does not allow lowering `oom_score_adj`, even for root on the
   host (`echo -998 > /proc/self/oom_score_adj` fails). Kubelet gives every pod
   sandbox `oomScoreAdj: -998`, so no pod can start. A runc wrapper in a custom
   node image that clamps the value to 0 would likely get around this, but it
   changes the runtime's security behaviour, so we did not use it.
2. **The images and charts can't be downloaded.** The egress proxy blocks
   `pkg-containers.githubusercontent.com`, which serves ghcr.io blobs. That
   rules out the NVSentinel chart, every NVSentinel image and
   `nvsentinel-fake-dcgm`. It also blocks `quay.io` and `charts.jetstack.io`
   (cert-manager), `registry.k8s.io` and `nvcr.io`. Docker Hub works but is
   rate-limited.

To run the demo, use a normal Linux or macOS machine with Docker, kind,
kubectl, helm and jq. It needs about 4 CPUs, 8 GB of RAM and 20 GB of disk.
Then run `cd demos/local-fault-injection-demo && ./demo.sh`.

## What the demo does

The fake DCGM hostengine has XID 95 injected (`dcgmi test --inject --gpuid 0 -f 230 -v 95`).
After that the pipeline runs on its own:

1. gpu-health-monitor sends a HealthEvent to platform-connectors.
2. platform-connectors stores it in MongoDB and sets a node condition.
3. fault-quarantine cordons the node.
4. node-drainer evicts the workload.
5. fault-remediation creates a `RebootNode` request.
6. janitor carries it out, using the `kind` provider here.

When the fault clears, the node is uncordoned. The modules don't call each
other. Each one watches the MongoDB change stream.

## How a custom health monitor sends events

The reference example is `demos/local-custom-remediation-demo/memory-pressure-monitor`.

- **Transport:** gRPC over a Unix socket to the platform-connectors pod on the
  same node. The socket is at `/var/run/nvsentinel/nvsentinel.sock` on the
  host. The monitor mounts that directory with a `hostPath` volume and dials
  `unix:///var/run/nvsentinel.sock`, with no TLS.
- **Auth:** a projected ServiceAccount token with audience
  `platform-connector.nvsentinel.nvidia.com`. It is sent as
  `authorization: Bearer <token>` gRPC metadata and re-read on every call,
  because the token rotates.
- **API:** `PlatformConnector.HealthEventOccurredV1(HealthEvents)`, defined in
  `data-models/protobufs/health_event.proto`. Go stubs are in
  `github.com/nvidia/nvsentinel/data-models/pkg/protos`.
- **Event fields that matter:**
  - `agent`, `componentClass`, `checkName` and `nodeName`. The `checkName`
    becomes the node condition type, and `True` means faulty.
  - `isFatal` and `isHealthy`.
  - `recommendedAction`. This is an enum such as `RESTART_VM`, or `CUSTOM`
    together with `customRecommendedAction`.
  - `processingStrategy`: `EXECUTE_REMEDIATION`, `STORE_ONLY` or
    `STORE_AND_ANALYSE`.
  - Also `errorCode`, `entitiesImpacted` and `metadata`.
- **Edge-triggered:** the monitor sends an event only when its state changes.
  To recover, it sends `isHealthy: true` for the same `checkName`.
- **Quarantine needs a rule:** fault-quarantine acts only when a CEL rule
  matches. For example:
  `event.agent == 'memory-pressure-monitor' && event.componentClass == 'Memory' && event.isFatal == true`.
  The rule goes under `fault-quarantine.ruleSets` in the Helm values.
- Without the Unix socket, a monitor set to `publishTo: deployment` can publish
  over TLS with a bearer token to a central platform-connectors Deployment
  (ADR 052).

## Relevance to FailSafe

FailSafe's predictor could run as a custom monitor. It would emit a
`HealthEvent` with componentClass `Disk` and `isFatal` set when the predicted
risk crosses the threshold, with a quarantine rule that cordons. NVSentinel would
then handle the cordon and drain, so our own cordon/evict code wouldn't be
needed. The etcd state handover would stay ours.
