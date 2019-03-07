class Ulomek:
    def __init__(self, stevec, imenovalec):
        self.prvotni_stevec = stevec
        self.prvotni_imenovalec = imenovalec
        m, n = stevec, imenovalec
        while n != 0:
            m, n = n, m % n
        self.gcd = m

    @property
    def stevec(self):
        return self.prvotni_stevec // self.gcd

    @property
    def imenovalec(self):
        return self.prvotni_imenovalec // self.gcd
    
    @stevec.setter
    def stevec(self, x):
        raise ValueError('Števca ulomka se ne da spreminjati.')
    
    @imenovalec.setter
    def imenovalec(self, x):
        raise ValueError('Imenovalca ulomka se ne da spreminjati.')
    
    def __repr__(self):
        return 'Ulomek({}, {})'.format(self.stevec, self.imenovalec)

    def __add__(self, other):
        a, b = self.stevec, self.imenovalec
        c, d = other.stevec, other.imenovalec
        return Ulomek(a * d + b * c, b * d)
    
    def __eq__(self, other):
        a, b = self.stevec, self.imenovalec
        c, d = other.stevec, other.imenovalec
        return a * d == b * c

assert Ulomek(1, 3) + Ulomek(1, 6) == Ulomek(1, 2)
u = Ulomek(8, 12)
u.stevec = 10
assert u.stevec == 2
assert u.imenovalec == 3
