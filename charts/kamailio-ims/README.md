# kamailio-ims

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![AppVersion: 5.3](https://img.shields.io/badge/AppVersion-5.3-informational?style=flat-square)

Helm chart to deploy Kamailio IMS on Kubernetes.

**Homepage:** <https://github.com/gradiant/openverso-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| mmarquez999 | <mmarquez@gradiant.org> |  |

## Source Code

* <https://github.com/kamailio/kamailio>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |
| https://charts.bitnami.com/bitnami | mariadb(mariadb) | 11.3.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apnImsSubnet | string | `"192.168.101.0/24"` |  |
| bind9.global.imagePullSecrets | list | `[]` |  |
| bind9.global.imageRegistry | string | `""` |  |
| bind9.global.storageClass | string | `""` |  |
| bind9.hostname | string | `"bind9"` |  |
| bind9.image.debug | bool | `false` |  |
| bind9.image.digest | string | `""` |  |
| bind9.image.pullPolicy | string | `"IfNotPresent"` |  |
| bind9.image.pullSecrets | list | `[]` |  |
| bind9.image.registry | string | `"docker.io"` |  |
| bind9.image.repository | string | `"internetsystemsconsortium/bind9"` |  |
| bind9.image.tag | string | `"9.18"` |  |
| bind9.livenessProbe.enabled | bool | `true` |  |
| bind9.podAnnotations | object | `{}` |  |
| bind9.readinessProbe.enabled | bool | `true` |  |
| bind9.replicaCount | int | `1` |  |
| bind9.resources.limits | object | `{}` |  |
| bind9.resources.requests | object | `{}` |  |
| bind9.services.dns.annotations | object | `{}` |  |
| bind9.services.dns.port | int | `53` |  |
| bind9.services.dns.type | string | `"ClusterIP"` |  |
| bind9.services.labels | string | `nil` |  |
| bind9.services.rndc.annotations | object | `{}` |  |
| bind9.services.rndc.port | int | `953` |  |
| bind9.services.rndc.type | string | `"ClusterIP"` |  |
| epc.pcrfHostname | string | `"pcrf"` |  |
| epc.upfHostname | string | `"upf"` |  |
| epcDomain | string | `"openverso"` |  |
| fhoss.global.imagePullSecrets | list | `[]` |  |
| fhoss.global.imageRegistry | string | `""` |  |
| fhoss.global.storageClass | string | `""` |  |
| fhoss.hostname | string | `"fhoss"` |  |
| fhoss.image.debug | bool | `false` |  |
| fhoss.image.digest | string | `""` |  |
| fhoss.image.pullPolicy | string | `"IfNotPresent"` |  |
| fhoss.image.pullSecrets | list | `[]` |  |
| fhoss.image.registry | string | `"docker.io"` |  |
| fhoss.image.repository | string | `"openverso/fhoss"` |  |
| fhoss.image.tag | string | `"develop"` |  |
| fhoss.livenessProbe.enabled | bool | `true` |  |
| fhoss.podAnnotations | object | `{}` |  |
| fhoss.readinessProbe.enabled | bool | `true` |  |
| fhoss.replicaCount | int | `1` |  |
| fhoss.resources.limits | object | `{}` |  |
| fhoss.resources.requests | object | `{}` |  |
| fhoss.services.frdi.annotations | object | `{}` |  |
| fhoss.services.frdi.port | int | `3868` |  |
| fhoss.services.frdi.type | string | `"ClusertIP"` |  |
| fhoss.services.http.annotations | object | `{}` |  |
| fhoss.services.http.port | int | `8080` |  |
| fhoss.services.http.type | string | `"ClusterIP"` |  |
| fhoss.services.labels | string | `nil` |  |
| imsDomain | string | `"ims.mnc001.mcc001.3gppnetwork.org"` |  |
| kamailio.global.imagePullSecrets | list | `[]` |  |
| kamailio.global.imageRegistry | string | `""` |  |
| kamailio.global.storageClass | string | `""` |  |
| kamailio.icscf.hostname | string | `"icscf"` |  |
| kamailio.icscf.livenessProbe.enabled | bool | `true` |  |
| kamailio.icscf.podAnnotations | object | `{}` |  |
| kamailio.icscf.readinessProbe.enabled | bool | `true` |  |
| kamailio.icscf.resources.limits | object | `{}` |  |
| kamailio.icscf.resources.requests | object | `{}` |  |
| kamailio.icscf.services.frdi.annotations | object | `{}` |  |
| kamailio.icscf.services.frdi.port | int | `3869` |  |
| kamailio.icscf.services.frdi.type | string | `"ClusterIP"` |  |
| kamailio.icscf.services.labels | string | `nil` |  |
| kamailio.icscf.services.sip.annotations | object | `{}` |  |
| kamailio.icscf.services.sip.port | int | `4060` |  |
| kamailio.icscf.services.sip.type | string | `"ClusterIP"` |  |
| kamailio.image.debug | bool | `false` |  |
| kamailio.image.digest | string | `""` |  |
| kamailio.image.pullPolicy | string | `"IfNotPresent"` |  |
| kamailio.image.pullSecrets | list | `[]` |  |
| kamailio.image.registry | string | `"docker.io"` |  |
| kamailio.image.repository | string | `"openverso/kamailio-ims"` |  |
| kamailio.image.tag | string | `"5.3-dev"` |  |
| kamailio.pcscf.containerSecurityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| kamailio.pcscf.containerSecurityContext.enabled | bool | `true` |  |
| kamailio.pcscf.containerSecurityContext.privileged | bool | `false` |  |
| kamailio.pcscf.containerSecurityContext.runAsNonRoot | bool | `false` |  |
| kamailio.pcscf.hostname | string | `"pcscf"` |  |
| kamailio.pcscf.livenessProbe.enabled | bool | `true` |  |
| kamailio.pcscf.podAnnotations | object | `{}` |  |
| kamailio.pcscf.readinessProbe.enabled | bool | `true` |  |
| kamailio.pcscf.resources.limits | object | `{}` |  |
| kamailio.pcscf.resources.requests | object | `{}` |  |
| kamailio.pcscf.services.frdi.annotations | object | `{}` |  |
| kamailio.pcscf.services.frdi.port | int | `3871` |  |
| kamailio.pcscf.services.frdi.type | string | `"ClusterIP"` |  |
| kamailio.pcscf.services.ipsec.annotations | object | `{}` |  |
| kamailio.pcscf.services.ipsec.client.port | int | `5100` |  |
| kamailio.pcscf.services.ipsec.server.port | int | `6100` |  |
| kamailio.pcscf.services.ipsec.type | string | `"ClusterIP"` |  |
| kamailio.pcscf.services.labels | string | `nil` |  |
| kamailio.pcscf.services.sip.annotations | object | `{}` |  |
| kamailio.pcscf.services.sip.port | int | `5060` |  |
| kamailio.pcscf.services.sip.type | string | `"ClusterIP"` |  |
| kamailio.replicaCount | int | `1` |  |
| kamailio.scscf.hostname | string | `"scscf"` |  |
| kamailio.scscf.livenessProbe.enabled | bool | `true` |  |
| kamailio.scscf.podAnnotations | object | `{}` |  |
| kamailio.scscf.readinessProbe.enabled | bool | `true` |  |
| kamailio.scscf.resources.limits | object | `{}` |  |
| kamailio.scscf.resources.requests | object | `{}` |  |
| kamailio.scscf.services.frdi.annotations | object | `{}` |  |
| kamailio.scscf.services.frdi.port | int | `3870` |  |
| kamailio.scscf.services.frdi.type | string | `"ClusterIP"` |  |
| kamailio.scscf.services.labels | string | `nil` |  |
| kamailio.scscf.services.sip.annotations | object | `{}` |  |
| kamailio.scscf.services.sip.port | int | `6060` |  |
| kamailio.scscf.services.sip.type | string | `"ClusterIP"` |  |
| mariadb.auth.rootPassword | string | `"ims"` |  |
| mariadb.hostname | string | `"mariadb"` |  |
| mariadb.image.tag | string | `"10.9.3"` |  |
| mariadb.initdbScriptsConfigMap | string | `"kamailio-ims-mariadb-entrypoint"` |  |
| mariadb.primary.existingConfigmap | string | `"kamailio-ims-mariadb-conf"` |  |
| mariadb.primary.persistence.enabled | bool | `true` |  |
| rtpengine.containerSecurityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| rtpengine.containerSecurityContext.enabled | bool | `true` |  |
| rtpengine.containerSecurityContext.privileged | bool | `false` |  |
| rtpengine.containerSecurityContext.runAsNonRoot | bool | `false` |  |
| rtpengine.gatewayHostname | string | `"upf"` |  |
| rtpengine.global.imagePullSecrets | list | `[]` |  |
| rtpengine.global.imageRegistry | string | `""` |  |
| rtpengine.global.storageClass | string | `""` |  |
| rtpengine.hostname | string | `"rtpengine"` |  |
| rtpengine.image.debug | bool | `false` |  |
| rtpengine.image.digest | string | `""` |  |
| rtpengine.image.pullPolicy | string | `"IfNotPresent"` |  |
| rtpengine.image.pullSecrets | list | `[]` |  |
| rtpengine.image.registry | string | `"docker.io"` |  |
| rtpengine.image.repository | string | `"openverso/rtpengine"` |  |
| rtpengine.image.tag | string | `"9.4.1.1"` |  |
| rtpengine.livenessProbe.enabled | bool | `true` |  |
| rtpengine.podAnnotations | object | `{}` |  |
| rtpengine.portMaxRtp | int | `50000` |  |
| rtpengine.portMinRtp | int | `49000` |  |
| rtpengine.readinessProbe.enabled | bool | `true` |  |
| rtpengine.replicaCount | int | `1` |  |
| rtpengine.resources.limits | object | `{}` |  |
| rtpengine.resources.requests | object | `{}` |  |
| rtpengine.services.labels | string | `nil` |  |
| rtpengine.services.ng.annotations | object | `{}` |  |
| rtpengine.services.ng.port | int | `2223` |  |
| rtpengine.services.ng.type | string | `"ClusterIP"` |  |
| rtpengine.services.rtp.annotations | object | `{}` |  |
| rtpengine.services.rtp.clusterIP | string | `"None"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
