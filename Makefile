COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up --build -d

up:
	$(COMPOSE) up -d

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

.PHONY: all up down clean fclean purge re
