#!/bin/bash

REGISTRY=registry-1.docker.io/gradiantcharts

push_metadata () {
  oras push \
  $REGISTRY/$1:artifacthub.io \
  --config /dev/null:application/vnd.cncf.artifacthub.config.v1+yaml \
  charts/$1/artifacthub-repo.yml:application/vnd.cncf.artifacthub.repository-metadata.layer.v1.yaml
}

docker login

for dir in charts/*/ 
do
    dir=${dir%*/}      # remove the trailing "/"
    dir="${dir##*/}"    # print everything after the final "/"
    push_metadata $dir
done