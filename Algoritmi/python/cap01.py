# Algoritmi - Roberto Scaramuzzino
# Capitolo 1
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def massimo(a):
    m = a[0]
    for i in range(1, len(a)):
        if a[i] > m:
            m = a[i]
    return m

print(massimo([7, 3, 9, 4]))


def mcd_sottrazioni(a, b):
    passi = 0
    while a != b:
        if a > b:
            a = a - b
        else:
            b = b - a
        passi += 1
    return a, passi

def mcd(a, b):
    passi = 0
    while b != 0:
        a, b = b, a % b
        passi += 1
    return a, passi

for a, b in [(48, 36), (1071, 462), (1000000, 1)]:
    print(a, b, mcd_sottrazioni(a, b), mcd(a, b))


def duplicati_coppie(a):
    confronti = 0
    n = len(a)
    for i in range(n - 1):
        for j in range(i + 1, n):
            confronti += 1
            if a[i] == a[j]:
                return True, confronti
    return False, confronti

def duplicati_insieme(a):
    visti = set()
    ricerche = 0
    for x in a:
        ricerche += 1
        if x in visti:
            return True, ricerche
        visti.add(x)
    return False, ricerche

for n in (10, 1000, 100000):
    if n <= 1000:
        c = duplicati_coppie(list(range(n)))[1]
    else:
        c = n * (n - 1) // 2
    r = duplicati_insieme(list(range(n)))[1]
    print(n, c, r)
