FROM debian:stable-slim

RUN apt-get update \
    apt-get upgrade -y \
    apt-get install mariadb-server \
    apt-get install clean


