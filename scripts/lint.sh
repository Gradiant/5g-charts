#!/bin/bash


docker run -ti --rm \
  -v $PWD:/gradiant \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct lint \
     --chart-repos bitnami=https://charts.bitnami.com/bitnami \
     --validate-maintainers=false $@

