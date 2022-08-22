#!/bin/bash
NAMESPACE=`kubectl config view --minify -o jsonpath='{..namespace}'`
POD_NAME=`kubectl -n $NAMESPACE get pod --selector=app.kubernetes.io/name=mongodb -o jsonpath='{.items[*].metadata.name}'`

IMSI_LIST="999700000053410 "
KI=2C9623736F9F37BD7BF6F6797F3CA9AF
OPC=09C74182747FA179A650BBE2147FCCDC

for IMSI in $IMSI_LIST; do
kubectl -n $NAMESPACE exec $POD_NAME -- /bin/bash -c \
"mongo --eval \"db.subscribers.update({\\\"imsi\\\" : \\\"$IMSI\\\"}, { \\\$setOnInsert: { \\\"imsi\\\" : \\\"$IMSI\\\", \\\"subscribed_rau_tau_timer\\\" : NumberInt(12), \\\"network_access_mode\\\" : NumberInt(2), \\\"subscriber_status\\\" : NumberInt(0), \\\"access_restriction_data\\\" : NumberInt(32),  \\\"slice\\\" : [ { \\\"sst\\\": NumberInt(1), \\\"default_indicator\\\": true, \\\"session\\\": [{ \\\"name\\\": \\\"internet\\\", \\\"type\\\": NumberInt(3), \\\"pcc_rule\\\": [], \\\"ambr\\\": {\\\"uplink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0)}, \\\"downlink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0) } }, \\\"qos\\\": { \\\"index\\\": NumberInt(9), \\\"arp\\\": {\\\"priority_level\\\": NumberInt(8), \\\"pre_emption_capability\\\": NumberInt(1), \\\"pre_emption_vulnerability\\\": NumberInt(1)} } } ] } ],  \\\"ambr\\\": {\\\"uplink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0)}, \\\"downlink\\\": {\\\"value\\\": NumberInt(1), \\\"unit\\\": NumberInt(0) } }, \\\"security\\\" : { \\\"k\\\" : \\\"$KI\\\", \\\"amf\\\" : \\\"8000\\\", \\\"op\\\" : null, \\\"opc\\\" : \\\"$OPC\\\" }, \\\"__v\\\" : 0 } }, upsert=true);\" open5gs "
done
