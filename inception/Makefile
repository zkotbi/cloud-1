
CONFIG_FILE = srcs/docker-compose.yml

all: up

up: volumes
	docker-compose -f  ${CONFIG_FILE} up -d

down:
	docker-compose -f  ${CONFIG_FILE} down

rebuild: down
	docker-compose -f  ${CONFIG_FILE} up -d --build


volumes:
	mkdir -p ${HOME}/data/mariadb
	mkdir -p ${HOME}/data/wordpress
	mkdir -p ${HOME}/data/adminer

purge: 
	docker stop $(shell docker ps -a -q)
	docker system prune -a --volumes
