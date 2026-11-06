# mongodb

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.0.34](https://img.shields.io/badge/AppVersion-8.0.34-informational?style=flat-square)

MongoDB Community Server deployment for 5g-charts

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Gradiant | <cgiraldo@gradiant.org> |  |

## Deployment

Standalone MongoDB Community Server chart used by the Open5GS umbrella and standalone component charts.

The default deployment uses the official Docker image `mongo:8.0.34`, listens
on port 27017, and requests an 8 GiB persistent volume mounted at `/data/db`.
Authentication is disabled, matching the Open5GS chart defaults. Enabling
`auth.enabled` or a replica-set architecture is rejected because this chart does
not configure them. Use an external database for those deployments.

Read [MIGRATION.md](MIGRATION.md) before replacing a Bitnami deployment.

## Health probes

Startup, readiness and liveness use a real MongoDB `ping` via `mongosh`.
Startup runs without a fixed delay and permits 30 failures at 10-second
intervals (approximately five minutes). Readiness and liveness begin after
startup succeeds, with no fixed delay; their intervals are 10 and 20 seconds,
respectively, with three consecutive failures. The client timeout is 10 seconds
to allow for shell startup overhead.

The probe timings and enabled flags are configurable through `startupProbe`,
`readinessProbe`, and `livenessProbe`. `customStartupProbe`,
`customReadinessProbe`, and `customLivenessProbe` replace the entire default
probe, taking priority even when the default is enabled. Set `enabled=false`
and leave the custom probe empty to omit a probe. These probes monitor the
local database; they do not depend on other Open5GS services.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.enabled | bool | `false` | The local MongoDB chart does not implement authentication; keep false or use an authenticated external database. |
| customLivenessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customReadinessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customStartupProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| image.repository | string | `"mongo"` | Container image repository. |
| image.tag | string | `"8.0.34"` | Container image tag. |
| livenessProbe.enabled | bool | `true` | Enable the default liveness probe. A non-empty custom probe takes priority. |
| livenessProbe.failureThreshold | int | `3` | Consecutive failed checks before restarting the container after startup has succeeded. |
| livenessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| livenessProbe.periodSeconds | int | `20` | Interval between checks in seconds (minimum 1). |
| livenessProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| livenessProbe.timeoutSeconds | int | `10` | Timeout for one check in seconds (minimum 1). |
| persistence.enabled | bool | `true` | Use persistent storage; disabling it uses ephemeral storage. |
| persistence.existingClaim | string | `""` | Pre-created PVC with the target data layout and ownership; this does not migrate Bitnami data. |
| persistence.size | string | `"8Gi"` | Requested PVC capacity as a Kubernetes quantity, for example 8Gi. |
| persistence.storageClass | string | `""` | StorageClass name; empty uses the cluster default. |
| readinessProbe.enabled | bool | `true` | Enable the default readiness probe. A non-empty custom probe takes priority. |
| readinessProbe.failureThreshold | int | `3` | Consecutive failed checks before marking the Pod NotReady; this does not restart the container. |
| readinessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| readinessProbe.periodSeconds | int | `10` | Interval between checks in seconds (minimum 1). |
| readinessProbe.successThreshold | int | `1` | Consecutive successes needed to restore readiness (minimum 1). |
| readinessProbe.timeoutSeconds | int | `10` | Timeout for one check in seconds (minimum 1). |
| resources.limits.cpu | string | `"1"` | Container cpu limit as a Kubernetes quantity (for example 100m). |
| resources.limits.memory | string | `"1Gi"` | Container memory limit as a Kubernetes quantity (for example 128Mi). |
| resources.requests.cpu | string | `"100m"` | Container cpu request as a Kubernetes quantity (for example 100m). |
| resources.requests.memory | string | `"256Mi"` | Container memory request as a Kubernetes quantity (for example 128Mi). |
| service.port | int | `27017` | MongoDB Service port; the database container listens on port 27017. |
| startupProbe.enabled | bool | `true` | Enable the default startup probe. A non-empty custom probe takes priority. |
| startupProbe.failureThreshold | int | `30` | Consecutive failed checks allowed during startup before a restart; the budget is approximately this value multiplied by periodSeconds. |
| startupProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| startupProbe.periodSeconds | int | `10` | Interval between checks in seconds (minimum 1). |
| startupProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| startupProbe.timeoutSeconds | int | `10` | Timeout for one check in seconds (minimum 1). |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
