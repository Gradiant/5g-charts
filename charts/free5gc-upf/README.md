# free5gc-upf

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 3.4.2](https://img.shields.io/badge/AppVersion-3.4.2-informational?style=flat-square)

Helm chart to deploy Free5GC UPF service on Kubernetes.

**Homepage:** <https://github.com/gradiant/5g-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cgiraldo | <cgiraldo@gradiant.org> |  |
| avrodriguez | <avrodriguez@gradiant.org> |  |

## Source Code

* <http://free5gc.org>

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
| config.dnnList[0].cidr | string | `"10.60.0.0/24"` |  |
| config.dnnList[0].dnn | string | `"internet"` |  |
| config.gtpu.ifList.name | string | `""` |  |
| config.logger.level | string | `"info"` |  |
| config.pfcp.addr | string | `""` |  |
| config.pfcp.nodeID | string | `""` |  |
| containerPorts.gtpu | int | `2152` |  |
| containerPorts.pfcp | int | `8805` |  |
| containerSecurityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.privileged | bool | `true` |  |
| customLivenessProbe | object | `{}` |  |
| customReadinessProbe | object | `{}` |  |
| customStartupProbe | object | `{}` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVarsCM | string | `""` |  |
| extraEnvVarsSecret | string | `""` |  |
| extraEnvVars[0].name | string | `"GIN_MODE"` |  |
| extraEnvVars[0].value | string | `"release"` |  |
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
| image.repository | string | `"free5gc/upf"` |  |
| image.tag | string | `"v3.4.2"` |  |
| initContainers | list | `[]` |  |
| kubeVersion | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| livenessProbe.initialDelaySeconds | int | `600` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeAffinityPreset.key | string | `""` |  |
| nodeAffinityPreset.type | string | `""` |  |
| nodeAffinityPreset.values | list | `[]` |  |
| nodeSelector."kubernetes.io/hostname" | string | `"solidsnake"` |  |
| podAffinityPreset | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podAntiAffinityPreset | string | `"soft"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| priorityClassName | string | `""` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `5` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
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
| startupProbe.enabled | bool | `false` |  |
| startupProbe.failureThreshold | int | `5` |  |
| startupProbe.initialDelaySeconds | int | `600` |  |
| startupProbe.path | string | `"/"` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

