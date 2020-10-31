# alpine_mariadb

Maria Database Server


## Enviroments

MYSQL_ROOT_USERNAME - Root user name

MYSQL_ROOT_PASSWORD - Root password

MYSQL_ADMIN_PAGE - If equal 1 then run web admin page (not recommended, but sometimes can use)

## Ports

3306 - Mysql

81 - Admin page

## Command line

Create network
```
docker network create -d bridge \
	--subnet=172.20.0.0/16 dockernet -o "com.docker.network.bridge.name"="dockernet"
docker volume create mariadb_data
```

Run
```
docker run -d -e MYSQL_ROOT_PASSWORD=mysqlrootpassword \
	--name mariadb --log-driver=journald --restart=unless-stopped \
	-v mariadb_data:/data --ip=172.20.0.5 --network="dockernet" bayrell/alpine_mariadb:10.4 \
	--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci \
	--sql-mode="" --ft_min_word_len=1 --bind-address=172.20.0.5 \
	--wait_timeout=600 --max_allowed_packet=1G --innodb_buffer_pool_size=100M \
	--net_read_timeout=3600 --net_write_timeout=3600
```


## Docker swarm

Yaml file:

```
version: "3.7"

services:

    mysql1:
        image: bayrell/alpine_mariadb:10.4
        command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --sql-mode="" --ft_min_word_len=1 --wait_timeout=600 --max_allowed_packet=1G --innodb_buffer_pool_size=100M --net_read_timeout=3600 --net_write_timeout=3600
        hostname: "{{.Service.Name}}.{{.Task.ID}}.local"
        volumes:
            - "mysql1_data:/data"
        environment:
			DOCKER: 1
			DOCKER_NODE_ID: {{.Node.ID}}
			DOCKER_TASK_ID: {{.Task.ID}}
			DOCKER_SERVICE_ID: {{.Service.ID}}
			MYSQL_ROOT_USERNAME: "lasto4ka"
            MYSQL_ROOT_PASSWORD: "7DF&d7jr!Lk5rZ^b"
        deploy:
            replicas: 1
            endpoint_mode: dnsrr
            update_config:
                parallelism: 1
                failure_action: rollback
                delay: 5s
            restart_policy:
                condition: "on-failure"
                delay: 10s
                window: 120s
        networks:
            - backend
        logging:
            driver: journald

volumes:
    mysql1_data:

networks:

    backend:
        driver: overlay
        attachable: true

```
