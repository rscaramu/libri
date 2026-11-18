# Algoritmi - Roberto Scaramuzzino
# Capitolo 36
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math

def bisezione(f, a, b, tolleranza=1e-12):
    fa = f(a)
    if fa * f(b) > 0:
        raise ValueError('nessun cambio di segno')
    passi = 0
    while b - a > tolleranza:
        m = a + (b - a) / 2
        fm = f(m)
        passi += 1
        if fm == 0:
            return m, passi
        if (fa > 0) == (fm > 0):
            a, fa = m, fm
        else:
            b = m
    return a + (b - a) / 2, passi

def newton(f, df, x, tolleranza=1e-12, massimo=50):
    for passi in range(1, massimo + 1):
        d = df(x)
        if d == 0:
            raise ZeroDivisionError('derivata nulla')
        passo = f(x) / d
        x -= passo
        if abs(passo) <= tolleranza * max(1.0, abs(x)):
            return x, passi
    raise RuntimeError('mancata convergenza')

def f(x):
    return x * x - 2

print(bisezione(f, 1, 2))
print(newton(f, lambda x: 2 * x, 1.0))
print(math.sqrt(2))

x = 1.0
for _ in range(5):
    x = (x + 2 / x) / 2
    print(f'{x:.15f} {abs(x - math.sqrt(2)):.1e}')

def radice_intera(n):
    if n < 2:
        return n
    # stima iniziale per eccesso
    x = 1 << ((n.bit_length() + 1) // 2)
    while True:
        y = (x + n // x) // 2
        if y >= x:
            return x
        x = y

print(radice_intera(10 ** 40 + 12345), radice_intera(99))


def secanti(f, x0, x1, tolleranza=1e-12, massimo=100):
    f0, f1 = f(x0), f(x1)
    for passi in range(1, massimo + 1):
        if f1 == f0:
            raise ZeroDivisionError('secante orizzontale')
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0)
        if abs(x2 - x1) <= tolleranza * max(1.0, abs(x2)):
            return x2, passi
        x0, f0, x1, f1 = x1, f1, x2, f(x2)
    raise RuntimeError('mancata convergenza')

def newton_sicuro(f, df, a, b, tolleranza=1e-12):
    fa = f(a)
    x = (a + b) / 2
    for passi in range(1, 200):
        fx = f(x)
        if (fa > 0) == (fx > 0):
            a, fa = x, fx
        else:
            b = x
        d = df(x)
        nuovo = x - fx / d if d != 0 else a
        if not a < nuovo < b:
            nuovo = (a + b) / 2          # bisezione
        soglia = tolleranza * max(1.0, abs(nuovo))
        if abs(nuovo - x) <= soglia:
            return nuovo, passi
        x = nuovo
    raise RuntimeError('mancata convergenza')

def g(x):
    return math.cos(x) - x

def dg(x):
    return -math.sin(x) - 1

print(bisezione(g, 0, 1))
print(secanti(g, 0.0, 1.0))
print(newton(g, dg, 1.0))

def h(x):
    return math.atan(x)

def dh(x):
    return 1 / (1 + x * x)

try:
    newton(h, dh, 2.0)
except (RuntimeError, OverflowError, ZeroDivisionError) as e:
    print('Newton da 2.0:', type(e).__name__)
print(newton_sicuro(h, dh, -3.0, 2.0))
