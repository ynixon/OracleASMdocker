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

# as grid
runcmd "unzip -q /software/linuxx64_12201_grid_home.zip -d /u01/app/12.2.0.1/grid/"
runcmd "/u01/app/12.2.0.1/grid/gridSetup.sh -silent -skipPrereqs -ignoreInternalDriverError -noconfig -noconsole -waitforcompletion INVENTORY_LOCATION=/u01/app/oraInventory oracle.install.option=CRS_SWONLY oracle.install.asm.OSDBA=asmdba oracle.install.asm.OSOPER=asmoper oracle.install.asm.OSASM=asmadmin oracle.install.crs.config.gpnp.scanPort=1521 oracle.install.crs.config.autoConfigureClusterNodeVIP=false oracle.install.crs.config.storageOption=ASM oracle.install.crs.config.gpnp.configureGNS=false oracle.installer.autoupdates.option=SKIP_UPDATES"
runcmd "cp /software/init+ASM.ora /u01/app/12.2.0.1/grid/dbs/"
runcmd "mkdir -p /home/grid/scripts/sqls/"
runcmd "cp /software/disks.sql /home/grid/scripts/sqls/"
runcmd "crontab /software/crontab.setup"

# as root
runcmd "sudo /u01/app/12.2.0.1/grid/root.sh"
runcmd "sudo /u01/app/12.2.0.1/grid/perl/bin/perl -I/u01/app/12.2.0.1/grid/perl/lib -I/u01/app/12.2.0.1/grid/crs/install /u01/app/12.2.0.1/grid/crs/install/roothas.pl"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/crsctl modify resource ora.cssd -attr AUTO_START=always -unsupported"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/crsctl modify resource ora.evmd -attr AUTO_START=always -unsupported"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/crsctl enable has"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/srvctl add asm -p /u01/app/12.2.0.1/grid/dbs/init+ASM.ora"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/crsctl start resource ora.cssd -init"
runcmd "sudo /u01/app/12.2.0.1/grid/bin/crsctl start resource ora.asm -init"
runcmd "sudo rpm -Uhv /software/rlwrap-0.42-1.el7.x86_64.rpm --replacepkgs"
runcmd "sudo cp /software/oracle_asm /etc/logrotate.d/"

# as grid
runcmd "cp /software/listener.ora /u01/app/12.2.0.1/grid/network/admin/"
runcmd "/u01/app/12.2.0.1/grid/bin/orapwd file=/u01/app/12.2.0.1/grid/dbs/orapw+ASM password=ynixon force=y format=12"
runcmd "cp /software/glogin.sql $ORACLE_HOME/sqlplus/admin/"
runcmd "cp /software/adrci_script.sh /home/grid/scripts/"
runcmd "\sqlplus / as sysasm @ /software/grants.sql"
runcmd "/u01/app/12.2.0.1/grid/bin/srvctl stop asm"
runcmd "/u01/app/12.2.0.1/grid/bin/srvctl start asm"
runcmd "/u01/app/12.2.0.1/grid/bin/srvctl add listener -l LISTENER -o /u01/app/12.2.0.1/grid"
runcmd "/u01/app/12.2.0.1/grid/bin/srvctl start listener"
runcmd "srvctl modify asm -pwfile /u01/app/12.2.0.1/grid/dbs/orapw+ASM"
