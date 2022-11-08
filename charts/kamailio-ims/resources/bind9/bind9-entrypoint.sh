# Entrypoint needed in order to resolve IP address and configure DNS bind9

# dnsutils package needed in order to use host command
apt-get update
apt-get install dnsutils ed gettext-base -y

if [[ ! -z "$FHOSS_HOSTNAME" ]] ; then 
    export FHOSS_ADDR="$(host -4 $FHOSS_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "FHOSS: ${FHOSS_ADDR}"
fi

if [[ ! -z "$PCSCF_HOSTNAME" ]] ; then 
    export PCSCF_ADDR="$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "PCSCF: ${PCSCF_ADDR}"
fi

if [[ ! -z "$SCSCF_HOSTNAME" ]] ; then 
    export SCSCF_ADDR="$(host -4 $SCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "SCSCF: ${SCSCF_ADDR}"
fi

if [[ ! -z "$ICSCF_HOSTNAME" ]] ; then 
    export ICSCF_ADDR="$(host -4 $ICSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "ICSCF: ${ICSCF_ADDR}"
fi

if [[ ! -z "$BIND_HOSTNAME" ]] ; then 
    export BIND_ADDR="$(host -4 $BIND_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "BIND: ${BIND_ADDR}"
fi

if [[ ! -z "$PCRF_HOSTNAME" ]] ; then 
    export PCRF_ADDR="$(host -4 $PCRF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
    echo "PCRF: ${PCRF_ADDR}"
fi

if [ -z "$FHOSS_ADDR" ] \
    || [[ -z "$PCSCF_ADDR" ]] \
    || [[ -z "$SCSCF_ADDR" ]] \
    || [[ -z "$ICSCF_ADDR" ]] \
    || [[ -z "$PCRF_ADDR" ]] \
    || [[ -z "$BIND_ADDR" ]]; then
echo "Unable to resolve some IPs... restarting"
exit 1
fi

# #Replacements in named.conf
# ed /tmp/bind_files/named.conf << END
# g/{IMS_DOMAIN}/s//${IMS_DOMAIN}/
# g/{EPC_DOMAIN}/s//${EPC_DOMAIN}/
# .
# w
# q
# END
# echo "Printing resulting named.conf...."
# cat /tmp/bind_files/named.conf

# #Replacements in e164.arpa
# ed /tmp/bind_files/e164.arpa << END
# g/{BIND_ADDR}/s//${BIND_ADDR}/
# g/{IMS_DOMAIN}/s//${IMS_DOMAIN}/
# .
# w
# q
# END
# echo "Printing resulting e164.arpa...."
# cat /tmp/bind_files/e164.arpa

# #Replacements in epc_zone
# ed /tmp/bind_files/epc_zone << END
# g/{BIND_ADDR}/s//${BIND_ADDR}/
# g/{PCRF_ADDR}/s//${PCRF_ADDR}/
# g/{EPC_DOMAIN}/s//${EPC_DOMAIN}/
# .
# w
# q
# END
# echo "Printing resulting epc_zone...."
# cat /etc/bind/epc_zone

# #Replacements in ims_zone
# ed /tmp/bind_files/ims_zone << END
# g/{BIND_ADDR}/s//${BIND_ADDR}/
# g/{PCSCF_ADDR}/s//${PCSCF_ADDR}/
# g/{ICSCF_ADDR}/s//${ICSCF_ADDR}/
# g/{SCSCF_ADDR}/s//${SCSCF_ADDR}/
# g/{FHOSS_ADDR}/s//${FHOSS_ADDR}/
# g/{IMS_DOMAIN}/s//${IMS_DOMAIN}/
# .
# w
# q
# END
# echo "Printing resulting ims_zone...."
# cat /tmp/bind_files/ims_zone

envsubst '$EPC_DOMAIN','$IMS_DOMAIN' < /tmp/bind_files/named.conf > /tmp/bind/named.conf

envsubst '$BIND_ADDR','$IMS_DOMAIN' < /tmp/bind_files/e164.arpa > /tmp/bind/e164.arpa

envsubst '$PCRF_ADDR','$EPC_DOMAIN','$BIND_ADDR' < /tmp/bind_files/epc_zone > /tmp/bind/epc_zone

envsubst '$BIND_ADDR','$PCSCF_ADDR','$ICSCF_ADDR','$SCSCF_ADDR','$FHOSS_ADDR','$IMS_DOMAIN' < /tmp/bind_files/ims_zone > /tmp/bind/ims_zone

cp -nr /etc/bind/* /tmp/bind/