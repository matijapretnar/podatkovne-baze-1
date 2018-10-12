-- Podatke lahko z GROUP BY združujemo v skupine
-- Število filmov v vsakem letu
SELECT count( * ) 
  FROM filmi
 GROUP BY leto;

-- Dobro je, če damo zraven še leto, da vemo, v katerem letu je bilo koliko filmov
SELECT leto,
       count( * ) 
  FROM filmi
 GROUP BY leto;

-- Poleg tega si poglejmo še povprečno oceno in dolžino vsakega leta
SELECT leto,
       count( * ),
       avg(ocena),
       avg(dolzina)
  FROM filmi
 GROUP BY leto;

-- Tudi tu se lahko omejimo le na posamezna leta
SELECT leto,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE leto >= 2010
 GROUP BY leto;

-- Število filmov vsakega režiserja
SELECT reziser,
       count( * ) 
  FROM filmi
 GROUP BY reziser;

-- Zadnjič smo opozorili, da takale poizvedba včasih dela, včasih pa ne
SELECT naslov,
       max(ocena) 
  FROM filmi;

-- Podobno je pri združevanju. Vedno izbirajmo le stolpce, ki bodisi določajo
-- skupino bodisi združujejo vrednosti
SELECT reziser,
       naslov,
       max(ocena) 
  FROM filmi
 GROUP BY reziser;

-- Število filmov ter povprečni ocena in dolžina filmov vsakega režiserja
SELECT reziser,
       count( * ),
       avg(ocena),
       avg(dolzina) 
  FROM filmi
 GROUP BY reziser;

-- Isto kot zgoraj, le urejeno padajoče po oceni
SELECT reziser,
       count( * ),
       avg(ocena),
       avg(dolzina) 
  FROM filmi
 GROUP BY reziser
 ORDER BY avg(ocena) DESC;

-- Da povprečja ne računamo dvakrat, ga raje poimenujemo
SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
 ORDER BY povprecna_ocena DESC;

-- Število dolgih filmov vsakega režiserja
SELECT reziser,
       count( * ) AS stevilo_filmov
  FROM filmi
 WHERE dolzina > 150
 GROUP BY reziser
 ORDER BY stevilo_filmov DESC;

-- Podatki o filmih posameznega režiserja, urejeni po povprečni dolžini
SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
 ORDER BY povprecna_dolzina DESC;

-- Če se želimo omejiti glede na združene podatke, moramo uporabiti HAVING
-- Izberemo le tiste režiserje ki so posneli vsaj tri filme
SELECT reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) AS povprecna_ocena,
       avg(dolzina) AS povprecna_dolzina
  FROM filmi
 GROUP BY reziser
HAVING stevilo_filmov >= 3
 ORDER BY povprecna_dolzina DESC;

-- Združujemo lahko tudi po izračunani vrednosti
-- Število filmov in povprečna ocena v vsakem desetletju
SELECT leto / 10 * 10 AS desetletje,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje;

-- Vidimo, da je povprečna ocena vedno nižja. Ali je vedno več slabih filmov?
-- Število dobrih filmov in povprečna ocena v vsakem desetletju
-- Vidimo, da je tudi dobrih filmov vedno več
SELECT leto / 10 * 10 AS desetletje,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE ocena > 8
 GROUP BY desetletje;

-- Združujemo lahko po več podatkih
-- Podatki o filmih po režiserjih in po desetletjih
SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje,
          reziser;

-- Podatki o filmih z oceno vsaj 8 po režiserjih in po desetletjih
SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ),
       avg(ocena) 
  FROM filmi
 WHERE ocena > 8
 GROUP BY desetletje,
          reziser;

-- Kako pa bi prešteli število režiserjev, ki so ustvarjali v posameznem desetletju?
-- Spodnja poizvedba nam da iste vrednosti kot zgornja, saj se režiser, ki je
-- režiral več filmov, pojavi večkrat
SELECT leto / 10 * 10 AS desetletje,
       count(reziser) 
  FROM filmi
 GROUP BY desetletje;

-- Če želimo prešteti le različne režiserje, lahko znotraj COUNT uporabimo DISTINCT
-- DISTINCT lahko uporabljamo tudi pri drugih združevanjih, vendar je najbolj
-- smiselen pri COUNT
SELECT leto / 10 * 10 AS desetletje,
       count(DISTINCT reziser) 
  FROM filmi
 GROUP BY desetletje;

-- Kateri režiserji v povprečju snemajo najboljše filme?
SELECT reziser,
       avg(ocena) as povprecna_ocena,
       count( * ) AS stevilo_filmov
  FROM filmi
 GROUP BY reziser
 ORDER BY povprecna_ocena DESC;

-- Lahko, da je kdo imel samo srečo.
-- S HAVING izberemo le tiste režiserje, ki so posneli vsaj tri take filme
SELECT reziser,
       avg(ocena) as povprecna_ocena,
       count( * ) AS stevilo_filmov
  FROM filmi
 GROUP BY reziser
HAVING stevilo_filmov >= 3
 ORDER BY povprecna_ocena DESC;

-- Poglejmo, kateri režiserji so posneli vsaj 5 filmov v posameznem desetletju
SELECT leto / 10 * 10 AS desetletje,
       reziser,
       count( * ) AS stevilo_filmov,
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje,
          reziser
HAVING stevilo_filmov >= 5;

-- Vsi režiserji, ki so posneli vsaj en dvourni film
SELECT reziser,
       count( * ) AS stevilo_filmov
  FROM filmi
 WHERE dolzina >= 120
 GROUP BY reziser
 ORDER BY stevilo_filmov DESC;

-- Vsi režiserji, ki so posneli vsaj tri dvourne filme
SELECT reziser,
       count( * ) AS stevilo_filmov
  FROM filmi
 WHERE dolzina >= 120
 GROUP BY reziser
HAVING stevilo_filmov >= 3
 ORDER BY stevilo_filmov DESC;

-- Vsi režiserji, ki so posneli vsaj pet slabih filmov.
SELECT reziser
  FROM filmi
 WHERE ocena <= 7
 GROUP BY reziser
HAVING count( * ) >= 5
 ORDER BY reziser;

-- Uredimo filme po letih, znotraj leta pa padajoče po oceni
SELECT naslov,
       leto,
       ocena
  FROM filmi
 ORDER BY leto,
          ocena DESC;

-- Koliko filmov je bilo leta 1999 slabših od Grozeče prikazni?
-- Podatki o Vojni zvezd: grozeča prikazen
SELECT *
  FROM filmi
 WHERE naslov = 'Star Wars: Episode I - The Phantom Menace';

-- Vnesemo podatke o oceni in letu
SELECT COUNT( * ) 
  FROM filmi
 WHERE leto = 1999 AND 
       ocena > 6.5;

-- Kako bi to naredili za vsak film?
-- Lahko bi uporabiti gnezdeni SELECT,
-- ampak kako napišemo, naj bo ocena filma več od ocene Grozeče prikazni?
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

-- Tabele lahko s pomočjo AS tudi preimenujemo, pri stolpcih pa lahko
-- eksplicitno povemo še ime tabele. Potem ne pride do težav.
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

-- Katero mesto je zasedel film na lestvici najboljših filmov tistega leta?
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

-- Katero mesto je zasedel film na lestvici najboljših filmov posameznega režiserja?
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

-- Filmi, ki so v danem desetletju glede ocene najbolj odstopali od povprečja.
SELECT 10 * (leto / 10) AS desetletje,
       leto,
       naslov,
       ocena,
       (ABS(ocena - (
                        SELECT AVG(ocena) 
                          FROM filmi AS f
                         WHERE 10 * (f.leto / 10) = 10 * (filmi.leto / 10)
                    )
       ) ) AS odstopanje
  FROM filmi
 ORDER BY desetletje,
          odstopanje DESC;
