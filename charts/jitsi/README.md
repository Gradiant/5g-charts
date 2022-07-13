# jitsi-meet

![Version: 1.2.2](https://img.shields.io/badge/Version-1.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: stable-6865](https://img.shields.io/badge/AppVersion-stable--6865-informational?style=flat-square)

A Helm chart for Kubernetes

## Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | prosody | 1.2.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableAuth | bool | `false` |  |
| enableGuests | bool | `true` |  |
| extraCommonEnvs | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.podAnnotations | object | `{}` |  |
| global.podLabels | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| imagePullSecrets | list | `[]` |  |
| jibri.breweryMuc | string | `"jibribrewery"` |  |
| jibri.enabled | bool | `false` |  |
| jibri.extraEnvs | object | `{}` |  |
| jibri.image.repository | string | `"jitsi/jibri"` |  |
| jibri.livenessProbe.exec.command[0] | string | `"pgrep"` |  |
| jibri.livenessProbe.exec.command[1] | string | `"java"` |  |
| jibri.persistence.enabled | bool | `false` |  |
| jibri.persistence.existingClaim | string | `nil` |  |
| jibri.persistence.size | string | `"4Gi"` |  |
| jibri.persistence.storageClassName | string | `nil` |  |
| jibri.readinessProbe.exec.command[0] | string | `"pgrep"` |  |
| jibri.readinessProbe.exec.command[1] | string | `"java"` |  |
| jibri.recorder.password | string | `nil` |  |
| jibri.recorder.user | string | `"recorder"` |  |
| jibri.shm.enabled | bool | `false` |  |
| jibri.timeout | int | `90` |  |
| jibri.xmpp.password | string | `nil` |  |
| jibri.xmpp.user | string | `"jibri"` |  |
| jicofo.affinity | object | `{}` |  |
| jicofo.extraEnvs | object | `{}` |  |
| jicofo.image.repository | string | `"jitsi/jicofo"` |  |
| jicofo.livenessProbe.tcpSocket.port | int | `8888` |  |
| jicofo.nodeSelector | object | `{}` |  |
| jicofo.podAnnotations | object | `{}` |  |
| jicofo.podLabels | object | `{}` |  |
| jicofo.podSecurityContext | object | `{}` |  |
| jicofo.readinessProbe.tcpSocket.port | int | `8888` |  |
| jicofo.replicaCount | int | `1` |  |
| jicofo.resources | object | `{}` |  |
| jicofo.securityContext | object | `{}` |  |
| jicofo.tolerations | list | `[]` |  |
| jicofo.xmpp.componentSecret | string | `nil` |  |
| jicofo.xmpp.password | string | `nil` |  |
| jicofo.xmpp.user | string | `"focus"` |  |
| jvb.UDPPort | int | `30000` |  |
| jvb.affinity | object | `{}` |  |
| jvb.breweryMuc | string | `"jvbbrewery"` |  |
| jvb.extraEnvs | object | `{}` |  |
| jvb.image.repository | string | `"jitsi/jvb"` |  |
| jvb.livenessProbe.httpGet.path | string | `"/about/health"` |  |
| jvb.livenessProbe.httpGet.port | int | `8080` |  |
| jvb.metrics.enabled | bool | `false` |  |
| jvb.metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| jvb.metrics.image.repository | string | `"docker.io/systemli/prometheus-jitsi-meet-exporter"` |  |
| jvb.metrics.image.tag | string | `"1.1.9"` |  |
| jvb.metrics.prometheusAnnotations | bool | `false` |  |
| jvb.metrics.resources.limits.cpu | string | `"20m"` |  |
| jvb.metrics.resources.limits.memory | string | `"32Mi"` |  |
| jvb.metrics.resources.requests.cpu | string | `"10m"` |  |
| jvb.metrics.resources.requests.memory | string | `"16Mi"` |  |
| jvb.metrics.serviceMonitor.enabled | bool | `true` |  |
| jvb.metrics.serviceMonitor.interval | string | `"10s"` |  |
| jvb.metrics.serviceMonitor.selector.release | string | `"prometheus-operator"` |  |
| jvb.nodeSelector | object | `{}` |  |
| jvb.podAnnotations | object | `{}` |  |
| jvb.podLabels | object | `{}` |  |
| jvb.podSecurityContext | object | `{}` |  |
| jvb.publicIP | string | `"1.2.3.4"` |  |
| jvb.readinessProbe.httpGet.path | string | `"/about/health"` |  |
| jvb.readinessProbe.httpGet.port | int | `8080` |  |
| jvb.replicaCount | int | `1` |  |
| jvb.resources | object | `{}` |  |
| jvb.securityContext | object | `{}` |  |
| jvb.service.annotations | object | `{}` |  |
| jvb.service.enabled | string | `nil` |  |
| jvb.service.externalIPs | list | `[]` |  |
| jvb.service.type | string | `"LoadBalancer"` |  |
| jvb.stunServers | string | `"meet-jit-si-turnrelay.jitsi.net:443"` |  |
| jvb.tolerations | list | `[]` |  |
| jvb.useHostPort | bool | `false` |  |
| jvb.websockets.enabled | bool | `false` |  |
| jvb.xmpp.password | string | `nil` |  |
| jvb.xmpp.user | string | `"jvb"` |  |
| nameOverride | string | `""` |  |
| octo.enabled | bool | `false` |  |
| prosody.enabled | bool | `true` |  |
| prosody.extraEnvFrom[0].secretRef.name | string | `"{{ include \"prosody.fullname\" . }}-jicofo"` |  |
| prosody.extraEnvFrom[1].secretRef.name | string | `"{{ include \"prosody.fullname\" . }}-jvb"` |  |
| prosody.extraEnvFrom[2].configMapRef.name | string | `"{{ include \"prosody.fullname\" . }}-common"` |  |
| prosody.image.repository | string | `"jitsi/prosody"` |  |
| prosody.image.tag | string | `"stable-6865"` |  |
| prosody.server | string | `nil` |  |
| publicURL | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| tz | string | `"Europe/Amsterdam"` |  |
| web.affinity | object | `{}` |  |
| web.extraEnvs | object | `{}` |  |
| web.httpRedirect | bool | `false` |  |
| web.httpsEnabled | bool | `false` |  |
| web.image.repository | string | `"jitsi/web"` |  |
| web.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| web.ingress.enabled | bool | `false` |  |
| web.ingress.hosts[0].host | string | `"jitsi.k8s.gradiant.org"` |  |
| web.ingress.hosts[0].paths[0] | string | `"/"` |  |
| web.ingress.tls[0].hosts[0] | string | `"jitsi.k8s.gradiant.org"` |  |
| web.ingress.tls[0].secretName | string | `"jitsi.k8s.gradiant.org-tls"` |  |
| web.livenessProbe.httpGet.path | string | `"/"` |  |
| web.livenessProbe.httpGet.port | int | `80` |  |
| web.nodeSelector | object | `{}` |  |
| web.podAnnotations | object | `{}` |  |
| web.podLabels | object | `{}` |  |
| web.podSecurityContext | object | `{}` |  |
| web.readinessProbe.httpGet.path | string | `"/"` |  |
| web.readinessProbe.httpGet.port | int | `80` |  |
| web.replicaCount | int | `1` |  |
| web.resources | object | `{}` |  |
| web.securityContext | object | `{}` |  |
| web.service.externalIPs | list | `[]` |  |
| web.service.port | int | `80` |  |
| web.service.type | string | `"ClusterIP"` |  |
| web.tolerations | list | `[]` |  |
| xmpp.authDomain | string | `nil` |  |
| xmpp.domain | string | `"meet.jitsi"` |  |
| xmpp.guestDomain | string | `nil` |  |
| xmpp.internalMucDomain | string | `nil` |  |
| xmpp.mucDomain | string | `nil` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
