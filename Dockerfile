FROM anapsix/alpine-java:8_jdk

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG kafka_version=0.10.2.1
ARG scala_version=2.12

RUN apk add --update unzip wget curl docker jq coreutils
RUN mkdir /etc/zookeeper /etc/kafka 

ENV KAFKA_VERSION=$kafka_version SCALA_VERSION=$scala_version

ADD download-kafka.sh /tmp/download-kafka.sh
RUN chmod a+x /tmp/download-kafka.sh && sync && /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

RUN mkdir /opt/jmx_exporter && wget -q https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.9/jmx_prometheus_javaagent-0.9.jar -P /opt/jmx_exporter/

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin

#CMD ["start-kafka.sh"]
