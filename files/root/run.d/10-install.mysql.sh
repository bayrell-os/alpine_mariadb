# Setup MySQL
if [ ! -d /data/mysql ]; then
	
	mkdir -p /data
	
	echo "Setup MySQL"
	
	mkdir -p /data/mysql
	chown mysql:mysql /data/mysql
	rm -rf /var/lib/mysql
	ln -s /data/mysql /var/lib/mysql
	
	echo "Install db"
	/usr/bin/mysql_install_db --datadir=/data/mysql --user=mysql >> /data/install.log 2>&1
	
	echo "Start MySQL"
	/usr/bin/mysqld --basedir=/usr --datadir=/data/mysql --plugin-dir=/usr/lib/mariadb/plugin \
		--user=mysql --log-error=/data/mysql/log.err --pid-file=run.pid &
	
	echo "Sleep 10 sec"
	sleep 10
	
	if [ ! -z $MYSQL_ROOT_USERNAME ] && [ ! -z $MYSQL_ROOT_PASSWORD ]; then
		
		echo "Setup user"
		echo "Setup user" >> /data/install.log
		mysql -h localhost -u root -e "CREATE USER '${MYSQL_ROOT_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> /dev/null 2>&1
		mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ROOT_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" >> /dev/null 2>&1
		mysql -h localhost -u root -e "flush privileges;" >> /dev/null 2>&1
		
	fi
	
	echo "Stop MySQL"
	mysql -h localhost -u root -e "shutdown" >> /dev/null 2>&1
	
	echo "Sleep 10 sec"
	sleep 10
	
	if [ -f /data/mysql/run.pid ]; then
		kill -s 9 `cat /data/mysql/run.pid`
		sleep 10
	fi
	
	echo "Install completed"
	
fi

rm -f /data/mysql/log.err
ln -sf /dev/stdout /data/mysql/log.err

sed -i "s|%CMD%|${MYSQL_CMD}|g" /etc/supervisor.d/mysql.ini