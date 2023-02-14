#!/bin/bash


docker run -ti --rm \
  -e HOME=$HOME \
  -v $HOME:/$HOME \
  -u $(id -u) \
  -v $PWD:/gradiant \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct lint \
     --chart-repos bitnami=https://charts.bitnami.com/bitnami \
     --validate-maintainers=false $@

