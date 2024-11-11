#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

wp config create --dbname={$MARIADB_DATABASE} \
  --dbuser={$MARIADB_USER} --dbpass={$MARIADB_PASSWORD} --allow-root

wp core install --url=fgabler.42.fr --title=inception \
   --admin_user={$WP_DB_USER} --admin_password={$WP_DB_USER_PASS} \
   --admin_email={$WP_DB_EMAIL} --allow-root

tail -f
