-- Vrnite tabelo imen in priimkov vseh oseb, ki jim je ime Matija
SELECT ime,
       priimek
  FROM osebe
 WHERE ime = 'Matija';

-- Vrnite tabelo imen in priimkov vseh oseb, urejeno po priimku
SELECT ime,
       priimek
  FROM osebe
 ORDER BY priimek;

-- Vrnite imena vseh predmetov na praktični matematiki (smer: 1PrMa)
SELECT ime
  FROM predmeti
 WHERE smer = '1PrMa';

-- Vrnite vse podatke o tistih skupinah z manj kot eno uro
SELECT *
  FROM skupine
 WHERE ure < 1;

-- Vrnite število vseh predmetov na posamezni smeri
SELECT smer,
       count( * ) 
  FROM predmeti
 GROUP BY smer;

-- Vrnite imena tistih predmetov, ki se pojavljajo na več smereh
SELECT ime
  FROM predmeti
 GROUP BY ime
HAVING count( * ) > 1;

-- Vrnite imena in vse pripadajoče smeri tistih predmetov, ki se pojavljajo na več smereh
SELECT ime, smer
  FROM predmeti
 WHERE id IN (
           SELECT id
             FROM predmeti
            GROUP BY ime
           HAVING count( * ) > 1
       );

-- Vrnite skupno število ur vseh oseb
SELECT ime,
       priimek,
       sum(ure) AS obremenitev
  FROM osebe
       INNER JOIN
       skupine ON osebe.id = skupine.učitelj
 GROUP BY osebe.id;

-- Vrnite imena in priimke vseh predavateljev,
-- torej tistih, ki imajo kakšno skupino tipa P
SELECT DISTINCT ime,
                priimek
  FROM osebe
       INNER JOIN
       skupine ON osebe.id = skupine.učitelj
 WHERE skupine.tip = 'P';

-- Vrnite imena in smeri vseh predmetov, ki imajo kakšen seminar
SELECT predmeti.ime,
       predmeti.smer
  FROM predmeti
       INNER JOIN
       dodelitve ON predmeti.id = dodelitve.predmet
       INNER JOIN
       skupine ON dodelitve.skupina = skupine.id
 WHERE skupine.tip = 'S';
