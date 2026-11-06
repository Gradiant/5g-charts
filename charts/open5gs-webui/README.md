# open5gs-webui

![Version: 2.4.0](https://img.shields.io/badge/Version-2.4.0-informational?style=flat-square) ![AppVersion: 2.7.5](https://img.shields.io/badge/AppVersion-2.7.5-informational?style=flat-square)

Helm chart to deploy Open5gs WebUI service on Kubernetes.

**Homepage:** <https://github.com/gradiant/5g-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cgiraldo | <cgiraldo@gradiant.org> |  |
| avrodriguez | <avrodriguez@gradiant.org> |  |

## Source Code

* <http://open5gs.org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../mongodb | mongodb | ~0.1.0 |
| https://charts.bitnami.com/bitnami | common | 2.x.x |

## MongoDB and startup

This chart uses the local MongoDB Community Server chart with `mongo:8.0.34`
when `mongodb.enabled=true`. Set `dbURI` and disable the bundled database to
connect to an external MongoDB instance. By default, the local Service is named
`<release>-mongodb`; `mongodb.service.port` is respected when generating the URI.

The `wait-for-mongodb` init container checks the same URI as the application
before it starts. It retries a MongoDB `ping` for up to 300 seconds, with bounded
client attempts, and reports a timeout without logging the connection URI.
It also runs when the database is external. Set `mongodbWait.enabled=false` to
opt out, or adjust the timeout and retry interval below. User-supplied init
containers run after the readiness check. This check covers initial startup;
it does not implement recovery from a database outage after startup.

For existing Bitnami deployments, read the [MongoDB migration notes](../mongodb/MIGRATION.md)
before upgrading. PVC contents and Bitnami-specific values are not automatically
converted. The local database supports standalone, unauthenticated deployments;
use an external database for authentication or replica sets.

## Health probes

Startup checks are enabled immediately, with a budget of approximately five
minutes (60 attempts at 5-second intervals). Once startup succeeds, readiness
and liveness checks can begin without a fixed delay. Readiness uses three
consecutive failures at 5-second intervals; liveness uses three at 10-second
intervals. A successful readiness check can mark the Pod Ready immediately.

`customStartupProbe`, `customReadinessProbe` and `customLivenessProbe` replace
the corresponding default probe, including when its `enabled` flag is true.
To omit a probe, disable it and leave its custom override empty. Startup and
liveness `successThreshold` must remain 1; probe intervals and timeouts must be
positive.

The default probes check a TCP connection to the application port. They do
not prove successful protocol exchanges, dependency availability, or the absence
of every application deadlock.

Application Services exclude unready Pods by default. Set
`services.<name>.publishNotReadyAddresses=true` only when peer discovery or
bootstrap requires publishing them before readiness. Metrics Services keep
this setting enabled by default so unhealthy instances remain observable.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| args | list | `[]` | Override default container args (useful when using custom images) |
| command | list | `[]` | Override default container command (useful when using custom images) |
| commonAnnotations | object | `{}` | Common annotations to add to all open5gs-webui resources (sub-charts are not considered). Evaluated as a template |
| commonLabels | object | `{}` | Common labels to add to all open5gs-webui resources (sub-charts are not considered). Evaluated as a template |
| containerPorts.http | int | `9999` | Container port for HTTP. |
| containerSecurityContext.enabled | bool | `true` | Apply this security context. |
| containerSecurityContext.runAsGroup | int | `999` | GID used by this security context. |
| containerSecurityContext.runAsNonRoot | bool | `true` | Require the container to run as a non-root user. |
| containerSecurityContext.runAsUser | int | `999` | UID used by this security context. |
| customLivenessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customReadinessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customStartupProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| dbURI | string | `""` | MongoDB URI; empty selects <release>-mongodb and its configured Service port. Helm templating is supported. |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release (evaluated as a template). |
| extraEnvVars | list | `[]` | Extra environment variables |
| extraEnvVarsCM | string | `""` | ConfigMap containing extra env vars |
| extraEnvVarsSecret | string | `""` | Secret containing extra env vars (in case of sensitive data) |
| extraVolumeMounts | list | `[]` | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. |
| extraVolumes | list | `[]` | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts` |
| fullnameOverride | string | `""` | String to fully override open5gs-webui.fullname template |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.storageClass | string | `""` | Global StorageClass for Persistent Volume(s) |
| hostAliases | list | `[]` | [array] Add deployment host aliases |
| image.debug | bool | `false` | Specify if debug logs should be enabled |
| image.digest | string | `""` | Optional image digest; takes precedence over the tag. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| image.pullSecrets | list | `[]` | Image pull Secret names in the workload namespace. |
| image.registry | string | `"docker.io"` | Container image registry. |
| image.repository | string | `"gradiant/open5gs-webui"` | Container image repository. |
| image.tag | string | `"2.7.5"` | Container image tag. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. |
| ingress.apiVersion | string | `""` | Override API Version (automatically detected if not set) |
| ingress.enabled | bool | `true` | Enable ingress controller resource |
| ingress.extraHosts | list | `[]` | The list of additional hostnames to be covered with this ingress record. |
| ingress.extraPaths | list | `[]` | Any additional arbitrary paths that may need to be added to the ingress under the main host. |
| ingress.extraRules | list | `[]` | Additional rules to be covered with this ingress record |
| ingress.extraTls | list | `[]` | The tls configuration for additional hostnames to be covered with this ingress record. |
| ingress.hostname | string | `""` | Default host for the ingress resource |
| ingress.ingressClassName | string | `""` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) |
| ingress.path | string | `"/"` | The Path to WebUI. |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress Path type |
| ingress.secrets | list | `[]` | If you're providing your own certificates, please use this to add the certificates as secrets |
| ingress.tls | bool | `false` | Enable TLS configuration for the hostname defined at ingress.hostname parameter |
| initContainers | list | `[]` | Add additional init containers to the pod (evaluated as a template) |
| kubeVersion | string | `""` | Force target Kubernetes version (using Helm capabilities if not set) |
| lifecycleHooks | object | `{}` | LifecycleHook to set additional configuration at startup Evaluated as a template |
| livenessProbe.enabled | bool | `true` | Enable the default liveness probe. A non-empty custom probe takes priority. |
| livenessProbe.failureThreshold | int | `3` | Consecutive failed checks before restarting the container after startup has succeeded. |
| livenessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| livenessProbe.periodSeconds | int | `10` | Interval between checks in seconds (minimum 1). |
| livenessProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| livenessProbe.timeoutSeconds | int | `2` | Timeout for one check in seconds (minimum 1). |
| mongodb.auth.enabled | bool | `false` | The local MongoDB chart does not implement authentication; keep false or use an authenticated external database. |
| mongodb.enabled | bool | `false` | set to 'false' to disable automatically deploying dependent charts -- Deploy the bundled local MongoDB chart; disable it when using an external database. |
| mongodbWait.enabled | bool | `true` | Wait for a successful MongoDB ping before application or subscriber initialization. |
| mongodbWait.image.digest | string | `""` | Optional image digest; takes precedence over the tag. |
| mongodbWait.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| mongodbWait.image.registry | string | `"docker.io"` | Container image registry. |
| mongodbWait.image.repository | string | `"library/mongo"` | Container image repository. |
| mongodbWait.image.tag | string | `"8.0.34"` | Container image tag. |
| mongodbWait.resources.limits.cpu | string | `"1"` | Container cpu limit as a Kubernetes quantity (for example 100m). |
| mongodbWait.resources.limits.memory | string | `"512Mi"` | Container memory limit as a Kubernetes quantity (for example 128Mi). |
| mongodbWait.resources.requests.cpu | string | `"50m"` | Container cpu request as a Kubernetes quantity (for example 100m). |
| mongodbWait.resources.requests.memory | string | `"128Mi"` | Container memory request as a Kubernetes quantity (for example 128Mi). |
| mongodbWait.retryIntervalSeconds | int | `5` | Delay between unsuccessful connection attempts in seconds (1-3600). |
| mongodbWait.timeoutSeconds | int | `300` | Maximum wait per init-container attempt in seconds (1-86400), not a fixed delay; Kubernetes may retry failed attempts. |
| nameOverride | string | `""` | String to partially override open5gs-webui.fullname template (will maintain the release name) |
| namespaceOverride | string | `""` | String to fully override common.names.namespace |
| nodeAffinityPreset.key | string | `""` | Node label key to match Ignored if `affinity` is set. |
| nodeAffinityPreset.type | string | `""` | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| nodeAffinityPreset.values | list | `[]` | Node label values to match. Ignored if `affinity` is set. |
| nodeSelector | object | `{}` | Node labels for pod assignment. Evaluated as a template. |
| podAffinityPreset | string | `""` | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| podAnnotations | object | `{}` | Pod annotations |
| podAntiAffinityPreset | string | `"soft"` | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| podLabels | object | `{}` | Add additional labels to the pod (evaluated as a template) |
| podSecurityContext.enabled | bool | `true` | Apply this security context. |
| podSecurityContext.fsGroup | int | `999` | Group used for mounted-volume access. |
| priorityClassName | string | `""` | open5gs-webui pods' priorityClassName |
| readinessProbe.enabled | bool | `true` | Enable the default readiness probe. A non-empty custom probe takes priority. |
| readinessProbe.failureThreshold | int | `3` | Consecutive failed checks before marking the Pod NotReady; this does not restart the container. |
| readinessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| readinessProbe.periodSeconds | int | `5` | Interval between checks in seconds (minimum 1). |
| readinessProbe.successThreshold | int | `1` | Consecutive successes needed to restore readiness (minimum 1). |
| readinessProbe.timeoutSeconds | int | `2` | Timeout for one check in seconds (minimum 1). |
| replicaCount | int | `1` | Number of application replicas. |
| resources.limits.cpu | string | `"500m"` | Container cpu limit as a Kubernetes quantity (for example 100m). |
| resources.limits.memory | string | `"512Mi"` | Container memory limit as a Kubernetes quantity (for example 128Mi). |
| resources.requests.cpu | string | `"50m"` | Container cpu request as a Kubernetes quantity (for example 100m). |
| resources.requests.memory | string | `"64Mi"` | Container memory request as a Kubernetes quantity (for example 128Mi). |
| schedulerName | string | `""` | Name of the k8s scheduler (other than default) |
| serviceAccount.annotations | object | `{}` | Add annotations |
| serviceAccount.automountServiceAccountToken | bool | `true` | Automount API credentials for a service account. |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| services.http.annotations | object | `{}` |  |
| services.http.clusterIP | string | `""` | Fixed Service cluster IP; empty lets Kubernetes allocate it. |
| services.http.externalTrafficPolicy | string | `"Cluster"` | Traffic policy for externally exposed Services. |
| services.http.extraPorts | list | `[]` |  |
| services.http.loadBalancerIP | string | `""` |  |
| services.http.loadBalancerSourceRanges | list | `[]` |  |
| services.http.nodePorts.http | string | `""` | NodePort override; empty lets Kubernetes allocate the port. |
| services.http.ports.http | int | `9999` | Service port for HTTP. |
| services.http.publishNotReadyAddresses | bool | `false` | Publish unready Pod endpoints; enable only for required bootstrap/discovery or metrics diagnostics. |
| services.http.sessionAffinity | string | `"None"` | Service session-affinity policy. |
| services.http.sessionAffinityConfig | object | `{}` |  |
| services.http.type | string | `"ClusterIP"` | Kubernetes Service type: ClusterIP, NodePort or LoadBalancer. |
| sessionAffinity | string | `"None"` | Control where client requests go, to the same pod or round-robin. Values: ClientIP or None |
| sidecars | list | `[]` | Attach additional containers to the pod (evaluated as a template) |
| startupProbe.enabled | bool | `true` | Enable the default startup probe. A non-empty custom probe takes priority. |
| startupProbe.failureThreshold | int | `60` | Consecutive failed checks allowed during startup before a restart; the budget is approximately this value multiplied by periodSeconds. |
| startupProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| startupProbe.periodSeconds | int | `5` | Interval between checks in seconds (minimum 1). |
| startupProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| startupProbe.timeoutSeconds | int | `2` | Timeout for one check in seconds (minimum 1). |
| tolerations | list | `[]` | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for pod assignment |
| updateStrategy.type | string | `"RollingUpdate"` | Update strategy - only really applicable for deployments with RWO PVs attached |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
