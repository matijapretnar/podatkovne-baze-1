-- Po novem imamo tabelo vlog, v kateri piše,
-- katere osebe so sodelovale pri katerih filmih.
-- Poglejmo, kateri filmi so imeli največ režiserjev.
       COUNT( * ) AS st_reziserjev
  FROM vloge
 WHERE vloga = 'reziser'
 GROUP BY film
HAVING st_reziserjev > 1
 ORDER BY st_reziserjev DESC;

-- Radi bi izračunali povprečno oceno filmov posameznega žanra.
-- Podatki so shranjeni v dveh tabelah, zato jih moramo združiti.
-- Najbolj surov način je, da za FROM naštejemo več tabel, s čimer
-- nam poizvedba vrne vse možne kombinacije (ki jih je ZELOOO veliko).
SELECT id,
       naslov,
       zanr
  FROM filmi,
       zanri;

-- Seveda bi radi le kombinacije, kjer se vrstica filma
-- ujema z vrstico dodelitve žanra.
SELECT id,
       naslov,
       zanr
  FROM filmi,
       zanri
 WHERE id = film;

-- Če delamo z več tabelami, je bolje,
-- da vse stolpce označimo z imenom tabele.
SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi,
       zanri
 WHERE filmi.id = zanri.film;

-- Postopek, v katerem uparimo vrstice dveh tabel,
-- ki se ujemajo v določenem stolpcu, je izjemno pogost.
-- Pravimo mu stikanje, v SQL stavku pa ga zapišemo kot:
SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film;

-- Sedaj lahko izračunamo želeno povprečje:
SELECT zanri.zanr,
       AVG(filmi.ocena) as povprecna_ocena
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film
 GROUP BY zanri.zanr
 ORDER BY povprecna_ocena DESC;

-- Poglejmo, katere osebe so režirale največ filmov.
SELECT osebe.ime,
       count( * ) AS st_filmov
  FROM vloge
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE vloge.vloga = 'reziser'
 GROUP BY osebe.id,
          osebe.ime
 ORDER BY st_filmov DESC;

-- Zakaj smo v GROUP BY dali tako id kot ime?
-- Poglejmo enostavnejši primer.

-- Kako bi izračunali povprečno oceno in število filmov v vsakem letu?
SELECT leto,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY leto;

-- Kako bi izračunali povprečno oceno in število filmov za vsako ID številko?
-- To ni zelo zanimivo, ker je v vsaki skupini natanko
-- en film, ampak recimo, da nas zanima, kaj je naslov
-- tega filma.
SELECT id,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id;

-- Če samo dodamo stolpec z naslovom, imamo neveljavno poizvedbo,
-- ki v nekaterih bazah dela načeloma pravilno, v drugih naključno,
-- v tretjih pa je zavrnjena. To torej ne bo dobra rešitev.
-- Pri združevanjih se lahko pojavljajo le kombinacije združevalnih
-- funkcij in vrednosti, po katerih združujemo.
SELECT id,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id;

-- Če združujemo po naslovu, dobimo druge podatke,
-- ker je več filmov z istim naslovom.
SELECT naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY naslov;

-- Rešitev: združevanje po več stolpcov. Na primer,
-- tu je število vseh filmov v danem letu z dano oceno.
-- Opazimo da dodatni stolpci skupine kvečjemu razdrobijo.
SELECT leto,
       ocena,
       count( * ) 
  FROM filmi
 GROUP BY leto,
          ocena;

-- Medklic: ali imamo v kakšnem letu več filmov z istim naslovom?
SELECT leto,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY leto,
          naslov
HAVING count( * ) > 1;

-- Če združimo vse filme z isto ID številko in naslovom,
-- ne dobimo nobene dodatne skupine, saj ID enolično določa
-- film in njegov naslov, hkrati pa naslov postane vrednost
-- po kateri združujemo, zato jo lahko uporabimo v stolpcu.
SELECT id,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id,
          naslov;

-- Zanimajo nas naslovi filmov, v katerih je igral Nicolas Cage.
-- Podatki so shranjeni v treh tabelah: naslovi v tabeli filmi,
-- imena oseb v tabeli osebe, povezava med filmi in osebami pa v
-- tabeli vloge. Torej moramo stakniti te tri tabele.

-- Lahko najprej združimo filme in vloge:
SELECT *
  FROM (
           filmi
           JOIN
           vloge ON filmi.id = vloge.film
       )
       JOIN
       osebe ON vloge.oseba = osebe.id;

-- Lahko najprej združimo vloge in osebe:
SELECT *
  FROM filmi
       JOIN
       (
           vloge
           JOIN
           osebe ON vloge.oseba = osebe.id
       )
       ON filmi.id = vloge.film;

-- Vendar je operacija asociativna, zato lahko oklepaje izpustimo:
-- (tudi komutativna je do vrstnega reda stolpcev natančno)
SELECT *
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id;

-- In tu so podatki o vseh filmih Nicolasa Cagea.
SELECT filmi.naslov,
       filmi.leto,
       filmi.ocena,
       osebe.ime,
       vloge.vloga,
       filmi.opis
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE osebe.ime = 'Nicolas Cage'
 ORDER BY ocena DESC;

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

-- Kdo je igral v največ komedijah?
SELECT osebe.ime,
       count(vloge.film) AS st_komedij
  FROM zanri
       JOIN
       vloge ON zanri.film = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE zanri.zanr = 'Comedy' AND 
       vloge.vloga = 'igralec'
 GROUP BY osebe.id, osebe.ime
 ORDER BY st_komedij DESC;

-- Namesto WHERE in GROUP BY lahko najprej naredimo tudi GROUP BY in potem HAVING.
SELECT osebe.ime,
       count(vloge.film) AS st_komedij
  FROM zanri
       JOIN
       vloge ON zanri.film = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 GROUP BY osebe.id,
          osebe.ime,
          zanri.zanr,
          vloge.vloga
HAVING zanri.zanr = 'Comedy' AND 
       vloge.vloga = 'igralec'
 ORDER BY st_komedij DESC;

-- Lahko bi naredili tudi podpoizvedbo, v kateri bi
-- prešteli, katere osebe so igral v komedijah, nato
-- pa na rezultate dodali še imena. V tem primeru moramo
-- podpoizvedbo poimenovati. Zadeva ni preveč elegantna,
-- ampak zdaj vemo, da obstaja.
SELECT osebe.ime,
       st_komedij
  FROM (
           SELECT vloge.oseba,
                  count(vloge.film) AS st_komedij
             FROM zanri
                  JOIN
                  vloge ON zanri.film = vloge.film
            WHERE zanri.zanr = 'Comedy' AND 
                  vloge.vloga = 'igralec'
            GROUP BY vloge.oseba
       )
       AS posteto
       JOIN
       osebe ON posteto.oseba = osebe.id
 ORDER BY st_komedij DESC;

-- V katerih filmih je igral Harrison Ford?
SELECT naslov
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE osebe.ime = 'Harrison Ford' AND 
       vloge.vloga = 'igralec';

-- Katere osebe igrajo v filmih z najboljšo oceno?
-- Zaradi relevantnosti se omejimo le na tiste, ki so
-- igrali v vsaj petih filmih.
SELECT osebe.ime,
       count( * ) AS st_filmov,
       avg(filmi.ocena) AS povprecna_ocena
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE vloge.vloga = 'igralec'
 GROUP BY osebe.ime
HAVING st_filmov >= 5
 ORDER BY povprecna_ocena DESC;

-- Naredimo krajšo statistiko žanrov
SELECT zanri.zanr,
       count( * ) AS st_filmov,
       avg(filmi.ocena) AS povprecna_ocena,
       avg(filmi.dolzina) AS povprecna_dolzina
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film
 GROUP BY zanri.zanr
 ORDER BY zanri.zanr;

-- Kako bi pogledali, kdo vse je igral v filmu, ki ga je sam režiral?
-- Lahko bi rekli, da so to tisti pari imen oseb in naslovov filmov, kjer
-- imamo dve vlogi, ampak zadeva je videti sumljiva.
SELECT osebe.ime,
       filmi.naslov
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 GROUP BY osebe.ime,
          filmi.naslov
HAVING count(vloge.vloga) = 2;

-- Lepše je, če naredimo stik tabele s samo sabo, da dobimo vse kombinacije
-- vlog z isto osebo in filmom.
SELECT osebe.ime,
       filmi.naslov
  FROM filmi
       JOIN
       vloge AS prve_vloge ON filmi.id = prve_vloge.film
       JOIN
       vloge AS druge_vloge ON prve_vloge.film = druge_vloge.film AND 
                               prve_vloge.oseba = druge_vloge.oseba
       JOIN
       osebe ON osebe.id = prve_vloge.oseba
 WHERE prve_vloge.vloga = 'igralec' AND 
       druge_vloge.vloga = 'reziser';

-- Ker dobimo različno število rezultatov, uporabimo podpoizvedbo,
-- da odkrijemo, kje so razlike.
SELECT osebe.ime,
       filmi.naslov
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE (osebe.ime, filmi.naslov) NOT IN (
           SELECT osebe.ime,
                  filmi.naslov
             FROM filmi
                  JOIN
                  vloge AS prve_vloge ON filmi.id = prve_vloge.film
                  JOIN
                  vloge AS druge_vloge ON prve_vloge.film = druge_vloge.film AND 
                                          prve_vloge.oseba = druge_vloge.oseba
                  JOIN
                  osebe ON osebe.id = prve_vloge.oseba
            WHERE prve_vloge.vloga = 'igralec' AND 
                  druge_vloge.vloga = 'reziser'
       )
 GROUP BY osebe.ime,
          filmi.naslov
HAVING count(vloge.vloga) = 2;

-- Vidimo, da je Jonah Hill igral v dveh filmih z naslovom Superzur,
-- zato se je pojavil v prvi poizvedbi, čeprav se ne bi smel.
SELECT *
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE filmi.naslov = 'Superzur' AND 
       osebe.ime = 'Jonah Hill';

-- Zanima nas, kateri režiserji in igralci dostikrat ustvarjajo skupaj.
SELECT podatki_reziserjev.ime AS reziser,
       podatki_igralcev.ime AS igralec,
       count( * ) AS st_filmov
  FROM vloge AS reziserji
       JOIN
       vloge AS igralci ON reziserji.film = igralci.film
       JOIN
       osebe AS podatki_reziserjev ON podatki_reziserjev.id = reziserji.oseba
       JOIN
       osebe AS podatki_igralcev ON podatki_igralcev.id = igralci.oseba
 WHERE reziserji.vloga = 'reziser' AND 
       igralci.vloga = 'igralec' AND 
       reziserji.oseba != igralci.oseba
 GROUP BY podatki_reziserjev.ime,
          reziserji.oseba,
          podatki_igralcev.ime,
          igralci.oseba
HAVING st_filmov >= 4
 ORDER BY st_filmov DESC;

-- Zanima nas, kateri pari igralcev dostikrat ustvarjajo skupaj.
SELECT podatki_prvega.ime AS prvi,
       podatki_drugega.ime AS drugi,
       count( * ) AS st_filmov
  FROM vloge AS prvi
       JOIN
       vloge AS drugi ON prvi.film = drugi.film
       JOIN
       osebe AS podatki_prvega ON podatki_prvega.id = prvi.oseba
       JOIN
       osebe AS podatki_drugega ON podatki_drugega.id = drugi.oseba
 WHERE prvi.vloga = 'igralec' AND 
       drugi.vloga = 'igralec' AND 
       podatki_prvega.ime < podatki_drugega.ime
 GROUP BY podatki_prvega.ime,
          prvi.oseba,
          podatki_drugega.ime,
          drugi.oseba
HAVING st_filmov >= 4
 ORDER BY st_filmov DESC;
