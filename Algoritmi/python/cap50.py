# Algoritmi - Roberto Scaramuzzino
# Capitolo 50
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def orientamento(a, b, c):
    return ((b[0] - a[0]) * (c[1] - a[1])
            - (b[1] - a[1]) * (c[0] - a[0]))

def segno(x):
    return (x > 0) - (x < 0)

def area_poligono(p):
    s = 0
    for i in range(len(p)):
        j = (i + 1) % len(p)
        s += p[i][0] * p[j][1] - p[j][0] * p[i][1]
    return s / 2

def sul_segmento(a, b, p):
    return (min(a[0], b[0]) <= p[0] <= max(a[0], b[0])
            and min(a[1], b[1]) <= p[1] <= max(a[1], b[1]))

def si_intersecano(a, b, c, d):
    o1 = segno(orientamento(a, b, c))
    o2 = segno(orientamento(a, b, d))
    o3 = segno(orientamento(c, d, a))
    o4 = segno(orientamento(c, d, b))
    if o1 != o2 and o3 != o4:
        return True
    return ((o1 == 0 and sul_segmento(a, b, c))
            or (o2 == 0 and sul_segmento(a, b, d))
            or (o3 == 0 and sul_segmento(c, d, a))
            or (o4 == 0 and sul_segmento(c, d, b)))

print(orientamento((0, 0), (4, 0), (2, 3)),
      orientamento((0, 0), (4, 0), (2, -3)),
      orientamento((0, 0), (4, 0), (9, 0)))
elle = [(0, 0), (4, 0), (4, 2), (2, 2), (2, 4), (0, 4)]
print(area_poligono(elle), area_poligono(elle[::-1]))
casi = [((0, 0), (4, 4), (0, 4), (4, 0)),      # croce
        ((0, 0), (2, 2), (3, 3), (5, 5)),      # staccati
        ((0, 0), (3, 3), (2, 2), (5, 5)),      # sovrapposti
        ((0, 0), (4, 0), (2, 0), (2, 5)),      # a T
        ((0, 0), (4, 0), (0, 1), (4, 1))]      # paralleli
print([si_intersecano(*c) for c in casi])


def dentro(poligono, q):
    risultato = False
    n = len(poligono)
    for i in range(n):
        a, b = poligono[i], poligono[(i + 1) % n]
        if (a[1] > q[1]) != (b[1] > q[1]):
            # confronto senza divisione: esatto con interi
            t = ((q[0] - a[0]) * (b[1] - a[1])
                 - (q[1] - a[1]) * (b[0] - a[0]))
            if (t < 0) == (b[1] > a[1]):
                risultato = not risultato
    return risultato

for q in ((1, 1), (3, 3), (3, 1), (1, 3), (5, 1), (-1, 2)):
    print(q, dentro(elle, q))

stella = [(0, 3), (1, 1), (3, 1), (1, -1), (2, -3), (0, -2),
          (-2, -3), (-1, -1), (-3, 1), (-1, 1)]
riga = ''
for y in range(3, -4, -1):
    riga += ''.join('#' if dentro(stella, (x + 0.5, y - 0.5))
                    else '.' for x in range(-3, 3)) + '\n'
print(riga, end='')


def inviluppo_convesso(punti):
    punti = sorted(set(punti))
    if len(punti) <= 2:
        return punti

    def meta(sequenza):
        pila = []
        for p in sequenza:
            while len(pila) >= 2:
                if orientamento(pila[-2], pila[-1], p) > 0:
                    break
                pila.pop()
            pila.append(p)
        return pila[:-1]

    return meta(punti) + meta(reversed(punti))

punti = [(0, 0), (2, 1), (4, 0), (3, 2), (4, 4), (2, 3),
         (0, 4), (1, 2), (2, 2), (2, 0), (2, 4)]
inviluppo = inviluppo_convesso(punti)
print(inviluppo, area_poligono(inviluppo))

import random
random.seed(32)
def casuale():
    return random.randint(-1000, 1000)

nuvola = [(casuale(), casuale()) for _ in range(20000)]
bordo = inviluppo_convesso(nuvola)
print(len(bordo), area_poligono(bordo) > 0)
n = len(bordo)
print(all(orientamento(bordo[i], bordo[(i + 1) % n], q) >= 0
          for i in range(n) for q in nuvola[:300]))


import math

def piu_vicini(punti):
    px = sorted(punti)

    def ricorri(p):
        if len(p) <= 3:
            migliore = (math.inf, None, None)
            for i in range(len(p)):
                for j in range(i + 1, len(p)):
                    d = math.dist(p[i], p[j])
                    migliore = min(migliore, (d, p[i], p[j]))
            return migliore, sorted(p, key=lambda q: q[1])
        meta = len(p) // 2
        x_meta = p[meta][0]
        ms, ys = ricorri(p[:meta])
        md, yd = ricorri(p[meta:])
        migliore = min(ms, md)
        # fusione delle due meta', ordinate per y
        per_y, i, j = [], 0, 0
        while i < len(ys) and j < len(yd):
            if ys[i][1] <= yd[j][1]:
                per_y.append(ys[i])
                i += 1
            else:
                per_y.append(yd[j])
                j += 1
        per_y += ys[i:] + yd[j:]
        striscia = [q for q in per_y
                    if abs(q[0] - x_meta) < migliore[0]]
        for i in range(len(striscia)):
            for j in range(i + 1, min(i + 8, len(striscia))):
                d = math.dist(striscia[i], striscia[j])
                migliore = min(migliore, (d, striscia[i],
                                          striscia[j]))
        return migliore, per_y

    return ricorri(px)[0]

def vicini_con_griglia(punti, raggio):
    griglia = {}
    for p in punti:
        casella = (p[0] // raggio, p[1] // raggio)
        griglia.setdefault(casella, []).append(p)
    coppie = 0
    for (cx, cy), contenuto in griglia.items():
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                for q in griglia.get((cx + dx, cy + dy), []):
                    for p in contenuto:
                        if p >= q:
                            continue
                        if math.dist(p, q) <= raggio:
                            coppie += 1
    return coppie

random.seed(33)
def coordinata():
    return random.randint(0, 10 ** 6)

punti = list({(coordinata(), coordinata())
              for _ in range(3000)})
d, a, b = piu_vicini(punti)
forza = min(math.dist(p, q) for i, p in enumerate(punti)
            for q in punti[i + 1:])
print(round(d, 3), d == forza, a, b)
ingenuo = sum(1 for i, p in enumerate(punti)
              for q in punti[i + 1:]
              if math.dist(p, q) <= 5000)
print(vicini_con_griglia(punti, 5000), ingenuo)
