set head off;
set feedback off;
set pagesize 5000;
set linesize 30000;
set serveroutput on;
begin
execute immediate 'grant sysasm to sys';
execute immediate 'grant create session to sys';
execute immediate 'alter user sys identified by ynixon';
execute immediate 'create spfile=''/u01/app/12.2.0.1/grid/dbs/spfile+ASM.ora'' from pfile=''/u01/app/12.2.0.1/grid/dbs/init+ASM.ora''';
dbms_output.put_line('grants.sql OK');
exception
when others then
dbms_output.put_line('Error in grants.sql');
end;
/
exit
