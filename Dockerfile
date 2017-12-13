FROM aptible/debian:jessie

ENV INFLUXDB_USER influxdb
ENV INFLUXDB_GROUP influxdb

RUN groupadd -r "$INFLUXDB_GROUP" \
 && useradd -r -g "$INFLUXDB_GROUP" "$INFLUXDB_USER"

ADD script /script
RUN /script/install-influxdb.sh

RUN apt-install pwgen sudo

ENV DATA_DIRECTORY /var/db
ENV PORT 8086

RUN mkdir "$DATA_DIRECTORY" \
 && chown -R "${INFLUXDB_USER}:${INFLUXDB_GROUP}" "$DATA_DIRECTORY"

VOLUME ["$DATA_DIRECTORY"]
EXPOSE "$PORT"

ADD template /template
ADD bin /usr/local/bin
ADD test /tmp/test

ENTRYPOINT ["/usr/local/bin/run-database.sh"]
