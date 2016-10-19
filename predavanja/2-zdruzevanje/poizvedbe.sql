-- najvišja ocena kateregakoli filma
SELECT MAX(ocena) 
  FROM filmi;

-- najkrajša dolžina kateregakoli filma
SELECT MIN(dolzina) 
  FROM filmi;

-- najkrajša, povprečna in največja dolžina kateregakoli filma
SELECT MIN(dolzina),
       AVG(dolzina),
       MAX(dolzina) 
  FROM filmi;

-- največja dolžina filma, ki ga je režiral Steven Spielberg
SELECT max(dolzina) 
  FROM filmi
 WHERE reziser = 'Steven Spielberg';

-- povprečna dolžina filmov, ki jih je režiral Steven Spielberg
SELECT avg(ocena) 
  FROM filmi
 WHERE reziser = 'Steven Spielberg';

-- vsi filmi, ki jih je režiral Charlie Chaplin
SELECT *
  FROM filmi
 WHERE reziser = 'Charles Chaplin';

-- skupna dolžina vseh filmov, ki jih je režiral Charlie Chaplin
SELECT sum(dolzina) 
  FROM filmi
 WHERE reziser = 'Charles Chaplin';

-- število filmov, ki jih je režiral Charlie Chaplin, pri katerih imamo podatke
-- o dolžini/oceni/certifikatu/režiserju
-- Običajno so vse številke enake, razen če kje kakšen podatek manjka
SELECT count(dolzina),
       count(ocena),
       count(certifikat),
       count(reziser) 
  FROM filmi
 WHERE reziser = 'Charles Chaplin';

-- Če želimo prešteti ujemajočevrstice, uporabimo count( * )
SELECT count( * ) 
  FROM filmi
 WHERE reziser = 'Charles Chaplin';

-- Dolžina najkrajšega Spielbergovega filma je 107 minut. Toda kateri film je to?
SELECT MIN(dolzina) 
  FROM filmi
 WHERE reziser = 'Steven Spielberg';

-- Poiščemo vse Spielbergove filme z dolžino 107 minut.
SELECT *
  FROM filmi
 WHERE dolzina = 107 AND 
       reziser = 'Steven Spielberg';

-- Še bolje je uporabiti gnezdeni SELECT
SELECT *
  FROM filmi
 WHERE dolzina = (
                     SELECT MIN(dolzina) 
                       FROM filmi
                      WHERE reziser = 'Steven Spielberg'
                 )
AND 
       reziser = 'Steven Spielberg';

-- Povprečna ocena vseh filmov
SELECT avg(ocena) 
  FROM filmi;

-- Podatki vseh filmov hkrati z absolutno razliko do povprečne vrednosti ocene
SELECT *,
       ABS(ocena - 6.94) 
  FROM filmi;

-- Podatki vseh filmov hkrati s tem, ali se ocena od povprečja razlikuje za manj kot 0.1
SELECT *
  FROM filmi
 WHERE ABS(ocena - 6.94) < 0.1;

-- Vsi povprečni filmi, torej tisti, ki se od povprečja razlikujejo za manj kot 0.1
SELECT *
  FROM filmi
 WHERE ocena BETWEEN 6.94 - 0.1 AND 6.94 + 0.1;

-- Boljša rešitev: gnezdeni SELECT
SELECT *
  FROM filmi
 WHERE ABS(ocena - (
                       SELECT avg(ocena) 
                         FROM filmi
                   )
       ) < 0.1;

SELECT *
  FROM filmi
 WHERE ocena < (
                   SELECT min(ocena) 
                     FROM filmi
                    WHERE reziser LIKE '%Shyamalan'
               );

SELECT count( * ) 
  FROM filmi
 GROUP BY leto;

SELECT leto,
       count( * ) 
  FROM filmi
 GROUP BY leto;

SELECT leto,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY leto;

SELECT leto,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE leto >= 2010
 GROUP BY leto;

SELECT reziser,
       count( * ) 
  FROM filmi
 GROUP BY reziser;

SELECT reziser,
       count( * ),
       avg(ocena),
       avg(dolzina) 
  FROM filmi
 GROUP BY reziser;

SELECT reziser,
       count( * ),
       avg(ocena),
       avg(dolzina) 
  FROM filmi
 GROUP BY reziser
 ORDER BY avg(ocena) DESC;

SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
 ORDER BY povprecna_ocena DESC;

SELECT reziser,
       count( * ) AS stevilo_filmov
  FROM filmi
 WHERE dolzina > 150
 GROUP BY reziser
 ORDER BY stevilo_filmov DESC;

SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
 ORDER BY povprecna_dolzina DESC;

SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
HAVING stevilo_filmov >= 3
 ORDER BY povprecna_dolzina DESC;

SELECT reziser,
       count( * ) AS stevilo_filmov
  FROM filmi
 WHERE dolzina >= 150
 GROUP BY reziser
HAVING stevilo_filmov >= 3;

SELECT naslov,
       max(ocena) 
  FROM filmi;

SELECT reziser,
       naslov,
       max(ocena) 
  FROM filmi
 GROUP BY reziser;

SELECT naslov,
       leto
  FROM filmi;

SELECT naslov,
       leto,
       leto / 10 * 10 AS desetletje
  FROM filmi;

SELECT leto / 10 * 10 AS desetletje,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje;

SELECT leto / 10 * 10 AS desetletje,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE ocena > 8
 GROUP BY desetletje;

SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE ocena > 8
 GROUP BY desetletje,
          reziser;

SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje,
          reziser;

SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje,
          reziser
HAVING stevilo_filmov >= 5;

SELECT leto / 10 * 10 AS desetletje,
       count( * ) 
  FROM filmi
 GROUP BY desetletje;

SELECT leto / 10 * 10 AS desetletje,
       count(reziser) 
  FROM filmi
 GROUP BY desetletje;

SELECT leto / 10 * 10 AS desetletje,
       count(DISTINCT reziser) 
  FROM filmi
 GROUP BY desetletje;

SELECT naslov,
       leto,
       ocena
  FROM filmi
 ORDER BY leto,
          ocena DESC;

SELECT *
  FROM filmi
 WHERE naslov = 'Star Wars: Episode I - The Phantom Menace';

SELECT COUNT( * ) 
  FROM filmi
 WHERE leto = 1999 AND 
       ocena > 6.5;

SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi
            WHERE leto = leto AND 
                  ocena > ocena
       )
  FROM filmi;

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
          ocena DESC;

SELECT leto,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.leto = filmi.leto AND 
                  f.ocena > filmi.ocena
       )
+      1 AS mesto
  FROM filmi
 ORDER BY leto,
          ocena DESC;

SELECT reziser,
       naslov,
       ocena,
       (
           SELECT COUNT( * ) 
             FROM filmi AS f
            WHERE f.reziser = filmi.reziser AND 
                  f.ocena > filmi.ocena
       )
+      1 AS mesto
  FROM filmi
 ORDER BY reziser,
          ocena DESC;