-- Po novem imamo tabelo pripada, v kateri piše,
-- kateri film pripada kateremu žanru.
-- Poglejmo, v katerih žanrih je posnetih največ filmov.
SELECT zanr,
       COUNT( * ) AS st_filmov
  FROM pripada
 GROUP BY zanr
 ORDER BY st_filmov DESC;

-- Dobili smo le IDje, ne pa nazivov žanrov. Ti so v tabeli zanr,
-- ki jo moramo pridružiti tabeli pripada. Najbolj surov način je,
-- da za FROM naštejemo več tabel, s čimer nam poizvedba vrne vse
-- možne kombinacije (ki jih je ZELOOO veliko).
SELECT *
  FROM pripada,
       zanr;

SELECT COUNT( * )
  FROM pripada;

SELECT COUNT( * )
  FROM zanr;

SELECT COUNT( * )
  FROM pripada,
       zanr;

-- Seveda bi radi le kombinacije, kjer se vrstica filma
-- ujema z vrstico dodelitve žanra. Ker delamo z več
-- tabelami, vse stolpce označimo z imenom tabele.
SELECT *
  FROM pripada,
       zanr
 WHERE pripada.zanr = zanr.id;

-- Postopek, v katerem uparimo vrstice dveh tabel,
-- ki se ujemajo v določenem stolpcu, je izjemno pogost.
-- Pravimo mu stikanje, v SQL stavku pa ga zapišemo kot:
SELECT *
  FROM pripada
       JOIN
       zanr ON pripada.zanr = zanr.id;

-- Sedaj lahko izračunamo želeno število:
SELECT zanr.naziv,
       COUNT( * ) AS st_filmov
  FROM pripada
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY zanr.naziv
 ORDER BY st_filmov DESC;

-- Izračunajmo še povprečno oceno filmov posameznega žanra.
-- Podatki so shranjeni v treh tabelah: ocene v tabeli film,
-- nazivi žanrov v tabeli zanr, povezava med njimi pa v tabeli
-- pripada. Torej moramo stakniti te tri tabele.

-- Lahko najprej združimo filme in pripadnost:
SELECT zanr.naziv, film.naslov, film.leto, film.ocena
  FROM (
           film
           JOIN
           pripada ON film.id = pripada.film
       )
       JOIN
       zanr ON pripada.zanr = zanr.id;

-- Lahko najprej združimo pripadnost in žanre:
SELECT zanr.naziv, film.naslov, film.leto, film.ocena
  FROM film
       JOIN
       (
           pripada
           JOIN
           zanr ON pripada.zanr = zanr.id
       )
       ON film.id = pripada.film;

-- Vendar je operacija asociativna, zato lahko oklepaje izpustimo:
-- (tudi komutativna je do vrstnega reda stolpcev natančno)
SELECT zanr.naziv, film.naslov, film.leto, film.ocena
  FROM film
       JOIN
       pripada ON film.id = pripada.film
       JOIN
       zanr ON pripada.zanr = zanr.id;

-- Sedaj lahko izračunamo želeno povprečje:
SELECT zanr.naziv,
       avg(film.ocena) AS povprecna_ocena
  FROM film
       JOIN
       pripada ON film.id = pripada.film
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY zanr.naziv
 ORDER BY povprecna_ocena DESC;

-- Še povprečna dolžina vsakega žanra:
SELECT zanr.naziv,
       avg(film.dolzina) AS povprecna_dolzina
  FROM zanr
       JOIN
       pripada ON zanr.id = pripada.zanr
       JOIN
       film ON pripada.film = film.id
 GROUP BY zanr.naziv
 ORDER BY povprecna_dolzina DESC;

-- Poglejmo, kateri filmi so imeli več kot enega režiserja.
SELECT film.naslov, COUNT( * ) AS st_reziserjev
  FROM vloga
       JOIN
       film on vloga.film = film.id
 WHERE vloga.tip = 'R'
 GROUP BY film
HAVING st_reziserjev > 1
 ORDER BY st_reziserjev DESC;

-- Zgornja poizvedba je napačna, saj združuje filme z istim
-- naslovom. Na primer, filma King Kong in Robin Hood sta
-- bila po dva, vsak z enim režiserjem. Bolje bi bilo
-- združevati po IDju, vendar po tem, ne moremo enostavno
-- pridobiti naslova, saj dobimo neveljavno poizvedbo,
-- ki v nekaterih bazah dela načeloma pravilno, v drugih naključno,
-- v tretjih pa je zavrnjena. To torej ne bo dobra rešitev.
-- Pri združevanjih se lahko pojavljajo le kombinacije združevalnih
-- funkcij in vrednosti, po katerih združujemo.
SELECT film.naslov, COUNT( * ) AS st_reziserjev
  FROM vloga
       JOIN
       film on vloga.film = film.id
 WHERE vloga.tip = 'R'
 GROUP BY film.id
 ORDER BY st_reziserjev DESC;

-- Poglejmo si enostavnejši primer. Kako bi izračunali
-- povprečno oceno in število filmov za vsako ID številko?
-- To ni zelo zanimivo, ker je v vsaki skupini natanko
-- en film, ampak recimo, da nas zanima, kaj je naslov
-- tega filma.
SELECT id,
       avg(ocena),
       count( * ) AS st_filmov
  FROM film
 GROUP BY id
 ORDER BY st_filmov DESC;

-- Če združujemo po naslovu, dobimo druge podatke,
-- ker je več filmov z istim naslovom.
SELECT naslov,
       avg(ocena),
       count( * ) AS st_filmov
  FROM film
 GROUP BY naslov
 ORDER BY st_filmov DESC;

-- Rešitev: združevanje po več stolpcih. Na primer,
-- tu je število vseh filmov v danem letu z dano oceno.
-- Opazimo da dodatni stolpci skupine kvečjemu razdrobijo.
SELECT naslov,
       leto,
       avg(ocena),
       count( * ) AS st_filmov
  FROM film
 GROUP BY naslov,
          leto
 ORDER BY st_filmov DESC;

-- Če združimo vse filme z isto ID številko in naslovom,
-- ne dobimo nobene dodatne skupine, saj ID enolično določa
-- film in njegov naslov, hkrati pa naslov postane vrednost
-- po kateri združujemo, zato jo lahko uporabimo v stolpcu.
SELECT id,
       naslov,
       avg(ocena),
       count( * ) AS st_filmov
  FROM film
 GROUP BY id,
          naslov
 ORDER BY st_filmov DESC;

-- Torej lahko svojo poizvedbo napišemo kot
SELECT film.naslov,
       count( * ) AS st_reziserjev
  FROM film
       JOIN
       vloga ON film.id = vloga.film
 WHERE vloga.tip = 'R'
 GROUP BY film.id, film.naslov
 ORDER BY st_reziserjev DESC;

-- Zanimajo nas naslovi in leta filmov, v katerih je igral Harrison Ford.
SELECT film.naslov, film.leto
FROM
  film
  JOIN
  vloga on film.id = vloga.film
  JOIN
  oseba on vloga.oseba = oseba.id
where
  vloga.tip = 'I' and oseba.ime = 'Harrison Ford';

-- Koliko so skupno zaslužili filmi posameznega režiserja
SELECT oseba.id,
       oseba.ime,
       sum(film.zasluzek) AS skupni_zasluzek
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 WHERE vloga.tip = 'R' AND
       film.zasluzek IS NOT NULL
 GROUP BY oseba.id,
          oseba.ime
 ORDER BY skupni_zasluzek DESC;

-- V katerih žanrih so igrali kateri igralci?
SELECT oseba.ime,
       pripada.zanr
  FROM oseba
       JOIN
       vloga ON oseba.id = vloga.oseba
       JOIN
       pripada ON vloga.film = pripada.film;

-- V koliko filmih posameznega žanra je igral kakšen igralec?
SELECT oseba.ime,
       pripada.zanr,
       count( * )
  FROM oseba
       JOIN
       vloga ON oseba.id = vloga.oseba
       JOIN
       pripada ON vloga.film = pripada.film
 GROUP BY oseba.ime,
          pripada.zanr;

-- Kdo je igral v največ komedijah?
SELECT oseba.ime,
       count(vloga.film) AS st_komedij
  FROM pripada
       JOIN
       vloga ON pripada.film = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
       JOIN
       zanr ON pripada.zanr = zanr.id
 WHERE zanr.naziv = 'Comedy' AND 
       vloga.tip = 'I'
 GROUP BY oseba.id, oseba.ime
 ORDER BY st_komedij DESC;

-- Katere osebe igrajo v filmih z najboljšo oceno?
-- Zaradi relevantnosti se omejimo le na tiste, ki so
-- igrali v vsaj petih filmih.
SELECT oseba.ime,
       count( * ) AS st_filmov,
       avg(film.ocena) AS povprecna_ocena
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 WHERE film.glasovi > 75000 AND vloga.tip = 'I'
 GROUP BY oseba.id,
          oseba.ime
HAVING st_filmov >= 5
 ORDER BY povprecna_ocena DESC;

-- Kako bi pogledali, kdo vse je igral v filmu, ki ga je sam režiral?
-- Lahko pogledamo vse tiste, ki so imeli v filmu dve vlogi.
SELECT film.naslov,
       oseba.ime
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 GROUP BY film.id,
          film.naslov,
          oseba.id,
          oseba.ime
HAVING count( * ) >= 2;

-- Lahko pa pogledamo, kje se v dveh različnih vlogah
-- ujemata tako oseba kot film.
WITH reziser AS (
    SELECT *
      FROM vloga
     WHERE tip = 'R'
),
igralec AS (
    SELECT *
      FROM vloga
     WHERE tip = 'I'
)
SELECT film.naslov, oseba.ime
  FROM reziser
       JOIN
       igralec ON reziser.oseba = igralec.oseba AND 
                  reziser.film = igralec.film
       JOIN
       film ON film.id = reziser.film
       JOIN
       oseba ON oseba.id = reziser.oseba;

-- Kdo je igral v največ filmih, ki jih je sam režiral?
WITH reziser AS (
    SELECT *
      FROM vloga
     WHERE tip = 'R'
),
igralec AS (
    SELECT *
      FROM vloga
     WHERE tip = 'I'
)
SELECT oseba.ime,
       count( * ) AS st_filmov
  FROM reziser
       JOIN
       igralec ON reziser.oseba = igralec.oseba AND 
                  reziser.film = igralec.film
       JOIN
       oseba ON oseba.id = reziser.oseba
 GROUP BY oseba.id,
          oseba.ime
 ORDER BY st_filmov DESC;

-- Zanima nas, kateri režiserji in igralci dostikrat ustvarjajo skupaj.
WITH reziser AS (
    SELECT *
      FROM vloga
     WHERE tip = 'R'
),
igralec AS (
    SELECT *
      FROM vloga
     WHERE tip = 'I'
)
SELECT oseba_reziser.ime,
       oseba_igralec.ime,
       count( * ) AS st_filmov
  FROM reziser
       JOIN
       igralec ON reziser.film = igralec.film
       JOIN
       oseba AS oseba_reziser ON oseba_reziser.id = reziser.oseba
       JOIN
       oseba AS oseba_igralec ON oseba_igralec.id = igralec.oseba
 GROUP BY oseba_reziser.id,
          oseba_reziser.ime,
          oseba_igralec.id,
          oseba_igralec.ime
 ORDER BY st_filmov DESC;

-- Zanima nas, kateri pari igralcev dostikrat ustvarjajo skupaj.
SELECT oseba_prvi.ime,
       oseba_drugi.ime,
       count( * ) AS st_filmov
  FROM vloga AS prvi
       JOIN
       vloga AS drugi ON prvi.film = drugi.film
       JOIN
       oseba AS oseba_prvi ON oseba_prvi.id = prvi.oseba
       JOIN
       oseba AS oseba_drugi ON oseba_drugi.id = drugi.oseba
  WHERE oseba_prvi.ime < oseba_drugi.ime
 GROUP BY oseba_prvi.id,
          oseba_prvi.ime,
          oseba_drugi.id,
          oseba_drugi.ime
 ORDER BY st_filmov DESC;

-- Kateri filmi so romantične komedije?
SELECT film.* FROM
    pripada AS prvi
    JOIN
    pripada AS drugi on prvi.film = drugi.film
    JOIN
    film ON film.id = prvi.film
where prvi.zanr = 4 AND drugi.zanr = 8 AND oznaka != 'R'
ORDER by film.glasovi DESC
