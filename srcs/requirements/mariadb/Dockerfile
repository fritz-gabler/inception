FROM debian:stable-slim

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    apt-get clean


COPY tools/user-init.sh /tools/user-init.sh
RUN chmod +x /tools/user-init.sh
CMD [ "sh", "/tools/user-init.sh" ]
