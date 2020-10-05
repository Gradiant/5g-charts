#!/bin/bash
FLAGS="--chart-repos bitnami=https://charts.bitnami.com/bitnami"

if [ "$#" -eq 1 ]; then
  FLAGS="$FLAGS --charts=charts/$1"
fi

KIND_KUBECONFIG="$PWD/scripts/kubeconfig"

KUBECONFIG=$KIND_KUBECONFIG kind create cluster --wait 1m
docker run -ti --rm \
  --net=host \
  -v $PWD:/gradiant \
  -v $HELM_HOME:/root/.helm:ro \
  -v $KIND_KUBECONFIG:/root/.kube/config:ro \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct lint-and-install $FLAGS --helm-extra-args "--timeout 300s"

kind delete cluster
rm $KIND_KUBECONFIG