import time

def naredi_funkcijo_ki_sama_stopa(f):
    def f_ki_tudi_sam_stopa(x):
        cas_zacetka = time.time()
        y = f(x)
        cas_konca = time.time()
        print(f'{1000 * (cas_konca - cas_zacetka):.2f} ms')
        return y
    return f_ki_tudi_sam_stopa

@naredi_funkcijo_ki_sama_stopa
def vsota_pocasna(n):
    vsota = 0
    for i in range(n + 1):
        vsota += i
    return vsota

@naredi_funkcijo_ki_sama_stopa
def vsota_hitra(n):
    vsota = (n * (n + 1)) // 2 
    return vsota

def stopaj_klic(f, x):
    cas_zacetka = time.time()
    y = f(x)
    cas_konca = time.time()
    print(f'{1000 * (cas_konca - cas_zacetka):.2f} ms')
    return y

# print(stopaj_klic(vsota_pocasna, 10 ** 6))
# print(stopaj_klic(vsota_hitra, 10 ** 6))
# print(stopaj_klic(vsota_pocasna, 10 ** 7))
# print(stopaj_klic(vsota_hitra, 10 ** 7))

print(vsota_pocasna(10 ** 6))
print(vsota_hitra(10 ** 6))
print(vsota_pocasna(10 ** 7))
print(vsota_hitra(10 ** 7))
