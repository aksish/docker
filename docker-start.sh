#!/bin/bash
#NO whote space after\ or before new line
docker run -it --rm \
--hostname worker1 \
--add-host  ux330uak:10.0.0.224 \
nubuntu:sparks

#Another way and this maps ports in docker-compsoe.yml file
#docker-compose run --service-ports <service-name>


