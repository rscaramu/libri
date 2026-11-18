# Algoritmi - Roberto Scaramuzzino
# Capitolo 40
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math

def sezione_aurea(f, a, b, tolleranza=1e-8):
    r = (math.sqrt(5) - 1) / 2
    c, d = b - r * (b - a), a + r * (b - a)
    fc, fd = f(c), f(d)
    valutazioni = 2
    while b - a > tolleranza:
        if fc < fd:
            b, d, fd = d, c, fc
            c = b - r * (b - a)
            fc = f(c)
        else:
            a, c, fc = c, d, fd
            d = a + r * (b - a)
            fd = f(d)
        valutazioni += 1
    return (a + b) / 2, valutazioni

def costo_lattina(raggio):
    # superficie di un cilindro da 330 cm3, in cm2
    altezza = 330 / (math.pi * raggio ** 2)
    return 2 * math.pi * raggio * (raggio + altezza)

r, n = sezione_aurea(costo_lattina, 1, 10)
h = 330 / (math.pi * r * r)
print(round(r, 4), round(h, 4), round(h / (2 * r), 4), n)


def discesa(grad, x, alfa, tolleranza=1e-8, massimo=100000):
    for passo in range(massimo):
        g = grad(x)
        if math.sqrt(sum(v * v for v in g)) <= tolleranza:
            return x, passo
        x = [xi - alfa * gi for xi, gi in zip(x, g)]
        if any(abs(v) > 1e100 for v in x):
            return None, passo          # divergenza
    return x, massimo

# f(x, y) = (x - 3)^2 + 10 (y + 1)^2 : minimo in (3, -1)
def gradiente(p):
    return [2 * (p[0] - 3), 20 * (p[1] + 1)]

for alfa in (0.001, 0.01, 0.09, 0.11):
    x, passi = discesa(gradiente, [0.0, 0.0], alfa)
    if x is None:
        print(alfa, 'diverge dopo', passi, 'passi')
    else:
        print(alfa, [round(v, 5) for v in x], passi)

# stessa funzione con la valle 100 volte piu' ripida
def gradiente_stretto(p):
    return [2 * (p[0] - 3), 2000 * (p[1] + 1)]

x, passi = discesa(gradiente_stretto, [0.0, 0.0], 0.0009)
print([round(v, 5) for v in x], passi)


def retta_minimi_quadrati(xs, ys):
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    sxx = sum((x - mx) ** 2 for x in xs)
    syy = sum((y - my) ** 2 for y in ys)
    m = sxy / sxx
    q = my - m * mx
    r2 = sxy * sxy / (sxx * syy)
    return m, q, r2

# tensione (V) e corrente (mA) misurate su un resistore
tensione = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
corrente = [2.1, 4.3, 6.2, 8.6, 10.4, 12.9]
m, q, r2 = retta_minimi_quadrati(tensione, corrente)
print(round(m, 4), round(q, 4), round(r2, 5))
print(round(1000 / m, 1), 'ohm')

# scarica di un condensatore: v = v0 * exp(-t / tau)
t = [0, 1, 2, 3, 4, 5]
v = [5.02, 3.03, 1.86, 1.11, 0.68, 0.41]
m, q, _ = retta_minimi_quadrati(t, [math.log(x) for x in v])
print(round(-1 / m, 3), round(math.exp(q), 3))


def simplesso(c, a, b):
    m, n = len(a), len(c)
    t = [a[i] + [float(i == k) for k in range(m)] + [b[i]]
         for i in range(m)]
    t.append([-v for v in c] + [0.0] * (m + 1))
    base = [n + i for i in range(m)]
    while True:
        j = min(range(n + m), key=lambda k: t[m][k])
        if t[m][j] >= -1e-12:
            break
        righe = [i for i in range(m) if t[i][j] > 1e-12]
        if not righe:
            raise ValueError('problema illimitato')
        i = min(righe, key=lambda r: t[r][-1] / t[r][j])
        perno = t[i][j]
        t[i] = [v / perno for v in t[i]]
        for r in range(m + 1):
            if r != i and t[r][j] != 0:
                f = t[r][j]
                t[r] = [v - f * w for v, w in zip(t[r], t[i])]
        base[i] = j
    x = [0.0] * n
    for i, var in enumerate(base):
        if var < n:
            x[var] = t[i][-1]
    return x, t[m][-1]

# guadagno 30 per tavolo, 20 per sedia
# legno:    4 per tavolo, 3 per sedia, disponibili 240
# lavoro:   2 per tavolo, 1 per sedia, disponibili 100
# vernice:  1 per sedia,               disponibili 60
x, guadagno = simplesso([30.0, 20.0],
                        [[4.0, 3.0], [2.0, 1.0], [0.0, 1.0]],
                        [240.0, 100.0, 60.0])
print([round(v, 4) for v in x], round(guadagno, 4))
