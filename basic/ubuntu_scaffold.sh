#!/bin/sh

# Ubuntu Scaffold Script
# Maintainer: jhezjkp
# version: alpha

# About
# This scipt is used to set up ubuntu for further use.
# Operation as followers:
# * replace default update source with mirrors.163.com
# * install basic packages: make curl unzip zip gcc git 
#        lrzsz python-setuptools python-pip vim htop iotop
#        nmon wget makepasswd bc

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

#mirror site url
mirrorUrl="http://mirrors.163.com/ubuntu/"

if ! grep -q "mirrors.163.com" /etc/apt/sources.list
then
    #get release code name
    codeName=`lsb_release -s -c`
    #backup sources.list
    mv /etc/apt/sources.list /etc/apt/sources.list.bak
    repoFile="/etc/apt/sources.list"
    touch ${repoFile}
    echo "deb ${mirrorUrl} ${codeName} main restricted universe multiverse" >> ${repoFile}
    for var in security updates proposed backports
    do
        echo "deb ${mirrorUrl} ${codeName}-${var} main restricted universe multiverse" >> ${repoFile}
        echo "deb-src ${mirrorUrl} ${codeName}-${var} main restricted universe multiverse" >> ${repoFile}
    done
    #update repository
    apt-get update
fi

#==
#== 1. install neccesary packages
#==
echo "===== install basic packages ======"
for package in make wget curl unzip zip gcc git lrzsz python-setuptools \
    python-pip vim htop iotop nmon makepasswd bc
do
    echo "install ${package}..."
    apt-get -y install ${package}
    echo "done!!!"
done
echo "==== basic packages installed ====="
