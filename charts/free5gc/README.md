# free5gc

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 3.4.2](https://img.shields.io/badge/AppVersion-3.4.2-informational?style=flat-square)

Helm chart to deploy Free5GC services on Kubernetes.

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
| file://../free5gc-amf | amf(free5gc-amf) | ~0.1.0 |
| file://../free5gc-ausf | ausf(free5gc-ausf) | ~0.1.0 |
| file://../free5gc-chf | chf(free5gc-chf) | ~0.1.0 |
| file://../free5gc-nrf | nrf(free5gc-nrf) | ~0.1.0 |
| file://../free5gc-nssf | nssf(free5gc-nssf) | ~0.1.0 |
| file://../free5gc-pcf | pcf(free5gc-pcf) | ~0.1.0 |
| file://../free5gc-smf | smf(free5gc-smf) | ~0.1.0 |
| file://../free5gc-udm | udm(free5gc-udm) | ~0.1.0 |
| file://../free5gc-udr | udr(free5gc-udr) | ~0.1.0 |
| file://../free5gc-upf | upf(free5gc-upf) | ~0.1.0 |
| file://../free5gc-webui | webui(free5gc-webui) | ~0.1.0 |
| https://charts.bitnami.com/bitnami | common | 1.x.x |
| https://charts.bitnami.com/bitnami | mongodb | ~12.1.19 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| amf.enabled | bool | `true` |  |
| ausf.enabled | bool | `true` |  |
| chf.enabled | bool | `true` |  |
| mongodb.auth.enabled | bool | `false` |  |
| mongodb.enabled | bool | `true` |  |
| nrf.enabled | bool | `true` |  |
| nssf.enabled | bool | `true` |  |
| pcf.enabled | bool | `true` |  |
| smf.enabled | bool | `true` |  |
| udm.enabled | bool | `true` |  |
| udr.enabled | bool | `true` |  |
| upf.enabled | bool | `true` |  |
| webui.enabled | bool | `true` |  |

