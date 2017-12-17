FROM ubuntu:16.04
MAINTAINER AashisKhanal[sraashis@gmail.com]

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections


#----------Java 8 setup-----------
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

#----------Pytho3 and pip3--------
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
#RUN pip install -r requirements.txt


#----------Scala setup------------
RUN apt-get install -y scala


#--------spark setup--------------
ARG spark_path=/usr/local/spark

ARG spark_url=http://mirrors.advancedhosters.com/apache/spark/spark-2.2.1/
ARG spark_release=spark-2.2.1-bin-hadoop2.7.tgz

RUN mkdir -p ${spark_path}

RUN wget ${spark_url}${spark_release}
RUN tar xvzf ${spark_release} -C ${spark_path}
RUN rm ${spark_release}


#-------Passwordless SSH-----------
ARG SPARK_USER=ak
RUN apt-get update 
RUN apt-get install -y openssh-server
RUN adduser ${SPARK_USER} --gecos "Docker User,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo 'ak:redhat' | chpasswd
RUN usermod -a -G sudo ak
RUN su ak

RUN mkdir -p /home/${SPARK_USER}/.ssh
RUN mkdir -p /var/run/sshd

RUN chmod -R 755 /var/run/sshd

RUN chmod -R 700 /home/${SPARK_USER}/.ssh
RUN chown -R ak:ak /home/${SPARK_USER}/.ssh

RUN chmod -R 700 ${spark_path}
RUN chown -R ak:ak ${spark_path}

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Run ssh-copy-id ak@worker from master for passwordless login. First time Password is "redhat"

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 755 /etc/bootstrap.sh


#clean
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/
RUN rm -rf /var/cache/oracle-jdk8-installer

#---------SET ENVIRONMENTS in .env file used by docker-compose----------------------	

#ENTRY POINT
CMD ["bash"]
ENTRYPOINT ["/etc/bootstrap.sh"]

