#!/usr/bin/env bash

#this script is used to install mysql-server on your server

. basic/helper.sh

if read -t 10 -p "Pls enter a password(MySQL root password):" password
then
    echo "MySQL root password provided!!"
else
    generate_password 8
    password=$return_var
    echo -e "\ntime out...generating password...done!"
fi

#install
echo mysql-server mysql-server/root_password password $password | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $password | debconf-set-selections
if is_ubuntu
then
    install_package mysql-client-5.5 mysql-server-5.5 libmysqlclient-dev
elif is_debian
then
    install_package mysql-client libmysqlclient-dev mysql-server
elif is_centos
then
    install_package mysql mysql-devel mysql-server
    service mysqld start
    /usr/bin/mysqladmin -u root password $password
fi
echo -en "\n\nThe MySQL root password is:\t"
print $password
