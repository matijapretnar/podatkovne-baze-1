-- Po novem imamo tabelo pripada, v kateri piše,
-- kateri film pripada kateremu žanru.
-- Poglejmo, v katerih žanrih je posnetih največ filmov.
SELECT zanr, COUNT( * ) AS stevilo_filmov
  FROM pripada
 GROUP BY zanr
 ORDER BY stevilo_filmov DESC;

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
       COUNT(*) as stevilo_filmov
  FROM pripada
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY zanr.naziv
 ORDER BY stevilo_filmov DESC;

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
       pripada
       JOIN
       zanr ON pripada.zanr = zanr.id;

-- Sedaj lahko izračunamo želeno povprečje:
SELECT zanr.naziv,
       AVG(film.ocena) as povprecna_ocena
  FROM film
       JOIN
       pripada ON film.id = pripada.film
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY zanr.naziv
 ORDER BY povprecna_ocena DESC;

-- Naredimo krajšo statistiko žanrov
SELECT zanr.naziv,
       count( * ) AS st_filmov,
       avg(film.ocena) AS povprecna_ocena,
       avg(film.dolzina) AS povprecna_dolzina
  FROM film
       JOIN
       pripada ON film.id = pripada.film
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY zanr.naziv
 ORDER BY zanr.naziv;

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
SELECT film.naslov, COUNT( * ) AS st_reziserjev
  FROM vloga
       JOIN
       film on vloga.film = film.id
 WHERE vloga.tip = 'R'
 GROUP BY film.id, film.naslov
 ORDER BY st_reziserjev DESC;

-- Zanimajo nas naslovi filmov, v katerih je igral Nicolas Cage.
-- In tu so podatki o vseh filmih Nicolasa Cagea.
SELECT film.naslov,
       film.leto,
       film.ocena,
       oseba.ime,
       vloga.tip,
       film.opis
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 WHERE oseba.ime = 'Nicolas Cage'
 ORDER BY ocena DESC;

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

-- Namesto WHERE in GROUP BY lahko najprej naredimo tudi GROUP BY in potem HAVING.
SELECT oseba.ime,
       count(vloga.film) AS st_komedij
  FROM pripada
       JOIN
       vloga ON pripada.film = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
       JOIN
       zanr ON pripada.zanr = zanr.id
 GROUP BY oseba.id,
          oseba.ime,
          pripada.zanr,
          vloga.tip
HAVING zanr.naziv = 'Comedy' AND 
       vloga.tip = 'I'
 ORDER BY st_komedij DESC;


-- V katerih filmih je igral Harrison Ford?
SELECT film.naslov, film.leto, film.opis
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 WHERE oseba.ime = 'Harrison Ford' AND 
       vloga.tip = 'I';

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
 WHERE vloga.tip = 'I'
 GROUP BY oseba.ime
HAVING st_filmov >= 5
 ORDER BY povprecna_ocena DESC;

-- Kako bi pogledali, kdo vse je igral v filmu, ki ga je sam režiral?
-- Lahko bi rekli, da so to tisti pari imen oseb in naslovov filmov, kjer
-- imamo dve vlogi, ampak zadeva je videti sumljiva.
SELECT oseba.ime,
       film.naslov
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 GROUP BY oseba.ime,
          film.naslov
HAVING count(vloga.tip) = 2;

-- Lepše je, če naredimo stik tabele s samo sabo, da dobimo vse kombinacije
-- vlog z isto osebo in filmom.
SELECT oseba.ime,
       film.naslov
  FROM film
       JOIN
       vloga AS prva_vloga ON film.id = prva_vloga.film
       JOIN
       vloga AS druga_vloga ON prva_vloga.film = druga_vloga.film AND 
                               prva_vloga.oseba = druga_vloga.oseba
       JOIN
       oseba ON oseba.id = prva_vloga.oseba
 WHERE prva_vloga.tip = 'I' AND 
       druga_vloga.tip = 'R';

-- Ker dobimo različno število rezultatov, uporabimo podpoizvedbo,
-- da odkrijemo, kje so razlike.
WITH poizvedba_s_having AS (
    SELECT oseba.ime,
           film.naslov
      FROM film
           JOIN
           vloga ON film.id = vloga.film
           JOIN
           oseba ON vloga.oseba = oseba.id
     GROUP BY oseba.ime,
              film.naslov
    HAVING count(vloga.tip) = 2
),
poizvedba_z_join AS (
    SELECT oseba.ime,
           film.naslov
      FROM film
           JOIN
           vloga AS prva_vloga ON film.id = prva_vloga.film
           JOIN
           vloga AS druga_vloga ON prva_vloga.film = druga_vloga.film AND 
                                   prva_vloga.oseba = druga_vloga.oseba
           JOIN
           oseba ON oseba.id = prva_vloga.oseba
     WHERE prva_vloga.tip = 'I' AND 
           druga_vloga.tip = 'R'
)
SELECT *
  FROM poizvedba_s_having
 WHERE (poizvedba_s_having.ime, poizvedba_s_having.naslov) NOT IN poizvedba_z_join;
;

-- Vidimo, da je Jonah Hill igral v dveh filmih z naslovom Superzur,
-- zato se je pojavil v prvi poizvedbi, čeprav se ne bi smel.
SELECT *
  FROM film
       JOIN
       vloga ON film.id = vloga.film
       JOIN
       oseba ON vloga.oseba = oseba.id
 WHERE film.naslov = 'Superzur' AND 
       oseba.ime = 'Jonah Hill';

-- Zanima nas, kateri režiserji in igralci dostikrat ustvarjajo skupaj.
SELECT podatki_reziserjev.ime AS reziser,
       podatki_igralcev.ime AS igralec,
       count( * ) AS st_filmov
  FROM vloga AS reziserji
       JOIN
       vloga AS igralci ON reziserji.film = igralci.film
       JOIN
       oseba AS podatki_reziserjev ON podatki_reziserjev.id = reziserji.oseba
       JOIN
       oseba AS podatki_igralcev ON podatki_igralcev.id = igralci.oseba
 WHERE reziserji.tip = 'R' AND 
       igralci.tip = 'I' AND 
       reziserji.oseba != igralci.oseba
 GROUP BY podatki_reziserjev.ime,
          reziserji.oseba,
          podatki_igralcev.ime,
          igralci.oseba
HAVING st_filmov > 5
 ORDER BY st_filmov DESC;

-- Zanima nas, kateri pari igralcev dostikrat ustvarjajo skupaj.
SELECT prva_oseba.ime AS prvi,
       druga_oseba.ime AS drugi,
       count( * ) AS st_filmov
  FROM vloga AS prva_vloga
       JOIN
       vloga AS druga_vloga ON prva_vloga.film = druga_vloga.film
       JOIN
       oseba AS prva_oseba ON prva_oseba.id = prva_vloga.oseba
       JOIN
       oseba AS druga_oseba ON druga_oseba.id = druga_vloga.oseba
 WHERE prva_vloga.tip = 'I' AND 
       druga_vloga.tip = 'I' AND 
       prva_oseba.ime < druga_oseba.ime
 GROUP BY prva_oseba.ime,
          prva_oseba.id,
          druga_oseba.ime,
          druga_oseba.id
HAVING st_filmov > 5
 ORDER BY st_filmov DESC;
