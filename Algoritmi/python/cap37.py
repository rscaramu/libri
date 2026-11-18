# Algoritmi - Roberto Scaramuzzino
# Capitolo 37
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def gauss(a, b):
    n = len(a)
    a = [riga[:] for riga in a]       # lavora su copie
    b = b[:]
    for k in range(n):
        p = max(range(k, n), key=lambda i: abs(a[i][k]))
        if abs(a[p][k]) < 1e-12:
            raise ValueError('matrice singolare')
        a[k], a[p] = a[p], a[k]
        b[k], b[p] = b[p], b[k]
        for i in range(k + 1, n):
            m = a[i][k] / a[k][k]
            for j in range(k, n):
                a[i][j] -= m * a[k][j]
            b[i] -= m * b[k]
    x = [0.0] * n
    for i in range(n - 1, -1, -1):
        resto = range(i + 1, n)
        s = b[i] - sum(a[i][j] * x[j] for j in resto)
        x[i] = s / a[i][i]
    return x

covoni = [[3, 2, 1], [2, 3, 1], [1, 2, 3]]
misure = [39, 34, 26]
print(gauss(covoni, misure))

def gauss_senza_perno(a, b):
    n = len(a)
    a = [riga[:] for riga in a]
    b = b[:]
    for k in range(n):
        for i in range(k + 1, n):
            m = a[i][k] / a[k][k]
            for j in range(k, n):
                a[i][j] -= m * a[k][j]
            b[i] -= m * b[k]
    x = [0.0] * n
    for i in range(n - 1, -1, -1):
        resto = range(i + 1, n)
        s = b[i] - sum(a[i][j] * x[j] for j in resto)
        x[i] = s / a[i][i]
    return x

# la soluzione vera e' circa (1, 1)
piccolo = [[1e-20, 1.0], [1.0, 1.0]]
print(gauss_senza_perno(piccolo, [1.0, 2.0]))
print(gauss(piccolo, [1.0, 2.0]))


def fattorizza_lu(a):
    n = len(a)
    lu = [riga[:] for riga in a]
    perm = list(range(n))
    segno = 1
    for k in range(n):
        p = max(range(k, n), key=lambda i: abs(lu[i][k]))
        if lu[p][k] == 0:
            raise ValueError('matrice singolare')
        if p != k:
            lu[k], lu[p] = lu[p], lu[k]
            perm[k], perm[p] = perm[p], perm[k]
            segno = -segno
        for i in range(k + 1, n):
            lu[i][k] /= lu[k][k]
            for j in range(k + 1, n):
                lu[i][j] -= lu[i][k] * lu[k][j]
    return lu, perm, segno

def risolvi_lu(lu, perm, b):
    n = len(lu)
    y = [0.0] * n
    for i in range(n):                 # in avanti, con L
        y[i] = b[perm[i]] - sum(lu[i][j] * y[j]
                                for j in range(i))
    x = [0.0] * n
    for i in range(n - 1, -1, -1):     # all'indietro, con U
        resto = range(i + 1, n)
        s = y[i] - sum(lu[i][j] * x[j] for j in resto)
        x[i] = s / lu[i][i]
    return x

def determinante(a):
    try:
        lu, _, segno = fattorizza_lu(a)
    except ValueError:
        return 0.0
    d = segno
    for i in range(len(a)):
        d *= lu[i][i]
    return d

lu, perm, segno = fattorizza_lu(covoni)
for b in ([39, 34, 26], [6, 6, 6], [1, 0, 0]):
    print([round(v, 4) for v in risolvi_lu(lu, perm, b)])
print(round(determinante(covoni), 6))
print(determinante([[1, 2], [2, 4]]))


from fractions import Fraction

def hilbert(n, esatta=False):
    uno = Fraction(1) if esatta else 1.0
    return [[uno / (i + j + 1) for j in range(n)]
            for i in range(n)]

def gauss_esatto(a, b):
    n = len(a)
    a = [riga[:] for riga in a]
    b = b[:]
    for k in range(n):
        p = next(i for i in range(k, n) if a[i][k] != 0)
        a[k], a[p] = a[p], a[k]
        b[k], b[p] = b[p], b[k]
        for i in range(k + 1, n):
            m = a[i][k] / a[k][k]
            for j in range(k, n):
                a[i][j] -= m * a[k][j]
            b[i] -= m * b[k]
    x = [0] * n
    for i in range(n - 1, -1, -1):
        resto = range(i + 1, n)
        s = b[i] - sum(a[i][j] * x[j] for j in resto)
        x[i] = s / a[i][i]
    return x

for n in (4, 8, 10, 12):
    h = hilbert(n)
    b = [sum(riga) for riga in h]      # soluzione: tutti 1
    try:
        x = gauss(h, b)
        errore = max(abs(v - 1) for v in x)
        print(n, f'{errore:.1e}')
    except ValueError as e:
        print(n, e)

n = 12
h = hilbert(n, esatta=True)
b = [sum(riga) for riga in h]
print(gauss_esatto(h, b) == [1] * n)


def gauss_seidel(a, b, tolleranza=1e-10, massimo=500):
    n = len(a)
    x = [0.0] * n
    for passo in range(1, massimo + 1):
        variazione = 0.0
        for i in range(n):
            s = b[i] - sum(a[i][j] * x[j]
                           for j in range(n) if j != i)
            nuovo = s / a[i][i]
            variazione = max(variazione, abs(nuovo - x[i]))
            x[i] = nuovo
        if variazione <= tolleranza:
            return x, passo
    raise RuntimeError('mancata convergenza')

dominante = [[10, 2, 1], [1, 5, 1], [2, 3, 10]]
termini = [7, -8, 6]
x, passi = gauss_seidel(dominante, termini)
print([round(v, 8) for v in x], passi)
print([round(v, 8) for v in gauss(dominante, termini)])
try:
    gauss_seidel([[1, 3], [4, 1]], [1, 1], massimo=40)
except RuntimeError as e:
    print(e)
