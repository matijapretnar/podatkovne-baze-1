import sqlite3

conn = sqlite3.connect('filmi.db')

class ObicajnoPolje:
    TEXT = 'TEXT'
    INTEGER = 'INTEGER'
    REAL = 'REAL'
    def __init__(self, ime, tip, **kwargs):
        self.ime = ime
        self.tip = tip
        if 'privzeta_vrednost' in kwargs:
            self.obvezno = False
            self.privzeta_vrednost = kwargs['privzeta_vrednost']
        else:
            self.obvezno = True
            self.privzeta_vrednost = None


class Zapis:
    polja = []

    def __init__(self, **kwargs):
        self.id = None
        for polje in self.polja:
            if polje.ime in kwargs:
                setattr(self, polje.ime, kwargs[polje.ime])
            elif not polje.obvezno:
                setattr(self, polje.ime, polje.privzeta_vrednost)
            else:
                raise ValueError(
                    'V konstruktorju {} je argument {} obvezen'.format(
                        self.__class__.__name__, polje.ime
                    )
                )

    def __repr__(self):
        return "<{} '{}' (#{})>".format(self.__class__.__name__, self, self.id if self.id else '???')
    
    @classmethod
    def ustvari_tabelo(cls):
        stolpci = ", ".join([
            '{} {}'.format(polje.ime, polje.tip)
            for polje in cls.polja
        ])
        poizvedba = """
            CREATE TABLE {} (
                id        INTEGER PRIMARY KEY,
                {}
            );
        """.format(cls.ime_tabele(), stolpci)
        conn.execute(poizvedba)

    @classmethod
    def pobrisi_tabelo(cls):
        poizvedba = """
            DROP TABLE {} IF EXISTS;
        """.format(cls.ime_tabele())
        conn.execute(poizvedba)


    @classmethod
    def ime_tabele(cls):
        return cls.__name__.lower()

    @classmethod
    def imena_polj(cls):
        for polje in cls.polja:
            yield polje.ime

    @staticmethod
    def relacija(drugi_zapis, povezovalna_tabela, moj_stolpec, drugi_stolpec):
        def metoda(self):
            razred_drugega_zapisa = eval(drugi_zapis)
            poizvedba = """
                SELECT {0}.* FROM {0} JOIN {1} ON {0}.id = {1}.{2} WHERE {1}.{3} = ?
            """.format(
                razred_drugega_zapisa.ime_tabele(),
                povezovalna_tabela,
                drugi_stolpec,
                moj_stolpec
            )
            with conn:
                for vrstica in conn.execute(poizvedba, [self.id]):
                    yield razred_drugega_zapisa._preberi_vrstico(vrstica)
        return metoda


    @classmethod
    def _preberi_vrstico(cls, vrstica):
        id, *vrednosti = vrstica
        kwargs = dict(zip(cls.imena_polj(), vrednosti))
        zapis = cls(**kwargs)
        zapis.id = id
        return zapis
    
    def _shrani_kot_novo_vrstico(self):
        assert self.id is None
        staknjeni_stolpci = ', '.join(self.imena_polj())
        vprasaji = ', '.join('?' for _ in self.polja)
        poizvedba = """
            INSERT INTO {} ({}) VALUES ({})
        """.format(self.ime_tabele(), staknjeni_stolpci, vprasaji)
        parametri = [getattr(self, stolpec) for stolpec in self.imena_polj()]
        with conn:
            cur = conn.execute(poizvedba, parametri)
            self.id = cur.lastrowid

    def _posodobi_obstojeco_vrstico(self):
        assert self.id is not None
        posodobitve = ', '.join('{} = ?'.format(stolpec) for stolpec in self.imena_polj())
        poizvedba = """
            UPDATE {} SET {} WHERE id = ?
        """.format(self.ime_tabele(), posodobitve)
        parametri = [getattr(self, stolpec) for stolpec in self.imena_polj()]
        parametri.append(self.id)
        with conn:
            conn.execute(poizvedba, parametri)

    def shrani(self):
        if self.id is None:
            self._shrani_kot_novo_vrstico()
        else:
            self._posodobi_obstojeco_vrstico()

    def pobrisi(self):
        if self.id is None:
            raise ValueError(
                '{} ne obstaja, zato ga ne morem pobrisati'.format(
                    self.ednina.capitalize()
                )
            )
        else:
            poizvedba = """
                DELETE FROM {} WHERE id = ?
            """.format(self.ime_tabele())
            with conn:
                conn.execute(poizvedba, [self.id])

    @classmethod
    def poisci_vse(cls, **kwargs):
        stolpci = []
        vrednosti = []
        for stolpec, vrednost in kwargs.items():
            stolpci.append(stolpec)
            vrednosti.append(vrednost)
        where = ' AND '.join('{} = ?'.format(stolpec) for stolpec in stolpci)
        poizvedba = """
            SELECT * FROM {} WHERE {}
        """.format(cls.ime_tabele(), where)
        with conn:
            for vrstica in conn.execute(poizvedba, vrednosti):
                yield cls._preberi_vrstico(vrstica)

    @classmethod
    def poisci_enega(cls, **kwargs):
        rezultati = cls.poisci_vse(**kwargs)
        prvi = next(rezultati, None)
        naslednji = next(rezultati, None)
        if prvi is None:
            raise ValueError(
                '{} z danimi podatki ne obstaja'.format(
                    cls.ime_tabele()
                )
            )
        elif naslednji is None:
            return prvi
        else:
            raise ValueError(
                '{} z danimi podatki ni natanko določen'.format(
                    cls.ime_tabele()
                )
            )



class Zanr(Zapis):
    ednina = 'žanr'
    mnozina = 'žanri'
    polja = [
        ObicajnoPolje('naziv', ObicajnoPolje.TEXT),
    ]
    filmi = Zapis.relacija(drugi_zapis='Film', povezovalna_tabela='pripada', moj_stolpec='zanr', drugi_stolpec='film')

    def __str__(self):
        return self.naziv


class Film(Zapis):
    ednina = 'film'
    mnozina = 'filmi'
    polja = [
        ObicajnoPolje('naslov', ObicajnoPolje.TEXT),
        ObicajnoPolje('dolzina', ObicajnoPolje.INTEGER),
        ObicajnoPolje('leto', ObicajnoPolje.INTEGER),
        ObicajnoPolje('ocena', ObicajnoPolje.REAL, privzeta_vrednost=None),
        ObicajnoPolje('metascore', ObicajnoPolje.INTEGER, privzeta_vrednost=None),
        ObicajnoPolje('glasovi', ObicajnoPolje.INTEGER, privzeta_vrednost=None),
        ObicajnoPolje('zasluzek', ObicajnoPolje.INTEGER, privzeta_vrednost=None),
        ObicajnoPolje('opis', ObicajnoPolje.TEXT, privzeta_vrednost=''),
    ]
    zanri = Zapis.relacija(drugi_zapis='Zanr', povezovalna_tabela='pripada', moj_stolpec='film', drugi_stolpec='zanr')
    osebe = Zapis.relacija(drugi_zapis='Oseba', povezovalna_tabela='nastopa', moj_stolpec='film', drugi_stolpec='oseba')

    def __str__(self):
        return '{} ({})'.format(self.naslov, self.leto)

class Oseba(Zapis):
    ednina = 'oseba'
    mnozina = 'osebe'
    polja = [
        ObicajnoPolje('ime', ObicajnoPolje.TEXT),
    ]
    filmi = Zapis.relacija(drugi_zapis='Film', povezovalna_tabela='nastopa', moj_stolpec='oseba', drugi_stolpec='film')

    def __str__(self):
        return self.ime
