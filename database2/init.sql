CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';
CREATE PUBLIC DATABASE LINK database_main CONNECT TO system IDENTIFIED BY oracle USING 'database_main';

CREATE TABLESPACE adm2_perm_01
  DATAFILE 'adm2_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE adm2_temp_01
  TEMPFILE 'adm2_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER Administrator2
  IDENTIFIED BY admin123
  DEFAULT TABLESPACE adm2_perm_01
  TEMPORARY TABLESPACE adm2_temp_01
  QUOTA 20M on adm2_perm_01;

GRANT CREATE MATERIALIZED VIEW TO Administrator2;
GRANT CREATE DATABASE LINK TO Administrator2;


GRANT create session TO Administrator2;
GRANT create table TO Administrator2;
GRANT create view TO Administrator2;
GRANT create any trigger TO Administrator2;
GRANT create any procedure TO Administrator2;
GRANT create sequence TO Administrator2;
GRANT create synonym TO Administrator2;



CREATE SNAPSHOT Administrator2.Sklep2
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Sklep2@database_main;
        
ALTER SNAPSHOT Administrator2.Sklep2 ADD CONSTRAINT PK_ID1 PRIMARY KEY (id);

CREATE TABLE Administrator2.MieszankaZiolowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep number(10) NOT NULL,
  Dostepnosc number(4),
  Cena number(5),
  Zdjecie varchar2(150),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Administrator2.Sklep2(id)
);

CREATE TABLE Administrator2.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(26) NOT NULL,
    Numerkonta number(38) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(38),
    PRIMARY KEY (id)
);

CREATE SNAPSHOT Administrator2.Abonamenty
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Abonament@database_main;

ALTER SNAPSHOT Administrator2.Abonamenty ADD CONSTRAINT PK_ID PRIMARY KEY (id);



CREATE TABLE Administrator2.Zakup
( id number(10) NOT NULL,
  Sklep number(5),
  Mieszanka number(10) NOT NULL,
  Nabywca number(10) NOT NULL,
  Datazakupu date,
  Zakupaabonamentu number(1),
  Rodzajabonamentu number(10),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) REFERENCES Administrator2.Sklep2(id),
  FOREIGN KEY (Nabywca) REFERENCES Administrator2.Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) REFERENCES Administrator2.Abonamenty(id),
  FOREIGN KEY (Mieszanka) REFERENCES Administrator2.MieszankaZiolowa(id)
);

INSERT INTO Administrator2.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('1','Tadeusz','Jedny','11114015601081110181488241','111222331','T.Jedny@gmail.com');
INSERT INTO Administrator2.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('2','Marian','Markos','21114015601081110181488241','211222331','M.Markos@gmail.com');
INSERT INTO Administrator2.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('3','Aleksander','Twardy','31114015601081110181488241','411222331','A.Twardy@gmail.com');
INSERT INTO Administrator2.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('4','Ignacy','Baran','41114015601081110181488241','511222331','I.Baran@gmail.com');
INSERT INTO Administrator2.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('5','Robert','Drogowskaz','51114015601081110181488241','611222331','R.Drogowskaz@gmail.com');

INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('1','PielegnujTwarz','2','100','30');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('2','PorostWlosow','2','100','30');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('3','Weekendowa','2','75','25');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('4','Owocowa','2','75','25');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('5','Wakacyjna','2','50','35');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('6','ZimowaWichura','2','50','35');

INSERT INTO Administrator2.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('1','2','3','2','11-APR-2020','1','1');
INSERT INTO Administrator2.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('2','2','1','3','1-APR-2020','1','2');
INSERT INTO Administrator2.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('3','2','2','4','2-APR-2020','1','2');

-- UPDATE Administrator2.Sklep
--     SET Miasto = 'NEW YORK' 
--     WHERE id = 1; 
-- UPDATE Administrator2.MieszankaZiolowa
--     SET Dostepnosc = 0
--     WHERE id = 1; 


CREATE SNAPSHOT Administrator2.MieszankaSnapBaza1
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator1.MieszankaZiolowa@database1;

CREATE SNAPSHOT Administrator2.MieszankaSnapBaza3
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator3.MieszankaZiolowa@database3;


CREATE VIEW Administrator2.WIDOKMIESZANEK AS 
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator2.MieszankaZiolowa
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator2.MieszankaSnapBaza1
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator2.MieszankaSnapBaza3;

SELECT * FROM Administrator2.WIDOKMIESZANEK;

--User

CREATE TABLESPACE user2_perm_01
  DATAFILE 'user2_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE user2_temp_01
  TEMPFILE 'user2_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER User2
  IDENTIFIED BY user123
  DEFAULT TABLESPACE User2_perm_01
  TEMPORARY TABLESPACE User2_temp_01
  QUOTA 20M on User2_perm_01;

GRANT create session TO User2;
GRANT create view TO User2;
GRANT create any trigger TO User2;
GRANT create any procedure TO User2;
GRANT create sequence TO User2;
GRANT create synonym TO User2;


CREATE DATABASE LINK userlink2
CONNECT TO User2 IDENTIFIED BY user123
USING 'database1';

CREATE SYNONYM User2.TowarySklep2
   FOR Administrator2.WIDOKMIESZANEK;

