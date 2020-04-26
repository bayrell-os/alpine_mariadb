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
	
	echo "Setup MySQL"
	
	mkdir -p /data/mysql
	chown mysql:mysql /data/mysql
	rm -rf /var/lib/mysql
	ln -s /data/mysql /var/lib/mysql
	
	echo "Install db"
	/usr/bin/mysql_install_db --datadir=/data/mysql --user=mysql
	
	echo "Start MySQL"
	mysql_run &
	
	echo "Sleep 10 sec"
	sleep 10
	
	if [ ! -z $MYSQL_USERNAME ] && [ ! -z $MYSQL_PASSWORD ]; then
		
		echo "Setup user"
		mysql -u root -e "CREATE USER '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
		mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
		mysql -u root -e "flush privileges;"
		
	fi
	
	echo "Stop MySQL"
	mysql -u root -e "shutdown"
	
	echo "Sleep 10 sec"
	sleep 10
	
	if [ -f /data/mysql/run.pid ]; then
		kill -s 9 `cat /data/mysql/run.pid`
		sleep 10
	fi
	
fi


echo "Start MySQL"

# Run MySQL
mysql_run

# Stop MySQL
echo "Stop MySQL"