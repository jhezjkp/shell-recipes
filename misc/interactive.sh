#!/usr/bin/env bash

#==
#== 交互式脚本：读取用户输入的密码，在5秒内未输入则生成一个
#==

if read -t 5 -p "Pls enter a password:" password
then
    echo "$password"
else
    echo "time out...generating password...done!"
    passwod=`makepassword --chars=6`
    echo "$passwod"
fi
#显示后退出程序
exit 0