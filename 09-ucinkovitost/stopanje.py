import contextlib
import time


@contextlib.contextmanager
def varni_open(ime_datoteke):
    datoteka = open(ime_datoteke)
    yield datoteka
    datoteka.close()


@contextlib.contextmanager
def stopaj(oznaka):
    cas_zacetka = time.time()
    yield
    cas_konca = time.time()
    print('{}: {:}ms'.format(oznaka, 1000 * (cas_konca - cas_zacetka)))


# with stopaj('Vsota'):
#     vsota = 0
#     for i in range(1000000):
#         vsota += i
