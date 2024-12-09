FROM debian:bullseye

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get install -y sed && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY tools/healthcheck.sh /tools/healthcheck.sh
COPY tools/user-init.sh /tools/user-init.sh
RUN chmod +x /tools/user-init.sh
CMD [ "sh", "/tools/user-init.sh" ]
