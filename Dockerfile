FROM anapsix/alpine-java:8_jdk


ARG kafka_version=2.1.0
ARG scala_version=2.12
ARG exporter_version=0.11.0
RUN apk add --update unzip wget curl docker jq coreutils tzdata
RUN ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime
RUN mkdir /etc/zookeeper /etc/kafka 

ENV KAFKA_VERSION=$kafka_version SCALA_VERSION=$scala_version EXPORTER_VERSION=$exporter_version

ADD download-kafka.sh /tmp/download-kafka.sh
RUN chmod a+x /tmp/download-kafka.sh && \
    sync && /tmp/download-kafka.sh && \
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
RUN mkdir /opt/jmx_exporter && \
    wget -q https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${EXPORTER_VERSION}/jmx_prometheus_javaagent-${EXPORTER_VERSION}.jar \
    -P /opt/jmx_exporter/

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin

#CMD ["start-kafka.sh"]
