#!/bin/bash
set -e

echo "Executing k8s customized entrypoint.sh"

{{- range .Values.config.subnetList }}
{{- if .createDev }}
echo "Creating net device {{ .dev }}"
if grep "{{ .dev }}" /proc/net/dev > /dev/null; then
    echo "Warnin: Net device {{ .dev }} already exists! may you need to set createDev: false";
    exit 1
fi

ip tuntap add name {{ .dev }} mode tun
ip link set {{ .dev }} up
echo "Setting IP {{ .gateway }} to device {{ .dev }}"
ip addr add {{ .gateway }}/{{ .mask }} dev {{ .dev }};
sysctl -w net.ipv4.ip_forward=1;
{{- if .enableNAT }}
echo "Enable NAT for {{ .subnet }} and device {{ .dev }}"
iptables -t nat -A POSTROUTING -s {{ .subnet }} ! -o {{ .dev }} -j MASQUERADE;
{{- end }}
{{- end }}
{{- end }}

$@