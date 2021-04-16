#!/bin/bash
NAMESPACE=test
POD_NAME=`kubectl -n $NAMESPACE get pod --selector=app.kubernetes.io/name=mongodb -o jsonpath='{.items[*].metadata.name}'`

#IMSI_LIST="901700000039226 "
#KI=491BB1C6E1179AED538028AE7AD525B3
#OPC=3B7FB099B3A6D16873B33F023B1679E9

IMSI_LIST="001010000000001 "
KI=465B5CE8B199B49FAA5F0A2EE238A6BC
OPC=E8ED289DEBA952E4283B54E88E6183CA

for IMSI in $IMSI_LIST; do
kubectl -n $NAMESPACE exec $POD_NAME -- /bin/bash -c \
"mongo --eval \"db.subscribers.update({\\\"imsi\\\" : \\\"$IMSI\\\"}, { \\\$setOnInsert: { \\\"imsi\\\" : \\\"$IMSI\\\", \\\"subscribed_rau_tau_timer\\\" : NumberInt(12), \\\"network_access_mode\\\" : NumberInt(2), \\\"subscriber_status\\\" : NumberInt(0), \\\"access_restriction_data\\\" : NumberInt(32),  \\\"slice\\\" : [ { \\\"sst\\\": NumberInt(1), \\\"default_indicator\\\": true, \\\"session\\\": [{ \\\"name\\\": \\\"internet\\\", \\\"type\\\": NumberInt(3), \\\"pcc_rule\\\": [], \\\"ambr\\\": {\\\"uplink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0)}, \\\"downlink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0) } }, \\\"qos\\\": { \\\"index\\\": NumberInt(9), \\\"arp\\\": {\\\"priority_level\\\": NumberInt(8), \\\"pre_emption_capability\\\": NumberInt(1), \\\"pre_emption_vulnerability\\\": NumberInt(1)} } } ] } ],  \\\"ambr\\\": {\\\"uplink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0)}, \\\"downlink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0) } }, \\\"security\\\" : { \\\"k\\\" : \\\"$KI\\\", \\\"amf\\\" : \\\"8000\\\", \\\"op\\\" : null, \\\"opc\\\" : \\\"$OPC\\\" }, \\\"__v\\\" : 0 } }, upsert=true);\" open5gs "
done
