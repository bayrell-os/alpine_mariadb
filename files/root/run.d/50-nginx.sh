if [ -z $MYSQL_ADMIN_PAGE ] || [ "$MYSQL_ADMIN_PAGE" != "1" ]; then
	
	rm -f /etc/supervisor.d/nginx.ini
	rm -f /etc/supervisor.d/php-fpm.ini
	
fi