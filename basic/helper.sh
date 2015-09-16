#!/usr/bin/env bash

#==
#== this script is used to be imported by other scripts
#==

:<<BLOCK
add the below line after #! declare line to import this shell:
. `pwd`/helper.sh

sample code:
#!/usr/bin/env bash

. `pwd`/helper.sh
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
    issueFile="/etc/issue"
    if [ -f "$releaseFile" ]; then
        os_name=`cat $releaseFile | cut -d " " -f1`
        os_version=`cat $releaseFile | cut -d " " -f3`
        os_code=`cat $releaseFile | cut -d " " -f4`
    elif [ -f "$issueFile" ]; then
        os_name=`cat $issueFile | cut -d " " -f1`
        os_version=`cat $issueFile | cut -d " " -f3`
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
    elif [ $os_name = 'CentOS' ]
    then
        return_var="yum install $@"
    fi
}

#==
#== 根据发行版本安装对应的软件包并打印屏幕提示
#==

function install_package() {
    if [ $# -lt 1 ]
    then
        return 1
    fi
    for package in $*
    do
        print_with_border $package
        if [ $os_name = "Ubuntu" ] || [ $os_name = "Debian" ]
        then
            apt-get -y install ${package}
        elif [ $os_name = "CentOS" ]
        then
            yum -y install ${package}
        fi
    done
}

#==
#== 重复输出某字符:第一个参数是内容，第二个参数是重复的次数
#==

function repeat_print() {
    if [ "$#" -lt 2 ]
    then
        return 1
    fi
    ch="$(printf "%$2s" "")"
    printf "%s" "${ch// /$1}"
    return 0;
}

#==
#== 输出带方框修饰的内容
#==

function print_with_border() {
    if [ "$#" -lt 1 ]
    then
        return 1
    fi
    #计算要输出的内容的长度
    len=`echo $* | wc -L`
    total_len=`expr 50 + $len`
    #奇偶修正
    fix=0
    if [ `expr $len % 2` -eq 1 ]
    then
        len=`expr $len - 1`
        fix=1
        total_len=`expr $total_len + 1`
    fi
    len=`expr $len / 2`
    #输出
    printf "+"
    repeat_print "-" $total_len
    printf "+\n+"
    repeat_print " " `expr $total_len / 2 - $len`
    printf "$*"
    repeat_print " " `expr $total_len / 2 - $len - $fix`
    printf "+\n+"
    repeat_print "-" `expr $total_len`
    echo "+"
    return 0

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


#==
#== 打印日志
#==

function log() {
    if [ "$#" -lt 1 ]
    then
        echo "\n"
        return 0
    fi
    echo -e "\e[40;37m$@${NORM}"
    return 0
}

#==
#== 高亮打印，一般用于用户提示的高亮显示
#==

function print() {
    if [ "$#" -lt 1 ]
    then
        echo "\n"
        return 0
    fi
    echo -e "${BOLD}\e[44;37m$@${NORM}"
    return 0
}

#==
#== 闪烁显示文本
#==

function blink() {
    if [ "$#" -lt 1 ]
    then
        echo "\n"
        return 0
    fi
    echo -e "${BLINK}$@${NORM}"
    return 0
}

#==
#== 一些有用的工具方法
#==

#生成随机密码：默认为8位长度，保存在return_var变量中
function generate_password() {
    return_var=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8}`
    return 0
}
