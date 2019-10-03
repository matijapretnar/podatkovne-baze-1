-- Iz tabele filmi poberemo podatke o naslovih in režiserjih

SELECT naslov,
       dolzina
  FROM film;

-- Podatke lahko izberemo tudi v drugačnem vrstnem redu

SELECT dolzina,
       naslov
  FROM film;

-- S podatki lahko tudi računamo
SELECT naslov,
       dolzina / 60
  FROM film;

-- Če želimo natančen rezultat, moramo dolžino pretvoriti
-- iz celega števila, saj sicer dobimo celoštevilsko deljenje
SELECT naslov,
       CAST (dolzina AS FLOAT) / 60
  FROM film;

-- Če želimo, lahko podatke tudi poimenujemo
SELECT naslov,
       CAST (dolzina AS FLOAT) / 60 AS dolzina_v_urah
  FROM film;

-- Če damo ime v narekovaje ali [...], lahko vsebuje tudi presledke,
-- vendar to ni priporočeno, ker je zamudno.
SELECT naslov,
       CAST (dolzina AS FLOAT) / 60 AS [dolzina v urah]
  FROM film;

-- Iskane podatke lahko omejimo z WHERE.
-- Filmi iz leta 2015
SELECT naslov,
       leto
  FROM film
 WHERE leto = 2015;

-- Filmi iz leta 2013 ali kasnejši
SELECT naslov,
       leto
  FROM film
 WHERE leto >= 2013;

-- Če ne želimo le naslova in leta, temveč vse podatke, lahko napišemo to
SELECT id,
       naslov,
       leto,
       ocena,
       metascore,
       glasovi,
       zasluzek,
       oznaka,
       opis
  FROM film
 WHERE leto >= 2013;

-- Ampak to je nerodno, zato raje pišemo kar
SELECT *
  FROM film
 WHERE leto >= 2013;

-- Dodamo lahko tudi več pogojev
-- Filmi po letu 2013 z oceno vsaj 8
SELECT *
  FROM film
 WHERE leto >= 2013 AND 
       ocena >= 8;

-- Filmi, ki zagotavljajo slabo izkušnjo: dolgi vsaj 130 minut in oceno manj kot 6
SELECT *
  FROM film
 WHERE dolzina >= 130 AND 
       ocena < 6;

SELECT naslov
  FROM film
 WHERE oznaka = 'PG-13' AND 
       dolzina <= 90;

-- Zelo kratki ali zelo dolgi filmi
SELECT *
  FROM film
 WHERE dolzina < 70 OR 
       dolzina > 180;

-- Pogoje lahko tudi poljubno gnezdimo, vendar običajno to ni prav pogosto
SELECT *
  FROM film
 WHERE (dolzina < 70 OR 
        dolzina > 180) AND 
       (ocena <= 6 OR 
        ocena >= 9);

-- Če želimo poiskati vse Vojne zvezd, spodnja poizvedba ne bo delala,
-- saj noben film nima točno takega naslova.
SELECT *
  FROM film
 WHERE naslov = 'Vojna zvezd';

-- Pomagamo si z vzorci. LIKE 'Vojna zvezd%' pomeni vse nize, ki se začnejo s
-- 'Vojna zvezd', potem pa vsebujejo še poljubno število poljubnih drugih znakov
SELECT *
  FROM film
 WHERE naslov LIKE 'Vojna zvezd%';

-- Vsi filmi, ki govorijo o slonih
SELECT *
  FROM film
 WHERE opis LIKE '%elephant%';

-- Z _ v vzorcu označimo poljuben znak
-- Vsi filmi, katerih naslovi se začnejo s tročrkovno besedo,
-- pri čemer je srednja črka o
SELECT *
  FROM film
 WHERE naslov LIKE '_o_ %';

-- Vsi drugi deli filmov
SELECT *
  FROM film
 WHERE naslov LIKE '% 2';

-- Če nas zanimajo vse oznake, bi lahko napisali
SELECT oznaka
  FROM film;

-- Vendar dostikrat želimo vsako vrednost videti le enkrat. Tedaj uporabimo DISTINCT
SELECT DISTINCT oznaka
  FROM film;

-- Če želimo filme z eno od naštetih oznak, lahko pišemo
SELECT *
  FROM film
 WHERE oznaka = 'R' OR 
       oznaka = 'X' OR 
       oznaka = 'TV-MA' OR 
       oznaka = 'M';

-- Še bolj elegantno pa je, če uporabimo IN
SELECT *
  FROM film
 WHERE oznaka IN ('R', 'X', 'TV-MA', 'M');

-- Včasih prav pride tudi BETWEEN
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120;

-- Zgornji BETWEEN pomeni isto kot spodnja poizvedba
SELECT *
  FROM film
 WHERE 90 <= dolzina AND 
       dolzina <= 120;

-- Zelo kratke ali zelo dolge filme bi lahko dobili tudi z
SELECT *
  FROM film
 WHERE NOT (dolzina BETWEEN 70 AND 180);

-- Lahko bi uporabili tudi malo elegantnejši zapis
SELECT *
  FROM film
 WHERE dolzina NOT BETWEEN 70 AND 180;

-- Tabelo lahko tudi uredimo po posameznem stolpcu
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena;

-- Z DESC urejamo padajoče
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC;

-- Če želimo, lahko urejamo po več stolpcih: najprej po oceni padajoče,
-- znotraj vsake ocene pa še naraščajoče po letu
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC;

-- Uredimo dobre filme najprej po letu, filme vsakega leta pa še po naslovu
SELECT *
  FROM film
 WHERE ocena > 8
 ORDER BY leto, naslov;
 
-- Z LIMIT omejimo število najdenih zadetkov
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 20;

-- Če dodamo še OFFSET, zamaknemo začetek najdenih zadetkov
-- Spodnja poizvedba vrne najboljših 70 filmov od 30. naprej
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 70 OFFSET 30;

-- Na krajše lahko zgornjo poizvedbo napišemo tudi kot spodnjo,
-- vendar je lahko malo nerazumljiva (tudi predavatelj se je zmedel)
SELECT *
  FROM film
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 30, 70;

-- Najslabših 20 filmov o vesoljcih
SELECT *
  FROM film
 WHERE opis LIKE '%alien%'
 ORDER BY ocena
 LIMIT 20;

-- Poglejmo tista leta, v katerih so posneli zares dober film
SELECT DISTINCT leto
  FROM film
 WHERE ocena > 9;

--------------------------------------------------------------------------------

-- Če bi želeli videti vse njihove filme, bi lahko rezultate prekopirali v poizvedbo in napisali
SELECT * FROM film WHERE let IN ('Richard Lester', 'John G. Avildsen', 'Brian Levant', 'Ivan Reitman', 'Donald Petrie', 'Steven E. de Souza', 'Paul Verhoeven', 'Luis Llosa', 'Joel Schumacher', 'Les Mayfield', 'Raja Gosnell', 'Mark A.Z. Dippé', 'Jan de Bont', 'Stephen Hopkins', 'Barry Sonnenfeld', 'Danny Cannon', 'Roger Christian', 'Adam Shankman', 'Wayne Wang', 'Keenen Ivory Wayans', 'Mark Steven Johnson', 'McG', 'Frank Oz', 'Pitof', 'Lee Tamahori', 'Peter Hewitt', 'Rob Bowman', 'David Zucker', 'Kurt Wimmer', 'Nora Ephron', 'Jay Chandrasekhar', 'John Pasquin', 'Andrzej Bartkowiak', 'Craig Mazin', 'Roland Emmerich', 'Stefen Fangmeier', 'Neil LaBute', 'Aaron Seltzer', 'Brian Robbins', 'Colin Strause', 'Malcolm D. Lee', 'Jason Friedberg', 'Martin Weisz', 'Dennis Dugan', 'Marcus Nispel', 'Frank Miller', 'Rob Cohen', 'M. Night Shyamalan', 'Michael J. Bassett', 'Tim Hill', 'Scott Stewart', 'Harold Ramis', 'Mark Neveldine', 'James Wong', 'Catherine Hardwicke', 'Steve Carr', 'Karyn Kusama', 'David R. Ellis', 'Samuel Bayer', 'Chris Weitz', 'Michael Patrick King', 'Rob Letterman', 'Bill Condon', 'David Slade', 'Elizabeth Banks', 'Stuart Beattie', 'Tom Six', 'Josh Trank', 'John Singleton', 'Jake Kasdan', 'Bradley Parker', 'Henry Joost', 'J Blakeson', 'Sam Taylor-Johnson', 'Ali Abbas Zafar', 'Terry George');

-- Ampak to ni pametno. Bolje je uporabiti gnezdeno poizvedbo.
-- Namesto rezultatov SELECT poizvedbe napišemo kar poizvedbo samo.
SELECT *
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE ocena <= 5.2
       );

-- Poglejmo vse filme tistih režiserjev, ki so kdaj posneli zares slab film.
-- Filme uredimo po režiserju in letu, da vidimo, kaj se je skozi čas dogajalo
-- z nesrečnim režiserjem.
SELECT *
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE ocena <= 5.2
       )
  ORDER BY reziser, leto;
  

-- Da ne bo preveč informacij, obdržimo le režiserja, leto, naslov in oceno
SELECT reziser, leto, naslov, ocena
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE ocena <= 5.2
       )
  ORDER BY reziser, leto;
  
-- Na podoben način nas zanima, kaj se je dogajalo z režiserji,
-- ki so kdaj posneli družinski film. So potem kdaj snemali grozljivke?

-- Spodnja poizvedba vrne SAMO DRUŽINSKE FILME. To ni tisto, kar nas zanima.
SELECT reziser, leto, naslov, oznaka
  FROM film
 WHERE oznaka = 'G'
  ORDER BY reziser, leto;

-- Spodnja poizvedba pa je pravilna in vrne VSE FILME režiserjev,
-- ki so KDAJ POSNELI DRUŽINSKI FILM.
SELECT reziser, leto, naslov, oznaka
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE oznaka = 'G'
       )
  ORDER BY reziser, leto;

-- Spodnja poizvedba vrne vse filme režiserjev, ki so posneli
-- tako družinski kot družinam neprijazen film.

SELECT *
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE oznaka = 'G'
       )
AND 
       reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE oznaka = 'R'
       )
 ORDER BY reziser,
          leto;

-- Ta poizvedba ne vrne nič rezultatov, saj bi iskala režiserje
-- tistih filmov, ki imajo hkrati oznako G in R. Takih seveda
-- ni, saj ima vsak film natanko eno oznako.

SELECT *
  FROM film
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM film
            WHERE oznaka = 'G'
              AND oznaka = 'R'
       )
 ORDER BY reziser,
          leto;

-- Poizvedbe počasi postajajo bolj zapletene. Kako se znajdemo?
-- Začnemo jih pisati po kosih.

-- Recimo, da bi radi videli, ali so bili filmi v kakšnih letih bolj kakovstni
-- kot v drugih. Radi bi pogledali vse zelo dobre in zelo slabe filme v tistih
-- letih, v katerih je bil posnet kakšen zelo dober film (z oceno več kot 8.5).

-- Poglejmo vse filme z oceno več kot 8.5
SELECT * FROM film WHERE ocena > 8.5;

-- Zanimajo nas leta takih filmov
SELECT leto FROM film WHERE ocena > 8.5;

-- Zanimajo nas le različna leta
SELECT DISTINCT leto FROM film WHERE ocena > 8.5;

-- Recimo, da dobimo tabelo let 1962, 1931, 1936, …
-- Če bi želeli videti vse filme, posnete v teh letih, bi lahko napisali
-- SELECT * FROM film WHERE leto in (1962, 1931, 1936, ...);
-- Ampak bolje je, če uporabimo gnezdeno poizvedbo:
SELECT * FROM film WHERE
  leto IN (SELECT DISTINCT leto FROM film WHERE ocena > 8.5);


-- Sedaj hočemo od teh filmov videti le zelo dobre in zelo slabe
SELECT * FROM film WHERE
  leto IN (SELECT DISTINCT leto FROM film WHERE ocena > 8.5)
AND
  ocena NOT BETWEEN 5.5 AND 8.5;

-- Vse skupaj uredimo še po letu
SELECT * FROM film WHERE
  leto IN (SELECT DISTINCT leto FROM film WHERE ocena > 8.5)
AND
  ocena NOT BETWEEN 5.5 AND 8.5;
ORDER BY leto;

-- najvišja ocena kateregakoli filma
SELECT MAX(ocena) 
  FROM film;

-- najkrajša dolžina kateregakoli filma
SELECT MIN(dolzina) 
  FROM film;

-- najkrajša, povprečna in največja dolžina kateregakoli filma
SELECT MIN(dolzina),
       AVG(dolzina),
       MAX(dolzina) 
  FROM film;

-- največja dolžina filma o slonih
SELECT max(dolzina) 
  FROM film
 WHERE opis LIKE '%elephant%';

-- povprečna dolžina filmov o slonih
SELECT avg(ocena) 
  FROM film
 WHERE opis LIKE '%elephant';

-- vsi filmi o krokodilih
SELECT *
  FROM film
 WHERE reziser = 'Charles Chaplin';

-- skupna dolžina vseh filmov, ki jih je režiral Charlie Chaplin
SELECT sum(dolzina) 
  FROM film
 WHERE reziser = 'Charles Chaplin';

-- število filmov, ki jih je režiral Charlie Chaplin, pri katerih imamo podatke
-- o dolžini/oceni/certifikatu/režiserju
-- Običajno so vse številke enake, razen če kje kakšen podatek manjka
SELECT count(dolzina),
       count(ocena),
       count(oznaka),
       count(reziser) 
  FROM film
 WHERE reziser = 'Charles Chaplin';

-- Če želimo prešteti ujemajočevrstice, uporabimo count( * )
SELECT count( * ) 
  FROM film
 WHERE reziser = 'Charles Chaplin';

-- Dolžina najkrajšega Spielbergovega filma je 107 minut. Toda kateri film je to?
SELECT MIN(dolzina) 
  FROM film
 WHERE reziser = 'Steven Spielberg';

-- Včasih dela tudi spodnja poizvedba, vendar se raje NE ZANAŠAJTE NA TO
SELECT naslov, MIN(dolzina) 
  FROM film
 WHERE reziser = 'Steven Spielberg';

-- Število vseh naslovov (isto kot število vseh filmov)
SELECT COUNT(naslov) FROM film;

-- Število različnih naslovov
SELECT COUNT(DISTINCT naslov) FROM film;

-- Lahko pogledamo, da je najkrajši Spielbergov film dolg 107 minut in nato
-- napišemo ustrezno poizvedbo
SELECT *
  FROM film
 WHERE dolzina = 107 AND 
       reziser = 'Steven Spielberg';

-- Še bolje pa je uporabiti gnezdeni SELECT.
-- Ta nam vrne vse filme Stevena Spielberga, pri katerih je
-- dosežena minimalna dolžina.
SELECT *
  FROM film
 WHERE dolzina = (
                     SELECT MIN(dolzina) 
                       FROM film
                      WHERE reziser = 'Steven Spielberg'
                 )
AND 
       reziser = 'Steven Spielberg';

-- Ta pa nam vrne vse filme, ki so tako dolgi kot najkrajši
-- film Stevena Spielberga.
SELECT *
  FROM film
 WHERE dolzina = (
                     SELECT min(dolzina) 
                       FROM film
                      WHERE reziser = 'Steven Spielberg'
                 );

-- Če nas zanima samo en ekstrem, je bolj enostavno, da
-- uporabimo ORDER BY in LIMIT 1.
SELECT *
  FROM film
 WHERE reziser = 'Steven Spielberg'
 ORDER BY dolzina
 LIMIT 1;

-- Povprečna ocena vseh filmov
SELECT avg(ocena) 
  FROM film;

-- Podatki vseh filmov hkrati z absolutno razliko do povprečne vrednosti ocene
SELECT *,
       ABS(ocena - 6.94) 
  FROM film;

-- Podatki vseh filmov hkrati s tem, ali se ocena od povprečja razlikuje za manj kot 0.1
SELECT *
  FROM film
 WHERE ABS(ocena - 6.94) < 0.1;

-- Vsi povprečni filmi, torej tisti, ki se od povprečja razlikujejo za manj kot 0.1
SELECT *
  FROM film
 WHERE ocena BETWEEN 6.94 - 0.1 AND 6.94 + 0.1;

-- Boljša rešitev: gnezdeni SELECT
SELECT *
  FROM film
 WHERE ABS(ocena - (
                       SELECT avg(ocena) 
                         FROM film
                   )
       ) < 0.1;

-- Vsi filmi, ki so bili slabši od najslabšega Shyamalanovega filma
SELECT *
  FROM film
 WHERE ocena < (
                   SELECT min(ocena) 
                     FROM film
                    WHERE reziser LIKE '%Shyamalan'
               );

