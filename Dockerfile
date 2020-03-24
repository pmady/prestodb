FROM centos:7
RUN yum update -y \
&& yum install wget -y \
&& yum -y install haproxy \
&& rm /etc/haproxy/haproxy.cfg \
&& mkdir /opt/presto \
&& cd /opt/presto \
&& wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.214/presto-server-0.214.tar.gz \
&& tar -xvzf presto-server-0.214.tar.gz \
&& ln -s /opt/presto/presto-server-0.214 current \
&& rm /opt/presto/presto-server-0.214.tar.gz \
&& cd /opt/presto/current/plugin/hive-hadoop2/ \
&& wget https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar \
&& wget https://repo1.maven.org/maven2/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar \
&& wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/2.0.0/azure-storage-2.0.0.jar \
&& wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.3/hadoop-azure-2.7.3.jar \
&& wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar \
&& wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha3/hadoop-azure-datalake-3.0.0-alpha3.jar \
&& mkdir -p /opt/presto/current/etc/catalog \
&& yum install -y java-1.8.0-openjdk \
&& echo 'com.facebook.presto=INFO' > /opt/presto/current/etc/log.properties \
&& echo 'access-control.name=read-only' > /opt/presto/current/etc/access-control.properties

COPY etc/config.properties /opt/presto/current/etc/config.properties
COPY etc/jvm.config /opt/presto/current/etc/jvm.config
COPY etc/node.properties /opt/presto/current/etc/node.properties
COPY files/presto.service /etc/systemd/system/presto.service
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
#ENTRYPOINT ["/opt/presto/current/bin/launcher", "run"]
