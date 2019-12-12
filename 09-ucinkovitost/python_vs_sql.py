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

def sql_filmi_z_oceno(ocena):
    sql = '''
        SELECT COUNT(*)
        FROM film
        WHERE ocena >= ? 
    '''
    return conn.execute(sql, [ocena]).fetchone()[0]

def sql_filmi_z_dolzino(dolzina):
    sql = '''
        SELECT COUNT(*)
        FROM film
        WHERE dolzina >= ? 
    '''
    return conn.execute(sql, [dolzina]).fetchone()[0]

def sql_filmi_z_dolzino_in_oceno(dolzina, ocena):
    sql = '''
        SELECT COUNT(*)
        FROM film
        WHERE dolzina >= ? AND ocena >= ? 
    '''
    return conn.execute(sql, [dolzina, ocena]).fetchone()[0]


def poskusi(ukaz, stevilo_poskusov=200):
    cas_zacetka = time.time()
    for _ in range(stevilo_poskusov):
        rezultat = eval(ukaz)
    cas_konca = time.time()
    povprecni_cas = (cas_konca - cas_zacetka) / stevilo_poskusov
    print(f'{ukaz} = {rezultat} ({1000 * povprecni_cas:.2f} ms)')

print('V PYTHONU')
poskusi('python_filmi_v_letu_vsi_podatki(2000)')
poskusi('python_filmi_v_letu(2000)')
print('BREZ INDEKSOV')
poskusi('sql_filmi_v_letu(2000)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
print('INDEKS LETA')
conn.execute('CREATE INDEX leta_filmov ON film(leto)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
conn.execute('DROP INDEX leta_filmov')
print('INDEKS DOLZINE')
conn.execute('CREATE INDEX dolzine_filmov ON film(dolzina)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
conn.execute('DROP INDEX dolzine_filmov')
print('INDEKS OCENE')
conn.execute('CREATE INDEX ocene ON film(ocena)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
conn.execute('DROP INDEX ocene')
print('INDEKS OCENE & INDEKS DOLZINE')
conn.execute('CREATE INDEX dolzine ON film(dolzina)')
conn.execute('CREATE INDEX ocene ON film(ocena)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
conn.execute('DROP INDEX dolzine')
conn.execute('DROP INDEX ocene')
print('INDEKS OCENE & DOLZINE')
conn.execute('CREATE INDEX dolzine_ocene ON film(ocena, dolzina)')
poskusi('sql_filmi_z_dolzino_in_oceno(120, 8.1)')
poskusi('sql_filmi_z_oceno(8.1)')
poskusi('sql_filmi_z_dolzino(120)')
conn.execute('DROP INDEX dolzine_ocene')
