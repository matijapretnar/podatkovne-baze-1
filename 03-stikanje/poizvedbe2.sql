SELECT *
  FROM film
 WHERE naslov LIKE '%vojna zvezd%';

SELECT *
  FROM vloga
 WHERE vloga.oseba = 229;

SELECT *
  FROM film
 WHERE id = 86491;

SELECT *
  FROM pripada,
       zanr;

SELECT *
  FROM pripada,
       zanr
 WHERE zanr.id = pripada.zanr;

SELECT pripada.film,
       zanr.naziv
  FROM pripada,
       zanr
 WHERE zanr.id = pripada.zanr;

SELECT pripada.film,
       zanr.naziv
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr;

SELECT film.naslov,
       zanr.naziv
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
       JOIN
       film ON film.id = pripada.film;

SELECT film.naslov,
       zanr.naziv
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
       JOIN
       film ON film.id = pripada.film
 WHERE film.naslov LIKE 'Žrelo%';

SELECT zanr.naziv,
       count( * ) 
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
 GROUP BY zanr.id;

SELECT zanr.naziv,
       count( * ) 
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
 GROUP BY zanr.naziv;

SELECT zanr.naziv,
       count( * ) 
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
 GROUP BY zanr.id,
          zanr.naziv;

SELECT oseba.ime,
       count( * ) 
  FROM film
       JOIN
       oseba ON oseba.id = film.reziser
 GROUP BY oseba.id,
          oseba.ime;

SELECT leto,
       naslov,
       count( * ) 
  FROM film
 GROUP BY leto,
          naslov
HAVING count( * ) > 1;

SELECT id,
       naslov,
       count( * ) 
  FROM film
 GROUP BY id,
          naslov;

SELECT zanr.naziv,
       count( * ) 
  FROM pripada
       JOIN
       zanr ON zanr.id = pripada.zanr
 GROUP BY zanr.id, zanr.naziv;
