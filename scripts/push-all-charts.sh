#!/bin/bash

REGISTRY=registry-1.docker.io/gradiantcharts

push_chart () {
    CHART=$1
    echo "Packaging chart '$CHART'..."
    helm dep update charts/$CHART
    helm package charts/$CHART
    echo "Push package '$CHART' to $REGISTRY ..."
    helm push $CHART*.tgz oci://$REGISTRY
}

helm registry login $REGISTRY

for dir in charts/*/ 
do
    dir=${dir%*/}      # remove the trailing "/"
    dir="${dir##*/}"    # print everything after the final "/"
    push_chart $dir
done