#-----------References------------
#https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile
#https://stackoverflow.com/questions/19275856/auto-yes-to-the-license-agreement-on-sudo-apt-get-y-install-oracle-java7-instal

FROM ubuntu:16.04
MAINTAINER AashisKhanal[sraashis@gmail.com]

#----------Java 8 setup-----------
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y scala
#RUN pip install -r requirements.txt


#--------spark setup--------------
ARG spark_path=/usr/local/spark

ARG spark_url=http://mirrors.advancedhosters.com/apache/spark/spark-2.2.1/
ARG spark_release=spark-2.2.1-bin-hadoop2.7.tgz

RUN mkdir ${spark_path}

RUN wget ${spark_url}${spark_release}
RUN tar xvzf ${spark_release} -C ${spark_path}
RUN rm ${spark_release}
 

#clean
RUN apt-get autoclean && apt-get autoremove
RUN rm -rf /var/lib/apt/lists/
RUN rm -rf /var/cache/oracle-jdk8-installer

#---------SET ENVIRONMENTS-----------------------
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
#ENV SPARK_HOME=/home/ak/spark-2.2.1-bin-hadoop2.7
#ENV PATH=$SPARK_HOME/bin:$PATH

#ENV PYSPARK_DRIVER_PYTHON=jupyter
#ENV PYSPARK_DRIVER_PYTHON_OPTS='notebook'

	
#Default command
CMD ["bash"]
