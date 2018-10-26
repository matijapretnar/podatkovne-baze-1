-- Opazili smo, da Emma Watson ni vnešena kot igralka pri prvem Harry Potter filmu.
-- Posamične vrednosti v tabelo vstavljamo z
-- INSERT INTO ime_tabele (stolpec1, stolpec2, ...) VALUES (vrednost1, vrednost2, ...)
INSERT INTO vloge (
                      oseba,
                      film,
                      vloga
                  )
                  VALUES (
                      914612,
                      241527,
                      'igralec'
                  );

-- Vnesemo lahko tudi več vrednosti, ki jih ločimo z vejicami.
INSERT INTO osebe (
                      id,
                      ime
                  )
                  VALUES (
                      123456,
                      'Matija Pretnar',
                  ),
                  (
                      234567,
                      'Janoš Vidali',
                  );


-- Da nam ni treba tipkati ID številk, lahko uporabimo tudi podpoizvedbe.
INSERT INTO vloge (
                      oseba,
                      film,
                      vloga
                  )
                  VALUES (
                      (
                          SELECT osebe.id
                            FROM osebe
                           WHERE osebe.ime = 'Emma Watson'
                      ),
                      (
                          SELECT filmi.id
                            FROM filmi
                           WHERE filmi.naslov = 'Harry Potter in kamen modrosti'
                      ),
                      'igralec'
                  );

-- INSERT INTO ime_tabele (stolpec1, ...) SELECT ...
-- v tabelo vnese rezultate SELECT poizvedbe

-- Naredimo remake vsakega filma, posnetega pred letom 1950.
-- Najprej naredimo SELECT, da vidimo, kaj bomo vstavljali.
SELECT naslov || " II",
       dolzina + 30,
       2020,
       10,
       opis
  FROM filmi
 WHERE filmi.leto < 1950;

-- Sedaj vstavimo podobno kot prej, le da namesto VALUES (...)
-- napišemo poizvebo.
INSERT INTO filmi (
                      naslov,
                      dolzina,
                      leto,
                      ocena,
                      opis
                  )
                  SELECT naslov || " II",
                         dolzina + 30,
                         2020,
                         10,
                         opis
                    FROM filmi
                   WHERE filmi.leto < 1950;

INSERT INTO zanri (
                      film,
                      zanr
                  )
                  VALUES (
                      5000,
                      'Comedy'
                  );

-- Tabele spreminjamo z
-- UPDATE ime_tabele SET stolpec1 = vrednost1, stolpec2 = vrednost2 WHERE pogoj

-- Skrijmo naslove vseh filmov, ki vsebujejo besedo America

-- Tako kot prej si najprej poglejmo, kaj bomo spremenili, preden izvedemo
-- spremembo. Tu je s popravkom poizvedbe malo več dela kot pri DELETE in INSERT

SELECT naslov, '******' FROM filmi WHERE naslov LIKE '%America%';

UPDATE filmi SET naslov = '******' WHERE naslov LIKE '%America%';

-- Vse ocene pomnožimo z 10.
UPDATE filmi
   SET ocena = 10 * ocena;

-- Ocene povrnimo vsem filmom razen Vojnam zvezd. Poglejmo
-- kaj se bo spremenilo pri katerih filmih:
SELECT naslov,
       ocena,
       ocena / 10
  FROM filmi
 WHERE naslov NOT LIKE 'Vojna zvezd%';

-- Nato izvedemo poizvedbo.
UPDATE filmi
   SET ocena = ocena / 10
 WHERE naslov NOT LIKE 'Vojna zvezd%';

-- Drama je zelo generičen žanr, zato pobrišimo
-- vse njegove vnose v tabeli zanri.
-- Vrstice iz tabel brišemo z
--   DELETE FROM ime_tabele WHERE pogoj
-- Če pogoj izpustimo, se pobrišejo vse vrstice!

-- Ta poizvedba popolnoma izprazni tabelo žanrov!
-- DELETE FROM zanri;

-- Najprej naredimo SELECT, da vidimo
-- kaj bomo pobrisali:
SELECT *
  FROM zanri
 WHERE zanr = 'Drama';

-- Potem le SELECT * spremenimo v DELETE
DELETE FROM zanri
      WHERE zanr = 'Drama';
