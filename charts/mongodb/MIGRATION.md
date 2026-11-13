# Migrating an Open5GS component from Bitnami MongoDB

Open5GS 2.4.0 component charts use the local `mongodb` chart instead of the
Bitnami MongoDB chart. The Open5GS umbrella already uses this local chart.
This dependency change does not copy or convert an existing database.

## New installations

The local chart runs `mongo:8.0.34` as UID/GID 999, stores data in `/data/db`,
and creates a Service and StatefulSet named `<release>-mongodb`. Its default
PVC is `data-<release>-mongodb-0`, with an 8 GiB storage request.

HSS, PCRF and UDR enable their bundled MongoDB by default. PCF and WebUI keep
it disabled by default, so configure `dbURI` to use a shared database or enable
`mongodb.enabled` explicitly.

Supported database values include `image.repository`, `image.tag`,
`image.pullPolicy`, `resources`, `persistence.enabled`, `persistence.size`,
`persistence.storageClass`, `persistence.existingClaim`, and `service.port`.
Bitnami options such as architecture, credentials, fullname overrides and data
mount settings are not interchangeable with this chart. Authentication and
replica sets must use an external database; they are not configured locally.

## Existing installations with data

Do not point `persistence.existingClaim` directly at an old Bitnami volume.
Bitnami uses a different data layout under `/bitnami/mongodb`, different default
ownership and potentially a different MongoDB server version. Reusing that
volume unchanged can hide the existing database or prevent the server starting.
The change from a Deployment/PVC to a StatefulSet/volumeClaimTemplate also
requires planning the Helm upgrade rather than assuming resource replacement
will retain the original storage.

1. Record the original image/server version, Helm values, database URI, PVC and
   storage class. Check the supported backup/restore path into MongoDB 8.0;
   restoring data from a newer server may require another target version.
2. Preserve the original PVC and take a verified logical backup. For subscriber
   and account consistency, stop writes while taking the final backup.
3. Deploy the new database separately with a fresh PVC and restore the backup.
   `persistence.existingClaim` may reference a separately prepared volume with
   the target layout and ownership; it does not perform the migration.
4. Validate subscribers and WebUI accounts, and test UE registration and data
   traffic against the restored database.
5. Point the component's `dbURI` at the validated database and disable its bundled
   MongoDB. Keep the old deployment and backup available until validation is
   complete. Plan removal of old resources separately.

An external URI can be set per component, including authentication/TLS options
supported by its client. For a full core, configure the database-consuming
components and subscriber population consistently; the umbrella's `dbURI` is
not a global override for every subchart.

## Database readiness

Each database-consuming component, and the umbrella subscriber-population init
container, waits for a successful MongoDB `ping` before
starting its application. `mongodbWait.timeoutSeconds` defaults to 300 and
`mongodbWait.retryIntervalSeconds` to 5. The same check applies to `dbURI` for
an external database. A timeout fails the init container with a clear message;
Kubernetes may retry that init container according to its normal restart policy.
The timeout bounds each invocation, not the total lifetime of a Pod whose
init container keeps being retried.

The check runs as UID/GID 999, drops all capabilities and disallows privilege
escalation. It uses the official MongoDB image as a client, with configurable
image and resources. It does not add a Kubernetes device plugin or operator.
Setting `mongodbWait.enabled=false` skips this check. WebUI still creates its
initial administrator in a separate init container, which retries normally if
its database operation fails.

## Local regression checks

With Helm and Python 3 plus PyYAML installed:

```bash
python3 scripts/tests/test_mongodb.py
```

These checks cover dependency selection, URI consistency, external databases,
custom ports and init containers, existing claims, invalid timeouts, disabled
waits, authentication rejection and bounded client failures.
