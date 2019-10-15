import csv
from modeli import Film, Oseba, Vloga, Zanr


def pobrisi_tabele(conn):
    """
    Pobriše tabele iz baze.
    """
    Vloga.pobrisi_tabele()
    Zanr.pobrisi_tabele()
    Oseba.pobrisi_tabele()
    Film.pobrisi_tabele()


def ustvari_tabele(conn):
    """
    Ustvari tabele v bazi.
    """
    Film.ustvari_tabele()
    Oseba.ustvari_tabele()
    Vloga.ustvari_tabele()
    Zanr.ustvari_tabele()
    conn.execute("""
        CREATE TABLE uporabniki (
            uporabnisko_ime  TEXT PRIMARY KEY,
            geslo TEXT,
            sol TEXT
        );
    """)


def uvozi_filme(conn):
    """
    Uvozi podatke o filmih.
    """
    Film.izprazni_tabele()
    with open('podatki/film.csv', encoding="UTF-8") as datoteka:
        podatki = csv.reader(datoteka)
        stolpci = next(podatki)
        poizvedba = """
            INSERT INTO film VALUES ({})
        """.format(', '.join(["?"] * len(stolpci)))
        for vrstica in podatki:
            conn.execute(poizvedba, vrstica)


def uvozi_osebe(conn):
    """
    Uvozi podatke o osebah.
    """
    Oseba.izprazni_tabele()
    with open('podatki/oseba.csv', encoding="UTF-8") as datoteka:
        podatki = csv.reader(datoteka)
        stolpci = next(podatki)
        poizvedba = """
            INSERT INTO oseba VALUES ({})
        """.format(', '.join(["?"] * len(stolpci)))
        for vrstica in podatki:
            conn.execute(poizvedba, vrstica)


def uvozi_vloge(conn):
    """
    Uvozi podatke o vlogah.
    """
    conn.execute("DELETE FROM oseba_filmi;")
    Vloga.izprazni_tabele()
    vloge = {}
    with open('podatki/vloge.csv', encoding="UTF-8") as datoteka:
        podatki = csv.reader(datoteka)
        stolpci = next(podatki)
        v = stolpci.index('vloga')
        poizvedba = """
            INSERT INTO oseba_filmi VALUES (?, ?)
        """
        poizvedba_vloga = "INSERT INTO vloga (naziv) VALUES (?);"
        for vrstica in podatki:
            vloga = vrstica[v]
            if vloga == 'reziser':
                continue
            else:
                vrstica = vrstica[:-1][::-1]
            if vloga not in vloge:
                cur = conn.execute(poizvedba_vloga, [vloga])
                vloge[vloga] = cur.lastrowid
            conn.execute(poizvedba, vrstica)


def uvozi_zanre(conn):
    """
    Uvozi podatke o žanrih.
    """
    conn.execute("DELETE FROM film_zanri;")
    Zanr.izprazni_tabele()
    zanri = {}
    with open('podatki/zanri.csv', encoding="UTF-8") as datoteka:
        podatki = csv.reader(datoteka)
        stolpci = next(podatki)
        z = stolpci.index('zanr')
        poizvedba = """
            INSERT INTO film_zanri VALUES ({})
        """.format(', '.join(["?"] * len(stolpci)))
        poizvedba_zanr = "INSERT INTO zanr (naziv) VALUES (?);"
        for vrstica in podatki:
            zanr = vrstica[z]
            if zanr not in zanri:
                cur = conn.execute(poizvedba_zanr, [zanr])
                zanri[zanr] = cur.lastrowid
            vrstica[z] = zanri[zanr]
            conn.execute(poizvedba, vrstica)


def ustvari_bazo(conn):
    """
    Opravi celoten postopek postavitve baze.
    """
    pobrisi_tabele(conn)
    ustvari_tabele(conn)
    uvozi_filme(conn)
    uvozi_osebe(conn)
    uvozi_vloge(conn)
    uvozi_zanre(conn)


def ustvari_bazo_ce_ne_obstaja(conn):
    """
    Ustvari bazo, če ta še ne obstaja.
    """
    with conn:
        cur = conn.execute("SELECT COUNT(*) FROM sqlite_master")
        if cur.fetchone() == (0, ):
            ustvari_bazo(conn)
