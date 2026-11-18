# Algoritmi - Roberto Scaramuzzino
# Capitolo 38
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math

def avanti(f, x, h):
    return (f(x + h) - f(x)) / h

def centrata(f, x, h):
    return (f(x + h) - f(x - h)) / (2 * h)

x = 1.0
vero = math.cos(x)                    # derivata del seno
print('    h      avanti    centrata')
for k in (1, 3, 5, 8, 11, 14):
    h = 10.0 ** -k
    ea = abs(avanti(math.sin, x, h) - vero)
    ec = abs(centrata(math.sin, x, h) - vero)
    print(f'1e-{k:<3} {ea:9.1e} {ec:10.1e}')


def trapezi(f, a, b, n):
    h = (b - a) / n
    s = (f(a) + f(b)) / 2
    for i in range(1, n):
        s += f(a + i * h)
    return s * h

def simpson(f, a, b, n):
    if n % 2 == 1:
        raise ValueError('n deve essere pari')
    h = (b - a) / n
    s = f(a) + f(b)
    for i in range(1, n):
        s += (4 if i % 2 == 1 else 2) * f(a + i * h)
    return s * h / 3

vero = 2.0                  # integrale di sen fra 0 e pi
print('    n    trapezi    Simpson')
for n in (4, 8, 16, 32, 64):
    et = abs(trapezi(math.sin, 0, math.pi, n) - vero)
    es = abs(simpson(math.sin, 0, math.pi, n) - vero)
    print(f'{n:>5} {et:10.1e} {es:10.1e}')

def cubica(x):
    return 4 * x ** 3 - 3 * x ** 2 + 1

print(simpson(cubica, 0, 2, 2), trapezi(cubica, 0, 2, 2))


valutazioni = 0

def picco(x):
    global valutazioni
    valutazioni += 1
    return 1 / (1e-8 + (x - 0.3) ** 2)

def simpson_adattivo(f, a, b, tolleranza):
    def passo(a, fa, m, fm, b, fb, tol, livello):
        intero = (b - a) / 6 * (fa + 4 * fm + fb)
        s, d = (a + m) / 2, (m + b) / 2
        fs, fd = f(s), f(d)
        meta = ((m - a) / 6 * (fa + 4 * fs + fm)
                + (b - m) / 6 * (fm + 4 * fd + fb))
        if abs(meta - intero) <= 15 * tol or livello > 40:
            return meta + (meta - intero) / 15
        t, k = tol / 2, livello + 1
        return (passo(a, fa, s, fs, m, fm, t, k)
                + passo(m, fm, d, fd, b, fb, t, k))

    m = (a + b) / 2
    return passo(a, f(a), m, f(m), b, f(b), tolleranza, 0)

esatto = 1e4 * (math.atan(7000) + math.atan(3000))
valutazioni = 0
r = simpson_adattivo(picco, 0, 1, 0.01)
errore = abs(r - esatto) / esatto
print(f'adattivo {errore:.1e} {valutazioni}')
for n in (1000, 10000, 50000):
    valutazioni = 0
    r = simpson(picco, 0, 1, n)
    errore = abs(r - esatto) / esatto
    print(f'uniforme {errore:.1e} {valutazioni}')


def integra_campioni(t, y):
    s = 0.0
    for i in range(1, len(t)):
        s += (y[i] + y[i - 1]) / 2 * (t[i] - t[i - 1])
    return s

# potenza in watt letta a istanti irregolari (secondi)
t = [0, 10, 25, 30, 60, 90, 120]
p = [0, 400, 950, 1000, 1000, 600, 0]
joule = integra_campioni(t, p)
print(joule, round(joule / 3600000, 5))
