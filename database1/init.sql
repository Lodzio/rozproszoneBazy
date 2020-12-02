CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';
CREATE PUBLIC DATABASE LINK database_main CONNECT TO system IDENTIFIED BY oracle USING 'database_main';

CREATE TABLESPACE adm1_perm_01
  DATAFILE 'adm1_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE adm1_temp_01
  TEMPFILE 'adm1_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER Administrator1
  IDENTIFIED BY admin123
  DEFAULT TABLESPACE adm1_perm_01
  TEMPORARY TABLESPACE adm1_temp_01
  QUOTA 20M on adm1_perm_01;

GRANT CREATE MATERIALIZED VIEW TO Administrator1;
GRANT CREATE DATABASE LINK TO Administrator1;

GRANT create session TO Administrator1;
GRANT create table TO Administrator1;
GRANT create view TO Administrator1;
GRANT create any trigger TO Administrator1;
GRANT create any procedure TO Administrator1;
GRANT create sequence TO Administrator1;
GRANT create synonym TO Administrator1;

CREATE SNAPSHOT Administrator1.Sklep1
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Sklep1@database_main;
        
ALTER SNAPSHOT Administrator1.Sklep1 ADD CONSTRAINT PK_ID1 PRIMARY KEY (id);


CREATE TABLE Administrator1.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(24) NOT NULL,
    Numerkonta number(38) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(23),
    PRIMARY KEY (id)
);


CREATE TABLE Administrator1.MieszankaZiolowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep number(10) NOT NULL,
  Dostepnosc number(4),
  Cena number(5),
  Zdjecie varchar2(150),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Administrator1.Sklep1(id)
);

CREATE SNAPSHOT Administrator1.Abonamenty
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator.Abonament@database_main;
        
ALTER SNAPSHOT Administrator1.Abonamenty ADD CONSTRAINT PK_ID PRIMARY KEY (id);

CREATE TABLE Administrator1.Zakup
( id number(10) NOT NULL,
  Sklep number(5),
  Mieszanka number(10) NOT NULL,
  Nabywca number(10) NOT NULL,
  Datazakupu date,
  Zakupaabonamentu number(1),
  Rodzajabonamentu number(10),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) REFERENCES Administrator1.Sklep1(id),
  FOREIGN KEY (Nabywca) REFERENCES Administrator1.Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) REFERENCES Administrator1.Abonamenty(id),
  FOREIGN KEY (Mieszanka) REFERENCES Administrator1.MieszankaZiolowa(id)
);

INSERT INTO Administrator1.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('1','Mateusz','Ziaja','11114015601081110181488249','111222333','M.Ziaja@gmail.com');
INSERT INTO Administrator1.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('2','Dariusz','Talik','21114015601081110181488249','211222333','D.Talik@gmail.com');
INSERT INTO Administrator1.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('3','Mariusz','Twardowski','31114015601081110181488249','411222333','M.Twardowski@gmail.com');
INSERT INTO Administrator1.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('4','Tomasz','Babka','41114015601081110181488249','511222333','T.babka@gmail.com');
INSERT INTO Administrator1.Nabywca(id,Imie,Nazwisko,Numerkonta,Numertelefonu, Adresemail)
Values('5','Robert','Droga','51114015601081110181488249','611222333','R.droga@gmail.com');

INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('1','Rozgrzejsie','1','100','30');
INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('2','PoprawOdpornosc','1','100','30');
INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('3','Swiateczna','1','75','25');
INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('4','NaKatar','1','75','25');
INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('5','Orzezwijsie','1','50','35');
INSERT INTO Administrator1.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena)
Values('6','ZastrzykEnergii','1','50','35');

INSERT INTO Administrator1.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('1','1','1','3','14-APR-2020','1','1');
INSERT INTO Administrator1.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('2','1','3','4','15-APR-2020','1','2');
INSERT INTO Administrator1.Zakup(id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu)
Values('3','1','6','1','16-APR-2020','1','2');

-- UPDATE Administrator1.Sklep
--     SET Miasto = 'NEW YORK' 
--     WHERE id = 1; 
-- UPDATE Administrator1.MieszankaZiolowa
--     SET Dostepnosc = 0
--     WHERE id = 1; 

CREATE SNAPSHOT Administrator1.MieszankaSnapBaza2
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator2.MieszankaZiolowa@database2;

CREATE SNAPSHOT Administrator1.MieszankaSnapBaza3
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator3.MieszankaZiolowa@database3;


CREATE VIEW Administrator1.WIDOKMIESZANEK AS 
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator1.MieszankaZiolowa
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator1.MieszankaSnapBaza2
UNION ALL
SELECT id,Nazwa,Sklep,Dostepnosc,Cena FROM Administrator1.MieszankaSnapBaza3;

SELECT * FROM Administrator1.WIDOKMIESZANEK;

--User

CREATE TABLESPACE user1_perm_01
  DATAFILE 'user1_perm_01.dat' 
    SIZE 20M
  ONLINE;

CREATE TEMPORARY TABLESPACE user1_temp_01
  TEMPFILE 'user1_temp_01.dbf'
    SIZE 5M
    AUTOEXTEND ON;

CREATE USER User1
  IDENTIFIED BY user123
  DEFAULT TABLESPACE user1_perm_01
  TEMPORARY TABLESPACE user1_temp_01
  QUOTA 20M on user1_perm_01;

GRANT create session TO User1;
GRANT create view TO User1;
GRANT create any trigger TO User1;
GRANT create any procedure TO User1;
GRANT create sequence TO User1;
GRANT create synonym TO User1;

CREATE DATABASE LINK userlink1
CONNECT TO USER1 IDENTIFIED BY user123
USING 'database1';

CREATE SYNONYM User1.TowarySklep
   FOR Administrator1.WIDOKMIESZANEK;


CREATE VIEW Administrator1.HistoriaSprzedazy1 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 1;

CREATE VIEW Administrator1.HistoriaSprzedazy2 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 2;

CREATE VIEW Administrator1.HistoriaSprzedazy3 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 3;

CREATE VIEW Administrator1.HistoriaSprzedazy4 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 4;

CREATE VIEW Administrator1.HistoriaSprzedazy5 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 5;

CREATE VIEW Administrator1.HistoriaSprzedazy6 as 
select id,Sklep,Mieszanka,Nabywca,Datazakupu,Zakupaabonamentu,Rodzajabonamentu
FROM Administrator1.Zakup WHERE Mieszanka = 6;

CREATE SNAPSHOT Administrator1.Nabywca2
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator2.Nabywca@database2;

CREATE SNAPSHOT Administrator1.Nabywca3
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator3.Nabywca@database3;

CREATE VIEW Administrator1.NabywcaKierownik as 
select id,Imie,Nazwisko
FROM Administrator1.Nabywca
UNION ALL
select id,Imie,Nazwisko
FROM Administrator1.Nabywca2
UNION ALL
select id,Imie,Nazwisko
FROM Administrator1.Nabywca3;

CREATE VIEW Administrator1.NabywcaAdmin as 
select Numerkonta,Numertelefonu, Adresemail
FROM Administrator1.Nabywca
UNION ALL
select Numerkonta,Numertelefonu, Adresemail
FROM Administrator1.Nabywca2
UNION ALL
select Numerkonta,Numertelefonu, Adresemail
FROM Administrator1.Nabywca3;


