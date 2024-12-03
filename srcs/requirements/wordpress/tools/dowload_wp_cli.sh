#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

MARIADB_PASSWORD = $(cat /run/secrets/maria-pass)
AUTHOR_PASS = $(cat /run/secrets/author_pass)
WP_DB_USER_PASS = $(cat /run/secrets/wp-db-user-pass)

mkdir -p /var/www/html/mysite

if [ ! -f "/var/www/html/mysite/index.php" ]; then
  wp core download --allow-root --path="/var/www/html/mysite/"
fi

cd /var/www/html/mysite/

if [ ! -f "/var/www/html/mysite/wp-config.php" ]; then
  wp config create \
  --dbname=$MARIADB_DATABASE \
  --dbuser=$MARIADB_USER \
  --dbpass=$MARIADB_PASSWORD \
  --dbhost='mariadb' \
  --allow-root \
  --path="/var/www/html/mysite/"


fi

if ! wp user exists $AUTHOR_NAME --allow-root; then
  wp user create \
    $AUTHOR_NAME \
    $AUTHOR_MAIL \
    --role=author \
    --user_pass=$AUTHOR_PASS \
    --allow-root
  echo 'Author user got created'
fi


if ! wp core is-installed --path="/var/www/html/mysite/" --allow-root; then
  wp core install \
    --url=https://fgabler.42.fr \
    --title=inception \
    --admin_user=$WP_DB_USER \
    --admin_password=$WP_DB_USER_PASS \
    --admin_email=$WP_DB_EMAIL \
    --allow-root
fi

php-fpm8.2 -F
