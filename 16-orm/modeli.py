import baza
import sqlite3

conn = sqlite3.connect('filmi.db')
baza.ustvari_bazo_ce_ne_obstaja(conn)
conn.execute('PRAGMA foreign_keys = ON')

class Zanr:
    def __init__(self, naziv):
        self.id = None
        self.naziv = naziv

    def __repr__(self):
        return '<Zanr {} (#{})>'.format(self.naziv, self.id if self.id else '???')

    def __str__(self):
        return self.naziv

    def _shrani_kot_novo_vrstico(self):
        assert self.id is None
        poizvedba = """
            INSERT INTO zanr (
                naziv
            ) VALUES (
                ?
            )
        """
        with conn:
            cur = conn.execute(poizvedba, [
                self.naziv
            ])
            self.id = cur.lastrowid

    def _posodobi_obstojeco_vrstico(self):
        assert self.id is not None
        poizvedba = """
            UPDATE zanr SET
                naziv = ?
            WHERE id = ?
        """
        with conn:
            conn.execute(poizvedba, [
                self.naziv,
                self.id
            ])

    def shrani(self):
        if self.id is None:
            self._shrani_kot_novo_vrstico()
        else:
            self._posodobi_obstojeco_vrstico()


    def pobrisi(self):
        if self.id is None:
            raise ValueError('Žanra, ki ne obstaja, ne morem pobrisati')
        else:
            poizvedba = """
                DELETE FROM zanr WHERE id = ?
            """
            with conn:
                conn.execute(poizvedba, [self.id])

    @staticmethod
    def _preberi_vrstico(vrstica):
        id, naziv = vrstica
        zanr = Zanr(
            naziv
        )
        zanr.id = id
        return zanr
    
    @staticmethod
    def poisci_vse(**kwargs):
        stolpci = []
        vrednosti = []
        for stolpec, vrednost in kwargs.items():
            stolpci.append(stolpec)
            vrednosti.append(vrednost)
        where = ' AND '.join('{} = ?'.format(stolpec) for stolpec in stolpci)
        poizvedba = """
            SELECT * FROM zanr WHERE {}
        """.format(where)
        with conn:
            for vrstica in conn.execute(poizvedba, vrednosti):
                yield Zanr._preberi_vrstico(vrstica)

    @staticmethod
    def poisci_enega(**kwargs):
        rezultati = Zanr.poisci_vse(**kwargs)
        prvi = next(rezultati, None)
        naslednji = next(rezultati, None)
        if prvi is None:
            raise ValueError('Žanr z danimi podatki ne obstaja')
        elif naslednji is None:
            return prvi
        else:
            raise ValueError('Žanr z danimi podatki ni natanko določen')

    def filmi(self):
        poizvedba = """
            SELECT film.* FROM film JOIN pripada ON film.id = pripada.film WHERE pripada.zanr = ?
        """
        with conn:
            for vrstica in conn.execute(poizvedba, [self.id]):
                yield Film._preberi_vrstico(vrstica)

class Film:
    def __init__(self, naslov, dolzina, leto, ocena=None, metascore=None, glasovi=None, zasluzek=None, opis=''):
        self.id = None
        self.naslov = naslov
        self.dolzina = dolzina
        self.leto = leto
        self.ocena = ocena
        self.metascore = metascore
        self.glasovi = glasovi
        self.zasluzek = zasluzek
        self.opis = opis

    def __repr__(self):
        return '<Film {} (#{})>'.format(self.naslov, self.id if self.id else '???')

    def __str__(self):
        return '{} ({})'.format(self.naslov, self.leto)

    def _shrani_kot_novo_vrstico(self):
        assert self.id is None
        poizvedba = """
            INSERT INTO film (
                naslov,
                dolzina,
                leto,
                ocena,
                metascore,
                glasovi,
                zasluzek,
                opis
            ) VALUES (
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?,
                ?
            )
        """
        with conn:
            cur = conn.execute(poizvedba, [
                self.naslov,
                self.dolzina,
                self.leto,
                self.ocena,
                self.metascore,
                self.glasovi,
                self.zasluzek,
                self.opis
            ])
            self.id = cur.lastrowid

    def _posodobi_obstojeco_vrstico(self):
        assert self.id is not None
        poizvedba = """
            UPDATE film SET
                naslov = ?,
                dolzina = ?,
                leto = ?,
                ocena = ?,
                metascore = ?,
                glasovi = ?,
                zasluzek = ?,
                opis = ?
            WHERE id = ?
        """
        with conn:
            conn.execute(poizvedba, [
                self.naslov,
                self.dolzina,
                self.leto,
                self.ocena,
                self.metascore,
                self.glasovi,
                self.zasluzek,
                self.opis,
                self.id
            ])

    def shrani(self):
        if self.id is None:
            self._shrani_kot_novo_vrstico()
        else:
            self._posodobi_obstojeco_vrstico()

    def pobrisi(self):
        if self.id is None:
            raise ValueError('Filma, ki ne obstaja, ne morem pobrisati')
        else:
            poizvedba = """
                DELETE FROM film WHERE id = ?
            """
            with conn:
                conn.execute(poizvedba, [self.id])
    
    def zanri(self):
        poizvedba = """
            SELECT zanr.* FROM zanr JOIN pripada ON zanr.id = pripada.zanr WHERE pripada.film = ?
        """
        with conn:
            for vrstica in conn.execute(poizvedba, [self.id]):
                yield Zanr._preberi_vrstico(vrstica)

    @staticmethod
    def _preberi_vrstico(vrstica):
        id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, opis = vrstica
        film = Film(
            naslov,
            dolzina,
            leto,
            ocena,
            metascore,
            glasovi,
            zasluzek,
            opis
        )
        film.id = id
        return film
    
    @staticmethod
    def poisci_vse(**kwargs):
        stolpci = []
        vrednosti = []
        for stolpec, vrednost in kwargs.items():
            stolpci.append(stolpec)
            vrednosti.append(vrednost)
        where = ' AND '.join('{} = ?'.format(stolpec) for stolpec in stolpci)
        poizvedba = """
            SELECT * FROM film WHERE {}
        """.format(where)
        with conn:
            for vrstica in conn.execute(poizvedba, vrednosti):
                yield Film._preberi_vrstico(vrstica)

    @staticmethod
    def poisci_enega(**kwargs):
        rezultati = Film.poisci_vse(**kwargs)
        prvi = next(rezultati, None)
        naslednji = next(rezultati, None)
        if prvi is None:
            raise ValueError('Film z danimi podatki ne obstaja')
        elif naslednji is None:
            return prvi
        else:
            raise ValueError('Film z danimi podatki ni natanko določen')

##################################################################

for film in Film.poisci_vse(leto=2010, ocena=6.7):
    print(film)

avatar = Film.poisci_enega(naslov='Avatar')
print(avatar)
avatar.opis = 'Eni modri ljudje skačejo naokoli.'
avatar.shrani()
for zanr in avatar.zanri():
    print(zanr)
    for _, film in zip(range(10), zanr.filmi()):
        print('-', film)
# print(list(avatar.zanri()))

# avatar = Film.poisci_enega(naslov='Avatar', leto=2016)
# print(avatar)

moj_film1 = Film('Podatkovne baze 1', 2000, 2018, zasluzek=0)
moj_film1.shrani()
moj_film1.ocena = 11
moj_film1.shrani()

# moj_film2 = Film('Podatkovne baze 1', 2000, 2018, zasluzek=0)
# moj_film3 = Film('Podatkovne baze 1', 2000, 2018, zasluzek=0)
# Film.__str__(moj_film1)
pass