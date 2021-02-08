#!/bin/bash

export EDITOR=nano

# Run scripts
if [ -d /root/run.d ]; then
  for i in /root/run.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi



function mysql_run {
	/usr/bin/mysqld --basedir=/usr --datadir=/data/mysql --plugin-dir=/usr/lib/mariadb/plugin --user=mysql --log-error=/data/mysql/log.err --pid-file=run.pid $*
}


# Setup MySQL
if [ ! -d /data/mysql ]; then
	
	mkdir -p /data
	
	echo "Setup MySQL" >> /data/install.log
	
	mkdir -p /data/mysql
	chown mysql:mysql /data/mysql
	rm -rf /var/lib/mysql
	ln -s /data/mysql /var/lib/mysql
	
	echo "Install db" >> /data/install.log
	/usr/bin/mysql_install_db --datadir=/data/mysql --user=mysql >> /data/install.log 2>&1
	
	echo "Start MySQL" >> /data/install.log
	mysql_run &
	
	echo "Sleep 10 sec" >> /data/install.log
	sleep 10
	
	if [ ! -z $MYSQL_ROOT_USERNAME ] && [ ! -z $MYSQL_ROOT_PASSWORD ]; then
		
		echo "Setup user" >> /data/install.log
		mysql -h localhost -u root -e "CREATE USER '${MYSQL_ROOT_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> /data/install.log 2>&1
		mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ROOT_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" >> /data/install.log 2>&1
		mysql -h localhost -u root -e "flush privileges;" >> /data/install.log 2>&1
		
	fi
	
	echo "Stop MySQL" >> /data/install.log
	mysql -h localhost -u root -e "shutdown" >> /data/install.log 2>&1
	
	echo "Sleep 10 sec" >> /data/install.log
	sleep 10
	
	if [ -f /data/mysql/run.pid ]; then
		kill -s 9 `cat /data/mysql/run.pid`
		sleep 10
	fi
	
	echo "Install completed" >> /data/install.log
	
fi


if [ ! -z $MYSQL_ADMIN_PAGE ] && [ "$MYSQL_ADMIN_PAGE" = "1" ]; then
	echo "Start nginx"
	nginx
	
	echo "Start php7"
	/usr/sbin/php-fpm7
fi

echo "Start MySQL"

# Run MySQL
mysql_run $*

# Stop MySQL
echo "Stop MySQL"