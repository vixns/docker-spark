FROM vixns/java8

# SPARK
ENV SPARK_VERSION 1.4.0
ENV HADOOP_VERSION 2.6
ENV SPARK_PACKAGE $SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV SPARK_HOME /usr/spark-$SPARK_PACKAGE
ENV PATH $PATH:$SPARK_HOME/bin
RUN curl -sL --retry 3 \
  "http://mirror.reverse.net/pub/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_PACKAGE.tgz" \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $SPARK_HOME /usr/spark

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    DISTRO=debian && \
    CODENAME=wheezy && \
    echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list && \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get -y install -yq --no-install-recommends mesos unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/mesos/zk && \
    rm /etc/mesos-master/quorum 

ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so

EXPOSE 7077

#CMD /usr/spark/bin/spark-class org.apache.spark.deploy.mesos.MesosClusterDispatcher 1