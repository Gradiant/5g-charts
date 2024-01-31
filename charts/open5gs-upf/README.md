# open5gs-upf

![Version: 2.1.0](https://img.shields.io/badge/Version-2.1.0-informational?style=flat-square) ![AppVersion: 2.4.11](https://img.shields.io/badge/AppVersion-2.4.11-informational?style=flat-square)

Helm chart to deploy Open5gs UPF service on Kubernetes.

**Homepage:** <https://github.com/gradiant/openverso-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cgiraldo | <cgiraldo@gradiant.org> |  |

## Source Code

* <http://open5gs.org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| command | list | `[]` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| config.logLevel | string | `"info"` |  |
| config.smf.pfcp.hostname | string | `""` |  |
| config.smf.pfcp.port | string | `nil` |  |
| config.subnetList[0].addr | string | `"10.45.0.1/16"` |  |
| config.subnetList[0].createDev | bool | `true` |  |
| config.subnetList[0].dev | string | `"ogstun"` |  |
| config.subnetList[0].dnn | string | `"internet"` |  |
| config.subnetList[0].enableNAT | bool | `true` |  |
| config.upf.gtpu.advertise | string | `""` |  |
| config.upf.gtpu.dev | string | `""` |  |
| containerPorts.gtpu | int | `2152` |  |
| containerPorts.metrics | int | `9090` |  |
| containerPorts.pfcp | int | `8805` |  |
| containerSecurityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.privileged | bool | `true` |  |
| containerSecurityContext.runAsNonRoot | bool | `false` |  |
| customLivenessProbe | object | `{}` |  |
| customOpen5gsConfig | object | `{}` |  |
| customReadinessProbe | object | `{}` |  |
| customStartupProbe | object | `{}` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVars | list | `[]` |  |
| extraEnvVarsCM | string | `""` |  |
| extraEnvVarsSecret | string | `""` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| hostAliases | list | `[]` |  |
| image.debug | bool | `false` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"gradiant/open5gs"` |  |
| image.tag | string | `"2.6.4"` |  |
| initContainers | list | `[]` |  |
| kubeVersion | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceScrape.additionalLabels | object | `{}` |  |
| metrics.serviceScrape.enabled | bool | `false` |  |
| metrics.serviceScrape.namespace | string | `""` |  |
| metrics.serviceScrape.scrape_interval | string | `"15s"` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeAffinityPreset.key | string | `""` |  |
| nodeAffinityPreset.type | string | `""` |  |
| nodeAffinityPreset.values | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| open5gs-smf.enabled | bool | `false` |  |
| podAffinityPreset | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podAntiAffinityPreset | string | `"soft"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| priorityClassName | string | `""` |  |
| replicaCount | int | `1` |  |
| resources.limits | object | `{}` |  |
| resources.requests | object | `{}` |  |
| schedulerName | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| services.gtpu.annotations | object | `{}` |  |
| services.gtpu.clusterIP | string | `""` |  |
| services.gtpu.externalTrafficPolicy | string | `"Cluster"` |  |
| services.gtpu.extraPorts | list | `[]` |  |
| services.gtpu.loadBalancerIP | string | `""` |  |
| services.gtpu.loadBalancerSourceRanges | list | `[]` |  |
| services.gtpu.nodePorts.gtpu | string | `""` |  |
| services.gtpu.ports.gtpu | int | `2152` |  |
| services.gtpu.sessionAffinity | string | `"None"` |  |
| services.gtpu.sessionAffinityConfig | object | `{}` |  |
| services.gtpu.type | string | `"ClusterIP"` |  |
| services.metrics.annotations."prometheus.io/path" | string | `"/metrics"` |  |
| services.metrics.clusterIP | string | `""` |  |
| services.metrics.externalTrafficPolicy | string | `"Cluster"` |  |
| services.metrics.extraPorts | list | `[]` |  |
| services.metrics.loadBalancerIP | string | `""` |  |
| services.metrics.loadBalancerSourceRanges | list | `[]` |  |
| services.metrics.nodePorts.metrics | string | `""` |  |
| services.metrics.ports.metrics | int | `9090` |  |
| services.metrics.sessionAffinity | string | `"None"` |  |
| services.metrics.sessionAffinityConfig | object | `{}` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| services.pfcp.annotations | object | `{}` |  |
| services.pfcp.clusterIP | string | `""` |  |
| services.pfcp.externalTrafficPolicy | string | `"Cluster"` |  |
| services.pfcp.extraPorts | list | `[]` |  |
| services.pfcp.loadBalancerIP | string | `""` |  |
| services.pfcp.loadBalancerSourceRanges | list | `[]` |  |
| services.pfcp.nodePorts.pfcp | string | `""` |  |
| services.pfcp.ports.pfcp | int | `8805` |  |
| services.pfcp.sessionAffinity | string | `"None"` |  |
| services.pfcp.sessionAffinityConfig | object | `{}` |  |
| services.pfcp.type | string | `"ClusterIP"` |  |
| sessionAffinity | string | `"None"` |  |
| sidecars | list | `[]` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
