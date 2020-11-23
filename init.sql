CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';

CREATE TABLESPACE adm_perm_01
  DATAFILE 'adm_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE adm_temp_01
  TEMPFILE 'adm_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER Administrator
  IDENTIFIED BY admin123
  DEFAULT TABLESPACE adm_perm_01
  TEMPORARY TABLESPACE adm_temp_01
  QUOTA 20M on adm_perm_01;

GRANT create session TO Administrator;
GRANT create table TO Administrator;
GRANT create view TO Administrator;
GRANT create any trigger TO Administrator;
GRANT create any procedure TO Administrator;
GRANT create sequence TO Administrator;
GRANT create synonym TO Administrator;

UPDATE Administrator1.Sklep@database1
    SET Miasto = 'Meh' 
    WHERE id = 63; 