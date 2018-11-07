begin transaction

drop table zanri

rollback;

DROP TABLE zanri;

End transaction;

BEGIN TRANSACTION;

ROLLBACK;

BEGIN TRANSACTION;

ROLLBACK;

DELETE from zanri;

BEGIN TRANSACTION;

DELETE from zanri;

ROLLBACK;

BEGIN TRANSACTION;

DELETE from vloge;

BEGIN TRANSACTION;

DELETE from vloge;

ROLLBACK;

BEGIN TRANSACTION;

DELETE from filmi;

BEGIN TRANSACTION;

DELETE from vloge;

DELETE from filmi;

END TRANSACTION;

ROLLBACK;

BEGIN TRANSACTION;

DELETE from filmi;

COMMIT;

BEGIN TRANSACTION;

DELETE from filmi;

UPDATE filmi
   SET naslov = null
 WHERE id = 21749
; 
PRAGMA foreign_keys = 0;

CREATE TABLE vloge (
    film  INTEGER REFERENCES filmi (id),
    oseba INTEGER REFERENCES osebe (id),
    vloga TEXT,
    placa INTEGER DEFAULT (10000) 
                  CHECK (placa > 0),
    PRIMARY KEY (film, oseba, vloga)
);

DROP TABLE vloge;

CREATE TABLE vloge (
    film  INTEGER REFERENCES filmi (id),
    oseba INTEGER REFERENCES osebe (id),
    vloga TEXT,
    placa INTEGER DEFAULT (10000) 
                  CHECK (placa > 0),
    PRIMARY KEY (film, oseba, vloga)
);

INSERT INTO vloge (
                      film,
                      oseba,
                      vloga,
                      placa
                  )
                  SELECT film,
                         oseba,
                         vloga,
                         placa
                    FROM sqlitestudio_temp_table
                   ; 
PRAGMA foreign_keys = 1;

PRAGMA foreign_keys = 1;

SELECT opis,
       count( * ) AS st_filmov
  FROM filmi
 GROUP BY opis
HAVING st_filmov > 1;

PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT *
                                          FROM filmi
                                         ; 
DROP TABLE filmi;

CREATE TABLE filmi (
    id        INTEGER PRIMARY KEY,
    naslov    TEXT    CONSTRAINT [Naslov je obvezen] NOT NULL,
    dolzina   INTEGER,
    leto      INTEGER,
    ocena     REAL    NOT NULL,
    metascore INTEGER,
    glasovi   INTEGER,
    zasluzek  INTEGER,
    opis      BLOB
);

INSERT INTO filmi (
                      id,
                      naslov,
                      dolzina,
                      leto,
                      ocena,
                      metascore,
                      glasovi,
                      zasluzek,
                      opis
                  )
                  SELECT id,
                         naslov,
                         dolzina,
                         leto,
                         ocena,
                         metascore,
                         glasovi,
                         zasluzek,
                         opis
                    FROM sqlitestudio_temp_table
                   ; 
DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;

select naslov, dolzina, leto, count(*) from filmi group by naslov, dolzina, leto having count(*) > 1;

select count(*) from filmi where ocena > 8;

select count(*) > 10 from filmi where ocena > 8;

select count(*) > 1000 from filmi where ocena > 8;

select count(*) from filmi where ocena > 8.5;

select count(*) >= 10 from filmi where ocena > 8.5;

BEGIN TRANSACTION;

DELETE FROM vloge;

BEGIN TRANSACTION;

DELETE FROM vloge;

ROLLBACK;

BEGIN TRANSACTION;

DELETE FROM vloge;

DROP TABLE zanri;

DELETE FROM osebe;

ROLLBACK;

SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto = filmi.leto AND 
                  f.ocena > filmi.ocena
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.ocena > filmi.ocena
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.id > filmi.id
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto > filmi.leto
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto > filmi.leto
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto > filmi.leto
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.ocena > filmi.ocena
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.ocena < filmi.ocena
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.ocena < filmi.ocena
       )
  FROM filmi
 ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto < filmi.leto
       )
  FROM filmi
 ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE filmi.leto = f.leto AND filmi.ocena > f.ocena
       )
  FROM filmi
 ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto = filmi.leto AND 
                  f.ocena > filmi.ocena
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto = filmi.leto AND 
                  f.ocena > filmi.ocena + 1
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
VACUUM;

SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto = filmi.leto AND 
                  f.ocena > filmi.ocena + 1
       )
  FROM filmi
 ORDER BY leto,
          ocena DESC
         ; 
SELECT naslov_filma
  FROM poimenovane_vloge
 WHERE ime_osebe = 'Nicolas Cage'
; 
SELECT ime_osebe, count(*)
  FROM poimenovane_vloge
 group by ime_osebe
; 
select naslov_filma, count(*) from poimenovane_vloge where vloga = 'reziser' having count(*) > 5;

SELECT naslov_filma,
       count( * ) 
  FROM poimenovane_vloge
 WHERE vloga = 'reziser'
 GROUP BY naslov_filma
HAVING count( * ) > 5;

select * from poimenovane_vloge where naslov_filma = 'Dumbo';

select * from poimenovane_vloge where vloga = 'reziser' and naslov_filma = 'Dumbo';

select * from poimenovane_vloge where vloga = 'reziser' and naslov_filma = "Paris je t'aime";

select * from poimenovane_vloge where vloga = 'reziser' and naslov_filma LIKE 'Paris%';

SELECT osebe.id AS id,
       osebe.ime AS ime,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       where vloge = 'reziser'
      ; 
SELECT osebe.id AS id,
       osebe.ime AS ime,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
 WHERE vloge.vloga = 'reziser'
 GROUP BY (osebe.id, osebe.ime)
; 
SELECT osebe.id AS id,
       osebe.ime AS ime,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
 WHERE vloge.vloga = 'reziser'
 GROUP BY osebe.id, osebe.ime
; 
SELECT osebe.id AS id,
       osebe.ime AS ime,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
 WHERE vloge.vloga = 'reziser'
 GROUP BY id, ime
; 
select * from reziserji where stevilo_filmov = 4;

select stevilo_filmov, count(*) from reziserji group by stevilo_filmov;

SELECT * from vloge where vloga = 'reziser';

SELECT *
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
; 
SELECT film, max(stevilo_filmov)
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film
; 
SELECT film
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
; 
SELECT *
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
; 
SELECT film, max(stevilo_filmov)
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film
; 
SELECT film, reziserji.id, max(stevilo_filmov)
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film
; 
SELECT film, max(stevilo_filmov)
  FROM vloge
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
 group by film
; 
select * from vloge;

select * from vloge where vloga = 'reziser';

SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
 WHERE vloga = 'reziser'
; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloga = 'reziser'
; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON vloge.oseba = reziserji.id
 WHERE vloge.vloga = 'reziser'
; 
SELECT *
  FROM stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON vloge.oseba = reziserji.id
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT vloge.film
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT film, oseba, stevilo_filmov
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT film, oseba, stevilo_filmov
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 
SELECT *
  FROM vloge
       JOIN
       stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma ON vloge.film = stevilo_filmov_najbolj_produktivnega_reziserja_danega_filma.film
       JOIN
       reziserji ON reziserji.id = vloge.oseba
      ; 