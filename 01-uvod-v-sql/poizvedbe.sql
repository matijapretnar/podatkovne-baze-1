-- Iz tabele film poberemo podatke o naslovih, letih in dolžinah

SELECT naslov,
       leto,
       dolzina
  FROM film;

-- S podatki lahko tudi računamo
SELECT naslov,
       leto,
       60 * dolzina
  FROM film;

-- Če želimo, lahko podatke tudi poimenujemo
SELECT naslov,
       leto,
       60 * dolzina AS dolzina_v_sekundah
  FROM film;

-- Iskane podatke lahko omejimo z WHERE.
-- Filmi iz leta 2015
SELECT naslov,
       leto,
       dolzina
  FROM film
 WHERE leto = 2015;

-- Filmi z oceno vsaj 9
SELECT naslov,
       leto,
       dolzina,
       ocena
  FROM film
 WHERE ocena >= 9;

-- Če ne želimo le naslova in leta, temveč vse podatke, lahko napišemo to
SELECT id,
       naslov,
       leto,
       dolzina,
       ocena,
       glasovi,
       zasluzek,
       opis,
       metascore,
       oznaka
  FROM film
 WHERE ocena >= 9;

-- Ampak to je nerodno, zato raje pišemo kar
SELECT *
  FROM film
 WHERE ocena >= 9;

-- Dodamo lahko tudi več pogojev
-- Filmi z oceno vsaj 9 in več kot 50000 glasovi
SELECT *
  FROM film
 WHERE ocena >= 9 AND 
       glasovi > 50000;


-- Filmi, ki zagotavljajo slabo izkušnjo: dolgi več kot 150 minut in oceno manj kot 6
SELECT *
  FROM film
 WHERE ocena < 6 AND 
       dolzina > 150 AND 
       glasovi > 50000;

-- Pogoje lahko tudi poljubno gnezdimo
SELECT *
  FROM film
 WHERE (ocena < 5 OR 
        ocena > 9) AND 
       (dolzina < 60 OR 
        leto > 2015);

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
 WHERE oznaka = 'Not Rated' OR 
       oznaka = 'R' OR 
       oznaka = 'Unrated';

-- Še bolj elegantno pa je, če uporabimo IN
SELECT *
  FROM film
 WHERE oznaka IN ('Not Rated', 'R', 'Unrated');

-- Pogoj lahko tudi negiramo
SELECT *
  FROM film
 WHERE NOT (oznaka IN ('Not Rated', 'R', 'Unrated') );

-- Za negacijo IN je lepše pisati NOT IN
SELECT *
  FROM film
 WHERE oznaka NOT IN ('Not Rated', 'R', 'Unrated');

-- Vidimo, da zgornji dve poizvedbi skupaj ne vrneta vseh filmov. Filmi, ki oznake
-- nimajo nastavljene, niso ne med prvimi ne med drugimi rezultati. Poiščemo jih z

SELECT *
  FROM film
 WHERE oznaka IS NULL;

-- Če iščemo vse, kjer vrednost je, pa pišemo

SELECT *
  FROM film
 WHERE oznaka IS NOT NULL;

-- Včasih prav pride tudi BETWEEN
SELECT *
  FROM film
 WHERE dolzina BETWEEN 72 AND 87;


-- Zgornji BETWEEN pomeni isto kot spodnja poizvedba
SELECT *
  FROM film
 WHERE 72 <= dolzina AND 
       dolzina <= 87;

-- Zelo kratke ali zelo dolge filme bi lahko dobili tudi z
SELECT *
  FROM film
 WHERE NOT (dolzina BETWEEN 72 AND 87);

-- Lahko bi uporabili tudi malo elegantnejši zapis
SELECT *
  FROM film
 WHERE dolzina NOT BETWEEN 72 AND 87;

-- V pogojih lahko tudi računamo
SELECT *
  FROM film
 WHERE ocena / dolzina > 0.15;

-- Običajno izračunane vrednosti želimo tudi videti, zato stolpec poimenujemo
SELECT ocena / dolzina AS gostota,
       *
  FROM film
 WHERE gostota > 0.15;


-- Tabelo lahko tudi uredimo po posameznem stolpcu
SELECT *
  FROM film
 ORDER BY ocena;

-- Z DESC urejamo padajoče
SELECT *
  FROM film
 ORDER BY ocena DESC;

-- Če želimo, lahko urejamo po več stolpcih: najprej po oceni padajoče,
-- znotraj vsake ocene pa še naraščajoče po dolžini
SELECT *
  FROM film
 WHERE glasovi > 50000
 ORDER BY ocena DESC,
          dolzina ASC;

-- Z LIMIT omejimo število najdenih zadetkov
SELECT *
  FROM film
 WHERE glasovi > 50000
 ORDER BY ocena DESC,
          dolzina ASC
 LIMIT 20;

-- Če dodamo še OFFSET, zamaknemo začetek najdenih zadetkov
-- Spodnja poizvedba vrne najboljših 20 filmov od 40. naprej
SELECT *
  FROM film
 WHERE glasovi > 50000
 ORDER BY ocena DESC,
          dolzina ASC
 LIMIT 20 OFFSET 40;

-- Najslabših 20 filmov o vesoljcih
SELECT *
  FROM film
 WHERE opis LIKE '%alien%' AND 
       glasovi > 50000
 ORDER BY ocena ASC
 LIMIT 20;

-- Poglejmo kakšne ocene so dobili Filmi, da te kap!
SELECT naslov,
       ocena
  FROM film
 WHERE naslov LIKE 'Scary Movie%' OR 
       naslov = 'Film da te kap';

-- Če bi želeli videti vse filme z isto oceno, bi lahko rezultate prekopirali v poizvedbo in napisali
SELECT *
  FROM film
 WHERE ocena IN (6.2, 5.3, 5.5, 5, 3.5);

-- Ampak to ni pametno. Bolje je uporabiti gnezdeno poizvedbo.
-- Namesto rezultatov SELECT poizvedbe napišemo kar poizvedbo samo.
SELECT *
  FROM film
 WHERE ocena IN (
           SELECT ocena
             FROM film
            WHERE naslov LIKE 'Scary Movie%' OR 
                  naslov = 'Film da te kap'
       );

-- Z WITH ime AS podpoizvedba ... lahko podpoizvedbe poimenujemo

WITH ocene_strasnih_filmov AS (
    SELECT ocena
      FROM film
     WHERE naslov LIKE 'Scary Movie%' OR 
           naslov = 'Film da te kap'
)
SELECT *
  FROM film
 WHERE ocena IN ocene_strasnih_filmov;

-- Vsi dobri filmi (ocena >= 8), ki so izšli istega leta kot kakšen
-- film o Indiani Jonesu

WITH leta_indiane_jonesa AS (
    SELECT leto
      FROM film
     WHERE naslov LIKE 'indiana jones%' OR 
           naslov = 'Lov za izgubljenim zakladom'
)
SELECT *
  FROM film
 WHERE leto IN leta_indiane_jonesa AND 
       ocena >= 8;

-- Podpoizvedb je lahko tudi več

WITH gospodarji_prstanov AS (
    SELECT *
      FROM film
     WHERE naslov LIKE 'Gospodar prstanov%'
),
leta_gospodarjev AS (
    SELECT leto
      FROM gospodarji_prstanov
),
ocene_gospodarjev AS (
    SELECT ocena
      FROM gospodarji_prstanov
)
SELECT *
  FROM film
 WHERE leto IN leta_gospodarjev AND 
       ocena IN ocene_gospodarjev;
