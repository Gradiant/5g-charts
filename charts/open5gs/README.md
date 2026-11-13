# open5gs

![Version: 2.4.0](https://img.shields.io/badge/Version-2.4.0-informational?style=flat-square) ![AppVersion: 2.8.0](https://img.shields.io/badge/AppVersion-2.8.0-informational?style=flat-square)

Helm chart to deploy Open5gs services on Kubernetes.

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
| file://../mongodb | mongodb | ~0.1.0 |
| file://../open5gs-amf | amf(open5gs-amf) | ~2.4.0 |
| file://../open5gs-ausf | ausf(open5gs-ausf) | ~2.4.0 |
| file://../open5gs-bsf | bsf(open5gs-bsf) | ~2.4.0 |
| file://../open5gs-hss | hss(open5gs-hss) | ~2.4.0 |
| file://../open5gs-mme | mme(open5gs-mme) | ~2.4.0 |
| file://../open5gs-nrf | nrf(open5gs-nrf) | ~2.4.0 |
| file://../open5gs-nssf | nssf(open5gs-nssf) | ~2.4.0 |
| file://../open5gs-pcf | pcf(open5gs-pcf) | ~2.4.0 |
| file://../open5gs-pcrf | pcrf(open5gs-pcrf) | ~2.4.0 |
| file://../open5gs-scp | scp(open5gs-scp) | ~2.4.0 |
| file://../open5gs-sepp | sepp(open5gs-sepp) | ~2.4.0 |
| file://../open5gs-sgwc | sgwc(open5gs-sgwc) | ~2.4.0 |
| file://../open5gs-sgwu | sgwu(open5gs-sgwu) | ~2.4.0 |
| file://../open5gs-smf | smf(open5gs-smf) | ~2.4.0 |
| file://../open5gs-udm | udm(open5gs-udm) | ~2.4.0 |
| file://../open5gs-udr | udr(open5gs-udr) | ~2.4.0 |
| file://../open5gs-upf | upf(open5gs-upf) | ~2.4.0 |
| file://../open5gs-webui | webui(open5gs-webui) | ~2.4.0 |
| https://charts.bitnami.com/bitnami | common | 2.x.x |

## Health probes

5G SBI components, WebUI and UPF enable startup probes and remove the previous
fixed readiness/liveness delays. Startup allows approximately five minutes of
failures and completes as soon as its check succeeds. Configure probes per
component, for example `nrf.startupProbe` or `upf.customReadinessProbe`; custom
probes take priority over the corresponding defaults. MongoDB also has its own
configurable startup/readiness/liveness checks. The database wait init
containers run before application probes and keep their separate timeout.

Open5GS application Services in the 5G/WebUI/UPF charts respect readiness; their
`services.<name>.publishNotReadyAddresses` flags allow explicit bootstrap
overrides. Metrics remain published for diagnostics.

HSS, MME, PCRF, SGWC and SGWU retain custom probes only. No new generic SBI
probe is applied to these different protocols. Socket checks do not establish
end-to-end 5G readiness or detect every application deadlock.

Render regression checks require Helm, Python 3 and PyYAML:

```bash
python3 scripts/tests/test_probes.py
```

## MongoDB startup

Database-consuming components wait for MongoDB before starting. Configure their
waits through `pcf.mongodbWait`, `udr.mongodbWait`, `hss.mongodbWait`,
`pcrf.mongodbWait`, or `webui.mongodbWait`. Subscriber population has the same
check under `populate.mongodbWait`. The default timeout is 300 seconds;
the same check applies when a component uses an external `dbURI`.

The shared database and standalone component dependencies use the local MongoDB
chart. Read the [MongoDB migration notes](../mongodb/MIGRATION.md) before upgrading
standalone installations that previously deployed Bitnami MongoDB.

## PFCP addressing

The UPF advertises its PFCP Service DNS name so the SMF uses the same endpoint
for association and subsequent PFCP messages. This avoids mixing the Service
address with the Pod address across Kubernetes UDP connection tracking.
Override `upf.config.upf.pfcp.advertise` when deploying with a different PFCP
network topology.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| amf.enabled | bool | `true` |  |
| ausf.enabled | bool | `true` |  |
| bsf.enabled | bool | `true` |  |
| dbURI | string | `"mongodb://{{ .Release.Name }}-mongodb/open5gs"` | MongoDB URI for subscriber population; configure database-consuming subcharts separately. Helm templating is supported. |
| hss.enabled | bool | `true` |  |
| hss.mongodb.enabled | bool | `false` | Deploy the bundled local MongoDB chart; disable it when using an external database. |
| mme.enabled | bool | `true` |  |
| mongodb.auth.enabled | bool | `false` | The local MongoDB chart does not implement authentication; keep false or use an authenticated external database. |
| mongodb.enabled | bool | `true` | Deploy the bundled local MongoDB chart; disable it when using an external database. |
| mongodb.image.repository | string | `"mongo"` | Container image repository. |
| mongodb.image.tag | string | `"8.0.34"` | Container image tag. |
| mongodb.persistence.enabled | bool | `true` | Use persistent storage; disabling it uses ephemeral storage. |
| mongodb.persistence.size | string | `"8Gi"` | Requested PVC capacity as a Kubernetes quantity, for example 8Gi. |
| nrf.enabled | bool | `true` |  |
| nssf.enabled | bool | `true` |  |
| pcf.enabled | bool | `true` |  |
| pcf.mongodb.enabled | bool | `false` | Deploy the bundled local MongoDB chart; disable it when using an external database. |
| pcrf.enabled | bool | `true` |  |
| pcrf.mongodb.enabled | bool | `false` | Deploy the bundled local MongoDB chart; disable it when using an external database. |
| populate.enabled | bool | `true` |  |
| populate.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| populate.image.registry | string | `"docker.io"` | Container image registry. |
| populate.image.repository | string | `"gradiant/open5gs-dbctl"` | Container image repository. |
| populate.image.tag | string | `"0.10.3"` | Container image tag. |
| populate.initCommands | list | `[]` |  |
| populate.mongodbWait.enabled | bool | `true` | Wait for a successful MongoDB ping before application or subscriber initialization. |
| populate.mongodbWait.image.digest | string | `""` | Optional image digest; takes precedence over the tag. |
| populate.mongodbWait.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy: Always, IfNotPresent or Never. |
| populate.mongodbWait.image.registry | string | `"docker.io"` | Container image registry. |
| populate.mongodbWait.image.repository | string | `"library/mongo"` | Container image repository. |
| populate.mongodbWait.image.tag | string | `"8.0.34"` | Container image tag. |
| populate.mongodbWait.resources.limits.cpu | string | `"1"` | Container cpu limit as a Kubernetes quantity (for example 100m). |
| populate.mongodbWait.resources.limits.memory | string | `"512Mi"` | Container memory limit as a Kubernetes quantity (for example 128Mi). |
| populate.mongodbWait.resources.requests.cpu | string | `"50m"` | Container cpu request as a Kubernetes quantity (for example 100m). |
| populate.mongodbWait.resources.requests.memory | string | `"128Mi"` | Container memory request as a Kubernetes quantity (for example 128Mi). |
| populate.mongodbWait.retryIntervalSeconds | int | `5` | Delay between unsuccessful connection attempts in seconds (1-3600). |
| populate.mongodbWait.timeoutSeconds | int | `300` | Maximum wait per init-container attempt in seconds (1-86400), not a fixed delay; Kubernetes may retry failed attempts. |
| populate.serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| populate.serviceAccount.automountServiceAccountToken | bool | `false` | Mount an API token; populate does not use the Kubernetes API |
| populate.serviceAccount.create | bool | `true` | Create a ServiceAccount for the populate Deployment |
| populate.serviceAccount.name | string | `""` | The ServiceAccount to use; empty uses the fullname with a -populate suffix when create is true, otherwise default |
| scp.enabled | bool | `true` |  |
| scp.mongodb.enabled | bool | `false` | Compatibility value; the SCP chart does not deploy MongoDB. |
| sepp.enabled | bool | `true` |  |
| sgwc.enabled | bool | `true` |  |
| sgwu.enabled | bool | `true` |  |
| smf.enabled | bool | `true` |  |
| udm.enabled | bool | `true` |  |
| udr.enabled | bool | `true` |  |
| udr.mongodb.enabled | bool | `false` | Deploy the bundled local MongoDB chart; disable it when using an external database. |
| upf.config.upf.pfcp.advertise | string | `"{{ include \"common.names.fullname\" . }}-pfcp.{{ .Release.Namespace }}.svc.{{ default \"cluster.local\" .Values.clusterDomain }}"` | PFCP identity advertised by UPF; the umbrella uses its PFCP Service DNS name to keep peer addressing consistent. |
| upf.enabled | bool | `true` |  |
| webui.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
