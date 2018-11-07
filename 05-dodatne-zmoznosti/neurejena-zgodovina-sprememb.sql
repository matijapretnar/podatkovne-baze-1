-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:03:32
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM vloge;
DROP TABLE vloge;
CREATE TABLE vloge (film INTEGER REFERENCES filmi (id), oseba INTEGER REFERENCES osebe (id), vloga TEXT, placa INTEGER);
INSERT INTO vloge (film, oseba, vloga) SELECT film, oseba, vloga FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:05:27
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM filmi;
DROP TABLE filmi;
CREATE TABLE filmi (id INTEGER PRIMARY KEY, naslov TEXT CONSTRAINT "Naslov je obvezen" NOT NULL, dolzina INTEGER, leto INTEGER, ocena REAL, metascore INTEGER, glasovi INTEGER, zasluzek INTEGER, opis BLOB);
INSERT INTO filmi (id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, opis) SELECT id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, opis FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:09:56
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM vloge;
DROP TABLE vloge;
CREATE TABLE vloge (film INTEGER REFERENCES filmi (id), oseba INTEGER REFERENCES osebe (id), vloga TEXT, placa INTEGER DEFAULT (10000));
INSERT INTO vloge (film, oseba, vloga, placa) SELECT film, oseba, vloga, placa FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:13:45
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM vloge;
DROP TABLE vloge;
CREATE TABLE vloge (film INTEGER REFERENCES filmi (id), oseba INTEGER REFERENCES osebe (id), vloga TEXT, placa INTEGER DEFAULT (10000) CHECK (placa > 0));
INSERT INTO vloge (film, oseba, vloga, placa) SELECT film, oseba, vloga, placa FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:27:16
DROP TABLE main.sqlitestudio_temp_table;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:37:32
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM vloge;
DROP TABLE vloge;
CREATE TABLE vloge (film INTEGER REFERENCES filmi (id), oseba INTEGER REFERENCES osebe (id), vloga TEXT, placa INTEGER DEFAULT (10000) CHECK (placa > 0), PRIMARY KEY (film, oseba, vloga));
INSERT INTO vloge (film, oseba, vloga, placa) SELECT film, oseba, vloga, placa FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:42:29
PRAGMA foreign_keys = 0;
CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM filmi;
DROP TABLE filmi;
CREATE TABLE filmi (id INTEGER PRIMARY KEY, naslov TEXT CONSTRAINT "Naslov je obvezen" NOT NULL, dolzina INTEGER, leto INTEGER, ocena REAL NOT NULL, metascore INTEGER, glasovi INTEGER, zasluzek INTEGER, opis BLOB, UNIQUE (naslov, leto, opis));
INSERT INTO filmi (id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, opis) SELECT id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, opis FROM sqlitestudio_temp_table;
DROP TABLE sqlitestudio_temp_table;
PRAGMA foreign_keys = 1;

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 10:59:05
CREATE INDEX "po letih" ON filmi (leto);

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 11:05:58
CREATE VIEW poimenovane_vloge AS SELECT osebe.id,
       osebe.ime,
       filmi.id,
       filmi.naslov,
       vloge.vloga
  FROM vloge
       JOIN
       osebe ON vloge.oseba = osebe.id
       JOIN
       filmi ON vloge.film = filmi.id;


-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 11:06:34
DROP VIEW poimenovane_vloge
CREATE VIEW poimenovane_vloge AS SELECT osebe.id as id_osebe,
       osebe.ime as ime_osebe,
       filmi.id as id_filma, 
       filmi.naslov as naslov_filma,
       vloge.vloga as vloga
  FROM vloge
       JOIN
       osebe ON vloge.oseba = osebe.id
       JOIN
       filmi ON vloge.film = filmi.id

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 11:38:39
CREATE VIEW reziserji AS SELECT osebe.id AS id,
       osebe.ime AS ime,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
 WHERE vloge.vloga = 'reziser'
 GROUP BY id,
          ime;


-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 11:51:19
CREATE VIEW stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma AS SELECT film, max(stevilo_filmov)
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film

-- Queries executed on database flimi-velika (/Users/matija/Documents/Matija/podatkovne-baze-1-2/03-stikanje/flimi-velika.sqlite)
-- Date and time of execution: 2018-11-07 11:58:23
DROP VIEW stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma
CREATE VIEW stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma AS SELECT film, max(stevilo_filmov) as max_filmov
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film