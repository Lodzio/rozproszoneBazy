CREATE TABLE SYSTEM.Sklep
( id number(10) NOT NULL,
  ulica varchar2(50) NOT NULL,
  Miasto varchar2(50) NOT NULL,
  NrLokalu number(5) NOT NULL,
  PRIMARY KEY (id),
);

CREATE TABLE SYSTEM.MieszankaZiołowa
( id number(10) NOT NULL,
  Nazwa varchar2(50) NOT NULL,
  Sklep varchar2(50) NOT NULL,
  Dostępność boolean,
  Cena number(5) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Sklep(id)
);

CREATE TABLE SYSTEM.Zakup
( id number(10) NOT NULL,
  Sklep varchar2(50) NOT NULL,
  Mieszanka varchar2(50) NOT NULL,
  Nabywca varchar2(50) NOT NULL,
  Datazakupu date NOT NULL,
  Zakupaabonamentu boolean,
  Rodzajabonamentu varchar2(25),
  PRIMARY KEY (id),
  FOREIGN KEY (Sklep) references Sklep(id),
  FOREIGN KEY (Nabywca) references Nabywca(id),
  FOREIGN KEY (Rodzajabonamentu) references Abonament(id),
);

CREATE TABLE SYSTEM.Nabywca
(
    id number(5) NOT NULL,
    Imie varchar2(20) NOT NULL,
    Nazwisko Varchar2(20) NOT NULL,
    Numerkonta number(20) NOT NULL,
    Numertelefonu number (11) NOT NULL,
    Adresemail varchar2(20),
)

CREATE TABLE SYSTEM.Abonament
(
    id number(5) NOT NULL,
    Nazwa varchar2(20) NOT NULL,
    Okrestrwania Varchar2(20) NOT NULL,
    Cena number(20) NOT NULL,
)