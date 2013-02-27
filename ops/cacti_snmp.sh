#!/usr/bin/env bash

#enable and configure snmpd service on monitored machine


. ../basic/helper.sh

if read -p "Pls enter the cacti server ip:" ip
then
    echo "Cacti server ip provided:" $ip
fi

#install snmp
install_package net-snmp

#configure
sed  -i "s/com2sec notConfigUser  default       public/com2sec notConfigUser  $ip       public/" /etc/snmp/snmpd.conf
sed  -i 's/access  notConfigGroup ""      any       noauth    exact  systemview none none/access  notConfigGroup ""      any       noauth    exact  all none none/' /etc/snmp/snmpd.conf
sed  -i 's/#view all    included  .1                               80/view all    included  .1                               80/' /etc/snmp/snmpd.conf

#restart service
service snmpd restart

#stop iptables
service iptables stop
