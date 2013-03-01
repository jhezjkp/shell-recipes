#!/bin/env bash

#zabbix configuration

. basic/helper.sh

#install_package patch gcc gcc-c++ libxml2 libxml2-devel autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel  zlib zlib-devel glibc glibc-devel glib2 glib2-devel nginx


#print_with_border "download and install php"
#wget http://www.php.net/get/php-5.2.17.tar.bz2/from/cn2.php.net/mirror -O /tmp/php.tar.bz2
#wget http://php-fpm.org/downloads/php-5.2.17-fpm-0.5.14.diff.gz -O /tmp/php-fpm.diff.gz
cd /tmp
#tar -jxvf php.tar.bz2
#gzip -cd php-fpm.diff.gz | patch -d php-5.2.17 -p1
cd php-5.2.17
#./configure  --prefix=/usr/local/php --enable-fastcgi --enable-fpm
#make
#make install

#configuration
cp php.ini-dist /usr/local/php/lib/php.ini  
sed -i '/Unix user of processes/a\<value name="user">nginx</value>' /usr/local/php/etc/php-fpm.conf
sed -i '/Unix group of processes/a\<value name="group">nginx</value>' /usr/local/php/etc/php-fpm.conf
sed  -i '/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php.ini

/usr/local/php/sbin/php-fpm start

#configure nginx
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
cat << EOF >> /etc/nginx/conf.d/default.conf
    server {  
        server_name localhost;  

    location / {  
        index index.html index.php;  
        root /var/www/html;  
    }  

    location ~ \.php$ {  
        root  html;
        fastcgi_pass   127.0.0.1:9000;  
        fastcgi_index  index.php;  
        fastcgi_param  SCRIPT_FILENAME  /var/www/html/\$fastcgi_script_name;    
        include        fastcgi_params;  
    }  
}   
EOF

#restart nginx
service nginx restart
