#!/bin/bash
set -e

echo "Executing k8s customized entrypoint.sh"

# Install extra packages needed
apt-get update && apt-get install -y dnsutils gettext-base

PCSCF_IP=${PCSCF_IP:-"$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export PCSCF_IP

if [[ -z "$PCSCF_IP" ]]; then
echo "Unable to resolve PCSCF's IP... restarting"
exit 1
fi

envsubst < /opt/open5gs/etc/open5gs/smf.yaml > /opt/open5gs/etc/open5gs/smf.yaml.output
cat /opt/open5gs/etc/open5gs/smf.yaml.output > /opt/open5gs/etc/open5gs/smf.yaml
rm /opt/open5gs/etc/open5gs/smf.yaml.output

$@