#!/bin/bash

# Ubuntu Scaffold Script
# Maintainer: jhezjkp
# version: alpha

# About
# This scipt is used to set up ubuntu for further use.
# Operation as followers:
# * replace default update source with mirrors.163.com
# * install basic packages: zsh make curl unzip zip gcc git 
#        lrzsz python-setuptools python-pip vim htop iotop
#        nmon wget makepasswd bc
# * install python packages:
#        virtualenv virtualenvwrapper

# USAGE
# !IMPORTANT run as root or sudo without prompting password cause script ignore any input.
#

. `pwd`/helper.sh

#==
#== miscs
#==

#fix locale problem
#if ! grep -q "export LC_ALL=C" /etc/profile
#then
    #echo "fix locale problem"
    #echo "export LC_ALL=C" >> /etc/profile
    #source /etc/profile
#fi

#==
#== replace default update source
#==

function replace_repository() {
    if [ "$os_name" = "CentOS" ]
    then
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
    elif [ "$os_name" = "Ubuntu" ] || [ "$os_name" = "Debian" ]
    then
        #mirror site url
        mirrorUrl="http://mirrors.163.com/"`echo ${os_name} | tr 'A-Z' 'a-z'`/
        echo $mirrorUrl

        if ! grep -q "mirrors.163.com" /etc/apt/sources.list
        then
            #get release code name
            codeName=`echo ${os_code} | tr 'A-Z' 'a-z'`
            #backup sources.list
            mv /etc/apt/sources.list /etc/apt/sources.list.bak
            repoFile="/etc/apt/sources.list"
            touch ${repoFile}
            if [ "$os_name" == "Ubuntu" ]
            then
                echo "deb ${mirrorUrl} ${codeName} main restricted universe multiverse" >> ${repoFile}
                for var in security updates proposed backports
                do
                    echo "deb ${mirrorUrl} ${codeName}-${var} main restricted universe multiverse" >> ${repoFile}
                    echo "deb-src ${mirrorUrl} ${codeName}-${var} main restricted universe multiverse" >> ${repoFile}
                done
            elif [ "$os_name" == "Debian" ]
            then
                echo "deb ${mirrorUrl} ${codeName} main non-free contrib" >> ${repoFile}
                echo "deb ${mirrorUrl} ${codeName}-proposed-updates main non-free contrib" >> ${repoFile}
                echo "deb-src ${mirrorUrl} ${codeName} main non-free contrib" >> ${repoFile}
                echo "deb-src ${mirrorUrl} ${codeName}-proposed-updates main non-free contrib" >> ${repoFile}
            else
        exit 1
          fi
            #update repository
            apt-get update
        fi

    fi
}



#==
#== install neccesary packages
#==

function install_basic_packages() {
    log "===== install basic software packages ======"
    install_package zsh make wget curl unzip zip gcc git lrzsz python-setuptools \
        python-pip vim htop iotop nmon makepasswd bc patch
    log "==== basic software packages installed ====="
}

#==
#== install python packages
#==

function install_basic_python_packages() {
    echo "==== install python packages ===="
    easy_install virtualenv virtualenvwrapper
    echo "==== python packages installed ===="
}


replace_repository
install_basic_packages
install_basic_python_packages
