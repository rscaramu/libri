# Algoritmi - Roberto Scaramuzzino
# Capitolo 25
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import random

def trova_las_vegas(a):
    tentativi = 0
    while True:
        tentativi += 1
        i = random.randrange(len(a))
        if a[i]:
            return i, tentativi

random.seed(16)
n = 1000
sfavorevole = [False] * (n // 2) + [True] * (n // 2)
deterministico = sfavorevole.index(True) + 1
prove = []
for _ in range(10000):
    prove.append(trova_las_vegas(sfavorevole)[1])
print(deterministico)
print(sum(prove) / len(prove), max(prove))


def per_vettore(m, v):
    return [sum(m[i][j] * v[j] for j in range(len(v)))
            for i in range(len(m))]

def freivalds(a, b, c, k=20):
    n = len(a)
    for _ in range(k):
        r = [random.randint(0, 1) for _ in range(n)]
        abr = per_vettore(a, per_vettore(b, r))
        if abr != per_vettore(c, r):
            return False
    return True

def prodotto(a, b):
    n = len(a)
    return [[sum(a[i][k] * b[k][j] for k in range(n))
             for j in range(n)] for i in range(n)]

random.seed(17)
n = 30
def casuale(n):
    return [[random.randint(-9, 9) for _ in range(n)]
            for _ in range(n)]

a, b = casuale(n), casuale(n)
c = prodotto(a, b)
print(freivalds(a, b, c))
c[17][4] += 1               # un solo elemento alterato
print(freivalds(a, b, c))
sfuggiti = sum(freivalds(a, b, c, k=1) for _ in range(2000))
print(sfuggiti / 2000)


import math

def stima_pi(n):
    dentro = 0
    for _ in range(n):
        x, y = random.random(), random.random()
        if x * x + y * y < 1:
            dentro += 1
    return 4 * dentro / n

random.seed(18)
for n in (100, 10000, 1000000):
    stima = stima_pi(n)
    errore = abs(stima - math.pi)
    tipico = 1.64 / n ** 0.5
    print(f'{n:>8} {stima:.5f} {errore:.5f} {tipico:.5f}')
