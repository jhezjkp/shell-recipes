#!/bin/sh

# CentOS Scaffold Script
# Maintainer: jhezjkp
# version: alpha

# About
# This scipt is used to set up ubuntu for further use.
# Operation as followers:
# * replace default update source with mirrors.163.com
# * install basic packages: make curl unzip zip gcc git 
#        lrzsz python-setuptools python-pip vim htop iotop
#        nmon wget makepasswd bc
# * install python packages:
#        virtualenv virtualenvwrapper

# USAGE
# !IMPORTANT run as root or sudo without prompting password cause script ignore any input.
#

#==
#== miscs
#==

#fix locale problem
if ! grep -q "export LC_ALL=C" /etc/profile
then
    echo "fix locale problem"
    echo "export LC_ALL=C" >> /etc/profile
    source /etc/profile
fi

#==
#== 0. replace default update source
#==
os_version=`cat /etc/issue | sed -n 1p | cut -d ' ' -f3 | cut -c1`
#repo
repoFile="CentOS${os_version}-Base-163.repo"
repoUrl="http://mirrors.163.com/.help/${repoFile}"
echo $repoUrl

#check if the 163 repo file exists
if [ ! -f "/etc/yum.repos.d/${repoFile}" ]
then
		#backup origin repoFile
		 mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
		 wget ${repoUrl} -P /etc/yum.repos.d/
         yum makecache
else
		echo "163 repo has bean set!"		 
fi

#==
#== 1. install neccesary packages
#==
echo "===== install basic software packages ======"
#python-pip htop nmon makepasswd
for package in make wget curl unzip zip gcc git lrzsz python-setuptools \
    vim iotop bc
do
    echo "install ${package}..."
    yum -y install ${package}
    echo "done!!!"
done
echo "==== basic software packages installed ====="

#==
#== 2. install python packages
#==
echo "==== install python packages ===="
easy_install pip virtualenv virtualenvwrapper
echo "==== python packages installed ===="


