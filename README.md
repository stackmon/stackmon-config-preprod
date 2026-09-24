# StackMon preprod configuration

Configuration repository for the **preprod / test environment only**. It is a
fork of `opentelekomcloud-infra/stackmon-config` (production) and is consumed
by the preprod cluster's ArgoCD. Production (EU / CH) configuration stays in
the parent repository.

## Contents

| Path | Consumed by (preprod ArgoCD) |
| --- | --- |
| `kustomize/mp/` | Application `mp` → `mp-preprod`, ns `sd3-test` (metrics-processor, convertor + reporter) |
| `kustomize/sd3/frontend/overlays/test` | Application `sd3-front-test` → `sd3-front-test-preprod`, ns `sd3-test` (frontend Ingress + ExternalName to the OBS test bucket) |
| `kustomize/sd3/api/overlays/test` | not consumed by any Application yet (kept for the future preprod SD3 API deployment) |

Everything else from the parent repository (CH overlays, SD2 `sdb`, the
`mp-prod`/`mp-ch2`/`sdb_*`/`epmon`/`globalmon` data directories, the root
`config.yaml`, and the Zuul/tox lint tooling) was removed on 2026-09-24: it is
production-only or unused by preprod.

## Branch discipline

All preprod changes are pushed **directly to `main`** (no pull requests), per
the 2026-09-24 decision.
