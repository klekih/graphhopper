FROM openjdk:8-jdk

ENV JAVA_OPTS "-server -Xconcurrentio -Xmx1g -Xms1g -XX:+UseG1GC -XX:MetaspaceSize=100M -Ddw.server.applicationConnectors[0].bindHost=0.0.0.0 -Ddw.server.applicationConnectors[0].port=8989"

RUN mkdir -p /data && \
    mkdir -p /graphhopper

COPY . /graphhopper/

WORKDIR /graphhopper

RUN ./graphhopper.sh build

RUN mkdir local-maps

RUN curl https://download.geofabrik.de/europe/romania-latest.osm.pbf -o "local-maps/romania-latest.osm.pbf"

VOLUME [ "/data" ]

EXPOSE 8989

ENTRYPOINT [ "./graphhopper.sh", "web" ]

CMD [ "/graphhopper/local-maps/romania-latest.osm.pbf" ]
