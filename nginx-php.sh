#!/bin/env bash

. basic/helper.sh

if is_centos
then
	rpm -Uvh http://centos.alt.ru/repository/centos/5/x86_64/centalt-release-5-3.noarch.rpm
fi

install_package libxml2 libxml2-devel autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel  zlib zlib-devel glibc glibc-devel glib2 glib2-devel nginx php spawn-fcgi


#configure php
sed  -i '/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php.ini
sed  -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php.ini
sed  -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php.ini
sed  -i 's/max_input_time = 60/max_input_time = 300/' /etc/php.ini
sed  -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php.ini
sed  -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php.ini

#configure cgi
cat << EOF >> /usr/bin/php-fastcgi
#!/bin/sh
/usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -u nginx -g nginx -C 2 -f /usr/bin/php-cgi
EOF
chmod 755 /usr/bin/php-fastcgi
cat << EOF >> /etc/init.d/fastcgi
#!/bin/bash
PHP_SCRIPT=/usr/bin/php-fastcgi
RETVAL=0
case "$1" in
start)
	echo "Starting fastcgi"
	$PHP_SCRIPT
	RETVAL=$?
;;
stop)
	echo "Stopping fastcgi"
	killall -9 php5-cgi
	RETVAL=$?
;;
restart)
	echo "Restarting fastcgi"
	killall -9 php5-cgi
	$PHP_SCRIPT
	RETVAL=$?
;;
*)
	echo "Usage: php-fastcgi {start|stop|restart}"
	exit 1
;;
esac
exit $RETVAL
EOF
chmod 755 /etc/init.d/fastcgi
update-rc.d fastcgi defaults

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
chkconfig nginx on

#restart nginx
service nginx restart
#restart fastcgi
service fastcgi restart

