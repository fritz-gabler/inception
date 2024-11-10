FROM debian:stable-slim


COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y php8.2 php8.2-fpm



COPY tools/dowload_wp_cli.sh /tools/dowload_wp_cli.sh
RUN chmod +x tools/dowload_wp_cli.sh
CMD [ "sh", "/tools/dowload_wp_cli.sh" ]
