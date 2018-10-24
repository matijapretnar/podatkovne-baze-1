SELECT id,
       naslov,
       zanr
  FROM filmi,
       zanri
 WHERE id = film;

SELECT AVG(ocena) AS povprecna_ocena,
       zanr
  FROM filmi,
       zanri
 WHERE id = film
 GROUP BY zanr
 ORDER BY povprecna_ocena DESC;

SELECT film,
       COUNT( * ) AS st_reziserjev
  FROM vloge
 WHERE vloga = 'reziser'
 GROUP BY film
HAVING st_reziserjev > 1
 ORDER BY st_reziserjev DESC;

SELECT id,
       naslov,
       zanr
  FROM filmi,
       zanri;

SELECT id,
       naslov,
       zanr
  FROM filmi,
       zanri
 WHERE id = film;

SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi,
       zanri
 WHERE filmi.id = zanri.film;

SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film;

SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi,
       zanri
 WHERE filmi.id = zanri.film AND 
       zanri.zanr != 'Comedy';

SELECT filmi.id,
       filmi.naslov,
       zanri.zanr
  FROM filmi
       JOIN
       zanri ON filmi.id = zanri.film
 WHERE zanri.zanr != 'Comedy';

SELECT osebe.ime,
       count( * ) AS st_filmov
  FROM vloge
       JOIN
       osebe ON vloge.oseba = osebe.id
 WHERE vloge.vloga = 'reziser'
 GROUP BY osebe.id,
          osebe.ime
 ORDER BY st_filmov DESC;

;

SELECT oseba,
       COUNT( * ) AS st_filmov
  FROM vloge
 WHERE vloga = 'reziser'
 GROUP BY oseba
HAVING st_reziserjev > 1
 ORDER BY st_reziserjev DESC;

SELECT leto,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY leto;

SELECT id,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id;

SELECT naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY naslov;

SELECT id,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id;

SELECT id,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id;

SELECT leto,
       count( * ) 
  FROM filmi
 GROUP BY leto;

SELECT ocena,
       count( * ) 
  FROM filmi
 GROUP BY ocena;

SELECT leto,
       ocena,
       count( * ) 
  FROM filmi
 GROUP BY leto,
          ocena;

SELECT id,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY id,
          naslov;

SELECT leto,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY leto,
          naslov;

SELECT leto,
       naslov,
       avg(ocena),
       count( * ) 
  FROM filmi
 GROUP BY leto,
          naslov
HAVING count( * ) > 1;

SELECT *
  FROM (
           filmi
           JOIN
           vloge ON filmi.id = vloge.film
       )
       JOIN
       osebe ON vloge.oseba = osebe.id;

SELECT *
  FROM filmi
       JOIN
       (
           vloge
           JOIN
           osebe ON vloge.oseba = osebe.id
       )
       ON filmi.id = vloge.film;

SELECT *
  FROM filmi
       JOIN
       vloge ON filmi.id = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id;

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

SELECT osebe.ime,
       count(vloge.film) AS st_komedij
  FROM zanri
       JOIN
       vloge ON zanri.film = vloge.film
       JOIN
       osebe ON vloge.oseba = osebe.id
 GROUP BY osebe.id,
          zanri.zanr,
          vloge.vloga
HAVING zanri.zanr = 'Comedy' AND 
       vloge.vloga = 'igralec'
 ORDER BY st_komedij DESC;

;

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
