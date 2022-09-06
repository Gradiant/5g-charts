#!/bin/bash

echo "Deploying kind cluster"
kind create cluster --name charttest --wait 1m
echo "Deploying metallb loadBalancer"
kind_IP=$(docker network inspect -f '{{index (index .IPAM.Config 0) "Gateway" }}' kind)
kubectl --kubeconfig=$kind_kubeconfig apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl --kubeconfig=$kind_kubeconfig apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
cat <<EOF | kubectl apply --kubeconfig=$kind_kubeconfig -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - ${kind_IP}00-${kind_IP}20
EOF
echo "Waiting for local-path-provisioner to be ready"
kubectl rollout status deployment -n local-path-storage local-path-provisioner --timeout=90s

docker run -ti --rm \
  --net=host \
  -u $(id -u) \
  -e HOME=$HOME \
  -v $HOME:/$HOME \
  -v $PWD:/gradiant \
  --workdir=/gradiant quay.io/helmpack/chart-testing ct install \
     --chart-repos bitnami=https://charts.bitnami.com/bitnami $@

echo "deleting kind cluster"
kind delete cluster --name charttest
