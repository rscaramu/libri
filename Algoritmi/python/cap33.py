# Algoritmi - Roberto Scaramuzzino
# Capitolo 33
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def primo_per_divisioni(n):
    if n < 2:
        return False
    if n < 4:
        return True
    if n % 2 == 0:
        return False
    d = 3
    while d * d <= n:
        if n % d == 0:
            return False
        d += 2
    return True

def crivello(n):
    primo = [True] * (n + 1)
    primo[0:2] = [False, False]
    p = 2
    while p * p <= n:
        if primo[p]:
            for m in range(p * p, n + 1, p):
                primo[m] = False
        p += 1
    return [i for i in range(n + 1) if primo[i]]

print(crivello(50))
primi = crivello(1000000)
print(len(primi), primi[-1])
attesi = [n for n in range(2000) if primo_per_divisioni(n)]
print(crivello(1999) == attesi)


def fattorizza(n):
    fattori = []
    d = 2
    while d * d <= n:
        while n % d == 0:
            fattori.append(d)
            n //= d
        d += 1 if d == 2 else 2
    if n > 1:
        fattori.append(n)
    return fattori

for n in (360, 97, 1001, 2 ** 32 - 1, 600851475143):
    print(n, fattorizza(n))


import random

BASI = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)

def testimone_composto(a, d, s, n):
    x = pow(a, d, n)
    if x == 1 or x == n - 1:
        return False
    for _ in range(s - 1):
        x = x * x % n
        if x == n - 1:
            return False
    return True

def e_primo(n, k=40):
    if n < 2:
        return False
    for p in BASI:
        if n % p == 0:
            return n == p
    d, s = n - 1, 0
    while d % 2 == 0:
        d //= 2
        s += 1
    if n < 318665857834031151167461:
        basi = BASI                   # risposta certa
    else:
        basi = [random.randrange(2, n - 1) for _ in range(k)]
    for a in basi:
        if testimone_composto(a, d, s, n):
            return False
    return True

print(all(e_primo(n) == primo_per_divisioni(n)
          for n in range(20000)))
print(e_primo(561), pow(2, 560, 561))       # Carmichael
print(e_primo(2 ** 61 - 1), e_primo(2 ** 61 + 1))
print(e_primo(2 ** 127 - 1), e_primo(2 ** 127 + 1))

def primo_casuale(bit):
    while True:
        n = random.getrandbits(bit) | (1 << (bit - 1)) | 1
        if e_primo(n):
            return n

random.seed(21)
p = primo_casuale(256)
print(len(str(p)), e_primo(p))


from math import gcd

def pollard_rho(n):
    if n % 2 == 0:
        return 2
    while True:
        c = random.randrange(1, n)
        x = y = random.randrange(n)
        d = 1
        while d == 1:
            x = (x * x + c) % n
            y = (y * y + c) % n
            y = (y * y + c) % n
            d = gcd(abs(x - y), n)
        if d != n:
            return d

def fattori_primi(n):
    if n == 1:
        return []
    if e_primo(n):
        return [n]
    d = pollard_rho(n)
    return sorted(fattori_primi(d) + fattori_primi(n // d))

random.seed(22)
print(fattori_primi(8051))
print(fattori_primi(2 ** 64 + 1))
n = 1000000007 * 998244353
print(fattori_primi(n))
print(fattori_primi(600851475143) == fattorizza(600851475143))


def inverso(a, m):
    return pow(a, -1, m)

random.seed(23)
p, q = primo_casuale(32), primo_casuale(32)
n = p * q
phi = (p - 1) * (q - 1)
e = 65537
d = inverso(e, phi)

messaggio = int.from_bytes(b'primi', 'big')
cifrato = pow(messaggio, e, n)
decifrato = pow(cifrato, d, n)
print(cifrato != messaggio, decifrato == messaggio)
print(decifrato.to_bytes(5, 'big'))
print(sorted(fattori_primi(n)) == sorted([p, q]))
