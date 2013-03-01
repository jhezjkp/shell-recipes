#!/bin/env bash

#入侵检测

. ../basic/helper.sh


print_with_border "账号安全检测"
print "/etc/passwd文件访问/修改时间检查:"
stat /etc/passwd
repeat_print "-" 50
echo ""
print "uid为0的用户列表:"
awk -F: '$3==0 {print $1}' /etc/passwd
repeat_print "-" 50
echo ""
n=`awk -F: 'length($2)==0 {print $1}' /etc/shadow | wc -l`
if [ "$n" -eq 0 ]
then
    print "未检测到空口令账号"
else
    print "空口令账号："
    awk -F: 'length($2)==0 {print $1}' /etc/shadow
fi
print_with_border "定时任务检测"
crontab -l
