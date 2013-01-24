#!/usr/bin/env bash

#==
#== 交互式脚本：读取用户输入的密码，在5秒内未输入则生成一个
#==

function generatePassword() {
    echo `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8}`
    return 0
}


if read -t 5 -p "Pls enter a password:" password
then
    echo "$password"
else
    echo -e "\ntime out...generating password...done!"
    #passwod=`makepasswd --chars=6`
    passwod=`generatePassword 6`
    echo "$passwod"
fi
#显示后退出程序
exit 0
