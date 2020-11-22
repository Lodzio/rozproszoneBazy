CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';


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

GRANT create session TO Administrator2;
GRANT create view TO Administrator2;
GRANT create any trigger TO Administrator2;
GRANT create any procedure TO Administrator2;
GRANT create sequence TO Administrator2;
GRANT create synonym TO Administrator2;


CREATE TABLE Administrator2.Sklep
( id number(10) NOT NULL,
  ulica varchar2(50) NOT NULL,
  Miasto varchar2(50) NOT NULL,
  NrLokalu number(5),
  PRIMARY KEY (id)
);

CREATE TABLE Administrator2.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(20) NOT NULL,
    Numerkonta number(20) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(20),
    PRIMARY KEY (id)
);

CREATE TABLE Administrator2.Abonament
(
    id number(5),
    Nazwa varchar2(20) NOT NULL,
    Okrestrwania Varchar2(20) NOT NULL,
    Cena number(20) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Administrator2.Zakup
( id number(10) NOT NULL,
  Sklep number(5),
  Mieszanka varchar2(50) NOT NULL,
  Nabywca number(10) NOT NULL,
  Datazakupu date,
  Zakupaabonamentu number(1),
  Rodzajabonamentu number(10),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) REFERENCES Administrator2.Sklep(id),
  FOREIGN KEY (Nabywca) REFERENCES Administrator2.Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) REFERENCES Administrator2.Abonament(id)
);

CREATE TABLE Administrator2.MieszankaZiolowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep number(10) NOT NULL,
  Dostepnosc number(3),
  Cena number(5),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Administrator2.Sklep(id)
);


INSERT INTO Administrator2.Sklep(id,ulica,Miasto,NrLokalu) Values('63','Malinowa','Wroclaw','51');
INSERT INTO Administrator2.MieszankaZiolowa(id,Nazwa,Sklep,Dostepnosc,Cena) Values('961','Rozgrzejsie','63','1','29');

UPDATE Administrator2.Sklep
    SET Miasto = 'NEW YORK' 
    WHERE id = 1; 
UPDATE Administrator2.MieszankaZiolowa
    SET Dostepnosc = 0
    WHERE id = 1; 









