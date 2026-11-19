COMPOSE = docker compose -f srcs/docker-compose.yml
VOLUMES = srcs_db_data srcs_wp_data

all: prepare
	$(COMPOSE) up --build -d

up: prepare
	$(COMPOSE) up -d

prepare:
	mkdir -p ~/data/db_data ~/data/wp_data
	-docker volume rm $(VOLUMES) 2>/dev/null

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down --volumes

fclean: clean
	$(COMPOSE) down --volumes --rmi local

purge: fclean
	rm -f ~/data/db_data/.initialized
	rm -rf ~/data/db_data/* ~/data/wp_data/*

re: fclean all

.PHONY: all up down clean fclean purge re prepare
