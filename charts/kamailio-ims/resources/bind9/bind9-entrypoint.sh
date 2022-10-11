# Entrypoint needed in order to resolve IP address and configure DNS bind9

# dnsutils package needed in order to use host command
apt-get update
apt-get install dnsutils -y

if [[ ! -z "$FHOSS_HOSTNAME" ]] ; then 
    export FHOSS_ADDR="$(host -4 $FHOSS_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$PCSCF_HOSTNAME" ]] ; then 
    export PCSCF_ADDR="$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$SCSCF_HOSTNAME" ]] ; then 
    export SCSCF_ADDR="$(host -4 $SCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$ICSCF_HOSTNAME" ]] ; then 
    export ICSCF_ADDR="$(host -4 $ICSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$BIND_HOSTNAME" ]] ; then 
    export BIND_ADDR="$(host -4 $BIND_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi

if [[ ! -z "$PCRF_HOSTNAME" ]] ; then 
    export PCRF_ADDR="$(host -4 $PCRF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
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

#Replacements in named.conf
sed -i 's|${IMS_DOMAIN}|'$IMS_DOMAIN'|g' /etc/bind/named.conf
sed -i 's|${EPC_DOMAIN}|'$EPC_DOMAIN'|g' /etc/bind/named.conf

#Replacements in e164.arpa
sed -i 's|${BIND_ADDR}|'$BIND_ADDR'|g' /etc/bind/e164.arpa
sed -i 's|${IMS_DOMAIN}|'$IMS_DOMAIN'|g' /etc/bind/e164.arpa

#Replacements in epc_zone
sed -i 's|${EPC_DOMAIN}|'$EPC_DOMAIN'|g' /etc/bind/epc_zone
sed -i 's|${BIND_ADDR}|'$BIND_ADDR'|g' /etc/bind/epc_zone
sed -i 's|${PCRF_ADDR}|'$PCRF_ADDR'|g' /etc/bind/epc_zone

#Replacements in ims_zone
sed -i 's|${IMS_DOMAIN}|'$IMS_DOMAIN'|g' /etc/bind/ims_zone
sed -i 's|${BIND_ADDR}|'$BIND_ADDR'|g' /etc/bind/ims_zone
sed -i 's|${PCSCF_ADDR}|'$PCSCF_ADDR'|g' /etc/bind/ims_zone
sed -i 's|${ICSCF_ADDR}|'$ICSCF_ADDR'|g' /etc/bind/ims_zone
sed -i 's|${SCSCF_ADDR}|'$SCSCF_ADDR'|g' /etc/bind/ims_zone
sed -i 's|${FHOSS_ADDR}|'$FHOSS_ADDR'|g' /etc/bind/ims_zone

