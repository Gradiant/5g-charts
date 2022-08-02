#!/bin/bash

echo "Changing ue default gateway to use dataplane"
kubectl -n test exec lte-srs-lte-ue-0 -- ip route replace default dev tun_srsue

echo "Traceroute to google.es from ue"
kubectl -n test exec lte-srs-lte-ue-0 -- traceroute google.es

