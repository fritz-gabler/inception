#!/bin/bash   

if mysqladmin ping -h localhost -p"$(cat run/secrets/sql-root-pass)" > /dev/null 2>&1; then
  echo Mariadb is Healthy
  exit 0
else
  echo Mariadb failed and is unhealthy
  exit 1
fi
