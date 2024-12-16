FROM debian:bullseye


#COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-imagick \
    php7.4-dom \
    php7.4-zip

#RUN mkdir /run/php

COPY tools/dowload_wp_cli.sh /tools/dowload_wp_cli.sh
COPY config/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod +x tools/dowload_wp_cli.sh
CMD [ "sh", "/tools/dowload_wp_cli.sh" ]
