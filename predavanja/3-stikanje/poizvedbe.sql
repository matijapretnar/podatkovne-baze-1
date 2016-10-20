-- spomnimo se od zadnjič:
-- poglejmo povprečno oceno filmov tistih režiserjev, ki so posneli več kot 3 filme
SELECT reziser,
       AVG(ocena) AS povprecna_ocena,
       COUNT( * ) AS stevilo_filmov
  FROM filmi
 GROUP BY reziser
HAVING stevilo_filmov > 3
 ORDER BY povprecna_ocena DESC;

-- Toda v novi tabeli nimamo imen, le ID režiserjev. Imena so shranjena v tabeli
-- osebe. Če jih želimo, moramo tabeli stakniti po ujemajočem stolpcu.
SELECT *
  FROM filmi
       JOIN
       osebe ON filmi.reziser = osebe.id;

-- Zanima nas le naslov filma in ime režiserja
SELECT filmi.naslov,
       osebe.ime,
       osebe.priimek
  FROM filmi
       JOIN
       osebe ON filmi.reziser = osebe.id;

-- Podobno lahko vsakemu filmu pritaknemo žanre
SELECT filmi.naslov,
       zanri.zanr
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film;

-- Paziti moramo, kako stikamo. Tu nam stakne filme in osebe, ki po naključju
-- delijo isti ID
SELECT *
  FROM filmi
       JOIN
       osebe ON filmi.id = osebe.id;

-- Lahko pritaknemo tudi osebe, katerih ID je enak letu filma. Tudi to ni preveč
-- smiselno.
SELECT filmi.naslov,
       filmi.ocena,
       osebe.ime,
       osebe.priimek
  FROM filmi
       JOIN
       osebe ON filmi.leto = osebe.id
 ORDER BY ocena DESC;

-- Stikamo lahko tudi več tabel.
SELECT *
  FROM (
           filmi
           JOIN
           vloge ON filmi.id = vloge.film
       )
       JOIN
       osebe ON vloge.oseba = osebe.id;

-- Zanimajo nas naslovi filmov ter imena igralcev v njih.
-- Ker je stikanje asociativno, ga pišemo kar kot:
SELECT filmi.naslov,
       osebe.ime,
       osebe.priimek
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id;

-- V katerih žanrih so igrali kateri igralci?
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film;

-- V koliko filmih posameznega žanra je igral kakšen igralec?
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) 
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY osebe.ime,
          osebe.priimek,
          zanri.zanr;

-- Če združimo le po žanrih, spet dobimo neko nepredvidljivo ime in priimek.
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) 
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY zanri.zanr;

-- Načeloma sta ime in priimek osebe določena z IDjem, tako da spodnja poizvedba
-- dela, a se je vseeno izogibajmo.
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) 
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY osebe.id,
          zanri.zanr
 ORDER BY osebe.priimek,
          osebe.ime;

-- Zanima nas, kdo je posnel največ komedij. Najprej uredimo po številu filmov.
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY osebe.ime,
          osebe.priimek,
          zanri.zanr
 ORDER BY stevilo_filmov DESC;

-- Omejimo se samo na komedije. Ker so naši podatki malo čudni (za vsakim žanrom
-- je še nek prazen znak), ta poizvedba ne dela
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY osebe.ime,
          osebe.priimek,
          zanri.zanr
HAVING zanri.zanr = 'Comedy'
 ORDER BY stevilo_filmov DESC;

-- Namesto da bi popravili bazo, si pomagamo z LIKE
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 GROUP BY osebe.ime,
          osebe.priimek,
          zanri.zanr
HAVING zanri.zanr LIKE 'Com%'
 ORDER BY stevilo_filmov DESC;

-- Namesto HAVING lahko napišemo tudi WHERE, je bolj učinkovito,
-- ker naredi izbor preden gre izračunavati skupine. Če pogledamo čas trajanja,
-- vidimo, da je poizvedba več kot dvakrat hitrejša.
SELECT osebe.ime,
       osebe.priimek,
       zanri.zanr,
       count( * ) AS stevilo_filmov
  FROM osebe
       JOIN
       vloge ON osebe.id = vloge.oseba
       JOIN
       zanri ON vloge.film = zanri.film
 WHERE zanri.zanr LIKE 'Com%'
 GROUP BY osebe.ime,
          osebe.priimek,
          zanri.zanr
 ORDER BY stevilo_filmov DESC;

-- Povprečna ocena filmov posameznega žanra
SELECT zanri.zanr,
       AVG(filmi.ocena) 
  FROM zanri
       JOIN
       filmi ON zanri.film = filmi.id
 GROUP BY zanri.zanr;

-- Filmi noir so dobro ocenjeni. Kdaj je bil posnet zadnji?
SELECT max(filmi.leto) 
  FROM zanri
       JOIN
       filmi ON zanri.film = filmi.id
 WHERE zanri.zanr LIKE 'Film-Noir%';

-- Poglejmo, kateri režiserji so igrali v svojih filmih
SELECT *
  FROM vloge
       JOIN
       filmi ON vloge.film = filmi.id
 WHERE vloge.oseba = filmi.reziser;
