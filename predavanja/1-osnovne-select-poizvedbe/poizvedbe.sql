SELECT naslov,
       reziser
  FROM filmi;

SELECT reziser,
       naslov
  FROM filmi;

SELECT naslov,
       dolzina / 60
  FROM filmi;/* SELECT naslov, dolzina / 60 AS dolzina v urah FROM filmi; */

SELECT naslov,
       dolzina / 60 AS dolzina_v_urah
  FROM filmi;

SELECT naslov,
       dolzina / 60 AS [dolzina v urah]
  FROM filmi;

SELECT naslov,
       dolzina / 60 AS [dolzina v urah]
  FROM filmi;

SELECT naslov,
       leto
  FROM filmi
 WHERE reziser = "Steven Spielberg";

SELECT naslov,
       leto
  FROM filmi
 WHERE leto = 2015;

SELECT naslov,
       leto
  FROM filmi
 WHERE leto = 2015;

SELECT naslov,
       leto
  FROM filmi
 WHERE leto >= 2013;

SELECT id,
       naslov,/* vmesni komentar */
       leto,
       reziser,/* se en komentar */
       certifikat,
       dolzina,
       ocena,
       opis
  FROM filmi
 WHERE leto >= 2013;

SELECT *
  FROM filmi
 WHERE leto >= 2013;/* to je komentar */

SELECT *
  FROM filmi
 WHERE leto >= 2013 AND 
       ocena >= 8;

SELECT *
  FROM filmi
 WHERE dolzina >= 130 AND 
       ocena < 6;

SELECT naslov
  FROM filmi
 WHERE certifikat = 'PG-13' AND 
       dolzina <= 90;

SELECT *
  FROM filmi
 WHERE dolzina < 70 OR 
       dolzina > 180;

SELECT *
  FROM filmi
 WHERE (dolzina < 70 OR 
        dolzina > 180) AND 
       (ocena <= 6 OR 
        ocena >= 9);

SELECT *
  FROM filmi
 WHERE reziser = "Steven";

SELECT *
  FROM filmi
 WHERE reziser LIKE "Steven%";

SELECT *
  FROM filmi
 WHERE reziser LIKE "% Smith";

SELECT *
  FROM filmi
 WHERE reziser LIKE "_o_ %";

SELECT *
  FROM filmi
 WHERE reziser LIKE "%son";

SELECT *
  FROM filmi
 WHERE reziser LIKE "%ll%";

SELECT certifikat
  FROM filmi;

SELECT DISTINCT certifikat
  FROM filmi;

SELECT *
  FROM filmi
 WHERE certifikat = 'R' OR 
       certifikat = 'X' OR 
       certifikat = 'TV-MA' OR 
       certifikat = 'M';

SELECT *
  FROM filmi
 WHERE certifikat IN ('R', 'X', 'TV-MA', 'M');

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120;

SELECT *
  FROM filmi
 WHERE 90 <= dolzina AND 
       dolzina <= 120;

SELECT *
  FROM filmi
 WHERENOT (dolzina BETWEEN 70 AND 180);

SELECT *
  FROM filmi
 WHERE dolzina NOT BETWEEN 70 AND 180;

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena;

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC;

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC;

SELECT *
  FROM filmi
 WHERE ocena > 8
 order by reziser, naslov;
 
SELECT *
  FROM filmi
 WHERE naslov LIKE "%Matrix%";


SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 20;

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 30, 70;

SELECT *
  FROM filmi
 WHERE dolzina BETWEEN 90 AND 120
 ORDER BY ocena DESC,
          leto ASC
LIMIT 70 OFFSET 30;

SELECT *
  FROM filmi
 WHERE reziser LIKE "James%"
 ORDER BY ocena
 LIMIT 20;

SELECT DISTINCT reziser
  FROM filmi
 WHERE ocena <= 5.2;

SELECT * FROM filmi WHERE reziser IN ('Richard Lester', 'John G. Avildsen', 'Brian Levant', 'Donald Petrie', 'Les Mayfield', 'Mark A.Z. Dippé', 'Stephen Hopkins', 'Jan de Bont', 'Raja Gosnell', 'Adam Shankman', 'Wayne Wang', 'Keenen Ivory Wayans', 'Mark Steven Johnson', 'Raja Gosnell', 'Frank Oz', 'Peter Hewitt', 'David Zucker', 'Jay Chandrasekhar', 'John Pasquin', 'Andrzej Bartkowiak', 'Roland Emmerich', 'Stefen Fangmeier', 'Ivan Reitman', 'Martin Weisz', 'Marcus Nispel', 'Rob Cohen', 'Michael J. Bassett', 'M. Night Shyamalan', 'Tim Hill', 'Scott Stewart', 'Harold Ramis', 'Stuart Beattie', 'Steve Carr', 'Karyn Kusama', 'David R. Ellis', 'Samuel Bayer', 'Rob Letterman', 'Bill Condon', 'David Slade', 'Bradley Parker', 'M. Night Shyamalan', 'Jake Kasdan', 'J Blakeson');

SELECT *
  FROM filmi
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM filmi
            WHERE ocena <= 5.2
       );


SELECT *
  FROM filmi
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM filmi
            WHERE ocena <= 5.2
       )
  ORDER BY reziser, leto;
  

SELECT reziser, leto, naslov, ocena
  FROM filmi
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM filmi
            WHERE ocena <= 5.2
       )
  ORDER BY reziser, leto;
  

SELECT reziser, naslov, certifikat from filmi where certifikat = 'G' order by reziser;

SELECT reziser, leto, naslov, certifikat
  FROM filmi
 WHERE reziser IN (
           SELECT DISTINCT reziser
             FROM filmi
            WHERE certifikat = 'G'
       )
  ORDER BY reziser, leto;

SELECT * from filmi where ocena > 8.5;

SELECT leto from filmi where ocena > 8.5;

SELECT distinct leto from filmi where ocena > 8.5;

--select * from filmi where leto in (1962, 1931, 1936, ...);

SELECT *
  FROM filmi
 WHERE leto IN (
           SELECT DISTINCT leto
             FROM filmi
            WHERE ocena > 8.5
       )
AND 
       ocena NOT BETWEEN 5.5 AND 8.5
 ORDER BY leto;



