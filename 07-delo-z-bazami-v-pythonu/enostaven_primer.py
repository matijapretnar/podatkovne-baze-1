import sqlite3

conn = sqlite3.connect('filmi.sqlite')

cur = conn.cursor()

cur.execute('SELECT COUNT(*), MAX(dolzina) FROM film')

stevilo_filmov, max_dolzina = cur.fetchone()

print(f'V bazi je {stevilo_filmov} filmov, najdaljši je dolg {max_dolzina} minut.')

cur.execute('''
    SELECT naslov, leto, ocena
    FROM film
    WHERE glasovi > 100000
    ORDER BY ocena DESC
    LIMIT 10
''')

for naslov, leto, ocena in cur:
    print(f'{naslov} ({leto}) - {ocena}/10')


def izpisi_najboljse(stevilo_najboljsih=10):
    cur = conn.execute('''
        SELECT naslov, leto, ocena
        FROM film
        WHERE glasovi > 100000
        ORDER BY ocena DESC
        LIMIT ?
    ''', [stevilo_najboljsih])

    for mesto, (naslov, leto, ocena) in enumerate(cur, 1):
        print(f'{mesto}. {naslov} ({leto}) - {ocena}/10')


izpisi_najboljse(10)
