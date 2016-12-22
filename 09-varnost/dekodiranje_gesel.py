import hashlib, binascii

def kodiraj(geslo, sol):
    return sol + '$' + hashlib.md5((sol + '$' + geslo).encode()).hexdigest()

def dekodiraj(zakodirano_geslo):
    # iz gesla izlocimo sol
    sol, _ = zakodirano_geslo.split('$')
    # nato le poskusimo vse mozne kombinacije petih crk in stevilk
    vse_crke = '0123456789abcdefhijklmnoprstuvz'
    for a in vse_crke:
        for b in vse_crke:
            print('{}{}...'.format(a, b))
            for c in vse_crke:
                for d in vse_crke:
                    for e in vse_crke:
                        poskus = a + b + c + d + e
                        if kodiraj(poskus, sol) == zakodirano_geslo:
                            return poskus

print(dekodiraj('1a2b3c4d5e$bd6d1961971c08c720e83e821ea2e16b'))
