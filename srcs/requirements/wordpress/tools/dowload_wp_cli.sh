#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#MARIADB_PASSWORD = $(cat /run/secrets/maria-pass)
#AUTHOR_PASS = $(cat /run/secrets/author_pass)
#WP_DB_USER_PASS = $(cat /run/secrets/wp-db-user-pass)

mkdir -p /var/www/html/mysite
mkdir -p /run/php

if [ ! -f "/var/www/html/mysite/index.php" ]; then
  wp core download --allow-root --path="/var/www/html/mysite/"
fi

cd /var/www/html/mysite/

if [ ! -f "/var/www/html/mysite/wp-config.php" ]; then
  wp config create \
  --dbname=$MARIADB_DATABASE \
  --dbuser=$MARIADB_USER \
  --dbhost='mariadb' \
  --allow-root \
  --path="/var/www/html/mysite/" \
  --prompt=dbpass < /run/secrets/maria-pass \


fi

if ! wp core is-installed --path="/var/www/html/mysite/" --allow-root; then
  wp core install \
    --url=https://fgabler.42.fr \
    --title=inception \
    --admin_user=$WP_DB_USER \
    --admin_email=$WP_DB_EMAIL \
    --allow-root \
    --prompt=admin_password < /run/secrets/wp-db-user-pass
fi

if ! wp user exists $AUTHOR_NAME --allow-root; then
  wp user create \
    $AUTHOR_NAME \
    $AUTHOR_MAIL \
    --role=author \
    --allow-root \
    --prompt=user_pass < /run/secrets/author_pass
  echo 'Author user got created'
fi



php-fpm7.4 -F
