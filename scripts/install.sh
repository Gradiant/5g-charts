#!/bin/bash

kind create cluster --name charttest --wait 1m

docker run -ti --rm \
  --net=host \
  -u $(id -u) \
  -e HOME=$HOME \
  -v $HOME:/$HOME \
  -v $PWD:/gradiant \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct install \
     --chart-repos bitnami=https://charts.bitnami.com/bitnami $@

kind delete cluster --name charttest
