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
    #加上--databases参数后导出的SQL文件中会有建库语句
    #mysqldump -h$host -P$port -u$user -p$password --databases --default-character-set=utf8 $db > $db.sql
    #mysqldump -h$host -P$port -u$user -p$password --default-character-set=utf8 $db > $db.sql
    #压缩一下
    mysqldump -h$host -P$port -u$user -p$password --databases --default-character-set=utf8 $db | gzip > $db.sql.gz
    echo "success!!"
done
