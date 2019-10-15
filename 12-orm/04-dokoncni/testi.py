import os
import baza
from modeli import conn, Film, Oseba, Zanr

os.chdir('/Users/matija/Documents/Matija/podatkovne-baze-1-2/19-dokoncni-orm/')
baza.ustvari_bazo_ce_ne_obstaja(conn)
conn.execute('PRAGMA foreign_keys = ON')

filmi_2010 = Film.poisci_vse(leto=2010, ocena=6.7)
assert next(filmi_2010).naslov == 'Ljubezen in druge droge'
assert next(filmi_2010).naslov == 'Robin Hood'
assert next(filmi_2010).leto == 2010

avatar = Film.poisci_enega(naslov='Avatar')
assert avatar.naslov == 'Avatar'
assert avatar.ocena == 7.8

avatar.ocena = 7.9
avatar.shrani()
assert len(list(Film.poisci_vse(naslov='Avatar'))) == 1
avatar.ocena = 7.8
avatar.shrani()
assert len(list(Film.poisci_vse(naslov='Avatar'))) == 1

assert {zanr.naziv for zanr in avatar.zanri()} == {'Fantasy', 'Adventure', 'Action'}


ime_predmeta = 'Podatkovne baze 1'
podatkovne_baze_1 = Film(naslov=ime_predmeta, dolzina=2000, leto=2018, zasluzek=0)
podatkovne_baze_1.shrani()
assert len(list(Film.poisci_vse(naslov=ime_predmeta))) == 1
podatkovne_baze_1.pobrisi()
assert len(list(Film.poisci_vse(naslov=ime_predmeta))) == 0

for zanr in avatar.zanri():
    print(zanr)
    for _, film in zip(range(10), zanr.filmi()):
        print('-', film)

lepi_leonardo = Oseba.poisci_enega(ime='Leonardo DiCaprio')
for film in lepi_leonardo.filmi():
    print(film)
    for soigralec_lepega_leonarda in film.osebe():
        print('-', soigralec_lepega_leonarda)

# conn.set_trace_callback(print)

zanri = {}
komedija = Zanr.poisci_enega(naziv='Comedy')
for film in komedija.filmi():
    # print(film)
    for zanr in film.zanri():
        if zanr.naziv in zanri:
            zanri[zanr.naziv] += 1
        else:
            zanri[zanr.naziv] = 1

print(zanri)