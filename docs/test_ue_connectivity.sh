#!/bin/bash

echo "Changing ue default gateway to use dataplane"
kubectl exec ue-srs-ue-0 -- ip route replace default dev tun_srsue

echo "Traceroute to google.es from ue"
kubectl exec ue-srs-ue-0 -- traceroute google.es

