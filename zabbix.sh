#!/bin/env bash

#zabbix

. basic/helper.sh

install_package mysql-devel gcc net-snmp-devel curl-devel perl-DBI php-gd php-mysql php-bcmath php-mbstring php-xml

wget http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.5/zabbix-2.0.5.tar.gz?r=http%3A%2F%2Fwww.zabbix.com%2Fdownload.php&ts=1362127077&use_mirror=jaist -O zabbix.tar.gz
tar -zxvf zabbix.tar.gz
cd zabbix-2.0.5
#http://lvzili.blog.51cto.com/1995527/772428
#/usr/lib64/mysql
./configure  --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl -enable-proxy
