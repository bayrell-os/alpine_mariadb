FROM bayrell/alpine:3.11

RUN cd ~; \
	apk add mariadb mariadb-client; \
	rm -rf /var/cache/apk/*; \
	echo "Ok"

ADD files /src/files
RUN cd ~; \
	echo "[mysqld]" > /etc/my.cnf.d/docker.cnf; \
	echo "datadir=/data/mysql" >> /etc/my.cnf.d/docker.cnf; \
	echo "skip-host-cache" >> /etc/my.cnf.d/docker.cnf; \
	echo "skip-name-resolve" >> /etc/my.cnf.d/docker.cnf; \
	echo "bind-address=0.0.0.0" >> /etc/my.cnf.d/docker.cnf; \
	mkdir -p /run/mysqld; \
	chown mysql:mysql /run/mysqld; \
	rm -f /etc/my.cnf.d/mariadb-server.cnf; \
	cp -rf /src/files/root/* /root/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo "Ok"


ENTRYPOINT ["/root/run.sh"]
CMD []