column DISKGROUP            format a10
column FAILGROUP            format a10
column DISK_NAME            format a15 heading "DISK|NAME"
column DISK_PATH            format a20 heading "DISK|PATH"
column LABEL                format a20
column MOUNT_STATUS                    heading "MOUNT|STATUS"
column HEADER_STATUS                   heading "HEADER|STATUS"
column MODE_STATUS                     heading "MODE|STATUS"
SELECT g.name diskgroup
,      g.TYPE
,      d.STATE
,      d.failgroup
,      d.LABEL
,      d.name disk_name
,      d.PATH disk_path
,      d.OS_MB
,      d.MOUNT_STATUS
,      d.HEADER_STATUS
,      d.MODE_STATUS
  FROM v$asm_diskgroup g, v$asm_disk d
 WHERE d.group_number = g.group_number;
