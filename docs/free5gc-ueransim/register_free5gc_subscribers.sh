#!/bin/sh
WEBCONSOLE_URL="http://localhost:5000"
N=20
KI=465B5CE8B199B49FAA5F0A2EE238A6BC
OPC=E8ED289DEBA952E4283B54E88E6183CA

IMSI="999700000000001"
# Registering internal ues of ueransim-gnb
for IMSI in `seq $IMSI $(($IMSI + $N))`;
do
    echo "registering IMSI: $IMSI"

    curl "$WEBCONSOLE_URL/api/subscriber/imsi-$IMSI/99970" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json;charset=UTF-8' \
      -H 'Token: admin' \
      --data-raw '{"plmnID":"99970","ueId":"'$IMSI'","AuthenticationSubscription":{"authenticationManagementField":"8000","authenticationMethod":"5G_AKA","milenage":{"op":{"encryptionAlgorithm":0,"encryptionKey":0,"opValue":""}},"opc":{"encryptionAlgorithm":0,"encryptionKey":0,"opcValue":"E8ED289DEBA952E4283B54E88E6183CA"},"permanentKey":{"encryptionAlgorithm":0,"encryptionKey":0,"permanentKeyValue":"465B5CE8B199B49FAA5F0A2EE238A6BC"},"sequenceNumber":"000000000025"},"AccessAndMobilitySubscriptionData":{"gpsis":["msisdn-0900000000"],"nssai":{"defaultSingleNssais":[{"sst":1,"sd":"FFFFFF","isDefault":true}],"singleNssais":[]},"subscribedUeAmbr":{"downlink":"2 Gbps","uplink":"1 Gbps"}},"SessionManagementSubscriptionData":[{"singleNssai":{"sst":1,"sd":"FFFFFF"},"dnnConfigurations":{"internet":{"sscModes":{"defaultSscMode":"SSC_MODE_1","allowedSscModes":["SSC_MODE_2","SSC_MODE_3"]},"pduSessionTypes":{"defaultSessionType":"IPV4","allowedSessionTypes":["IPV4"]},"sessionAmbr":{"uplink":"200 Mbps","downlink":"100 Mbps"},"5gQosProfile":{"5qi":9,"arp":{"priorityLevel":8},"priorityLevel":8}}}}],"SmfSelectionSubscriptionData":{"subscribedSnssaiInfos":{"01FFFFFF":{"dnnInfos":[{"dnn":"internet"}]}}},"AmPolicyData":{"subscCats":["free5gc"]},"SmPolicyData":{"smPolicySnssaiData":{"01FFFFFF":{"snssai":{"sst":1,"sd":"FFFFFF"},"smPolicyDnnData":{"internet":{"dnn":"internet"}}}}},"FlowRules":[]}'
done