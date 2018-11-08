#!/bin/bash
docker save -o /depo/export/Docker_ynixon_asm_server.tar ynixon/ynixon_asm_server:latest
gzip /depo/export/docker_ynixon_asm_server.tar
