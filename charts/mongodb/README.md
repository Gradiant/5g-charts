# mongodb

Standalone MongoDB Community Server chart used by the Open5GS umbrella chart.

The default deployment uses the official Docker image `mongo:8.0.34`, listens
on port 27017, and requests an 8 GiB persistent volume mounted at `/data/db`.
Authentication is disabled, matching the Open5GS chart defaults.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `mongo` | MongoDB image repository |
| image.tag | string | `8.0.34` | MongoDB image tag |
| persistence.enabled | bool | `true` | Create persistent storage |
| persistence.size | string | `8Gi` | Persistent volume capacity |
| persistence.storageClass | string | `""` | Storage class; empty uses the cluster default |
| persistence.existingClaim | string | `""` | Optional pre-created PVC |
| resources | object | `{}` | Container resource requests and limits |
| service.port | int | `27017` | MongoDB service port |
