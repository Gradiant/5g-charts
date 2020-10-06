#!/bin/bash
FLAGS="--chart-repos bitnami=https://charts.bitnami.com/bitnami"

if [ "$#" -eq 1 ]; then
  FLAGS="$FLAGS --charts=charts/$1"
fi

KIND_KUBECONFIG="$PWD/scripts/kubeconfig"

KUBECONFIG=$KIND_KUBECONFIG kind create cluster --wait 1m
docker run -ti --rm \
  --net=host \
  -u $(id -u) \
  -e HOME=/tmp \
  -v $KIND_KUBECONFIG:/tmp/.kube/config:ro \
  -v $PWD:/gradiant \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct lint-and-install $FLAGS --helm-extra-args "--timeout 300s"

kind delete cluster
rm $KIND_KUBECONFIG