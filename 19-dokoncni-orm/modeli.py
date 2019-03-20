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


class Relacija:
    def __init__(self, ime, obratno_ime, drugi_zapis):
        self.ime = ime
        self.obratno_ime = obratno_ime
        self.drugi_zapis = drugi_zapis

    def metoda_ki_nam_da_vse_zapise(self_relacija, prvi_zapis):
        def metoda(self_zapis):
            # če imam v razredu Film polje Relacija('igralci', Oseba)
            # SELECT oseba.* FROM oseba JOIN film_igralci ON oseba.id = film_igralci.oseba WHERE film_igralci.film = ?
            poizvedba = """
                SELECT {0}.* FROM {0} JOIN {1}_{2} ON {0}.id = {1}_{2}.{0} WHERE {1}_{2}.{1} = ?
            """.format(
                self_relacija.drugi_zapis.ime_tabele(),  # oseba
                prvi_zapis.ime_tabele(),  # film
                self_relacija.ime,  # igralci
            )
            with conn:
                for vrstica in conn.execute(poizvedba, [self_zapis.id]):
                    yield self_relacija.drugi_zapis._preberi_vrstico(vrstica)
        return metoda

    def metoda_ki_nam_da_obratne_zapise(self_relacija, prvi_zapis):
        def metoda(self_zapis):
            # če imam v razredu Film polje Relacija('igralci', Oseba)
            # SELECT oseba.* FROM oseba JOIN film_igralci ON oseba.id = film_igralci.oseba WHERE film_igralci.film = ?
            poizvedba = """
                SELECT {1}.* FROM {1} JOIN {1}_{2} ON {1}.id = {1}_{2}.{1} WHERE {1}_{2}.{0} = ?
            """.format(
                self_relacija.drugi_zapis.ime_tabele(),  # oseba
                prvi_zapis.ime_tabele(),  # film
                self_relacija.ime,  # igralci
            )
            with conn:
                for vrstica in conn.execute(poizvedba, [self_zapis.id]):
                    yield prvi_zapis._preberi_vrstico(vrstica)
        return metoda


class Zapis:
    polja = []

    def __init__(self, **kwargs):
        self.id = None
        for polje in self.obicajna_polja():
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
        for relacija in self.relacije():
            if relacija.ime in kwargs:
                # TODO: kaj bomo naredili z relacijami
                # Oseba(filmi=[...])
                raise ValueError(
                    'V zapisu {} je polje {} relacija'.format(
                        self.__class__.__name__, relacija.ime
                    )
                )
            else:
                setattr(self.__class__, relacija.ime, relacija.metoda_ki_nam_da_vse_zapise(self.__class__))
                setattr(relacija.drugi_zapis, relacija.obratno_ime, relacija.metoda_ki_nam_da_obratne_zapise(self.__class__))

    def __repr__(self):
        return "<{} '{}' (#{})>".format(self.__class__.__name__, self, self.id if self.id else '???')

    @classmethod
    def ustvari_tabele(cls):
        stolpci = ", ".join([
            '{} {}'.format(polje.ime, polje.tip)
            for polje in cls.obicajna_polja()
        ])
        poizvedba = """
            CREATE TABLE {} (
                id        INTEGER PRIMARY KEY,
                {}
            );
        """.format(cls.ime_tabele(), stolpci)
        with conn:
            conn.execute(poizvedba)
        for relacija in cls.relacije():
            poizvedba = """
                CREATE TABLE {1}_{0} (
                    {1} INTEGER REFERENCES {1} (id),
                    {2} INTEGER REFERENCES {2} (id),
                    PRIMARY KEY ({1}, {2})
                );
            """.format(relacija.ime, cls.ime_tabele(), relacija.drugi_zapis.ime_tabele())
            with conn:
                conn.execute(poizvedba)

    @classmethod
    def pobrisi_tabele(cls):
        poizvedba = """
            DROP TABLE IF EXISTS {};
        """.format(cls.ime_tabele())
        with conn:
            conn.execute(poizvedba)
        for relacija in cls.relacije():
            poizvedba = """
                DROP TABLE IF EXISTS {1}_{0};
            """.format(relacija.ime, cls.ime_tabele())
            with conn:
                conn.execute(poizvedba)

    @classmethod
    def izprazni_tabele(cls):
        poizvedba = """
            DELETE FROM {};
        """.format(cls.ime_tabele())
        with conn:
            conn.execute(poizvedba)
        for relacija in cls.relacije():
            poizvedba = """
                DELETE FROM {1}_{0};
            """.format(relacija.ime, cls.ime_tabele())
            with conn:
                conn.execute(poizvedba)


    @classmethod
    def ime_tabele(cls):
        return cls.__name__.lower()

    @classmethod
    def obicajna_polja(cls):
        for polje in cls.polja:
            if isinstance(polje, ObicajnoPolje):
                yield polje

    @classmethod
    def relacije(cls):
        for polje in cls.polja:
            if isinstance(polje, Relacija):
                yield polje

    @classmethod
    def imena_stolpcev(cls):
        for polje in cls.obicajna_polja():
            yield polje.ime

    @classmethod
    def _preberi_vrstico(cls, vrstica):
        id, *vrednosti = vrstica
        kwargs = dict(zip(cls.imena_stolpcev(), vrednosti))
        zapis = cls(**kwargs)
        zapis.id = id
        return zapis
    
    def _shrani_kot_novo_vrstico(self):
        assert self.id is None
        staknjeni_stolpci = ', '.join(self.imena_stolpcev())
        vprasaji = ', '.join('?' for _ in self.obicajna_polja())
        poizvedba = """
            INSERT INTO {} ({}) VALUES ({})
        """.format(self.ime_tabele(), staknjeni_stolpci, vprasaji)
        parametri = [getattr(self, stolpec) for stolpec in self.imena_stolpcev()]
        with conn:
            cur = conn.execute(poizvedba, parametri)
            self.id = cur.lastrowid

    def _posodobi_obstojeco_vrstico(self):
        assert self.id is not None
        posodobitve = ', '.join('{} = ?'.format(stolpec) for stolpec in self.imena_stolpcev())
        poizvedba = """
            UPDATE {} SET {} WHERE id = ?
        """.format(self.ime_tabele(), posodobitve)
        parametri = [getattr(self, stolpec) for stolpec in self.imena_stolpcev()]
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
            for relacija in self.relacije():
                poizvedba = """
                    DELETE FROM {1}_{0} WHERE {1} = ?;
                """.format(relacija.ime, self.ime_tabele())
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

    def __str__(self):
        return self.naziv

class Vloga(Zapis):
    ednina = 'vloga'
    mnozina = 'vloge'
    polja = [
        ObicajnoPolje('naziv', ObicajnoPolje.TEXT),
    ]

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
        Relacija('zanri', 'filmi', Zanr),
    ]

    def __str__(self):
        return '{} ({})'.format(self.naslov, self.leto)

class Oseba(Zapis):
    ednina = 'oseba'
    mnozina = 'osebe'
    polja = [
        ObicajnoPolje('ime', ObicajnoPolje.TEXT),
        Relacija('filmi', 'osebe', Film),
    ]

    def __str__(self):
        return self.ime
