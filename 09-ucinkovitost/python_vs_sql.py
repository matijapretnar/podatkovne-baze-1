import sqlite3
import time

conn = sqlite3.connect('../filmi.db')

def python_filmi_v_letu(leto):
    sql = '''
        SELECT leto
        FROM film
    '''
    v_letu = 0
    for l, in conn.execute(sql):
        if l == leto:
            v_letu += 1
    return v_letu

def python_filmi_v_letu_vsi_podatki(leto):
    sql = '''
        SELECT leto, *
        FROM film
    '''
    v_letu = 0
    for l, *_ in conn.execute(sql):
        if l == leto:
            v_letu += 1
    return v_letu


def sql_filmi_v_letu(leto):
    sql = '''
        SELECT COUNT(*)
        FROM film
        WHERE leto = ?
    '''
    return conn.execute(sql, [leto]).fetchone()[0]

def poskusi(ukaz, stevilo_poskusov=100):
    cas_zacetka = time.time()
    for _ in range(stevilo_poskusov):
        rezultat = eval(ukaz)
    cas_konca = time.time()
    povprecni_cas = (cas_konca - cas_zacetka) / stevilo_poskusov
    print(f'{ukaz} = {rezultat} ({1000 * povprecni_cas:.2f} ms)')

poskusi('python_filmi_v_letu_vsi_podatki(2000)')
poskusi('python_filmi_v_letu(2000)')
poskusi('sql_filmi_v_letu(2000)')
