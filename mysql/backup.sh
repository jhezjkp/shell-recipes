#!/usr/bin/env bash

#数据库备份脚本

#数据库配置
host="localhost"
port=3306
user="root"
password="123456"

#要备份的数据库，以空格分隔
databases="db db2"

for db in $databases; do
    printf "backup $db, please wait for a while..."
    #加上--databases参数后导出的SQL文件中会有建库语句,在把多个数据库备份到一个文件中才会用该参数
    #mysqldump -h$host -P$port -u$user -p$password --databases --default-character-set=utf8 $db > $db.sql
    mysqldump -h$host -P$port -u$user -p$password --default-character-set=utf8 $db > $db.sql
    echo "success!!"
done
