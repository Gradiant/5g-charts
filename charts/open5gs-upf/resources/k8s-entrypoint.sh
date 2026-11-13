#!/bin/bash
set -e

echo "Executing k8s customized entrypoint.sh"

if [ ! -c /dev/net/tun ]; then
    mknod -m 0666 /dev/net/tun c 10 200
fi

{{- range .Values.config.subnetList }}
{{- if .createDev }}
echo "Creating net device {{ .dev }}"
if grep "{{ .dev }}" /proc/net/dev > /dev/null; then
    echo "Warning: Net device {{ .dev }} already exists! may you need to set createDev: false";
    exit 1
fi

ip tuntap add name {{ .dev }} mode tun user {{ $.Values.containerSecurityContext.runAsUser }} group {{ $.Values.containerSecurityContext.runAsGroup }}
ip link set {{ .dev }} up
ip link set dev {{ .dev }} txqueuelen 4096
echo "Setting IP {{ .gateway }} to device {{ .dev }}"
ip addr add {{ .gateway }}/{{ .mask }} dev {{ .dev }};
if [ "$(sysctl -n net.ipv4.ip_forward)" != "1" ]; then
    sysctl -w net.ipv4.ip_forward=1
fi
{{- if .enableNAT }}
echo "Enable NAT for {{ .subnet }} and device {{ .dev }}"
iptables -t nat -A POSTROUTING -s {{ .subnet }} ! -o {{ .dev }} -j MASQUERADE;
{{- end }}
{{- end }}
{{- end }}

$@
