import sqlite3

conn = sqlite3.connect('03-stikanje/filmi-velika.sqlite')

# for rezultat in conn.execute('SELECT naslov, leto, ocena FROM filmi ORDER BY ocena'):
#     print(rezultat)

# for rezultat in conn.execute('SELECT COUNT(*) FROM filmi'):
#     print(rezultat)

for rezultat in conn.execute('SELECT COUNT(*) FROM osebe'):
    print(rezultat)

conn.execute('INSERT INTO osebe (ime) VALUES ("Matija Pretnar")')

for rezultat in conn.execute('SELECT COUNT(*) FROM osebe'):
    print(rezultat)

def dodaj_osebo(ime):
    conn.execute('INSERT INTO osebe (ime) VALUES (?)', ime)

dodaj_osebo('Matija Pretnar')
dodaj_osebo('Janoš Vidali')
dodaj_osebo('Matija Lokar')
poisci_osebo('"); DELETE * FROM osebe;')
conn.commit()
