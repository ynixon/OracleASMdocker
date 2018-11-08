#!/bin/bash

RED="\E[1;40;31m"
STD="\E[1;40;37m"
GREEN="\033[1;32m"

echo ""
echo -e "${GREEN}Local Images${STD}"
echo -e "${GREEN}============${STD}"
docker images 
echo ""
echo -e "${GREEN}Running Containers${STD}"
echo -e "${GREEN}==================${STD}"
docker ps 
echo ""
