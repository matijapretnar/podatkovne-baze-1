import sqlite3

conn = sqlite3.connect('../filmi.sqlite')


class Film:
    def __init__(self, id, naslov, leto, ocena):
        self.id = id
        self.naslov = naslov
        self.leto = leto
        self.ocena = ocena
    
    def __str__(self):
        return self.naslov

    @staticmethod
    def najboljsi_v_letu(leto):
        '''Vrne najboljših 10 filmov v danem letu.'''
        sql = '''
            SELECT id, naslov, leto, ocena
            FROM film
            WHERE leto = ?
            ORDER BY ocena DESC
            LIMIT 10
        '''
        film = []
        for id, naslov, leto, ocena in conn.execute(sql, [leto]):
            film.append(Film(id, naslov, leto, ocena))
        return film



class Oseba:
    def __init__(self, id, ime):
        self.id = id
        self.ime = ime
    
    def __str__(self):
        return self.ime

    def poisci_vloge(self):
        sql = '''
            SELECT film.naslov, film.leto, vloga.tip
            FROM film
                JOIN vloga ON film.id = vloga.film
            WHERE vloga.oseba = ?
            ORDER BY leto
        '''
        return conn.execute(sql, [self.id]).fetchall()

    @staticmethod
    def poisci(niz):
        '''Vrne vse osebe, ki v imenu vsebujejo dani niz.'''
        sql = '''
            SELECT id, ime FROM oseba WHERE ime LIKE ?
        '''
        osebe = []
        for id, ime in conn.execute(sql, ['%' + niz + '%']):
            osebe.append(Oseba(id, ime))
        return osebe

