#!/bin/bash
docker run --privileged --detach --name asm_grid -h gridserver -p 1521:1521 --shm-size 2048m -e TZ=UTC -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /boot:/boot --device=/dev/sdb1 ynixon/ynixon_asm_server
MYIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
echo ""
echo "To get into the docker you can:"
echo "1. ssh to the current server (locally/remotely):"
echo "   ssh grid@${MYIP} -p 2222"
echo "   or"
echo "   ssh root@${MYIP} -p 2222"
echo "2. get into docker container (locally):"
echo "   docker exec -it --user grid asm_grid bash -l"
echo "   or"
echo "   docker exec -it --user root asm_grid bash -l"
echo ""
