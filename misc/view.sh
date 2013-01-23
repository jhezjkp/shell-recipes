#!/usr/bin/env bash

#==
#== 文件查看
#==

#判断参数个数
if [ $# -lt "1" ]
then
    echo "usage: $0 <file_name>"
    exit 1
fi
#行计数器
counter=1
cat $1 | while read line
do
    echo -e "Line $counter:\t$line"
    counter=$[ $counter + 1 ]
done
exit 0
