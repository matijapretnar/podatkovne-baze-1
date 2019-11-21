--
-- File generated with SQLiteStudio v3.2.1 on Thu Nov 21 15:35:46 2019
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: film
CREATE TABLE film (
    id        INTEGER PRIMARY KEY,
    naslov    TEXT    NOT NULL,
    dolzina   INTEGER NOT NULL,
    leto      INTEGER NOT NULL,
    ocena     REAL    NOT NULL,
    metascore INTEGER,
    glasovi   INTEGER NOT NULL
                      CHECK (glasovi >= 0) 
                      DEFAULT (0),
    zasluzek  INTEGER,
    oznaka    TEXT    REFERENCES oznaka (kratica),
    opis      TEXT    NOT NULL
);


-- Table: oseba
CREATE TABLE oseba (
    id  INTEGER PRIMARY KEY,
    ime TEXT    NOT NULL
);


-- Table: oznaka
CREATE TABLE oznaka (
    kratica TEXT PRIMARY KEY
);


-- Table: pripada
CREATE TABLE pripada (
    film INTEGER REFERENCES film (id) ON DELETE CASCADE,
    zanr INTEGER REFERENCES zanr (id) ON UPDATE CASCADE,
    PRIMARY KEY (
        film,
        zanr
    )
);


-- Table: vloga
CREATE TABLE vloga (
    film  INTEGER   REFERENCES film (id),
    oseba INTEGER   REFERENCES oseba (id),
    tip   CHARACTER CHECK (tip IN ('I', 'R') ),
    mesto INTEGER   CHECK (mesto >= 1) 
                    NOT NULL,
    PRIMARY KEY (
        film,
        oseba,
        tip
    ),
    UNIQUE (
        film,
        tip,
        mesto
    )
);


-- Table: zanr
CREATE TABLE zanr (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    naziv TEXT    NOT NULL
                  UNIQUE
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
