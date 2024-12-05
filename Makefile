SECRETS = secrets

up:
	mkdir -p /home/fgabler/data/wp_and_nginx_dir
	mkdir -p /home/fgabler/data/mariadb-dir
	docker compose -f ./srcs/docker-compose.yml up

up-d:
	mkdir -p /home/fgabler/data/wp_and_nginx_dir
	mkdir -p /home/fgabler/data/mariadb-dir
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

build:
	docker compose -f ./srcs/docker-compose.yml build

re-d: down build up-d

re: down build up

secret_files:
	mkdir -p secrets
	touch ./$(SECRETS)/author_pass.txt
	touch ./$(SECRETS)/maria-pass.txt
	touch ./$(SECRETS)/wp-db-user-pass.txt
	touch ./$(SECRETS)/sql_root_pass.txt

rm-dir:
	@rm -rf ./srcs/wp_and_nginx_dir ./srcs/mariadb-dir
	@sudo rm -rf  /home/fgabler/data/mariadb-dir  /home/fgabler/data/wp_and_nginx_dir
	@echo volume directory and wp_and_nginx_dir mariadb_dir are removed now

rm-vol: 
	docker volume rm wp-and-nginx-dir mariadb-vol

rm-all:
	docker system prune -a
