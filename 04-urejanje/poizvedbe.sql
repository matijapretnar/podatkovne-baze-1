-- Vrstice iz tabel brišemo z
--   DELETE FROM ime_tabele WHERE pogoj
-- Če pogoj izpustimo, se pobrišejo vse vrstice!

-- Ta poizvedba popolnoma izprazni tabelo vlog!
-- DELETE FROM vloge;

-- Pobrišimo vse vloge Adama Sandlerja, ki ima id 1191
-- Preden pobrišemo vrstice, je dobro, da pogledamo, kaj se bo zgodilo.
SELECT *
  FROM vloge
 WHERE oseba = 1191;

-- Potem le SELECT * spremenimo v DELETE
DELETE FROM vloge
      WHERE oseba = 1191;

-- Pobrišimo Adama Sandlerja še iz tabele oseb.
SELECT *
  FROM osebe
 WHERE id = 1191;

DELETE FROM osebe
      WHERE id = 1191;

-- Pobrišimo še M. Shyamalana iz tabele oseb.
SELECT *
  FROM osebe
 WHERE id = 796117;

DELETE FROM osebe
      WHERE id = 796117;

-- Poizvedba ne deluje, ker se Shyamalan pojavlja kot režiser filmov

-- Pobrišimo najprej vse njegove filme
SELECT *
  FROM filmi
 WHERE reziser = 796117;

DELETE FROM filmi
      WHERE reziser = 796117;

-- Poizvedba ne deluje, ker se filmi pojavljajo v tabelah vlog in žanrov

-- V poizvedbah bomo uporabljali gnezdeni SELECT za izbor filmov
SELECT id
  FROM filmi
 WHERE reziser = 796117;

-- Pobrišimo vse žanre Shyamalanovih filmov
SELECT *
  FROM zanri
 WHERE film IN (
           SELECT id
             FROM filmi
            WHERE reziser = 796117
       );

DELETE FROM zanri
      WHERE film IN (
    SELECT id
      FROM filmi
     WHERE reziser = 796117
);

-- Pobrišimo vse vloge v Shyamalanovih filmih

SELECT *
  FROM vloge
 WHERE film IN (
           SELECT id
             FROM filmi
            WHERE reziser = 796117
       );

DELETE FROM vloge
      WHERE film IN (
    SELECT id
      FROM filmi
     WHERE reziser = 796117
);

-- Sedaj lahko končno pobrišemo vse Shyamalanove filme

DELETE FROM filmi
      WHERE reziser = 796117;

-- Na koncu lahko pobrišemo tudi Shyamalana

DELETE FROM osebe
      WHERE id = 796117;

-- Posamične vrednosti v tabelo vstavljamo z
-- INSERT INTO ime_tabele (stolpec1, stolpec2, ...) VALUES (vrednost1, vrednost2, ...)

INSERT INTO osebe (
                      id,
                      priimek,
                      ime,
                      srednje
                  )
                  VALUES (
                      987654321,
                      'Pretnar',
                      'Matija',
                      ''
                  );

-- Če stolpce izpustimo, bo za vrednost nastavljeno NULL

INSERT INTO osebe (
                      id,
                      priimek,
                      ime
                  )
                  VALUES (
                      987654310,
                      'Pretnar',
                      'Matija'
                  );

-- Če izpustimo primarni ključ, ki ima nastavljen AUTO INCREMENT, se bo
-- vrednost izpolnila sama

INSERT INTO osebe (
                      priimek,
                      ime
                  )
                  VALUES (
                      'Pretnar',
                      'Matija'
                  );

-- Vnesemo lahko tudi več vrednosti, ki jih ločimo z vejicami.

INSERT INTO osebe (
                      priimek,
                      ime
                  )
                  VALUES (
                      'Vidali',
                      'Janoš'
                  ),
                  (
                      'Lokar',
                      'Matija'
                  ),
                  (
                      'Žagar',
                      'Emil'
                  );

-- INSERT INTO ime_tabele (stolpec1, ...) SELECT ...
-- v tabelo vnese rezultate SELECT poizvedbe

-- Vsem filmom kot igralca dodajmo še njihovega režiserja

-- Preden izvedemo poizvedbo, si poglejmo, katere podatke bomo vstavili.

SELECT id AS film,
       reziser AS oseba
  FROM filmi;

INSERT INTO vloge (
                      film,
                      oseba
                  )
                  SELECT id AS film,
                         reziser AS oseba
                    FROM filmi;

-- Dodajmo še biografije vseh režiserjev

SELECT max(leto),
       avg(dolzina),
       avg(ocena) 
  FROM filmi
 WHERE reziser = 122;

SELECT ime || ' ' || priimek
  FROM osebe;

SELECT *
  FROM filmi
       JOIN
       osebe ON filmi.reziser = osebe.id;

SELECT 'The life of ' || ime || ' ' || priimek AS naslov,
       max(leto) AS leto,
       avg(dolzina) AS dolzina,
       avg(ocena) AS ocena,
       reziser
  FROM filmi
       JOIN
       osebe ON filmi.reziser = osebe.id
 GROUP BY reziser,
          ime,
          priimek;

INSERT INTO filmi (
                      naslov,
                      leto,
                      dolzina,
                      ocena,
                      reziser
                  )
                  SELECT 'The life of ' || ime || ' ' || priimek AS naslov,
                         max(leto) AS leto,
                         avg(dolzina) AS dolzina,
                         avg(ocena) AS ocena,
                         reziser
                    FROM filmi
                         JOIN
                         osebe ON filmi.reziser = osebe.id
                   GROUP BY reziser,
                            ime,
                            priimek;

-- Tabele spreminjamo z
-- UPDATE ime_tabele SET stolpec1 = vrednost1, stolpec2 = vrednost2 WHERE pogoj

-- Skrijmo naslove vseh filmov, ki vsebujejo besedo America

-- Tako kot prej si najprej poglejmo, kaj bomo spremenili, preden izvedemo
-- spremembo. Tu je s popravkom poizvedbe malo več dela kot pri DELETE in INSERT

SELECT naslov, '******' FROM filmi WHERE naslov LIKE '%America%';

UPDATE filmi SET naslov = '******' WHERE naslov LIKE '%America%';

-- Vrednosti so lahko tudi izračunane

SELECT naslov,
       'Nek film o Evropi iz leta ' || leto
  FROM filmi
 WHERE naslov LIKE '%Euro%';

UPDATE filmi
   SET naslov = 'Nek film o Evropi iz leta ' || leto
 WHERE naslov LIKE '%Euro%';

-- Filmi režiserja z id 1438 so precenjeni in dolgočasni. Oceno jim razpolovimo,
-- dolžino pa podaljšajmo za polovico.

SELECT *
  FROM filmi
 WHERE reziser = 1438;

SELECT naslov,
       dolzina,
       dolzina * 1.5,
       ocena,
       ocena / 2
  FROM filmi
 WHERE reziser = 1438;

UPDATE filmi
   SET dolzina = dolzina * 1.5,
       ocena = ocena / 2
 WHERE reziser = 1438;
