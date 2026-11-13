# open5gs-upf

![Version: 2.4.1](https://img.shields.io/badge/Version-2.4.1-informational?style=flat-square) ![AppVersion: 2.8.0](https://img.shields.io/badge/AppVersion-2.8.0-informational?style=flat-square)

Helm chart to deploy Open5gs UPF service on Kubernetes.

**Homepage:** <https://github.com/gradiant/5g-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cgiraldo | <cgiraldo@gradiant.org> |  |

## Source Code

* <http://open5gs.org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 2.x.x |

## Container permissions

The init container creates `/dev/net/tun` in a shared `emptyDir` with
`NET_ADMIN` and `MKNOD`, configures the persistent TUN interface and NAT, and
assigns the interface to `containerSecurityContext.runAsUser` and
`containerSecurityContext.runAsGroup`. The UPF mounts the device directory
read-only and runs as UID/GID 999 without Linux capabilities. Both containers
use `privileged: false`, disable privilege escalation and use `RuntimeDefault`
seccomp. No device plugin or `hostPath` mount is used.

The node must support TUN, and its runtime and admission policies must permit
the init container's capabilities and access to character device 10:200. The
init preserves IPv4 forwarding when it is already enabled. If forwarding is
disabled, it attempts to enable it and fails if the runtime makes that sysctl
read-only. This mode has been tested locally with kind/containerd; runtimes
with stricter device policies may deny access even when the device node exists.

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

The default probes check the local PFCP UDP socket. An open socket does not
prove successful PFCP exchanges or end-to-end UE traffic.

Application Services exclude unready Pods by default. Set
`services.<name>.publishNotReadyAddresses=true` only when peer discovery or
bootstrap requires publishing them before readiness. Metrics Services keep
this setting enabled by default so unhealthy instances remain observable.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| args | list | `[]` | Override default container args (useful when using custom images) |
| autoscaling.enabled | bool | `false` | Create a HorizontalPodAutoscaler for the Deployment |
| autoscaling.maxReplicas | int | `1` | Maximum number of replicas for the autoscaler |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas for the autoscaler |
| command | list | `[]` | Override default container command (useful when using custom images) |
| commonAnnotations | object | `{}` | Common annotations to add to all open5gs-upf resources (sub-charts are not considered). Evaluated as a template |
| commonLabels | object | `{}` | Common labels to add to all open5gs-upf resources (sub-charts are not considered). Evaluated as a template |
| config.logLevel | string | `"info"` |  |
| config.subnetList | list | `[{"createDev":true,"dev":"ogstun","dnn":"internet","enableNAT":true,"gateway":"10.45.0.1","mask":16,"subnet":"10.45.0.0/16"}]` | UE subnets, DNNs and related user-plane settings. |
| config.upf.gtpu.advertise | string | `""` | GTP-U address advertised to peers; empty uses the configured interface address. |
| config.upf.gtpu.dev | string | `""` |  |
| config.upf.pfcp.advertise | string | `""` | PFCP identity advertised by UPF; the umbrella uses its PFCP Service DNS name to keep peer addressing consistent. |
| config.upf.pfcp.dev | string | `""` |  |
| containerPorts.gtpu | int | `2152` | Container port for GTP-U. |
| containerPorts.metrics | int | `9090` | Container port for metrics. |
| containerPorts.pfcp | int | `8805` | Container port for PFCP. |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Allow container processes to gain additional privileges. |
| containerSecurityContext.capabilities.drop | list | `["ALL"]` | Linux capabilities removed from the main container. |
| containerSecurityContext.enabled | bool | `true` | Apply this security context. |
| containerSecurityContext.privileged | bool | `false` | Run the main container in privileged mode. |
| containerSecurityContext.runAsGroup | int | `999` | GID used by this security context. |
| containerSecurityContext.runAsNonRoot | bool | `true` | Require the container to run as a non-root user. |
| containerSecurityContext.runAsUser | int | `999` | UID used by this security context. |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Seccomp profile type; RuntimeDefault uses the container runtime profile. |
| customLivenessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customOpen5gsConfig | object | `{}` | overwrite open5gs configuration file |
| customReadinessProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| customStartupProbe | object | `{}` | Complete replacement for the default probe, taking priority even when it is enabled. Empty uses the default or omits it when disabled. |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release (evaluated as a template). |
| extraEnvVars | list | `[]` | Extra environment variables |
| extraEnvVarsCM | string | `""` | ConfigMap containing extra env vars |
| extraEnvVarsSecret | string | `""` | Secret containing extra env vars (in case of sensitive data) |
| extraVolumeMounts | list | `[]` | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. |
| extraVolumes | list | `[]` | Array of extra volumes to be added to the deployment (evaluated as template). Requires setting `extraVolumeMounts` |
| fullnameOverride | string | `""` | String to fully override open5gs-upf.fullname template |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.storageClass | string | `""` | Global StorageClass for Persistent Volume(s) |
| hostAliases | list | `[]` | [array] Add deployment host aliases |
| image.debug | bool | `false` | Specify if debug logs should be enabled |
| image.digest | string | `""` | Optional image digest; takes precedence over the tag. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| image.pullSecrets | list | `[]` | Image pull Secret names in the workload namespace. |
| image.registry | string | `"docker.io"` | Container image registry. |
| image.repository | string | `"gradiant/open5gs"` | Container image repository. |
| image.tag | string | `"2.8.0"` | Container image tag. |
| initContainers | list | `[]` | Add additional init containers to the pod (evaluated as a template) |
| kubeVersion | string | `""` | Force target Kubernetes version (using Helm capabilities if not set) |
| lifecycleHooks | object | `{}` | LifecycleHook to set additional configuration at startup Evaluated as a template |
| livenessProbe.enabled | bool | `true` | Enable the default liveness probe. A non-empty custom probe takes priority. |
| livenessProbe.failureThreshold | int | `3` | Consecutive failed checks before restarting the container after startup has succeeded. |
| livenessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| livenessProbe.periodSeconds | int | `10` | Interval between checks in seconds (minimum 1). |
| livenessProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| livenessProbe.timeoutSeconds | int | `5` | Timeout for one check in seconds (minimum 1). |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` | Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus |
| metrics.serviceMonitor.enabled | bool | `false` | Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator |
| metrics.serviceMonitor.honorLabels | bool | `false` | Specify honorLabels parameter to add the scrape endpoint |
| metrics.serviceMonitor.interval | string | `""` | The interval at which metrics should be scraped |
| metrics.serviceMonitor.metricRelabelings | list | `[]` | Metrics RelabelConfigs to apply to samples before ingestion. |
| metrics.serviceMonitor.namespace | string | `""` | The namespace in which the ServiceMonitor will be created |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` | The timeout after which the scrape is ended |
| metrics.serviceScrape.additionalLabels | object | `{}` | Additional labels that can be used so VMServiceScrape resource(s) can be discovered by VictoriaMetrics |
| metrics.serviceScrape.enabled | bool | `false` | Create VMServiceScrape resource(s) for scraping metrics using VictoriaMetrics Operator |
| metrics.serviceScrape.namespace | string | `""` | The namespace in which the VMServiceScrape will be created |
| metrics.serviceScrape.scrape_interval | string | `"15s"` | The interval at which metrics should be scraped |
| nameOverride | string | `""` | String to partially override open5gs-upf.fullname template (will maintain the release name) |
| namespaceOverride | string | `""` | String to fully override common.names.namespace |
| nodeAffinityPreset.key | string | `""` | Node label key to match Ignored if `affinity` is set. |
| nodeAffinityPreset.type | string | `""` | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| nodeAffinityPreset.values | list | `[]` | Node label values to match. Ignored if `affinity` is set. |
| nodeSelector | object | `{}` | Node labels for pod assignment. Evaluated as a template. |
| open5gs-smf.enabled | bool | `false` |  |
| podAffinityPreset | string | `""` | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| podAnnotations | object | `{}` | Pod annotations |
| podAntiAffinityPreset | string | `"soft"` | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard` |
| podLabels | object | `{}` | Add additional labels to the pod (evaluated as a template) |
| podSecurityContext.enabled | bool | `true` | Apply this security context. |
| podSecurityContext.fsGroup | int | `999` | Group used for mounted-volume access. |
| priorityClassName | string | `""` | open5gs-upf pods' priorityClassName |
| readinessProbe.enabled | bool | `true` | Enable the default readiness probe. A non-empty custom probe takes priority. |
| readinessProbe.failureThreshold | int | `3` | Consecutive failed checks before marking the Pod NotReady; this does not restart the container. |
| readinessProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| readinessProbe.periodSeconds | int | `5` | Interval between checks in seconds (minimum 1). |
| readinessProbe.successThreshold | int | `1` | Consecutive successes needed to restore readiness (minimum 1). |
| readinessProbe.timeoutSeconds | int | `5` | Timeout for one check in seconds (minimum 1). |
| replicaCount | int | `1` | Number of application replicas. |
| resources.limits.cpu | string | `"1"` | Container cpu limit as a Kubernetes quantity (for example 100m). |
| resources.limits.memory | string | `"512Mi"` | Container memory limit as a Kubernetes quantity (for example 128Mi). |
| resources.requests.cpu | string | `"50m"` | Container cpu request as a Kubernetes quantity (for example 100m). |
| resources.requests.memory | string | `"64Mi"` | Container memory request as a Kubernetes quantity (for example 128Mi). |
| schedulerName | string | `""` | Name of the k8s scheduler (other than default) |
| serviceAccount.annotations | object | `{}` | Add annotations |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount an API token in pods and on the ServiceAccount created by the chart. |
| serviceAccount.create | bool | `true` | Specifies whether a dedicated service account should be created. |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| services.gtpu.annotations | object | `{}` |  |
| services.gtpu.clusterIP | string | `""` | Fixed Service cluster IP; empty lets Kubernetes allocate it. |
| services.gtpu.externalTrafficPolicy | string | `"Cluster"` | Traffic policy for externally exposed Services. |
| services.gtpu.extraPorts | list | `[]` |  |
| services.gtpu.loadBalancerIP | string | `""` |  |
| services.gtpu.loadBalancerSourceRanges | list | `[]` |  |
| services.gtpu.nodePorts.gtpu | string | `""` | NodePort override; empty lets Kubernetes allocate the port. |
| services.gtpu.ports.gtpu | int | `2152` | Service port for GTP-U. |
| services.gtpu.publishNotReadyAddresses | bool | `false` | Publish unready Pod endpoints; enable only for required bootstrap/discovery or metrics diagnostics. |
| services.gtpu.sessionAffinity | string | `"None"` | Service session-affinity policy. |
| services.gtpu.sessionAffinityConfig | object | `{}` |  |
| services.gtpu.type | string | `"ClusterIP"` | Kubernetes Service type: ClusterIP, NodePort or LoadBalancer. |
| services.metrics.annotations."prometheus.io/path" | string | `"/metrics"` |  |
| services.metrics.clusterIP | string | `""` | Fixed Service cluster IP; empty lets Kubernetes allocate it. |
| services.metrics.externalTrafficPolicy | string | `"Cluster"` | Traffic policy for externally exposed Services. |
| services.metrics.extraPorts | list | `[]` |  |
| services.metrics.loadBalancerIP | string | `""` |  |
| services.metrics.loadBalancerSourceRanges | list | `[]` |  |
| services.metrics.nodePorts.metrics | string | `""` | NodePort override; empty lets Kubernetes allocate the port. |
| services.metrics.ports.metrics | int | `9090` | Service port for metrics. |
| services.metrics.publishNotReadyAddresses | bool | `true` | Publish unready Pod endpoints; enable only for required bootstrap/discovery or metrics diagnostics. |
| services.metrics.sessionAffinity | string | `"None"` | Service session-affinity policy. |
| services.metrics.sessionAffinityConfig | object | `{}` |  |
| services.metrics.type | string | `"ClusterIP"` | Kubernetes Service type: ClusterIP, NodePort or LoadBalancer. |
| services.pfcp.annotations | object | `{}` |  |
| services.pfcp.clusterIP | string | `""` | Fixed Service cluster IP; empty lets Kubernetes allocate it. |
| services.pfcp.externalTrafficPolicy | string | `"Cluster"` | Traffic policy for externally exposed Services. |
| services.pfcp.extraPorts | list | `[]` |  |
| services.pfcp.loadBalancerIP | string | `""` |  |
| services.pfcp.loadBalancerSourceRanges | list | `[]` |  |
| services.pfcp.nodePorts.pfcp | string | `""` | NodePort override; empty lets Kubernetes allocate the port. |
| services.pfcp.ports.pfcp | int | `8805` | Service port for PFCP. |
| services.pfcp.publishNotReadyAddresses | bool | `false` | Publish unready Pod endpoints; enable only for required bootstrap/discovery or metrics diagnostics. |
| services.pfcp.sessionAffinity | string | `"None"` | Service session-affinity policy. |
| services.pfcp.sessionAffinityConfig | object | `{}` |  |
| services.pfcp.type | string | `"ClusterIP"` | Kubernetes Service type: ClusterIP, NodePort or LoadBalancer. |
| sessionAffinity | string | `"None"` | Control where client requests go, to the same pod or round-robin. Values: ClientIP or None |
| sidecars | list | `[]` | Attach additional containers to the pod (evaluated as a template) |
| startupProbe.enabled | bool | `true` | Enable the default startup probe. A non-empty custom probe takes priority. |
| startupProbe.failureThreshold | int | `60` | Consecutive failed checks allowed during startup before a restart; the budget is approximately this value multiplied by periodSeconds. |
| startupProbe.initialDelaySeconds | int | `0` | Delay in seconds before checks can begin (minimum 0). Application probes run after init containers. |
| startupProbe.periodSeconds | int | `5` | Interval between checks in seconds (minimum 1). |
| startupProbe.successThreshold | int | `1` | Consecutive successes required; Kubernetes requires 1 for startup and liveness. |
| startupProbe.timeoutSeconds | int | `5` | Timeout for one check in seconds (minimum 1). |
| tolerations | list | `[]` | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for pod assignment |
| updateStrategy.type | string | `"RollingUpdate"` | Update strategy - only really applicable for deployments with RWO PVs attached |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
