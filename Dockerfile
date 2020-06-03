FROM centos:7
LABEL maintainer="pavan4devops@gmail.com"

ARG MIRROR="https://repo1.maven.org/maven2/io/prestosql"
ARG PRESTO_VERSION="333"
ARG PRESTO_BIN="${MIRROR}/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz"
ARG PRESTO_CLI_BIN="${MIRROR}/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar"

ENV JAVA_HOME /usr/lib/jvm/java-11
ENV PRESTO_HOME /opt/presto
ENV PRESTO_USER presto
ENV PRESTO_CONF_DIR ${PRESTO_HOME}/etc
ENV PATH $PATH:$PRESTO_HOME/bin

USER root

RUN \
    set -xeu && \
    yum -y -q update && \
    yum -y -q install wget curl less java-11-openjdk-devel && \
    yum -q clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/* /var/tmp/* && \
    mkdir -p $PRESTO_HOME && \
    wget -q $PRESTO_BIN && \
    tar xzf presto-server-${PRESTO_VERSION}.tar.gz && \
    rm -rf presto-server-${PRESTO_VERSION}.tar.gz && \
    mv presto-server-${PRESTO_VERSION}/* $PRESTO_HOME && \
    rm -rf presto-server-${PRESTO_VERSION} && \
    mkdir -p ${PRESTO_CONF_DIR}/catalog/ && \
    mkdir -p ${PRESTO_HOME}/data && \
    cd ${PRESTO_HOME}/bin && \
    wget -q ${PRESTO_CLI_BIN} && \
    mv presto-cli-${PRESTO_VERSION}-executable.jar presto && \
    groupadd ${PRESTO_USER} --gid 1000 && \
    useradd ${PRESTO_USER} --uid 1000 --gid 1000 && \
    chmod +x presto && \
    chown -R ${PRESTO_USER}:${PRESTO_USER} $PRESTO_HOME
  
USER $PRESTO_USER
EXPOSE 8080
ENV LANG en_US.UTF-8
CMD ["launcher", "run"]
