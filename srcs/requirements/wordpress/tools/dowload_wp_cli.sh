#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

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

#tail -f
