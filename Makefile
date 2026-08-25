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

re: fclean all

.PHONY: all up down clean fclean re
