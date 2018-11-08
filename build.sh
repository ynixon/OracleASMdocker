#!/bin/bash

FULL_FILE_NAME=${self:-${0##*/}}
FILE_NAME="${FULL_FILE_NAME%.*}"
export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR=${SCRIPT_DIR}
LOG_FILE=${LOG_DIR}/${FILE_NAME}_run.log


infomsg()
{
 echo -e "$@" >> ${LOG_FILE} 2>&1
}

runcmd()
{
infomsg "$@"
eval "$@" 2>&1
if [ $? -eq 0 ]; then
    infomsg "=== done ==="
else
    infomsg "Failed " "$@" "at ${FUNCNAME[1]}[${BASH_LINENO[1]}] \nAborting...\n"
    exit 1
fi
}

runcmd "cd ${SCRIPT_DIR}/docker_folder/"
#build base
runcmd "docker build -t ynixon/docker_grid_asm ."
# run base
runcmd "docker run --privileged --detach --name asm_grid_build -h gridserver -p 1521:1521 -p 2222:22 --shm-size 2048m -e TZ=UTC -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /depo:/software --volume /boot:/boot --device=/dev/sdb1 --restart always ynixon/docker_grid_asm"
# run install script
runcmd "docker exec -it asm_grid_build su - grid -c '/software/install_grid.sh'"
# commit the changes
runcmd "docker commit -m \"oracle linux 7.5 standalone grid infrastructure with ASM\" -a \"Yossi Nixon <ynixon@gmail.com>\" `docker ps -lq` ynixon/ynixon_asm_server"
# clean intermediate image
runcmd "docker rm -f asm_grid_build"
