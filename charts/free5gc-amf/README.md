# free5gc-amf

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 3.3.0](https://img.shields.io/badge/AppVersion-3.3.0-informational?style=flat-square)

Helm chart to deploy Free5GC AMF service on Kubernetes.

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
| config.amfName | string | `"AMF"` |  |
| config.logger.level | string | `"info"` |  |
| config.networkName.full | string | `"Gradiant5G"` |  |
| config.networkName.short | string | `"G5G"` |  |
| config.ngapIpList | string | `""` |  |
| config.nrfUri | string | `""` |  |
| config.plmnSupportList[0].plmnId.mcc | int | `999` |  |
| config.plmnSupportList[0].plmnId.mnc | int | `70` |  |
| config.plmnSupportList[0].snssaiList[0].sd | string | `"ffffff"` |  |
| config.plmnSupportList[0].snssaiList[0].sst | int | `1` |  |
| config.sbi.bindingIPv4 | string | `""` |  |
| config.sbi.registerIPv4 | string | `""` |  |
| config.servedGuamiList[0].amfId | string | `"cafe00"` |  |
| config.servedGuamiList[0].plmnId.mcc | int | `999` |  |
| config.servedGuamiList[0].plmnId.mnc | int | `70` |  |
| config.supportDnnList[0] | string | `"internet"` |  |
| config.supportTaiList[0].plmnId.mcc | int | `999` |  |
| config.supportTaiList[0].plmnId.mnc | int | `70` |  |
| config.supportTaiList[0].tac | string | `"000001"` |  |
| containerPorts.ngap | int | `38412` |  |
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
| image.repository | string | `"free5gc/amf"` |  |
| image.tag | string | `"v3.3.0"` |  |
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
| services.ngap.annotations | object | `{}` |  |
| services.ngap.clusterIP | string | `""` |  |
| services.ngap.externalTrafficPolicy | string | `"Cluster"` |  |
| services.ngap.extraPorts | list | `[]` |  |
| services.ngap.loadBalancerIP | string | `""` |  |
| services.ngap.loadBalancerSourceRanges | list | `[]` |  |
| services.ngap.nodePorts.ngap | string | `""` |  |
| services.ngap.ports.ngap | int | `38412` |  |
| services.ngap.sessionAffinity | string | `"None"` |  |
| services.ngap.sessionAffinityConfig | object | `{}` |  |
| services.ngap.type | string | `"ClusterIP"` |  |
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

