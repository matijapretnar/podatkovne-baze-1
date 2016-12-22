import sqlite3

con = sqlite3.connect('/Users/matija/Documents/urnik/urnik.sqlite3')
con.row_factory = sqlite3.Row

for vrstica in con.execute('SELECT * FROM oseba'):
    print(vrstica)

for id, ime, priimek, email in con.execute('SELECT * FROM oseba'):
    print(ime + priimek)

for vrstica in con.execute('SELECT * FROM oseba'):
    print(str(vrstica['id']) + vrstica['ime'] + vrstica['priimek'])
