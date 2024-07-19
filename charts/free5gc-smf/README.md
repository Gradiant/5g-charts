# free5gc-smf

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 3.4.2](https://img.shields.io/badge/AppVersion-3.4.2-informational?style=flat-square)

Helm chart to deploy Free5GC SMF service on Kubernetes.

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
| config.logger.level | string | `"info"` |  |
| config.nrfUri | string | `""` |  |
| config.pfcp.externalAddr | string | `""` |  |
| config.pfcp.listenAddr | string | `""` |  |
| config.pfcp.nodeID | string | `""` |  |
| config.plmnList[0].mcc | int | `999` |  |
| config.plmnList[0].mnc | int | `70` |  |
| config.sbi.bindingIPv4 | string | `""` |  |
| config.sbi.registerIPv4 | string | `""` |  |
| config.smfName | string | `"SMF"` |  |
| config.snssaiInfos[0].dnnInfos[0].dnn | string | `"internet"` |  |
| config.snssaiInfos[0].dnnInfos[0].dns.ipv4 | string | `"8.8.8.8"` |  |
| config.snssaiInfos[0].dnnInfos[0].dns.ipv6 | string | `"2001:4860:4860::8888"` |  |
| config.snssaiInfos[0].sNssai.sd | string | `"ffffff"` |  |
| config.snssaiInfos[0].sNssai.sst | int | `1` |  |
| config.userplaneInformation.upNodes.UPF.addr | string | `""` |  |
| config.userplaneInformation.upNodes.UPF.interfaces.endpoints | string | `""` |  |
| config.userplaneInformation.upNodes.UPF.interfaces.networkInstances | string | `"internet"` |  |
| config.userplaneInformation.upNodes.UPF.nodeID | string | `""` |  |
| config.userplaneInformation.upNodes.UPF.sNssaiUpfInfos[0].dnnUpfInfoList[0].dnn | string | `"internet"` |  |
| config.userplaneInformation.upNodes.UPF.sNssaiUpfInfos[0].dnnUpfInfoList[0].pools[0].cidr | string | `"10.60.0.0/16"` |  |
| config.userplaneInformation.upNodes.UPF.sNssaiUpfInfos[0].dnnUpfInfoList[0].staticPools[0].cidr | string | `"10.60.100.0/24"` |  |
| config.userplaneInformation.upNodes.UPF.sNssaiUpfInfos[0].sNssai.sd | string | `"ffffff"` |  |
| config.userplaneInformation.upNodes.UPF.sNssaiUpfInfos[0].sNssai.sst | int | `1` |  |
| containerPorts.pfcp | int | `8805` |  |
| containerPorts.sbi | int | `8000` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
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
| image.repository | string | `"free5gc/smf"` |  |
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
| nodeSelector | object | `{}` |  |
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
| services.sbi.annotations | object | `{}` |  |
| services.sbi.clusterIP | string | `""` |  |
| services.sbi.externalTrafficPolicy | string | `"Cluster"` |  |
| services.sbi.extraPorts | list | `[]` |  |
| services.sbi.loadBalancerIP | string | `""` |  |
| services.sbi.loadBalancerSourceRanges | list | `[]` |  |
| services.sbi.nodePorts.sbi | string | `""` |  |
| services.sbi.ports.sbi | int | `8000` |  |
| services.sbi.sessionAffinity | string | `"None"` |  |
| services.sbi.sessionAffinityConfig | object | `{}` |  |
| services.sbi.type | string | `"ClusterIP"` |  |
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

