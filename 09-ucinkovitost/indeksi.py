import random
import sqlite3
from stopanje import stopaj

with stopaj('priprava baze'):
    conn = sqlite3.connect('baza.sqlite3')

with stopaj('priprava tabele'):
    with conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS tabela (
                strnjen   INTEGER,
                razprsen  INTEGER
            )
        """)

with stopaj('polnjenje tabele'):
    with conn:
        stevilo_vrstic, = conn.execute("""
            SELECT COUNT(*) FROM tabela
        """).fetchone()
        if not stevilo_vrstic:
            for _ in range(1000000):
                conn.execute("""
                    INSERT INTO tabela (strnjen, razprsen) VALUES (?, ?)
                """, (random.randint(1, 100), random.randint(1, 100000)))

with stopaj('izdelava indeksa'):
    with conn:
        conn.execute("""
            CREATE INDEX IF NOT EXISTS kazalo_strnjenih ON tabela(strnjen)
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS kazalo_razprsenih ON tabela(razprsen)
        """)

with stopaj('prestej strnjen = 1'):
    stevilo, = conn.execute("""
        SELECT COUNT(*) FROM tabela WHERE strnjen = 1
    """).fetchone()
    print(stevilo)

with stopaj('prestej razprsen = 1'):
    stevilo, = conn.execute("""
        SELECT COUNT(*) FROM tabela WHERE razprsen = 1
    """).fetchone()
    print(stevilo)

with stopaj('prestej razprsen = 1'):
    print(conn.execute("""
        EXPLAIN QUERY PLAN
        SELECT COUNT(*) FROM tabela WHERE (strnjen BETWEEN 1 AND 3) AND razprsen = 1
    """).fetchone())
