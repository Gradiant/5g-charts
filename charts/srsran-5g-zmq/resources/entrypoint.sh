#!/bin/bash

set -ex

if [ $# -lt 1 ]
then
        echo "Usage : $0 [gnb]"
        exit
fi

if [[ ! -z "$AMF_HOSTNAME" ]] ; then 
    export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ -z "${AMF_BIND_ADDR}" ]] ; then
    export AMF_BIND_ADDR=$(ip addr show $AMF_BIND_INTERFACE | grep -Po 'inet \K[\d.]+')
fi

if [[ ! -z "$GNB_HOSTNAME" ]] ; then 
    export GNB_ADDRESS="$(host -4 $GNB_HOSTNAME | awk '/has.*address/{print $NF; exit}')"
else
    export GNB_ADDRESS="$(host -4 localhost | awk '/has.*address/{print $NF; exit}')"
fi


if [[ ! -z "$UE_HOSTNAME" ]] ; then 
    export UE_ADDRESS="$(host -4 $UE_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi


if grep -q "device_driver: zmq" /gnb-template.yml; then
    awk '{
        print
        if ($0 ~ /tac:/) {
            print "  pdcch:"
            print "    common:"
            print "      ss0_index: 0"
            print "      coreset0_index: 12"
            print "    dedicated:"
            print "      ss2_type: common"
            print "      dci_format_0_1_and_1_1: false"
            print "  prach:"
            print "    prach_config_index: 1"
        }
    }' /gnb-template.yml > tmpfile && mv tmpfile /gnb-var.yml

    sed -i -e "/device_args:/s/tx_port=tcp:\/\/:/tx_port=tcp:\/\/${GNB_ADDRESS}:/" \
           -e "/device_args:/s/rx_port=tcp:\/\/:/rx_port=tcp:\/\/${UE_ADDRESS}:/" \
           /gnb-var.yml
fi



envsubst < /gnb-var.yml > gnb.yml

/opt/srsRAN_Project/target/bin/gnb -c gnb.yml