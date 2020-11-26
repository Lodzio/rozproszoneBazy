CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';

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

GRANT create session TO Administrator1;
GRANT create table TO Administrator1;
GRANT create view TO Administrator1;
GRANT create any trigger TO Administrator1;
GRANT create any procedure TO Administrator1;
GRANT create sequence TO Administrator1;
GRANT create synonym TO Administrator1;


CREATE TABLE Administrator1.Sklep
( id number(10) NOT NULL,
  ulica varchar2(50) NOT NULL,
  Miasto varchar2(50) NOT NULL,
  NrLokalu number(5),
  PRIMARY KEY (id)
);

CREATE TABLE Administrator1.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(20) NOT NULL,
    Numerkonta number(38) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(23),
    PRIMARY KEY (id)
);

CREATE TABLE Administrator1.Abonament
(
    id number(5),
    Nazwa varchar2(20) NOT NULL,
    Okrestrwania Varchar2(20) NOT NULL,
    Cena number(20) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Administrator1.MieszankaZiolowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep number(10) NOT NULL,
  Dostepnosc number(4),
  Cena number(5),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Administrator1.Sklep(id)
);

CREATE TABLE Administrator1.Zakup
( id number(10) NOT NULL,
  Sklep number(5),
  Mieszanka number(10) NOT NULL,
  Nabywca number(10) NOT NULL,
  Datazakupu date,
  Zakupaabonamentu number(1),
  Rodzajabonamentu number(10),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) REFERENCES Administrator1.Sklep(id),
  FOREIGN KEY (Nabywca) REFERENCES Administrator1.Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) REFERENCES Administrator1.Abonament(id),
  FOREIGN KEY (Mieszanka) REFERENCES Administrator1.MieszankaZiolowa(id)
);



INSERT INTO Administrator1.Sklep(id,ulica,Miasto,NrLokalu) 
Values('1','Malinowa','Wroclaw','4');

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

INSERT INTO Administrator1.Abonament(id,Nazwa,Okrestrwania,Cena)
Values('1','Premium Begginer','7','60');
INSERT INTO Administrator1.Abonament(id,Nazwa,Okrestrwania,Cena)
Values('2','Premium Intermediate','7','160');
INSERT INTO Administrator1.Abonament(id,Nazwa,Okrestrwania,Cena)
Values('3','Premium Proffesional','7','260');


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
Values('3','1','6','1','16-APR-2020','1','3');

-- UPDATE Administrator1.Sklep
--     SET Miasto = 'NEW YORK' 
--     WHERE id = 1; 
-- UPDATE Administrator1.MieszankaZiolowa
--     SET Dostepnosc = 0
--     WHERE id = 1; 

GRANT CREATE MATERIALIZED VIEW TO Administrator1;
GRANT CREATE DATABASE LINK TO Administrator1;

CREATE SNAPSHOT Administrator1.SklepRefresh
refresh complete start with (sysdate) next  (sysdate+1/1440) with rowid
        as select * from Administrator2.Sklep@database2;

CREATE VIEW Administrator1.WIDOK AS 
SELECT id,ulica,miasto,nrlokalu FROM Administrator1.Sklep
UNION ALL
SELECT id,ulica,miasto,nrlokalu FROM Administrator1.Skleprefresh;

SELECT * FROM Administrator1.WIDOK;

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
GRANT SELECT ON Administrator1.widok
   TO User1;

CREATE DATABASE LINK userlink1
CONNECT TO USER1 IDENTIFIED BY user123
USING 'database1';

CREATE SYNONYM User1.TowarySklep1
   FOR Administrator1.Sklep;

-- select * from User1.TowarySklep1;

