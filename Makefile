up:
	mkdir -p ./srcs/wp_and_nginx_dir
	docker-compose -f ./srcs/docker-compose.yml up

up-d:
	mkdir -p ./srcs/wp_and_nginx_dir
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

build:
	docker-compose -f ./srcs/docker-compose.yml build
