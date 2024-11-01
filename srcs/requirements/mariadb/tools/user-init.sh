#!/bin/bash

if [ -z "$MARIADB-DATABASE" ]; then
  echo "MARIADB-DATABASE is not set"
  exit 1
else if [ -z "$MARIADB_USER" ]; then
  echo "MARIADB-DATABASE is not set"
  exit 1
else if [ -z "$MARIADB_PASSWORD" ]; then
  echo "MARIADB_PASSWORD is not set"
  exit 1


