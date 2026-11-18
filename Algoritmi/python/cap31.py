# Algoritmi - Roberto Scaramuzzino
# Capitolo 31
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

print(0.1 + 0.2)
print(0.1 + 0.2 == 0.3)
print(f'{0.1:.20f}')
print(0.5 + 0.25 == 0.75)

totale = 0.0
for _ in range(10):
    totale += 0.1
print(totale, totale == 1.0)
print(2.0 ** 53, 2.0 ** 53 + 1.0)


import sys

eps = 1.0
while 1.0 + eps / 2 > 1.0:
    eps /= 2
print(eps, eps == sys.float_info.epsilon, eps == 2 ** -52)
print(1.0 + eps > 1.0, 1.0 + eps / 2 > 1.0)


import math

def quasi_uguali(a, b, rel=1e-9, ass=0.0):
    return abs(a - b) <= max(rel * max(abs(a), abs(b)), ass)

print(quasi_uguali(0.1 + 0.2, 0.3))
print(math.isclose(0.1 + 0.2, 0.3))
print(math.isclose(1e-12, 0.0), math.isclose(1e-12, 0.0,
                                             abs_tol=1e-9))
print(math.isclose(1e20 + 1e5, 1e20))


def secondo_grado_ingenuo(a, b, c):
    d = math.sqrt(b * b - 4 * a * c)
    return (-b + d) / (2 * a), (-b - d) / (2 * a)

def secondo_grado(a, b, c):
    d = math.sqrt(b * b - 4 * a * c)
    q = -(b + d) / 2 if b >= 0 else -(b - d) / 2
    return q / a, c / q

# soluzioni vere: circa -1e8 e -1e-8
print(secondo_grado_ingenuo(1, 1e8, 1))
print(secondo_grado(1, 1e8, 1))


def somma_semplice(a):
    somma = 0.0
    for x in a:
        somma += x
    return somma

def somma_kahan(a):
    somma = c = 0.0
    for x in a:
        y = x - c
        t = somma + y
        c = (t - somma) - y
        somma = t
    return somma

dati = [0.1] * 1000000
print(somma_semplice(dati))
print(somma_kahan(dati))
print(math.fsum(dati), sum(dati))

misti = [1e16, 1.0, 1.0, 1.0, 1.0, -1e16]
print(somma_semplice(misti), somma_kahan(misti))
print(somma_semplice(sorted(misti, key=abs)))
print(math.fsum(misti))


grande = 1e308
print(grande * 10, -grande * 10)
nan = float('inf') - float('inf')
print(nan, nan == nan, math.isnan(nan))
print(sorted([3.0, nan, 1.0]) == sorted([1.0, 3.0, nan]))
print(math.hypot(3e200, 4e200), 1e-320, 1e-330)


from decimal import Decimal
from fractions import Fraction

print(Decimal('0.10') + Decimal('0.20') == Decimal('0.30'))
print(sum([Fraction(1, 10)] * 10) == 1)
print(Fraction(1, 3) + Fraction(1, 6))
prezzo_centesimi = 1999
print(3 * prezzo_centesimi, 19.99 * 100, int(19.99 * 100))
