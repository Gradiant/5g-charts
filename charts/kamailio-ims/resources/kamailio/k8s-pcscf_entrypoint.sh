echo "Waiting..."
sleep 5

echo "Deploying component: '$COMPONENT_NAME'"
/k8s-pcscf_init.sh && \
mkdir -p /var/run/kamailio_pcscf && \
kamailio -f /etc/kamailio_pcscf/kamailio_pcscf.cfg -P /kamailio_pcscf.pid -DD -E -e