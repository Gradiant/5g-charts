# packetrusher

![Version: 0.0.2](https://img.shields.io/badge/Version-0.0.2-informational?style=flat-square) ![AppVersion: 97f9f0c](https://img.shields.io/badge/AppVersion-97f9f0c-informational?style=flat-square)

Helm chart to deploy PacketRusher service on Kubernetes.

**Homepage:** <https://github.com/gradiant/5g-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| avrodriguez | <avrodriguez@gradiant.org> |  |

## Source Code

* <https://github.com/HewlettPackard/PacketRusher>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args[0] | string | `"ue"` |  |
| command | list | `[]` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| config.amf.hostname | string | `"open5gs-amf-ngap"` |  |
| config.gnb.gnbid | string | `"000008"` |  |
| config.gnb.gtpu.dev | string | `"eth0"` |  |
| config.gnb.mcc | string | `"999"` |  |
| config.gnb.mnc | string | `"70"` |  |
| config.gnb.ngap.dev | string | `"eth0"` |  |
| config.gnb.sd | string | `"ffffff"` |  |
| config.gnb.sst | string | `"01"` |  |
| config.gnb.tac | string | `"000001"` |  |
| config.ue.dnn | string | `"internet"` |  |
| config.ue.hplmn.mcc | string | `"999"` |  |
| config.ue.hplmn.mnc | string | `"70"` |  |
| config.ue.key | string | `"491BB1C6E1179AED538028AE7AD525B3"` |  |
| config.ue.msin | string | `"0000000001"` |  |
| config.ue.opc | string | `"3B7FB099B3A6D16873B33F023B1679E9"` |  |
| config.ue.sd | string | `"ffffff"` |  |
| config.ue.sst | string | `"01"` |  |
| containerPorts.gtpu | int | `2152` |  |
| containerPorts.ngap | int | `9487` |  |
| containerSecurityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.privileged | bool | `true` |  |
| containerSecurityContext.runAsNonRoot | bool | `false` |  |
| customLivenessProbe | object | `{}` |  |
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
| image.repository | string | `"gradiant/packetrusher"` |  |
| image.tag | string | `"97f9f0c"` |  |
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
| services.ngap.annotations | object | `{}` |  |
| services.ngap.clusterIP | string | `""` |  |
| services.ngap.externalTrafficPolicy | string | `"Cluster"` |  |
| services.ngap.extraPorts | list | `[]` |  |
| services.ngap.loadBalancerIP | string | `""` |  |
| services.ngap.loadBalancerSourceRanges | list | `[]` |  |
| services.ngap.nodePorts.ngap | string | `""` |  |
| services.ngap.ports.ngap | int | `9487` |  |
| services.ngap.sessionAffinity | string | `"None"` |  |
| services.ngap.sessionAffinityConfig | object | `{}` |  |
| services.ngap.type | string | `"ClusterIP"` |  |
| sessionAffinity | string | `"None"` |  |
| sidecars | list | `[]` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

