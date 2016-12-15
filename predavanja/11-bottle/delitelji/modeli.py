def delitelji(n):
    koren_n = int(n ** 0.5)
    mali_delitelji = [1]
    veliki_delitelji = [n]
    for d in range(2, koren_n):
        if n % d == 0:
            mali_delitelji.append(d)
            veliki_delitelji.append(n // d)
    if koren_n ** 2 == n:
        mali_delitelji.append(koren_n)
    return mali_delitelji + veliki_delitelji[::-1]
