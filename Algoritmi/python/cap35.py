# Algoritmi - Roberto Scaramuzzino
# Capitolo 35
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def binomiale(n, k):
    if k < 0 or k > n:
        return 0
    k = min(k, n - k)
    r = 1
    for i in range(1, k + 1):
        r = r * (n - k + i) // i
    return r

def pascal(n):
    riga = [1]
    righe = [riga]
    for _ in range(n):
        riga = [1] + [riga[i] + riga[i + 1]
                      for i in range(len(riga) - 1)] + [1]
        righe.append(riga)
    return righe

print(binomiale(90, 5), binomiale(90, 6), binomiale(5, 7))
for riga in pascal(5):
    print(riga)

P = 1000000007

def tabelle(n):
    fatt = [1] * (n + 1)
    for i in range(1, n + 1):
        fatt[i] = fatt[i - 1] * i % P
    inv = [1] * (n + 1)
    inv[n] = pow(fatt[n], P - 2, P)
    for i in range(n, 0, -1):
        inv[i - 1] = inv[i] * i % P
    return fatt, inv

fatt, inv = tabelle(100000)

def binomiale_mod(n, k):
    if k < 0 or k > n:
        return 0
    return fatt[n] * inv[k] % P * inv[n - k] % P

print(binomiale_mod(90, 6), binomiale(90, 6) % P)
print(binomiale_mod(100000, 50000))


def catalan(n):
    return binomiale(2 * n, n) // (n + 1)

print([catalan(n) for n in range(8)])
print(binomiale(8 + 8, 8))            # scacchiera 8 x 8
print(binomiale(10 + 3 - 1, 3 - 1))   # 10 caramelle, 3 bimbi

def divisibili(n, primi):
    totale = 0
    for maschera in range(1, 1 << len(primi)):
        prodotto, quanti = 1, 0
        for i, p in enumerate(primi):
            if maschera >> i & 1:
                prodotto *= p
                quanti += 1
        segno = 1 if quanti % 2 == 1 else -1
        totale += segno * (n // prodotto)
    return totale

print(divisibili(100, [2, 3, 5]),
      sum(1 for v in range(1, 101)
          if v % 2 == 0 or v % 3 == 0 or v % 5 == 0))


def permutazione_successiva(a):
    i = len(a) - 2
    while i >= 0 and a[i] >= a[i + 1]:
        i -= 1
    if i < 0:
        return False
    j = len(a) - 1
    while a[j] <= a[i]:
        j -= 1
    a[i], a[j] = a[j], a[i]
    a[i + 1:] = reversed(a[i + 1:])
    return True

a = [1, 2, 2]
elenco = [''.join(map(str, a))]
while permutazione_successiva(a):
    elenco.append(''.join(map(str, a)))
print(elenco)

def combinazione_successiva(c, n):
    k = len(c)
    i = k - 1
    while i >= 0 and c[i] == n - k + i:
        i -= 1
    if i < 0:
        return False
    c[i] += 1
    for j in range(i + 1, k):
        c[j] = c[j - 1] + 1
    return True

c = [0, 1]
elenco = [tuple(c)]
while combinazione_successiva(c, 4):
    elenco.append(tuple(c))
print(elenco)
print([f'{i ^ (i >> 1):03b}' for i in range(8)])


def per_matrice(a, b, m):
    righe, colonne, n = len(a), len(b[0]), len(b)
    c = [[0] * colonne for _ in range(righe)]
    for i in range(righe):
        for j in range(colonne):
            for k in range(n):
                c[i][j] = (c[i][j] + a[i][k] * b[k][j]) % m
    return c

def potenza_matrice(mat, n, m):
    k = len(mat)
    r = [[int(i == j) for j in range(k)] for i in range(k)]
    while n > 0:
        if n % 2 == 1:
            r = per_matrice(r, mat, m)
        mat = per_matrice(mat, mat, m)
        n //= 2
    return r

def fibonacci(n, m=10 ** 30):
    return potenza_matrice([[1, 1], [1, 0]], n, m)[0][1]

def fibonacci_raddoppio(n, m):
    if n == 0:
        return 0, 1
    a, b = fibonacci_raddoppio(n // 2, m)
    c = a * (2 * b - a) % m
    d = (a * a + b * b) % m
    return (d, (c + d) % m) if n % 2 else (c, d)

print([fibonacci(n) for n in range(10)])
print(fibonacci(90))
n = 10 ** 18
print(fibonacci(n, P), fibonacci_raddoppio(n, P)[0])

# tribonacci: T(n) = T(n-1) + T(n-2) + T(n-3)
tri = [[1, 1, 1], [1, 0, 0], [0, 1, 0]]
m = 10 ** 30
print([potenza_matrice(tri, n, m)[0][2] for n in range(10)])
