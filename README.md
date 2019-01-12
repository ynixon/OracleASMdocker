# OracleASMdocker
Oracle Linux ASM docker

[![](https://1.bp.blogspot.com/-A_7v97I-hpk/W-WBFEI-fUI/AAAAAAAF7cw/td69KmT0lgITIpwAwtHhocdS_dBuZX0kgCLcBGAs/s320/EGH_NodeDocker_1000.png)](https://draft.blogger.com/null)

General information
-------------------

In this setup we are:

*   Installing docker
*   Creating Non-root user (ynixon) with sudo and docker privileges
*   ASM device: /dev/sdb1
*   Enabling sqlnet + ssh to the container
*   Default ASM port is 1521
*   ssh port 2222
*   Passwords for root + grid os users in the container are “ynixon”
*   Password for sys ASM user is “ynixon”
*   Grid software is 12.2 without any patches
*   Container Operating system is Oracle Linux 7.5
*   Within the container, there is no use of UDEV / ASMLIB or ASMFD – the asm\_diskstring='/dev/asm\*' ,'/dev/\*'
*   All test done on regular Ubuntu 14.04
*   There is a crontab job to keep 15 days of trace files + remove audit files.

Prepare host for ASM device
---------------------------

#### Make sure the device has permissions of the same container ids by applying UDEV rules

> $ vi /etc/udev/rules.d/100-asm.rules KERNEL=="sdb1", NAME="ASM\_DISK", OWNER="54421", GROUP="54421", MODE="0660" udevadm trigger --sysname-match=sdb1 --verbose

#### Verify the device has ASM lables

> DISK\_GROUP=$( blkid | grep oracleasm | sed 's/.\*LABEL=\\"\\(\[^\\"\]\*\\)\\" TYPE=\\"oracleasm\\"/\\1/') if \[ -z "$DISK\_GROUP" \] then     echo "device /dev/sdb1 has not asm metadata" else     echo "device /dev/sdb1 has diskgroup $DISK\_GROUP" fi

Install Docker
--------------

As root

> $ curl -fsSL https://get.docker.com/ | sh

Or

> $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - add-apt-repository "deb \[arch=amd64\] https://download.docker.com/linux/ubuntu $(lsb\_release -cs) stable" $ apt-get update $ apt-cache policy docker-ce $ apt-get install -y docker-ce $ service docker status

Add users
---------

As root Equivalent user ids to the docker to follow (will be identified from outside)

> $ groupadd -g 54422 asmadmin $ useradd -u 54421 -g 54422 grid

A dedicated user to manage the docker

> $ adduser ynixon -g 54422 $ echo "ynixon:ynixon" | chpasswd $ usermod -aG docker ynixon $ usermod -aG sudo ynixon $ sed -i '/PasswordAuthentication/d' /etc/ssh/sshd\_config ; echo "PasswordAuthentication no" >> /etc/ssh/sshd\_config sed -i '/PubkeyAuthentication/d' /etc/ssh/sshd\_config ; echo "PubkeyAuthentication yes" >> /etc/ssh/sshd\_config sed -i '/ChallengeResponseAuthentication/d' /etc/ssh/sshd\_config ; echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd\_config $ service ssh reload

Building a new image
--------------------

If you already have an image file skip to **Load image**. In this step we will create a new image from scratch, and pack it at the end. You can run /depo/build.sh + /depo/export.sh or run the following manual steps:

#### Prepare the files

As root

> $ mkdir /depo/ $ chown -R root:54422 /depo/ $ chmod 775 /depo $ git clone https://github.com/ynixon/OracleASMdocker.git /depo/

Ensure you download the file linuxx64\_12201\_grid\_home.zip and copy it to /depo/ folder

List of the files

**Script**

**Description**

**adrci\_script.sh**

A script to that will run for crontab to delete trace files periodically

**build.sh**

A script to build a docker image

**clean.sh**

A script to clean all docker containers and an image

**crontab.setup**

A cronjob script for grid user that will delete trace files periodically

**disks.sql**

An SQL script for listing disks

**docker\_descendants.py**

A script to check docker images dependencies

**docker\_folder/Dockerfile**

Build instruction for docker image

**export.sh**

Export a docker image and compress it

**glogin.sql**

setting SQL\*Plus prettier output

**grants.sql**

grants for the build process

**init+ASM.ora**

The initialization file for ASM instance

**install\_grid.sh**

Install script for grid

**linuxx64\_12201\_grid\_home.zip**

Oracle 12.2 Grid software (no patches) download it separately

**listener.ora**

Listener file

**oracle\_asm**

Logrotate for oracle logfiles

**rlwrap-0.42-1.el7.x86\_64.rpm**

Handy tool to enable history in SQL\*Plus, asmcmd

**run.sh**

Start a container

**status.sh**

Images and Container status

#### Run build image

As root/ynixon

> $ cd /depo/docker\_folder $ docker build -t ynixon/docker\_grid\_asm .

#### Run image detached (at background)

> $ docker run --rm --privileged --detach --name asm\_grid\_build -h gridserver -p 1521:1521 -p 2222:22 --shm-size 2048m -e TZ=UTC \-v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /depo:/software --volume /boot:/boot --device=/dev/sdb1 ynixon/docker\_grid\_asm

#### Install grid software

> $ docker exec -it asm\_grid\_build su - grid -c '/software/install\_grid.sh'

#### Save the image with the grid

> $ docker commit -m "oracle linux 7.5 standalone grid infrastructure with ASM" -a "Yossi Nixon" \`docker ps -lq\` ynixon/ynixon\_asm\_server

#### Remove intermediate image (without the grid)

> $ docker rm -f asm\_grid\_build

#### Optional – check the the new image

Run the container at the background

> $ docker run --privileged --detach --name asm\_grid -h gridserver -p 1521:1521 -p 2222:22 --shm-size 2048m -e TZ=UTC -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /depo:/software --volume /boot:/boot --device=/dev/sdb1 --restart always ynixon/ynixon\_asm\_server

Connect to the new container to verify the environment

> $ docker exec -it --user grid asm\_grid bash -l

#### Export the image and compress it

> $ docker save -o /depo/export/docker\_ynixon\_asm\_server.tar ynixon/ynixon\_asm\_server:latest $ gzip docker\_ynixon\_asm\_server.tar

Load image
----------

Copy the file docker\_ynixon\_asm\_server.tar.gz to /tmp

#### Uncompress the file

> $ gunzip /tmp/docker\_ynixon\_asm\_server.tar.gz

#### Load the file into the local container repository

> $ docker load -i /depo/export/docker\_ynixon\_asm\_server.tar

#### Run a container based on the loaded image

> $ docker run --privileged --detach --name asm\_grid -h gridserver -p 1521:1521 -p 2222:22 --shm-size 2048m -e TZ=UTC \-v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume /boot:/boot --device=/dev/sdb1 \--restart always ynixon/ynixon\_asm\_server

Test Connection from remote machines:
-------------------------------------

> $ ssh root@ -p 2222$ sqlplus sys/ynixon@:1521/+ASM as sysasm

Deploy Web Interface – Portainer
--------------------------------

> $ docker volume create portainer\_data $ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer\_data:/data portainer/portainer

Open browser at: http://<docker server>:9000/ [Yossi](https://twitter.com/YossiNixon)
