# docker build -t ynixon/docker_grid_asm .
# TBD: replace oraclelinux to oraclelinux:7-slim

FROM oraclelinux
MAINTAINER Yossi nixon <Yossi.Nixon@Axxana.com>
ENV container docker

ENV ORA_MOUNT_PATH /u01
ENV ORA_ORACLE_BASE /u01/app/oracle
ENV ORA_ORACLE_HOME /u01/app/oracle/product/12.2.0.1/dbhome_1
ENV GRID_ORACLE_BASE /u01/app/grid
ENV GRID_ORACLE_HOME /u01/app/12.2.0.1/grid
ENV ORAINVENTORY /u01/app/oraInventory
ENV GRID_SID ASM
ENV AXXANA_PASSWD axxana
ENV TZ UTC

##installpackages
RUN yum -y install oracle-database-server-12cR2-preinstall unzip sudo selinux-policy vim openssh openssh-server openssh-clients passwd net-tools wget less perl-Data-Dumper
RUN yum -y update
RUN yum -y clean all
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;\
ln -s /usr/lib/systemd/system/systemd-user-sessions.service  /etc/systemd/system/multi-user.target.wants/systemd-user-sessions.service;\
userdel -r oracle;\
chmod u+s /usr/bin/ping;

###################################################################################
##  Users and Groups
###################################################################################

# Add groups for grid infrastructure
RUN ["groupadd", "--force", "--gid", "54321", "oinstall"]
RUN ["groupmod", "--gid", "54321", "oinstall"]
RUN ["groupadd", "--gid", "54421", "asmdba"]
RUN ["groupadd", "--gid", "54422", "asmadmin"]
RUN ["groupadd", "--gid", "54423", "asmoper"]

# Add grid infrastructure owner
RUN useradd --create-home --uid 54421 --gid oinstall --groups asmdba,asmadmin,asmoper grid || \
    (RES=$? && ( [ $RES -eq 9 ] && exit 0 || exit $RES))
RUN ["usermod", "--uid", "54421", "--gid", "oinstall", "--groups", "asmdba,asmadmin,asmoper", "grid"]

# Give grid and oracle users passwords
RUN echo "grid:${AXXANA_PASSWD}" | chpasswd
RUN echo "root:${AXXANA_PASSWD}" | chpasswd

# Disable SELinux
RUN sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
RUN echo "grid ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN sed -i "s/^\(Defaults.*requiretty\)/#\1/" /etc/sudoers

# Add ulimits configuration file for grid user
# grid user ulimits configuration file already added by oracle-rdbms-server-12gR2-preinstall
RUN echo -e "grid     soft   nofile    1024\n\
grid     hard   nofile    65536\n\
grid     soft   nproc    16384\n\
grid     hard   nproc    16384\n\
grid     soft   stack    10240\n\
grid     hard   stack    32768\n\
grid     hard   memlock    134217728\n\
grid     soft   memlock    134217728\n\
" >> /etc/security/limits.conf

RUN echo -e "if [ \$USER = \"grid\" ]; then\n\
    if [ \$SHELL = \"/bin/ksh\" ]; then\n\
        ulimit -p 16384\n\
        ulimit -n 65536\n\
    else\n\
        ulimit -u 16384 -n 65536\n\
    fi\n\
    umask 022\n\
fi" >> /etc/profile

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

###################################################################################
##  SSH Shared Keys
###################################################################################

# Create SSH shared key directory for the grid user
RUN ["mkdir", "-p", "-m", "0700", "/home/grid/.ssh/"]

# Generate SSH shared keys for the grid user
RUN ssh-keygen -q -C '' -N '' -f /home/grid/.ssh/id_rsa

# Create the authorized_keys file for the grid user
RUN cat /home/grid/.ssh/id_rsa.pub > /home/grid/.ssh/authorized_keys

# Change ownership of the SSH shared key files for the grid user
RUN chown -R grid:oinstall /home/grid/.ssh

# Change permissions of the authorized_keys file for the grid user
RUN ["chmod", "0640", "/home/grid/.ssh/authorized_keys"]

# Generate SSH host ECDSA shared keys
RUN ssh-keygen -q -C '' -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key

# Create the ssh_known_hosts file
RUN cat /etc/ssh/ssh_host_ecdsa_key.pub >> /etc/ssh/ssh_known_hosts

## .bash_profile ###
RUN echo -e "#this is for grid install#\n\
if [ -t 0 ]; then\n\
        stty intr ^C\n\
fi" >> /home/grid/.bashrc
## .bash_profile ###
RUN echo -e "### for grid install ####\n\
export ORACLE_BASE=${GRID_ORACLE_BASE}\n\
export ORACLE_HOME=${GRID_ORACLE_HOME}\n\
export ORACLE_SID=+${GRID_SID^^}\n\
export ORACLE_PATH=/home/grid/scripts/sqls\n\
export oracle_sid=+${GRID_SID,,}\n\
export ORACLE_HOSTNAME=\`hostname\`\n\
" >> /home/grid/.bash_profile
RUN echo -e "export TMPDIR=/tmp\n\
export TEMP=/tmp\n\
export TZ=${TZ}\n\
export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/OPatch/:/usr/sbin:\$PATH\n\
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/usr/lib\n\
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib\n\
alias cds='cd \$ORACLE_HOME/dbs'\n\
alias cdo='cd \$ORACLE_HOME'\n\
alias cdn='cd \$ORACLE_HOME/network/admin'\n\
alias sqlplus='rlwrap sqlplus'\n\
alias asmcmd='rlwrap asmcmd -p'\n\
alias c='sqlplus / as sysasm'\n\
alias ll='ls -l --color=always'\n\
alias ls='ls --color=auto'\n\
alias talert='tail -200f \$ORACLE_BASE/diag/\${GRID_SID,,}/\${oracle_sid}/\${ORACLE_SID}/trace/alert_\${ORACLE_SID}.log'\n\
" >> /home/grid/.bash_profile

## create grid home
RUN  mkdir ${ORA_MOUNT_PATH} && \
     mkdir -p ${GRID_ORACLE_BASE} && \
     mkdir -p ${GRID_ORACLE_HOME} && \
     chown -R grid:oinstall ${ORA_MOUNT_PATH} && \
     chmod -R 775 ${ORA_MOUNT_PATH}

# oraInst.loc
RUN echo -e "inventory_loc=$ORAINVENTORY\n\
inst_group=oinstall" >> /etc/oraInst.loc
RUN chown grid:oinstall /etc/oraInst.loc

# Hide/disable the ttyS0 serial console service
RUN ["systemctl", "mask", "serial-getty@ttyS0.service"]

RUN systemctl enable sshd
RUN rm -rf /run/nologin

VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 1521 22

CMD ["/usr/sbin/init"]
