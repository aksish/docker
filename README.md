# spark
Dockerfile for spark-ubunt-scala-python3
This image is intended to use as a spark worker, easy to deploy. It consists of Java 8, python 3, pip 3 and spark-2.2.1-bin-hadoop2.7.tgz.
Also, the container will have a new user name "ak" setup with PASSWORD ##>"redhat"<<##.
This is to authenticate the worker to master for password less login that initiates worker-master negotiation for spark.
For password less authentication just add:
~# ssh-copy-id ak@worker and use "redhat" as password for first and the last time.

To run service named worker:
~# ./run.sh worker
In run.sh
-------------------------
SERVICE_NAME=$1
docker-compose run --service-ports $SERVICE_NAME

Environment variables lies in a separate file name .env which will be captured by docker-compose.yml file.
Also for bootstraping we have a bootsrap.sh file which has following content for now:

#!/bin/bash
/usr/sbin/sshd
/bin/bash -c "$*"


