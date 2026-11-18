# Algoritmi - Roberto Scaramuzzino
# Capitolo 34
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

conta = 0

def karatsuba(x, y):
    # x, y interi non negativi; base 10 per leggibilita'
    global conta
    if x < 10 or y < 10:
        conta += 1
        return x * y
    m = max(len(str(x)), len(str(y))) // 2
    potenza = 10 ** m
    x1, x0 = divmod(x, potenza)
    y1, y0 = divmod(y, potenza)
    a = karatsuba(x1, y1)
    c = karatsuba(x0, y0)
    b = karatsuba(x1 + x0, y1 + y0) - a - c
    return a * potenza * potenza + b * potenza + c

print(karatsuba(1234, 5678), 1234 * 5678)
import random
random.seed(24)
for cifre in (16, 64, 256):
    x = random.randrange(10 ** (cifre - 1), 10 ** cifre)
    y = random.randrange(10 ** (cifre - 1), 10 ** cifre)
    conta = 0
    assert karatsuba(x, y) == x * y
    print(cifre, conta, cifre * cifre)


def horner(a, x):
    r = 0
    for coefficiente in reversed(a):
        r = r * x + coefficiente
    return r

p = [5, -4, 0, 2]              # 2x^3 - 4x + 5
print(horner(p, 3), 2 * 3 ** 3 - 4 * 3 + 5)

def da_cifre(testo, base=10):
    r = 0
    for c in testo:
        r = r * base + int(c, 36)
    return r

print(da_cifre('2024'), da_cifre('ff', 16))
print(da_cifre('1011', 2))
ore, minuti, secondi = 2, 45, 30
print((ore * 60 + minuti) * 60 + secondi)


def somma_polinomi(a, b):
    n = max(len(a), len(b))
    a = a + [0] * (n - len(a))
    b = b + [0] * (n - len(b))
    return [x + y for x, y in zip(a, b)]

def prodotto_polinomi(a, b):
    c = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            c[i + j] += x * y
    return c

def derivata(a):
    return [i * a[i] for i in range(1, len(a))]

# (x + 1)(x - 1) = x^2 - 1 ;  (1 + x)^4
print(prodotto_polinomi([1, 1], [-1, 1]))
q = [1]
for _ in range(4):
    q = prodotto_polinomi(q, [1, 1])
print(q, derivata(q))


from fractions import Fraction

def lagrange(xs, ys, x):
    totale = 0
    for i in range(len(xs)):
        termine = ys[i]
        for j in range(len(xs)):
            if j != i:
                rapporto = (x - xs[j]) / (xs[i] - xs[j])
                termine = termine * rapporto
        totale += termine
    return totale

xs = [Fraction(v) for v in (0, 1, 2, 3)]
ys = [Fraction(v) for v in (5, 3, 13, 47)]   # 2x^3 - 4x + 5
print(*[lagrange(xs, ys, Fraction(v)) for v in (4, -1)])
print(horner(p, 4), horner(p, -1))

import math
nodi = [i / 10 for i in range(-10, 11)]
runge = [1 / (1 + 25 * v * v) for v in nodi]
vero = 1 / (1 + 25 * 0.95 ** 2)
print(round(vero, 4), round(lagrange(nodi, runge, 0.95), 4))


import cmath

def fft(a, inversa=False):
    n = len(a)
    if n == 1:
        return a[:]
    pari = fft(a[0::2], inversa)
    dispari = fft(a[1::2], inversa)
    segno = -1 if inversa else 1
    y = [0] * n
    for k in range(n // 2):
        w = cmath.exp(segno * 2j * cmath.pi * k / n)
        y[k] = pari[k] + w * dispari[k]
        y[k + n // 2] = pari[k] - w * dispari[k]
    return y

def prodotto_fft(a, b):
    n = 1
    while n < len(a) + len(b) - 1:
        n *= 2
    fa = fft(a + [0] * (n - len(a)))
    fb = fft(b + [0] * (n - len(b)))
    prodotto = fft([x * y for x, y in zip(fa, fb)], True)
    lung = len(a) + len(b) - 1
    return [round(v.real / n) for v in prodotto[:lung]]

a, b = [3, 2, 1], [1, 0, 4, 5]
print(prodotto_fft(a, b), prodotto_polinomi(a, b))

random.seed(25)
a = [random.randint(-50, 50) for _ in range(300)]
b = [random.randint(-50, 50) for _ in range(200)]
print(prodotto_fft(a, b) == prodotto_polinomi(a, b))
