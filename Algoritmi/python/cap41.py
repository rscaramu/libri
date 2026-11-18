# Algoritmi - Roberto Scaramuzzino
# Capitolo 41
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def cerca_diretto(t, p):
    confronti, posizioni = 0, []
    for i in range(len(t) - len(p) + 1):
        j = 0
        while j < len(p):
            confronti += 1
            if t[i + j] != p[j]:
                break
            j += 1
        if j == len(p):
            posizioni.append(i)
    return posizioni, confronti

def funzione_prefisso(p):
    pi = [0] * len(p)
    k = 0
    for j in range(1, len(p)):
        while k > 0 and p[j] != p[k]:
            k = pi[k - 1]
        if p[j] == p[k]:
            k += 1
        pi[j] = k
    return pi

def cerca_kmp(t, p):
    pi = funzione_prefisso(p)
    posizioni, k, confronti = [], 0, 0
    for i in range(len(t)):
        while k > 0 and t[i] != p[k]:
            confronti += 1
            k = pi[k - 1]
        confronti += 1
        if t[i] == p[k]:
            k += 1
        if k == len(p):
            posizioni.append(i - len(p) + 1)
            k = pi[k - 1]
    return posizioni, confronti

def funzione_z(s):
    n = len(s)
    z = [0] * n
    sin = des = 0
    for i in range(1, n):
        if i < des:
            z[i] = min(des - i, z[i - sin])
        while i + z[i] < n and s[z[i]] == s[i + z[i]]:
            z[i] += 1
        if i + z[i] > des:
            sin, des = i, i + z[i]
    return z

def cerca_z(t, p):
    z = funzione_z(p + '\x00' + t)
    m = len(p)
    return [i - m - 1 for i in range(m + 1, len(z))
            if z[i] == m]

print(funzione_prefisso('abcabd'), funzione_z('aabxaab'))
testo = 'abracadabra abracadabra'
print(cerca_diretto(testo, 'abra')[0])
print(cerca_kmp(testo, 'abra')[0], cerca_z(testo, 'abra'))

cattivo = 'a' * 20000
motivo = 'a' * 200 + 'b'
print(cerca_diretto(cattivo, motivo)[1],
      cerca_kmp(cattivo, motivo)[1])


def cerca_rabin_karp(t, p, q=1000000007, b=256):
    n, m = len(t), len(p)
    if m > n:
        return [], 0
    alto = pow(b, m - 1, q)
    hp = ht = 0
    for i in range(m):
        hp = (hp * b + ord(p[i])) % q
        ht = (ht * b + ord(t[i])) % q
    posizioni, falsi = [], 0
    for i in range(n - m + 1):
        if hp == ht:
            if t[i:i + m] == p:
                posizioni.append(i)
            else:
                falsi += 1
        if i < n - m:
            ht = (ht - ord(t[i]) * alto) % q
            ht = (ht * b + ord(t[i + m])) % q
    return posizioni, falsi

def cerca_horspool(t, p):
    n, m = len(t), len(p)
    salto = {}
    for j in range(m - 1):
        salto[p[j]] = m - 1 - j
    posizioni, letti, i = [], 0, 0
    while i <= n - m:
        j = m - 1
        while j >= 0:
            letti += 1
            if t[i + j] != p[j]:
                break
            j -= 1
        if j < 0:
            posizioni.append(i)
        i += salto.get(t[i + m - 1], m)
    return posizioni, letti

print(cerca_rabin_karp(testo, 'abra'))
print(cerca_rabin_karp(testo, 'abra', q=7))
print(cerca_horspool(testo, 'abra')[0])

frase = ('nel mezzo del cammin di nostra vita mi ritrovai '
         'per una selva oscura che la diritta via era '
         'smarrita ') * 200
for motivo in ('via', 'selva oscura', 'la diritta via era'):
    pos, letti = cerca_horspool(frase, motivo)
    print(len(motivo), len(pos), letti, len(frase))

import random
random.seed(26)
for _ in range(2000):
    t = ''.join(random.choice('ab') for _ in range(30))
    p = ''.join(random.choice('ab')
                for _ in range(random.randint(1, 4)))
    atteso = cerca_diretto(t, p)[0]
    assert cerca_kmp(t, p)[0] == atteso == cerca_z(t, p)
    assert cerca_rabin_karp(t, p, q=11)[0] == atteso
    assert cerca_horspool(t, p)[0] == atteso
print('2000 prove superate')
