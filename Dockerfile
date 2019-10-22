FROM ubuntu:18.04

WORKDIR /opt/

ENV SPARK_VERSION 2.4.0
ENV HADOOP_VERSION 2.7
ENV BIGDL_VERSION 0.9.0

ENV BIGDL_HOME /opt/big_dl
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /opt/jdk

ENV PATH ${JAVA_HOME}/bin:${PATH}

# Install linux packages
RUN apt-get update && \
  apt-get install -y vim curl wget vim unzip git

# Install Java
RUN wget -q --show-progress --progress=bar:force:noscroll \
  https://build.funtoo.org/distfiles/oracle-java/jdk-8u152-linux-x64.tar.gz && \
  gunzip jdk-8u152-linux-x64.tar.gz && \
  tar -xf jdk-8u152-linux-x64.tar -C /opt && \
  rm jdk-8u152-linux-x64.tar && \
  ln -s /opt/jdk1.8.0_152 $JAVA_HOME

# Install Python
RUN apt-get install -y python3 python3-pip python-numpy python-six

# Apache Spark
RUN wget -q --show-progress --progress=bar:force:noscroll \
  https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  && tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  && mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME \
  && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# Big DL: Download pre-built libs
RUN wget -q --show-progress --progress=bar:force:noscroll \
  https://repo1.maven.org/maven2/com/intel/analytics/bigdl/dist-spark-$SPARK_VERSION-scala-2.11.8-all/$BIGDL_VERSION/dist-spark-$SPARK_VERSION-scala-2.11.8-all-$BIGDL_VERSION-dist.zip \
  && unzip dist-spark-$SPARK_VERSION-scala-2.11.8-all-$BIGDL_VERSION-dist.zip -d $BIGDL_HOME \
  && rm dist-spark-$SPARK_VERSION-scala-2.11.8-all-$BIGDL_VERSION-dist.zip

# Big DL: Save the libs in the environment and save in config
ENV PYTHON_API_ZIP_PATH=$BIGDL_HOME/lib/bigdl-$BIGDL_VERSION-python-api.zip
ENV BIGDL_JAR_PATH=$BIGDL_HOME/lib/bigdl-SPARK_2.4-$BIGDL_VERSION-jar-with-dependencies.jar
RUN echo "spark.driver.extraClassPath\t${BIGDL_JAR_PATH}" >> $BIGDL_HOME/conf/spark-bigdl.conf
RUN echo "spark.executor.extraClassPath\t${BIGDL_JAR_PATH}" >> $BIGDL_HOME/conf/spark-bigdl.conf

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

# Copy master, worker and submit script and make them executable
COPY start-master.sh start-master.sh
COPY start-worker.sh start-worker.sh
COPY submit.sh submit.sh
RUN chmod +x *.sh

COPY data /opt/data
COPY src /opt/src
