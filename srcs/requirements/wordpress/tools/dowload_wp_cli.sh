#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download


wp core install --url=fgabler.42.fr --title=inception --admin_user=admin \
       --admin_password=1234 --admin_email=fgabler.test@mail.com
