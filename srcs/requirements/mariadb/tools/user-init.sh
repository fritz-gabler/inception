#!/bin/bash

MARIADB_PASSWORD=$(cat /run/secrets/maria-pass)

if [ -z "$MARIADB_DATABASE" ]; then
  echo "MARIADB_DATABASE is not set"
  exit 1
elif [ -z "$MARIADB_USER" ]; then
  echo "MARIADB_USER is not set"
  exit 1
fi


if [ ! -f "/etc/mysql/init.sql" ]; then
  touch /etc/mysql/init.sql
  echo creaded file init.sql
fi

chmod 0777 /etc/mysql/init.sql
cat << EOF > /tools/init.sql
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
EOF

FILE=run/mysqld/mysqld.sock

if [ ! -f "$FILE" ]; then
  mkdir -p /run/mysqld/
  touch /run/mysqld/mysqld.sock
  echo created file mysqld.sock
fi

sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/g" "/etc/mysql/mariadb.conf.d/50-server.cnf"
sed -i "s/^user[[:space:]]*=[[:space:]]*mysql/user = root/" "/etc/mysql/mariadb.conf.d/50-server.cnf"

mariadbd

echo AFTER CREATION OF USER AND DATABASE
