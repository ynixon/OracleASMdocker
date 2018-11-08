define _editor=vi 
set serveroutput on size 1000000 format wrapped pagesize 35 linesize 170 trimspool on long 20000

column segment_name          format a20
column NAME                  format a40
column column_name           format a20
column plan_plus_exp         format a90
column dest_name             format a20 heading "DEST|NAME"
column destination           format a25
column member                format a50
column next_change#          format 99999999999999999999
column module                format a30
column action                format a30
column CLIENT_INFO           format a30
column PROGRAM               format a30 trunc
column USERNAME              format a20 trunc
column VALUE                 format a30
column SOURCE_DB_UNIQUE_NAME format a7 heading "SOURCE|DB|UNIQUE|NAME"
column TIME_COMPUTED         format a20
column MEMBER                format a70
column MACHINE               format a10
column SCHEMANAME            format a10 trunc
column TERMINAL              format a10 trunc
column OSUSER                format a10 trunc
column MESSAGE               format a70
column ALTERNATE             format a18
column DB_UNIQUE_NAME        format a7  heading "DB|UNIQUE|NAME"
column ERROR                 format a50
column FAIL_SEQUENCE         format 99999
column FAIL_DATE             format a10
column DEST_ID               format 99 heading "DEST|ID"
column STATUS                format a12
column SCHEDULE              format a7
column INST_ID               format 99 heading "INST|ID"
column FAIL_SEQUENCE         format 9999999 heading "FAIL|SEQUENCE"
column VALID_NOW             format a9
column FAILURE_COUNT         format 9999 heading "FAILURE|COUNT"
column FAIL_BLOCK            format 99999 heading "FAIL|BLOCK"
column SOURCE_DBID                        heading "SOURCE|DBID"
column MESSAGE_NUM                        heading "MESSAGE|NUM"
column ERROR_CODE                         heading "ERROR|CODE"
column DELAY_MINS                         heading "DELAY|MINS"
column KNOWN_AGENTS                       heading "KNOWN|AGENTS"
column ACTIVE_AGENTS                      heading "ACTIVE|AGENTS"
column TIME_COMPUTED         format a19   heading "TIME|COMPUTED"
column DATUM_TIME            format a19   heading "DATUM|TIME"
column CON_ID                format 99    heading "CON|ID"
column VALUE                 format a20
column GROUP#                format 99999999
column CLIENT_DBID           format a15   heading "CLIENT|DBID"
column CLIENT_PID            format a10   heading "CLIENT|PID"
column CLIENT_PROCESS        format a10   heading "CLIENT|PROCESS"
column PID                   format a10 
column THREAD#               format 9999999
column SEQUENCE#             format 999999999
column DBID                  format a15
column TARGET                format a7
column INSTANCE_NAME         format a8    heading "INSTANCE|NAME"
column BLOCK_GETS                         heading "BLOCK|GETS"
column CONSISTENT_GETS                    heading "CONSISTENT|GETS"
column PHYSICAL_READS                     heading "PHYSICAL|READS"
column BLOCK_CHANGES                      heading "BLOCK|CHANGES"
column CONSISTENT_CHANGES                 heading "CONSISTENT|CHANGES"
column OPTIMIZED_PHYSICAL_READS           heading "OPTIMIZED|PHYSICAL|READS"
column PATH                  format a20
column SVRNAME               format a15
column FILENAME              format a60
column FILESIZE              format 99999999999
column SVR_ID                format 9     heading "SVR|ID"
column LOCAL                 format a15
column CH_ID                 format 9     heading "CH|ID"
column ACTIVE_SPEED                       heading "ACTIVE|SPEED"
column PEAK_FMR                           heading "PEAK|FMR"
column RDMA_CREDITS                       heading "RDMA|CREDITS"
column CURRENT_FMR                        heading "CURRENT|FMR"
column FMRREG_COUNT                       heading "FMRREG|COUNT"
column VALID_NOW                          heading "VALID|NOW"
column DIRNAME               format a40
column CURRENT_SCHEMA        format a10 heading "CURRENT|SCHEMA"
column SESSION_USER          format a10 heading "SESSION|USER"
column ACTION_TIME           format a30
column NAMESPACE             format a10
column VERSION               format a10
column COMMENTS              format a30
column ACTION                format a10
column METRIC_UNIT           format a20
column GROUP_ID              format 99999999
column METRIC_NAME           format a30
column INSTANCE_NUMBER                  heading "INSTANCE|NUMBER"
column VALUE                 format 9999999999
column BEGIN_TIME                       heading "BEGIN|TIME"
column END_TIME                         heading "END|TIME"
column METRIC_NAME           format a22 heading "METRIC|NAME"
column METRIC_UNIT                      heading "METRIC|UNIT"
column 00                    format 9990.99
column 01                    format 9990.99
column 02                    format 9990.99
column 03                    format 9990.99
column 04                    format 9990.99
column 05                    format 9990.99
column 06                    format 9990.99
column 07                    format 9990.99
column 08                    format 9990.99
column 09                    format 9990.99
column 10                    format 9990.99
column 11                    format 9990.99
column 12                    format 9990.99
column 13                    format 9990.99
column 14                    format 9990.99
column 15                    format 9990.99
column 16                    format 9990.99
column 17                    format 9990.99
column 18                    format 9990.99
column 19                    format 9990.99
column 20                    format 9990.99
column 21                    format 9990.99
column 22                    format 9990.99
column 23                    format 9990.99
column AFFIRM                format a6
column REOPEN_SECS                      heading "REOPEN|SECS"
column MAX_CONNECTIONS                  heading "MAX|CONNECTIONS"
column NET_TIMEOUT                      heading "NET|TIMEOUT"
column PARENT_INSTANCE                  heading "PARENT|INSTANCE"
column INSTANCE_ROLE                    heading "INSTANCE|ROLE"
column DATABASE_ROLE                    heading "DATABASE|ROLE"
column PROTECTION_MODE                  heading "PROTECTION|MODE"
column PROTECTION_LEVEL                 heading "PROTECTION|LEVEL"
column RECOVERY_MODE                    heading "RECOVERY|MODE"
column DATABASE_MODE                    heading "DATABASE|MODE"
column OPEN_MODE                        heading "OPEN|MODE"
column DEST_NAME                        heading "DEST|NAME"
column TRANSMIT_MODE                    heading "TRANSMIT|MODE"
column SCHEDULE             format a8
column SIZE_MB                          heading "Size (Mb)"
column BANDWIDTH_MBPS                   heading "BandWidth|Mbps"
column CALLOUT              format a7
column WAIT_TIME_MILLI                  heading "WAIT|TIME|MILLI"
column WAIT_COUNT                       heading "WAIT|COUNT"
column LAST_UPDATE_TIME     format a40  heading "LAST|UPDATE|TIME"
column STANDBY_LOGFILE_COUNT            heading "STANDBY|LOGFILE|COUNT"
column STANDBY_LOGFILE_ACTIVE           heading "STANDBY|LOGFILE|ACTIVE"
column DISKGROUP            format a10
column FAILGROUP            format a10
column DISK_NAME            format a10
column DISK_PATH            format a15
column DISKGROUP            format a10
column FAILGROUP            format a10
column DISK_NAME            format a15 heading "DISK|NAME"
column DISK_PATH            format a20 heading "DISK|PATH"
column LABEL                format a20
column MOUNT_STATUS                    heading "MOUNT|STATUS"
column HEADER_STATUS                   heading "HEADER|STATUS"
column MODE_STATUS                     heading "MODE|STATUS"
column FLASHBACK_ON                    heading "FLASHBACK|ON"
column PLUGGABLE_DATABASE   format a15 heading "PLUGGABLE|DATABASE"
column UTILIZATION_LIMIT    format 999 heading "UTILIZATION|LIMIT"
column PARALLEL_SERVER_LIMIT format 999 heading "PARALLEL|SERVER|LIMIT"
column PLAN                 format a30
column DATABASE_STATUS                       heading "DATABASE|STATUS"
column ACTIVE_STATE                          heading "ACTIVE|STATE"
column INSTANCE_MODE                         heading "INSTANCE|MODE"

column INSTANCE_NUMBER      format 99        heading "INST|NUM"
column HOST_NAME            format a15 trunc heading "HOST|NAME"
column SHUTDOWN_PENDING     format a8        heading "SHUTDOWN|PENDING"
column BLOCKED              format a7 
column PASSWORD_PROFILE     format a10       heading "PASSWORD|PROFILE"
column LAST_LOGIN           format a5        heading "LAST|LOGIN"
column EXTERNAL_NAME        format a15       heading "EXTERNAL|NAME"
column ACCOUNT_STATUS       format a10       heading "ACCOUNT|STATUS"
column LOCK_DATE            format a4        heading "LOCK|DATE"
column AUTHENTICATION_TYPE  format a14       heading "AUTHENTICATION|TYPE"

set sqlprompt "_user'@'_connect_identifier:SQL> "
set term off
alter session set NLS_DATE_FORMAT = 'mm-dd-yyyy HH24:mi:ss';
set history on
set term on

