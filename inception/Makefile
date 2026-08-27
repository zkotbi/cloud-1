CONFIG_FILE = srcs/docker-compose.yml
ENV_FILE    = srcs/.env

all: up

up: volumes
	docker compose -f ${CONFIG_FILE} --env-file ${ENV_FILE} up -d

down:
	docker compose -f ${CONFIG_FILE} down

rebuild: down
	docker compose -f ${CONFIG_FILE} --env-file ${ENV_FILE} up -d --build

volumes:
	mkdir -p ${HOME}/data/mariadb
	mkdir -p ${HOME}/data/wordpress

purge:
	docker stop $$(docker ps -qa) 2>/dev/null || true
	docker system prune -af --volumes
	sudo rm -rf ${HOME}/data/mariadb/* ${HOME}/data/wordpress/*

.PHONY: all up down rebuild volumes purge
