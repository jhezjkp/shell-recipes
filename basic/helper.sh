#!/usr/bin/env bash

#==
#== this script is used to be imported by other scripts
#==

:<<BLOCK
add the below line after #! declare line to import this shell:
. `pwd`/helper.sh

sample code:
#!/usr/bin/env bash

. `pwd`/os_check.sh
echo $os_name

if is_centos
then
    echo 'it is centos!'
else
    echo 'it is NOT centos!'
fi
BLOCK

#global function return value
return_var=""



###########################################
###   os check
###########################################

#below code is used to check os distribution/version/codename(eg: Ubuntu 12.10 quantal)


os_name=""
os_version=""
os_code=""

#check if lsb_release command is avaliable
which lsb_release >> /dev/null 2>&1
if [ $? -eq 0 ]
then
    os_name=`lsb_release -si`
    os_version=`lsb_release -sr`
    os_code=`lsb_release -sc`
else
    releaseFile="/etc/redhat-release"
    if [ -f "$releaseFile" ]
    then
        os_name=`cat $releaseFile | cut -d " " -f1`
        os_version=`cat $releaseFile | cut -d " " -f3`
        os_code=`cat $releaseFile | cut -d " " -f4`
    fi
fi

#echo $os_name $os_version $os_code

#==
#== 判断发行版本的几个方法
#==

function is_centos() {
    if [ "CentOS" == $os_name ]    
    then
        return 0
    else
        return 1
    fi
}

function is_debian() {
    if [ "Debian" == $os_name ]    
    then
        return 0
    else
        return 1
    fi
}

function is_ubuntu() {
    if [ "Ubuntu" == $os_name ]    
    then
        return 0
    else
        return 1
    fi
}

#==
#== 根据发行版本返回对应的软件包的安装命令
#==

function get_install_cmd() {
    if [ $# -lt 1 ]
    then
        return 1
    fi
    if [ $os_name = "Ubuntu" ] || [ $os_name = "Debian" ]
    then
        return_var="apt-get install $@"
    fi
}

######################################################
###  color output
######################################################

LF="\n"; CR="\r"
INVT="\033[7m"; NORM="\033[0m"; BOLD="\033[1m"; BLINK="\033[5m"
#UNDR="\033[2m\033[4m"; EOL="\033[0K"; EOD="\033[0J"
UNDR="\033[4m"; EOL="\033[0K"; EOD="\033[0J"
SOD="\033[1;1f"; CUR_UP="\033[1A"; CUR_DN="\033[1B"; CUR_LEFT="\033[1D"
CUR_RIGHT="\033[1C"

#-- ANSI code
SCR_HOME="\033[0;0H" #-- Home of the display

BLACK_F="\033[30m"; BLACK_B="\033[40m"
RED_F="\033[31m"; RED_B="\033[41m"
GREEN_F="\033[32m"; GREEN_B="\033[42m"
YELLOW_F="\033[33m"; YELLOW_B="\033[43m"
BLUE_F="\033[34m"; BLUE_B="\033[44m"
MAGENTA_F="\033[35m"; MAGENTA_B="\033[45m"
CYAN_F="\033[36m"; CYAN_B="\033[46m"
WHITE_F="\033[37m"; WHITE_B="\033[47m"

function print() {
    if [ "$#" -lt 1 ]
    then
        echo "\n"
        return 0
    fi
    echo -e "${BOLD}\e[44;37m$@${NORM}"
    return 0
}

function blink() {
    if [ "$#" -lt 1 ]
    then
        echo "\n"
        return 0
    fi
    echo -e "${BLINK}$@${NORM}"
    return 0
}
