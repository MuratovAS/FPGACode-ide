#!/bin/bash
if(( $(docker ps -a --filter status=running --filter name=$(pwd | sed -n '{s@.*/@@; p}') | wc -l) == 1 )) 
then
    docker start $(pwd | sed -n '{s@.*/@@; p}') 
fi
docker exec -it $(pwd | sed -n '{s@.*/@@; p}') /bin/bash -c "source /root/.bashrc && $*"