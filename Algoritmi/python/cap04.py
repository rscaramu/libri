# Algoritmi - Roberto Scaramuzzino
# Capitolo 4
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def ricerca_lineare(a, x):
    confronti = 0
    for i in range(len(a)):
        confronti += 1
        if a[i] == x:
            return i, confronti
    return -1, confronti

dati = list(range(100, 200))
print(ricerca_lineare(dati, 100))
print(ricerca_lineare(dati, 199))
print(ricerca_lineare(dati, 7))


import math

titoli = ('n', 'log n', 'n log n', 'n^2', '2^n')
print('{:>6} {:>6} {:>9} {:>8} {:>10}'.format(*titoli))
fmt = '{:>6} {:>6.1f} {:>9.0f} {:>8} {:>10}'
for n in (10, 20, 50, 100, 1000):
    lg = math.log2(n)
    due = f'{2 ** n:.1e}'
    print(fmt.format(n, lg, n * lg, n * n, due))


import math

budget = 10 ** 8

def massimo_n(costo):
    n = 1
    while costo(2 * n) <= budget:
        n *= 2
    passo = n
    while passo >= 1:
        if costo(n + passo) <= budget:
            n += passo
        passo //= 2
    return n

classi = [
    ('n', lambda n: n),
    ('n log n', lambda n: n * math.log2(n)),
    ('n^2', lambda n: n ** 2),
    ('n^3', lambda n: n ** 3),
    ('2^n', lambda n: 2 ** n),
]
for nome, costo in classi:
    print(f'{nome:<8} {massimo_n(costo)}')


def somma_coppie(n):
    passi = 0
    for i in range(n):
        for j in range(n):
            passi += 1
    return passi

def coppie_ordinate(n):
    passi = 0
    for i in range(n - 1):
        for j in range(i + 1, n):
            passi += 1
    return passi

def dimezza(n):
    passi = 0
    while n > 1:
        n //= 2
        passi += 1
    return passi

for n in (10, 100, 1000):
    print(n, somma_coppie(n), coppie_ordinate(n), dimezza(n))


def senza_ripetizioni(a):
    risultato = []
    for x in a:
        if x not in risultato:      # ricerca lineare!
            risultato.append(x)
    return risultato

def senza_ripetizioni_veloce(a):
    visti = set()
    risultato = []
    for x in a:
        if x not in visti:          # tempo costante in media
            visti.add(x)
            risultato.append(x)
    return risultato

dati = [3, 1, 3, 2, 1, 5]
print(senza_ripetizioni(dati))
print(senza_ripetizioni_veloce(dati))
