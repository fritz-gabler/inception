FROM debian:stable-slim


COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y php8.2-fpm php8.2-mysql

COPY tools/dowload_wp_cli.sh /tools/dowload_wp_cli.sh
COPY config/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN chmod +x tools/dowload_wp_cli.sh
CMD [ "sh", "/tools/dowload_wp_cli.sh" ]
