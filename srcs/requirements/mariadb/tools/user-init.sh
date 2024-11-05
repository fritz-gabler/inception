#!/bin/bash

if [ -z "$MARIADB_DATABASE" ]; then
  echo "MARIADB_DATABASE is not set"
  exit 1
elif [ -z "$MARIADB_USER" ]; then
  echo "MARIADB_USER is not set"
  exit 1
elif [ -z "$MARIADB_PASSWORD" ]; then
  echo "MARIADB_PASSWORD is not set"
  exit 1
fi


if [ ! -f "init.sql" ]; then
  touch /tools/init.sql
  echo creaded file init.sql
fi

chmod 0777 /tools/init.sql
cat << EOF > /tools/init.sql
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;
GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PASSWORD';
EOF

FILE=run/mysqld/mysqld.sock
if [ ! -f "$FILE" ]; then
  mkdir /run/mysqld/
  touch /run/mysqld/mysqld.sock
  echo created file mysqld.sock
fi

mariadbd --user=root --init-file=/tools/init.sql
