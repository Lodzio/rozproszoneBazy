CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database_main CONNECT TO system IDENTIFIED BY oracle USING 'database_main';

CREATE TABLESPACE adm3_perm_01
  DATAFILE 'adm3_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE adm3_temp_01
  TEMPFILE 'adm3_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER Administrator3
  IDENTIFIED BY admin123
  DEFAULT TABLESPACE adm3_perm_01
  TEMPORARY TABLESPACE adm3_temp_01
  QUOTA 20M on adm3_perm_01;

GRANT CREATE MATERIALIZED VIEW TO Administrator3;
GRANT CREATE DATABASE LINK TO Administrator3;


GRANT create session TO Administrator3;
GRANT create table TO Administrator3;
GRANT create view TO Administrator3;
GRANT create any trigger TO Administrator3;
GRANT create any procedure TO Administrator3;
GRANT create sequence TO Administrator3;
GRANT create synonym TO Administrator3;


CREATE SNAPSHOT Administrator3.Sklep3
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Sklep3@database_main;
        
ALTER SNAPSHOT Administrator3.Sklep3 ADD CONSTRAINT PK_ID1 PRIMARY KEY (id);

CREATE TABLE Administrator3.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(26) NOT NULL,
    Numerkonta number(38) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(28),
    PRIMARY KEY (id)
);

CREATE SNAPSHOT Administrator3.Abonamenty
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Abonament@database_main;

ALTER SNAPSHOT Administrator3.Abonamenty ADD CONSTRAINT PK_ID PRIMARY KEY (id);

CREATE TABLE Administrator3.MieszankaZiolowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep number(10) NOT NULL,
  Dostepnosc number(3),
  Cena number(5),
  Zdjecie varchar2(150),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Administrator3.Sklep3(id)
);

CREATE TABLE Administrator3.Zakup
( id number(10) NOT NULL,
  Sklep number(5),
  Mieszanka number(10) NOT NULL,
  Nabywca number(10) NOT NULL,
  Datazakupu date,
  Zakupaabonamentu number(1),
  Rodzajabonamentu number(10),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) REFERENCES Administrator3.Sklep3(id),
  FOREIGN KEY (Nabywca) REFERENCES Administrator3.Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) REFERENCES Administrator3.Abonamenty(id),
  FOREIGN KEY (Mieszanka) REFERENCES Administrator3.MieszankaZiolowa(id)
);

INSERT INTO Administrator3.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('1','Tadeusz','Jedny','11114015601081110181488241','111222331','T.Jedny@gmail.com');
INSERT INTO Administrator3.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('2','Marian','Markos','21114015601081110181488241','211222331','M.Markos@gmail.com');
INSERT INTO Administrator3.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('3','Aleksander','Twardy','31114015601081110181488241','411222331','A.Twardy@gmail.com');
INSERT INTO Administrator3.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('4','Ignacy','Baran','41114015601081110181488241','511222331','I.Baran@gmail.com');
INSERT INTO Administrator3.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('5','Robert','Drogowskaz','51114015601081110181488241','611222331','R.Drogowskaz@gmail.com');

INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('1','PielegnujTwarz','3','100','30');
INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('2','PorostWlosow','3','100','30');
INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('3','Weekendowa','3','75','25');
INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('4','Owocowa','3','75','25');
INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('5','Wakacyjna','3','50','35');
INSERT INTO Administrator3.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('6','ZimowaWichura','3','50','35');

INSERT INTO Administrator3.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('1','3','5','2','11-APR-2020','1','1');
INSERT INTO Administrator3.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('2','3','1','3','1-APR-2020','1','2');
INSERT INTO Administrator3.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('3','3','2','4','2-APR-2020','1','3');

-- UPDATE Administrator2.Sklep
--     SET Miasto = 'NEW YORK' 
--     WHERE id = 1; 
-- UPDATE Administrator2.MieszankaZiolowa
--     SET Dostepnosc = 0
--     WHERE id = 1; 


CREATE SNAPSHOT Administrator3.MieszankaSnapBaza1
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator1.MieszankaZiolowa@database1;

CREATE SNAPSHOT Administrator3.MieszankaSnapBaza2
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator2.MieszankaZiolowa@database2;


CREATE VIEW Administrator3.WIDOKMIESZANEK AS 
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator3.MieszankaZiolowa
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator3.MieszankaSnapBaza1
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator3.MieszankaSnapBaza2;

SELECT * FROM Administrator3.WIDOKMIESZANEK;

--User

CREATE TABLESPACE user3_perm_01
  DATAFILE 'user3_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE user3_temp_01
  TEMPFILE 'user3_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER User3
  IDENTIFIED BY user123
  DEFAULT TABLESPACE User3_perm_01
  TEMPORARY TABLESPACE User3_temp_01
  QUOTA 20M on User3_perm_01;

GRANT create session TO User3;
GRANT create view TO User3;
GRANT create any trigger TO User3;
GRANT create any procedure TO User3;
GRANT create sequence TO User3;
GRANT create synonym TO User3;


CREATE DATABASE LINK userlink3
CONNECT TO User3 IDENTIFIED BY user123
USING 'database1';

CREATE SYNONYM User3.TowarySklep2
   FOR Administrator3.WIDOKMIESZANEK;

