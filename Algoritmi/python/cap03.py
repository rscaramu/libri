# Algoritmi - Roberto Scaramuzzino
# Capitolo 3
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def massimo(a):
    assert len(a) > 0, 'sequenza vuota'
    m = a[0]
    for i in range(1, len(a)):
        assert m == max(a[:i])      # invariante
        if a[i] > m:
            m = a[i]
    return m

print(massimo([4, 8, 1, 8, 3]))
try:
    massimo([])
except AssertionError as e:
    print('precondizione violata:', e)


def mcd(a, b):
    while b != 0:
        r = a % b
        assert 0 <= r < b           # la variante diminuisce
        a, b = b, r
    return a

print(mcd(1071, 462), mcd(17, 0), mcd(0, 17))


def potenza(b, e):
    if e == 0:
        return 1
    return b * potenza(b, e - 1)

print(potenza(2, 10), potenza(5, 0), potenza(-3, 3))


def ricerca_binaria(a, x):
    basso, alto = 0, len(a) - 1
    while basso <= alto:
        medio = basso + (alto - basso) // 2
        if a[medio] == x:
            return medio
        if a[medio] < x:
            basso = medio + 1
        else:
            alto = medio - 1
    return -1

dati = [2, 5, 8, 12, 16, 23, 38]
print(ricerca_binaria(dati, 23), ricerca_binaria(dati, 7))
print(ricerca_binaria([], 1), ricerca_binaria([4], 4))


import random

def oracolo(a, x):
    for i in range(len(a)):
        if a[i] == x:
            return i
    return -1

random.seed(1)
for _ in range(2000):
    n = random.randint(0, 12)
    a = sorted(random.sample(range(40), n))
    x = random.randint(-1, 40)
    assert ricerca_binaria(a, x) == oracolo(a, x), (a, x)
print('2000 prove superate')
