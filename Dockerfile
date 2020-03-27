FROM centos:7

ENV PRESTO_VERSION="0.233.1"
ARG TYPE="coordinator"

RUN yum update -y \
&& yum install wget -y \
&& mkdir /opt/presto \
&& cd /opt/presto \
&& wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz \
&& tar -xvzf presto-server-${PRESTO_VERSION}.tar.gz \
&& ln -s /opt/presto/presto-server-${PRESTO_VERSION} current \
&& rm /opt/presto/presto-server-${PRESTO_VERSION}.tar.gz \
&& mkdir -p /opt/presto/current/etc/catalog \
&& yum install -y java-1.8.0-openjdk \
&& echo 'com.facebook.presto=INFO' > /opt/presto/current/etc/log.properties \
&& echo 'access-control.name=read-only' > /opt/presto/current/etc/access-control.properties

COPY ${TYPE}-etc/ /opt/presto/current/etc/
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["bash", "/entrypoint.sh"]
#ENTRYPOINT ["/opt/presto/current/bin/launcher", "run"]
