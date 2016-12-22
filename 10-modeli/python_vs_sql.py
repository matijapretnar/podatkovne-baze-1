import sqlite3

con = sqlite3.connect('urnik.sqlite3')


def python_osebe_brez_emaila():
    sql = '''
        SELECT ime, priimek, email
        FROM oseba
    '''
    brez_maila = []
    for ime, priimek, email in con.execute(sql):
        if email is None:
            brez_maila.append((ime, priimek))
    return brez_maila


def sql_osebe_brez_emaila():
    sql = '''
        SELECT ime, priimek
        FROM oseba
        WHERE email IS NULL
    '''
    return list(con.execute(sql))

def python_prestej_osebe_brez_emaila():
    sql = '''
        SELECT ime, priimek, email
        FROM oseba
    '''
    brez_maila = 0
    for ime, priimek, email in con.execute(sql):
        if email is None:
            brez_maila += 1
    return brez_maila


def sql_prestej_osebe_brez_emaila():
    sql = '''
        SELECT COUNT(*)
        FROM oseba
        WHERE email IS NULL
    '''
    return con.execute(sql).fetchone()[0]

cur = con.cursor()

def python_prestej_osebe_brez_emaila_en_kurzor():
    sql = '''
        SELECT ime, priimek, email
        FROM oseba
    '''
    brez_maila = 0
    for ime, priimek, email in cur.execute(sql):
        if email is None:
            brez_maila += 1
    return brez_maila


def sql_prestej_osebe_brez_emaila_en_kurzor():
    sql = '''
        SELECT COUNT(*)
        FROM oseba
        WHERE email IS NULL
    '''
    return cur.execute(sql).fetchone()[0]


# print(python_osebe_brez_emaila())
# print(sql_osebe_brez_emaila())


import timeit

print(timeit.timeit('python_prestej_osebe_brez_emaila()', globals=globals(), number=50000))
print(timeit.timeit('sql_prestej_osebe_brez_emaila()', globals=globals(), number=50000))
print(timeit.timeit('python_prestej_osebe_brez_emaila_en_kurzor()', globals=globals(), number=50000))
print(timeit.timeit('sql_prestej_osebe_brez_emaila_en_kurzor()', globals=globals(), number=50000))
