import random

class Student:
    fakulteta = 'FMF'
    def __init__(self):
        self.vpisna = random.randint(27160000, 27169999)

    def obicajna(*args, **kwargs):
        print('obicajna')
        print(args)
        print(kwargs)

    @staticmethod
    def staticna(*args, **kwargs):
        print('staticna')
        print(args)
        print(kwargs)

    @classmethod
    def razredna(*args, **kwargs):
        print('razredna')
        print(args)
        print(kwargs)

s = Student()
# s.obicajna(1, 2, a=3, b=4)  --> Student.obicajna(s, 1, 2, a=3, b=4)
# s.staticna(1, 2, a=3, b=4)  --> Student.staticna(1, 2, a=3, b=4)
# s.razredna(1, 2, a=3, b=4)  --> Student.razredna(Student, 1, 2, a=3, b=4)