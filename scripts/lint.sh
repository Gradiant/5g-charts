#!/bin/bash

if [ "$#" -eq 1 ]; then
  FLAGS="$FLAGS --charts=charts/$1"
fi

CT_CONFIG="$PWD/scripts/ct-config.yaml"

docker run -ti --rm \
  --net=host \
  -u $(id -u) \
  -e HOME=/tmp \
  -v $KIND_KUBECONFIG:/tmp/.kube/config:ro \
  -v $PWD:/gradiant \
  -v $CT_CONFIG:/tmp/ct.yaml \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct lint --config /tmp/ct.yaml

