from model import Film, Oseba
import sqlite3

conn = sqlite3.connect('../filmi.sqlite')

def izpisi_vloge(igralec):
    print(igralec.ime)
    for naslov, leto, tip_vloge in igralec.poisci_vloge():
        vloga = {'I': 'igralec', 'R': 'režiser'}[tip_vloge]
        print(f'- {naslov} ({leto}, {vloga})')

def vnesi_izbiro(moznosti):
    for i, moznost in enumerate(moznosti, 1):
        print(f'{i}) {moznost}')
    izbira = int(input('> ')) - 1
    return moznosti[izbira]

def poisci_osebo():
    ime_igralca = input('Kdo te zanima? ')
    osebe = Oseba.poisci(ime_igralca)
    if len(osebe) == 1:
        return osebe[0]
    elif len(osebe) == 0:
        print('Te osebe ne najdem. Poskusi znova.')
        return poisci_osebo()
    else:
        print('Našel sem več igralcev, kateri od teh te zanima?')
        return vnesi_izbiro(osebe)

def najboljsi_filmi():
    leto = input('Katero leto te zanima? ')
    filmi = Film.najboljsi_v_letu(leto)
    for mesto, film in enumerate(filmi, 1):
        print(f'{mesto}) {film.naslov} ({film.ocena}/10)')

def glavni_meni():
    print('Pozdravljen v bazi filmov!')
    while True:
        print('Kaj bi rad delal?')
        ISKAL_OSEBO = 'Iskal osebo'
        POGLEDAL_DOBRE_FILME = 'Pogledal dobre filme'
        SEL_DOMOV = 'Šel domov'
        moznosti = [ISKAL_OSEBO, POGLEDAL_DOBRE_FILME, SEL_DOMOV]
        izbira = vnesi_izbiro(moznosti)
        if izbira == ISKAL_OSEBO:
            oseba = poisci_osebo()
            izpisi_vloge(oseba)
        elif izbira == POGLEDAL_DOBRE_FILME:
            najboljsi_filmi()
        elif izbira == SEL_DOMOV:
            print('Adijo!')
            return

glavni_meni()