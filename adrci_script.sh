#!/bin/bash

export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=/u01/app/12.2.0.1/grid
export ORACLE_SID=+ASM
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH

AGE7DAYS=10080
AGE10DAYS=14400
AGE15DAYS=21600
AGE30DAYS=43200
PURGETARGET=$AGE15DAYS
for f in $( adrci exec="show homes" | grep -v "ADR Homes:" );
do
echo "Purging ${f}:";
adrci exec="set home $f; purge -age $PURGETARGET ;" ;
done





