#!/bin/bash
docker rm -f `docker ps -aq`
docker rmi ynixon/ynixon_asm_server
