import time

def vsota_prvih(n):
    vsota = 0
    for i in range(1, n + 1):
        vsota += i
    return vsota

def vsota_prvih_s_casom(n):
    zacetek = time.time()
    vsota = 0
    for i in range(1, n + 1):
        vsota += i
    konec = time.time()
    print('Porabljen čas: {:}ms'.format(1000 * (konec - zacetek)))
    return vsota

def izracunaj_cas(f, x):
    zacetek = time.time()
    rezultat = f(x)
    konec = time.time()
    print('Porabljen čas: {:}ms'.format(1000 * (konec - zacetek)))
    return rezultat

def dodaj_merjenje_casa(f):
    def f_s_casom(*args, **kwargs):
        zacetek = time.time()
        rezultat = f(*args, **kwargs)
        konec = time.time()
        print('Porabljen čas: {:}ms'.format(1000 * (konec - zacetek)))
        return rezultat
    return f_s_casom

vsota_prvih_s_casom(10000)
izracunaj_cas(vsota_prvih, 10000)
se_ena_vsota_prvih_s_casom = dodaj_merjenje_casa(vsota_prvih)
se_ena_vsota_prvih_s_casom(10000)

@dodaj_merjenje_casa
def lepsa_vsota_prvih(n):
    return sum(range(n + 1))

lepsa_vsota_prvih(10000)


def f_vec_argumentov(x, *args, **kwargs):
    print('Prvi je {!r}, ostali pa {!r} in {!r}'.format(x, args, kwargs))

def vsota(x, y):
    print('{} + {} = {}'.format(x, y, x + y))

f_vec_argumentov(10, 20, 30, 40)
f_vec_argumentov(10, 20)
f_vec_argumentov(10)
f_vec_argumentov(10, a=20)
f_vec_argumentov(10, 30, a=40)
vsota(10, 20)
vsota(*[10, 20])
vsota(*'ab')