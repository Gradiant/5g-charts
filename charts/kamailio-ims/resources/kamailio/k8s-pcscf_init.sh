#!/bin/bash

# Just wait 10 seconds to be "running" and resolvable
sleep 10

MYSQL_IP=${MYSQL_IP:-"$(host -4 $MYSQL_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export MYSQL_IP
echo "MYSQL_IP: $MYSQL_IP"

PCSCF_IP=${PCSCF_IP:-"$(host -4 $PCSCF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export PCSCF_IP
echo "PCSCF_IP: $PCSCF_IP"

RTPENGINE_IP=${RTPENGINE_IP:-"$(host -4 $RTPENGINE_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export RTPENGINE_IP
echo "RTPENGINE_IP: $RTPENGINE_IP"

UPF_IP=${UPF_IP:-"$(host -4 $UPF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export UPF_IP
echo "UPF_IP: $UPF_IP"

DNS_IP=${DNS_IP:-"$(host -4 $DNS_HOSTNAME |awk '/has.*address/{print $NF; exit}')"}
export DNS_IP
echo "DNS_IP: $DNS_IP"

if [ -z "$MYSQL_IP" ] \
    || [[ -z "$RTPENGINE_IP" ]] \
    || [[ -z "$PCSCF_IP" ]] \
    || [[ -z "$UPF_IP" ]] \
    || [[ -z "$DNS_IP" ]]; then
echo "Unable to resolve some IPs... restarting"
exit 1
fi

sh -c "echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind"
sh -c "echo 1 > /proc/sys/net/ipv6/ip_nonlocal_bind"

EPC_DOMAIN=$EPC_DOMAIN
IMS_DOMAIN=$IMS_DOMAIN

mkdir /etc/kamailio_pcscf
cp /mnt/pcscf/pcscf.cfg /etc/kamailio_pcscf
cp /mnt/pcscf/pcscf.xml /etc/kamailio_pcscf
cp /mnt/pcscf/kamailio_pcscf.cfg /etc/kamailio_pcscf
cp -r /mnt/pcscf/route /etc/kamailio_pcscf
cp -r /mnt/pcscf/sems /etc/kamailio_pcscf
cp /mnt/pcscf/tls.cfg /etc/kamailio_pcscf
cp /mnt/pcscf/dispatcher.list /etc/kamailio_pcscf

while ! mysqladmin ping -h ${MYSQL_IP} --silent; do
	sleep 5;
done

# Sleep until permissions are set
sleep 10;

# Create PCSCF database, populate tables and grant privileges
if [[ -z "`mysql -u root -h ${MYSQL_IP} -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='pcscf'" 2>&1`" ]];
then
	mysql -u root -h ${MYSQL_IP} -e "create database pcscf;"
	mysql -u root -h ${MYSQL_IP} pcscf < /usr/local/src/kamailio/utils/kamctl/mysql/standard-create.sql
	mysql -u root -h ${MYSQL_IP} pcscf < /usr/local/src/kamailio/utils/kamctl/mysql/presence-create.sql
	mysql -u root -h ${MYSQL_IP} pcscf < /usr/local/src/kamailio/utils/kamctl/mysql/ims_usrloc_pcscf-create.sql
	mysql -u root -h ${MYSQL_IP} pcscf < /usr/local/src/kamailio/utils/kamctl/mysql/ims_dialog-create.sql
	PCSCF_USER_EXISTS=`mysql -u root -h ${MYSQL_IP} -s -N -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE User = 'pcscf' AND Host = '%')"`
	if [[ "$PCSCF_USER_EXISTS" == 0 ]]
	then
		mysql -u root -h ${MYSQL_IP} -e "CREATE USER 'pcscf'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('heslo')";
		mysql -u root -h ${MYSQL_IP} -e "CREATE USER 'pcscf'@'$PCSCF_IP' IDENTIFIED VIA mysql_native_password USING PASSWORD('heslo')";
		mysql -u root -h ${MYSQL_IP} -e "GRANT ALL ON pcscf.* TO 'pcscf'@'%'";
		mysql -u root -h ${MYSQL_IP} -e "GRANT ALL ON pcscf.* TO 'pcscf'@'$PCSCF_IP'";
		mysql -u root -h ${MYSQL_IP} -e "FLUSH PRIVILEGES;"
	fi
fi

sed -i 's|PCSCF_IP|'$PCSCF_IP'|g' /etc/kamailio_pcscf/pcscf.cfg
sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/kamailio_pcscf/pcscf.cfg
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' /etc/kamailio_pcscf/pcscf.cfg
sed -i 's|MYSQL_IP|'$MYSQL_IP'|g' /etc/kamailio_pcscf/pcscf.cfg

sed -i 's|PCSCF_IP|'$PCSCF_IP'|g' /etc/kamailio_pcscf/pcscf.xml
sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/kamailio_pcscf/pcscf.xml
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' /etc/kamailio_pcscf/pcscf.xml

sed -i 's|RTPENGINE_IP|'$RTPENGINE_IP'|g' /etc/kamailio_pcscf/kamailio_pcscf.cfg

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add static route to route traffic back to UE as there is not NATing
ip r add 192.168.101.0/24 via ${UPF_IP} dev eth0 onlink

# Configure dns service as main nameserver
sleep 5
ed /etc/resolv.conf << END
2i
nameserver ${DNS_IP}
.
w
q
END
cat /etc/resolv.conf
