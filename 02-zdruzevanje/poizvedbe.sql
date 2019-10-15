-- Z združevalnimi funkcijami lahko izračunamo vrednost glede na celotno tabelo
-- Najdaljša dolžina filma
SELECT max(dolzina) 
  FROM film;

-- Skupna dolžina in povprečna ocena Gospodarjev prstanov
SELECT sum(dolzina),
       avg(ocena) 
  FROM film
 WHERE naslov LIKE 'Gospodar prstanov%';

-- S count preštejemo vrednosti. Koliko filmov ima naslove? Vseh 10000
SELECT count(naslov) 
  FROM film;

-- Koliko filmov ima oznake? Manj, ker marsikje niso definirane
SELECT count(oznaka) 
  FROM film;

-- Če želimo prešteti število vrstic, namesto posameznega stolpca uporabimo *,
-- saj bi sicer lahko zaradi manjkajočih vrednosti lahko dobili manj rezultatov
SELECT count( * ) 
  FROM film
 WHERE ocena > 8;

-- Kaj pa je najdaljši film? Ta poizvedba sicer dela, vendar ni dobro definirana.
-- SQLite načeloma da pravilen odgovor, samo se nanj ne zanašamo. Kakšne bolj stroge
-- baze poizvedbo zavrnejo.
SELECT max(dolzina), naslov
  FROM film;

-- Bolje je uporabiti gnezdeno poizvedbo.
SELECT *
  FROM film
 WHERE dolzina = (
                     SELECT max(dolzina) 
                       FROM film
                 );


-- Podatke lahko z GROUP BY združujemo v skupine
-- Število filmov v vsakem letu
SELECT count( * ) 
  FROM film
 GROUP BY leto;

-- Dobro je, če damo zraven še leto, da vemo, v katerem letu je bilo koliko filmov
SELECT leto,
       count( * ) 
  FROM film
 GROUP BY leto;

-- Poleg tega si poglejmo še povprečno oceno in dolžino vsakega leta
SELECT leto,
       count( * ),
       avg(ocena) 
  FROM film
 GROUP BY leto;

-- Tudi tu se lahko omejimo le na posamezna leta ali filme z dovolj glasovi
SELECT leto,
       count( * ),
       avg(ocena) 
  FROM film
 WHERE leto > 1996
 GROUP BY leto;

SELECT leto,
       count( * ),
       avg(ocena) 
  FROM film
 WHERE glasovi > 50000
 GROUP BY leto;

-- Združujemo lahko tudi po izračunani vrednosti
-- Število filmov in povprečna ocena v vsakem desetletju
SELECT leto / 10 * 10 AS desetletje,
       count( * ),
       avg(ocena) 
  FROM filmi
 GROUP BY desetletje;

-- Združujemo lahko po več podatkih
-- Podatki o filmih po letih in oznakah
SELECT leto,
       oznaka,
       count( * ) 
  FROM film
 GROUP BY leto,
          oznaka;

-- Vidimo, da so skupine pri oznaki G zelo majhne. Preverimo, ali je to res. 
SELECT *
  FROM film
 WHERE oznaka = 'G'
 ORDER BY leto;

-- V katerih letih so imeli filmi v povprečju največji dobiček?
SELECT leto,
       avg(zasluzek) 
  FROM film
 GROUP BY leto;

-- Isto kot zgoraj, le urejeno padajoče po oceni
SELECT leto,
       avg(zasluzek) 
  FROM film
 GROUP BY leto
 ORDER BY avg(zasluzek) DESC;

-- Da povprečja ne računamo dvakrat, ga raje poimenujemo
SELECT leto,
       avg(zasluzek) AS povprecni_zasluzek
  FROM film
 GROUP BY leto
 ORDER BY povprecni_zasluzek DESC;

-- Deset let z najboljšo povprečno oceno
SELECT leto,
       avg(ocena) AS povprecna_ocena
  FROM film
 GROUP BY leto
 ORDER BY povprecna_ocena DESC
 LIMIT 10;

-- Izumili smo časovni stroj in bi šli radi v leta, v katerih so bili posneti
-- čimboljši filmi o času. Podatki o filmih, ki govorijo o času:
SELECT *
  FROM film
 WHERE naslov LIKE '%time%' OR 
       opis LIKE '%time%' AND 
       opis NOT LIKE '%small-time%';

-- V katero leto se nam splača iti?
SELECT leto,
       avg(ocena) AS povprecna_ocena
  FROM film
 WHERE naslov LIKE '%time%' OR 
       opis LIKE '%time%' AND 
       opis NOT LIKE '%small-time%'
 GROUP BY leto
 ORDER BY povprecna_ocena DESC;

-- Pri izboru bi radi upoštevali tudi leta,
-- v katerih je bilo posnetih več takih filmov.
SELECT leto,
       avg(ocena) AS povprecna_ocena,
       count( * ) AS stevilo_filmov
  FROM film
 WHERE naslov LIKE '%time%' OR 
       opis LIKE '%time%' AND 
       opis NOT LIKE '%small-time%'
 GROUP BY leto
 ORDER BY povprecna_ocena DESC;

-- Kako bi se lahko omejili na leta, kjer so bili posneti vsaj trije filmi?
-- Lahko uporabimo gnezdeno poizvedbo.
SELECT *
  FROM (
           SELECT leto,
                  avg(ocena) AS povprecna_ocena,
                  count( * ) AS stevilo_filmov
             FROM film
            WHERE naslov LIKE '%time%' OR 
                  opis LIKE '%time%' AND 
                  opis NOT LIKE '%small-time%'
            GROUP BY leto
       )
 WHERE stevilo_filmov >= 3
 ORDER BY povprecna_ocena DESC;

-- Poizvedba, kjer filtriramo po združenih rezultatih je pogosta,
-- zato obstaja enostavnejši način: HAVING
SELECT leto,
       avg(ocena) AS povprecna_ocena,
       count( * ) AS stevilo_filmov
  FROM film
 WHERE naslov LIKE '%time%' OR 
       opis LIKE '%time%' AND 
       opis NOT LIKE '%small-time%'
 GROUP BY leto
HAVING stevilo_filmov >= 3
 ORDER BY povprecna_ocena DESC;
 
-- Vsa leta, v katerih je bilo posnetih več kot 5 filmov z oceno več kot 8
SELECT leto,
       count( * ) AS stevilo_filmov
  FROM film
 WHERE ocena > 8
 GROUP BY leto
HAVING stevilo_filmov > 5;

-- Naslovi, ki se pojavljajo pri vsaj treh filmih
SELECT naslov,
       count( * ) AS stevilo_filmov
  FROM film
 GROUP BY naslov
HAVING stevilo_filmov >= 3;

-- Kako bi našli najboljši film vsakega leta?
-- Prej smo videli, da taka poizvedba včasih dela, včasih pa ne.
-- Podobno je pri združevanju. Vedno izbirajmo le stolpce, ki bodisi določajo
-- skupino bodisi združujejo vrednosti
WITH znani_filmi AS (
    SELECT *
      FROM film
     WHERE glasovi > 100000
)
SELECT leto,
       max(ocena) AS najvecja_ocena,
       naslov
  FROM znani_filmi
 GROUP BY leto;

-- Toda kako naredimo ustrezno gnezdeno poizvedbo?
WITH znani_filmi AS (
    SELECT *
      FROM film
     WHERE glasovi > 100000
)
SELECT leto,
       max(ocena) AS najvecja_ocena,
       (
           SELECT naslov
             FROM znani_filmi
            WHERE ???
            ORDER BY ocena DESC
            LIMIT 1
       )
  FROM znani_filmi
 GROUP BY leto;

-- Tabele lahko s pomočjo AS tudi preimenujemo, pri stolpcih pa lahko
-- eksplicitno povemo še ime tabele. Potem ne pride do težav.
WITH znani_filmi AS (
    SELECT *
      FROM film
     WHERE glasovi > 100000
)
SELECT leto,
       max(ocena) AS najvecja_ocena,
       (
           SELECT naslov
             FROM znani_filmi AS f
            WHERE f.leto = znani_filmi.leto
            ORDER BY ocena DESC
            LIMIT 1
       )
  FROM znani_filmi
 GROUP BY leto;

-- Koliko filmov v istem letu je zaslužilo manj od danega filma?
WITH znani_filmi AS (
    SELECT *
      FROM film
     WHERE glasovi > 100000 AND 
           zasluzek IS NOT NULL
)
SELECT naslov,
       leto,
       zasluzek,
       (
           SELECT count( * ) 
             FROM znani_filmi AS f
            WHERE f.zasluzek < znani_filmi.zasluzek AND 
                  f.leto = znani_filmi.leto
       )
  FROM znani_filmi
 ORDER BY zasluzek DESC;

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
