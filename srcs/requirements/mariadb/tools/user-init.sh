#!/bin/bash

MARIADB_PASSWORD=$(cat /run/secrets/maria-pass)

if [ -z "$MARIADB_DATABASE" ]; then
  echo "MARIADB_DATABASE is not set"
  exit 1
elif [ -z "$MARIADB_USER" ]; then
  echo "MARIADB_USER is not set"
  exit 1
fi



mkdir -p /run/mysqld/
chown -R mysql:mysql /run/mysqld/
#FILE=run/mysqld/mysqld.sock

#if [ ! -f "$FILE" ]; then
#  touch /run/mysqld/mysqld.sock
#  echo created file mysqld.sock
#fi

#if [ ! -f "/etc/mysql/init.sql" ]; then
#  touch /etc/mysql/init.sql
#  echo creaded file init.sql
#fi

cat << EOF > /tools/init.sql
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
EOF
chmod 777 /etc/mysql/init.sql


sed -i "s/bind-address            = 127.0.0.1/bind-address            = mariadb/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"

mariadbd 
