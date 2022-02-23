# open5gs

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![AppVersion: 2.4.4](https://img.shields.io/badge/AppVersion-2.4.4-informational?style=flat-square)

Helm chart to deploy Open5gs services on Kubernetes.

**Homepage:** <https://github.com/gradiant/openverso-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cgiraldo | cgiraldo@gradiant.org |  |

## Source Code

* <http://open5gs.org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | common | 1.x.x |
| https://charts.bitnami.com/bitnami | mongodb | ~9.2.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| amf.enabled | bool | `true` |  |
| amf.externalService.advertiseDomain | string | `"ext.lab5g.gradiant.org"` |  |
| amf.externalService.enabled | bool | `false` |  |
| amf.externalService.externalTrafficPolicy | string | `"Local"` |  |
| amf.externalService.loadBalancerIP | string | `nil` |  |
| amf.externalService.loadBalancerSourceRanges | list | `[]` |  |
| amf.externalService.type | string | `"LoadBalancer"` |  |
| amf.guami[0].amf_id.region | int | `2` |  |
| amf.guami[0].amf_id.set | int | `1` |  |
| amf.guami[0].plmn_id.mcc | int | `999` |  |
| amf.guami[0].plmn_id.mnc | int | `70` |  |
| amf.logger.level | string | `"info"` |  |
| amf.parameter | object | `{}` |  |
| amf.plmn_support[0].plmn_id.mcc | int | `999` |  |
| amf.plmn_support[0].plmn_id.mnc | int | `70` |  |
| amf.plmn_support[0].s_nssai[0].sd | string | `"ffffff"` |  |
| amf.plmn_support[0].s_nssai[0].sst | string | `"1"` |  |
| amf.resources | object | `{}` |  |
| amf.tai[0].plmn_id.mcc | int | `999` |  |
| amf.tai[0].plmn_id.mnc | int | `70` |  |
| amf.tai[0].tac | int | `1` |  |
| ausf.enabled | bool | `true` |  |
| ausf.logger.level | string | `"info"` |  |
| ausf.parameter | object | `{}` |  |
| ausf.resources | object | `{}` |  |
| bsf.enabled | bool | `true` |  |
| bsf.logger.level | string | `"info"` |  |
| bsf.parameter | object | `{}` |  |
| bsf.resources | object | `{}` |  |
| hss.enabled | bool | `true` |  |
| hss.logger.level | string | `"info"` |  |
| hss.resources | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"openverso/open5gs"` |  |
| image.tag | string | `"2.4.4"` |  |
| mme.enabled | bool | `true` |  |
| mme.externalService.enabled | bool | `false` |  |
| mme.externalService.externalTrafficPolicy | string | `"Local"` |  |
| mme.externalService.loadBalancerIP | string | `nil` |  |
| mme.externalService.loadBalancerSourceRanges | list | `[]` |  |
| mme.externalService.type | string | `"LoadBalancer"` |  |
| mme.gummei.mme_code | int | `1` |  |
| mme.gummei.mme_gid | int | `2` |  |
| mme.gummei.plmn_id.mcc | int | `999` |  |
| mme.gummei.plmn_id.mnc | int | `70` |  |
| mme.logger.level | string | `"info"` |  |
| mme.parameter | object | `{}` |  |
| mme.resources | object | `{}` |  |
| mme.tai.plmn_id.mcc | int | `999` |  |
| mme.tai.plmn_id.mnc | int | `70` |  |
| mme.tai.tac | int | `1` |  |
| mongodb | object | `{"auth":{"enabled":false},"enabled":true}` | pass vars towards mongodb chart, from dependencies |
| mongodb.enabled | bool | `true` | set to 'false' to disable automatically deploying dependent charts |
| nrf.enabled | bool | `true` |  |
| nrf.logger.level | string | `"info"` |  |
| nrf.parameter | object | `{}` |  |
| nrf.resources | object | `{}` |  |
| nssf.enabled | bool | `true` |  |
| nssf.logger.level | string | `"info"` |  |
| nssf.nsi[0].sd | string | `"ffffff"` |  |
| nssf.nsi[0].sst | string | `"1"` |  |
| nssf.parameter | object | `{}` |  |
| nssf.resources | object | `{}` |  |
| pcf.enabled | bool | `true` |  |
| pcf.logger.level | string | `"info"` |  |
| pcf.parameter | object | `{}` |  |
| pcf.resources | object | `{}` |  |
| pcrf.enabled | bool | `true` |  |
| pcrf.logger.level | string | `"info"` |  |
| pcrf.parameter | string | `nil` |  |
| pcrf.resources | object | `{}` |  |
| securityPolicy.enabled | bool | `false` |  |
| sgwc.enabled | bool | `true` |  |
| sgwc.logger.level | string | `"info"` |  |
| sgwc.max | object | `{}` |  |
| sgwc.parameter.no_ipv6 | bool | `true` |  |
| sgwc.pool | object | `{}` |  |
| sgwc.resources | object | `{}` |  |
| sgwu.enabled | bool | `true` |  |
| sgwu.externalService.advertiseDomain | string | `"ext.lab5g.gradiant.org"` |  |
| sgwu.externalService.enabled | bool | `false` |  |
| sgwu.externalService.externalTrafficPolicy | string | `"Local"` |  |
| sgwu.externalService.loadBalancerIP | string | `nil` |  |
| sgwu.externalService.loadBalancerSourceRanges | list | `[]` |  |
| sgwu.externalService.type | string | `"LoadBalancer"` |  |
| sgwu.logger.level | string | `"info"` |  |
| sgwu.max | object | `{}` |  |
| sgwu.parameter.no_ipv6 | bool | `true` |  |
| sgwu.pool | object | `{}` |  |
| sgwu.resources | object | `{}` |  |
| smf.enabled | bool | `true` |  |
| smf.logger.level | string | `"info"` |  |
| smf.parameter | object | `{}` |  |
| smf.pdn.addr | string | `"10.45.0.1/16"` |  |
| smf.resources | object | `{}` |  |
| udm.enabled | bool | `true` |  |
| udm.logger.level | string | `"info"` |  |
| udm.parameter | object | `{}` |  |
| udm.resources | object | `{}` |  |
| udr.enabled | bool | `true` |  |
| udr.logger.level | string | `"info"` |  |
| udr.parameter | object | `{}` |  |
| udr.resources | object | `{}` |  |
| upf.enabled | bool | `true` |  |
| upf.externalService.advertiseDomain | string | `"ext.lab5g.gradiant.org"` |  |
| upf.externalService.enabled | bool | `false` |  |
| upf.externalService.externalTrafficPolicy | string | `"Local"` |  |
| upf.externalService.loadBalancerIP | string | `nil` |  |
| upf.externalService.loadBalancerSourceRanges | list | `[]` |  |
| upf.externalService.type | string | `"LoadBalancer"` |  |
| upf.logger.level | string | `"info"` |  |
| upf.parameter | object | `{}` |  |
| upf.pdn.addr | string | `"10.45.0.1/16"` |  |
| upf.resources | object | `{}` |  |
| webui.enabled | bool | `true` |  |
| webui.image.pullPolicy | string | `"IfNotPresent"` |  |
| webui.image.registry | string | `"docker.io"` |  |
| webui.image.repository | string | `"openverso/open5gs-webui"` |  |
| webui.image.tag | string | `"2.3.3"` |  |
| webui.ingress.annotations | object | `{}` |  |
| webui.ingress.certManager | bool | `false` |  |
| webui.ingress.enabled | bool | `true` |  |
| webui.ingress.hostname | string | `nil` |  |
| webui.ingress.path | string | `"/"` |  |
| webui.ingress.pathType | string | `"ImplementationSpecific"` |  |
| webui.ingress.tls | bool | `false` |  |
| webui.resources | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
