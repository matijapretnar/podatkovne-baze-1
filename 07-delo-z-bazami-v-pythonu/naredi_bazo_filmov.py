import json
import os
import sqlite3


def dodaj_osebo(conn, oseba):
    sql = '''
        INSERT INTO oseba
        (id, ime)
        VALUES
        (?, ?)
    '''
    parametri = [
        oseba['id'],
        oseba['ime'],
    ]
    conn.execute(sql, parametri)


def dodaj_vlogo(conn, film_id, oseba_id, tip, mesto):
    sql = '''
        INSERT INTO vloga
        (film, oseba, tip, mesto)
        VALUES
        (?, ?, ?, ?)
    '''
    parametri = [
        film_id,
        oseba_id,
        tip,
        mesto,
    ]
    conn.execute(sql, parametri)


def dodaj_zanr(conn, zanr):
    sql = '''
        INSERT INTO zanr
        (naziv)
        VALUES
        (?)
    '''
    parametri = [
        zanr,
    ]
    cur = conn.execute(sql, parametri)
    return cur.lastrowid


def dodaj_dolocitev_zanra(conn, film_id, zanr_id):
    sql = '''
        INSERT INTO pripada
        (film, zanr)
        VALUES
        (?, ?)
    '''
    parametri = [
        film_id,
        zanr_id,
    ]
    conn.execute(sql, parametri)


def dodaj_podatke_filma(conn, film):
    sql = '''
        INSERT INTO film
        (id, naslov, dolzina, leto, ocena, metascore, glasovi, zasluzek, oznaka, opis)
        VALUES
        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    '''
    parametri = [
        film['id'],
        film['naslov'],
        film['dolzina'],
        film['leto'],
        film['ocena'],
        film['metascore'],
        film['glasovi'],
        film['zasluzek'],
        film['oznaka'],
        film['opis'],
    ]
    conn.execute(sql, parametri)


def dodaj_oznako(conn, oznaka, ze_videne_oznake):
    if oznaka is None or oznaka in ze_videne_oznake:
        return
    else:
        ze_videne_oznake.add(oznaka)
    sql = '''
        INSERT INTO oznaka
        (kratica)
        VALUES
        (?)
    '''
    parametri = [
        oznaka
    ]
    conn.execute(sql, parametri)


def dodaj_vloge(conn, film, osebe, tip, ze_videne_osebe):
    film_id = film['id']
    for mesto, oseba in enumerate(osebe, 1):
        oseba_id = oseba['id']
        if oseba_id not in ze_videne_osebe:
            dodaj_osebo(conn, oseba)
            ze_videne_osebe.add(oseba_id)
        dodaj_vlogo(conn, film_id, oseba_id, tip, mesto)


def dodaj_zanre(conn, film, zanri, idji_zanrov):
    film_id = film['id']
    for zanr in zanri:
        if zanr not in idji_zanrov:
            id_zanra = dodaj_zanr(conn, zanr)
            idji_zanrov[zanr] = id_zanra
        dodaj_dolocitev_zanra(conn, film_id, idji_zanrov[zanr])


def napolni_tabele(conn, filmi):
    ze_videne_osebe = set()
    idji_zanrov = {}
    ze_videne_oznake = set()
    for film in filmi:
        dodaj_oznako(conn, film['oznaka'], ze_videne_oznake)
        dodaj_podatke_filma(conn, film)
        dodaj_vloge(conn, film, film['igralci'], 'I', ze_videne_osebe)
        dodaj_vloge(conn, film, film['reziserji'], 'R', ze_videne_osebe)
        dodaj_zanre(conn, film, film['zanri'], idji_zanrov)
    conn.commit()


def naredi_bazo_filmov(pobrisi_ce_obstaja=False):
    IME_SQLITE_DATOTEKE = '../filmi.sqlite'
    IME_DDL_DATOTEKE = 'filmi_ddl.sql'
    IME_DATOTEKE_S_PODATKI = 'filmi.json'
    # Naredimo prazno bazo
    if os.path.exists(IME_SQLITE_DATOTEKE):
        if pobrisi_ce_obstaja:
            os.remove(IME_SQLITE_DATOTEKE)
        else:
            print('Baza že obstaja in je ne bom spreminjal.')
            return
    conn = sqlite3.connect(IME_SQLITE_DATOTEKE)
    # Ustvarimo tabele iz DDL datoteke
    with open(IME_DDL_DATOTEKE) as ddl_datoteka:
        ddl = ddl_datoteka.read()
        conn.executescript(ddl)
    # Naložimo podatke o filmih
    with open(IME_DATOTEKE_S_PODATKI) as datoteka_s_podatki:
        filmi = json.load(datoteka_s_podatki)
    napolni_tabele(conn, filmi)


naredi_bazo_filmov()
