up:
	mkdir -p ./srcs/wp_and_nginx_dir
	mkdir -p ./srcs/mariadb-dir
	docker-compose -f ./srcs/docker-compose.yml up

up-d:
	mkdir -p ./srcs/wp_and_nginx_dir
	mkdir -p ./srcs/mariadb-dir
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

build:
	docker-compose -f ./srcs/docker-compose.yml build

re-d: down build up-d

re: down build up
