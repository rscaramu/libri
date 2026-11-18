# Algoritmi - Roberto Scaramuzzino
# Capitolo 47
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

class Congruenziale:
    def __init__(self, seme):
        self.stato = seme
        self.a, self.c, self.m = 1103515245, 12345, 2 ** 31

    def prossimo(self):
        self.stato = (self.a * self.stato + self.c) % self.m
        return self.stato

g = Congruenziale(42)
valori = [g.prossimo() for _ in range(8)]
print(valori[:3])
print([v & 1 for v in valori], [v >> 30 for v in valori])

def xorshift64(x):
    x ^= x << 13 & 0xFFFFFFFFFFFFFFFF
    x ^= x >> 7
    x ^= x << 17 & 0xFFFFFFFFFFFFFFFF
    return x

x = 88172645463325252
uscite = []
for _ in range(100000):
    x = xorshift64(x)
    uscite.append(x >> 61)             # i tre bit piu' alti
print([uscite.count(k) for k in range(8)])


import random
from collections import Counter

def tre_bit():
    return random.getrandbits(3)       # da 0 a 7

def dado_distorto():
    return tre_bit() % 6

def dado_corretto():
    while True:
        x = tre_bit()
        if x < 6:
            return x

random.seed(27)
prove = 60000
a = Counter(dado_distorto() for _ in range(prove))
b = Counter(dado_corretto() for _ in range(prove))
print([a[k] for k in range(6)])
print([b[k] for k in range(6)])


def mescola(a):
    for i in range(len(a) - 1, 0, -1):
        j = random.randint(0, i)
        a[i], a[j] = a[j], a[i]

def mescola_sbagliato(a):
    for i in range(len(a)):
        j = random.randint(0, len(a) - 1)
        a[i], a[j] = a[j], a[i]

random.seed(28)
for funzione in (mescola, mescola_sbagliato):
    conta = Counter()
    for _ in range(60000):
        a = ['a', 'b', 'c']
        funzione(a)
        conta[''.join(a)] += 1
    print(funzione.__name__)
    print(' '.join(f'{p}:{conta[p]}' for p in sorted(conta)))


def serbatoio(flusso, k):
    s = []
    for i, x in enumerate(flusso, start=1):
        if i <= k:
            s.append(x)
        else:
            j = random.randint(1, i)
            if j <= k:
                s[j - 1] = x
    return s

random.seed(29)
print(sorted(serbatoio(range(1000000), 5)))
conta = Counter()
for _ in range(20000):
    conta.update(serbatoio(iter('abcdefghij'), 3))
print([conta[c] for c in 'abcdefghij'])


import bisect
import itertools
import math

def scelta_pesata(elementi, pesi):
    cumulate = list(itertools.accumulate(pesi))
    def estrai():
        r = random.random() * cumulate[-1]
        return elementi[bisect.bisect_right(cumulate, r)]
    return estrai

random.seed(30)
estrai = scelta_pesata(['A', 'B', 'C'], [1, 2, 7])
conta = Counter(estrai() for _ in range(100000))
print(conta['A'], conta['B'], conta['C'])

def esponenziale(media):
    return -media * math.log(1 - random.random())

def normale():
    u, v = 1 - random.random(), random.random()
    r = math.sqrt(-2 * math.log(u))
    return r * math.cos(2 * math.pi * v)

attese = [esponenziale(5.0) for _ in range(100000)]
print(round(sum(attese) / len(attese), 2))
z = [normale() for _ in range(100000)]
media = sum(z) / len(z)
varianza = sum((v - media) ** 2 for v in z) / len(z)
entro = sum(1 for v in z if abs(v) < 1) / len(z)
print(round(media, 2) + 0.0, round(varianza, 2),
      round(entro, 3))
