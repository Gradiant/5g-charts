#!/bin/bash

# export KUBECONFIG and HELM_HOME if you need to
: {KUBECONFIG:="$HOME/.kube/config"}
echo "KUBECONFIG=$KUBECONFIG"
: ${HELM_HOME:="$HOME/.helm"}
echo "HELM_HOME=$HELM_HOME"

ARGS=$@

docker run -ti --rm \
  --net=host \
  -v $PWD:/gradiant \
  -v $HELM_HOME:/root/.helm:ro \
  -v $KUBECONFIG:/root/.kube/config:ro \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct $ARGS
