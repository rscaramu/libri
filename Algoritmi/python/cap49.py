# Algoritmi - Roberto Scaramuzzino
# Capitolo 49
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

class Nodo:
    def __init__(self, chiave=None, valore=None):
        self.chiave, self.valore = chiave, valore
        self.prec = self.succ = self

class CacheLRU:
    def __init__(self, capacita):
        self.capacita = capacita
        self.tabella = {}
        self.sentinella = Nodo()      # succ: piu' recente
        self.successi = self.fallimenti = 0

    def _stacca(self, nodo):
        nodo.prec.succ = nodo.succ
        nodo.succ.prec = nodo.prec

    def _in_testa(self, nodo):
        s = self.sentinella
        nodo.prec, nodo.succ = s, s.succ
        s.succ.prec = nodo
        s.succ = nodo

    def leggi(self, chiave):
        nodo = self.tabella.get(chiave)
        if nodo is None:
            self.fallimenti += 1
            return None
        self.successi += 1
        self._stacca(nodo)
        self._in_testa(nodo)
        return nodo.valore

    def scrivi(self, chiave, valore):
        nodo = self.tabella.get(chiave)
        if nodo is not None:
            nodo.valore = valore
            self._stacca(nodo)
        else:
            if len(self.tabella) == self.capacita:
                vecchio = self.sentinella.prec
                self._stacca(vecchio)
                del self.tabella[vecchio.chiave]
            nodo = Nodo(chiave, valore)
            self.tabella[chiave] = nodo
        self._in_testa(nodo)

    def chiavi(self):
        elenco, nodo = [], self.sentinella.succ
        while nodo is not self.sentinella:
            elenco.append(nodo.chiave)
            nodo = nodo.succ
        return elenco

c = CacheLRU(3)
for k in 'abc':
    c.scrivi(k, k.upper())
print(c.chiavi())
print(c.leggi('a'), c.chiavi())
c.scrivi('d', 'D')                   # esce b, il meno recente
print(c.chiavi(), c.leggi('b'))


import random
from functools import lru_cache

random.seed(31)
elementi = list(range(1, 10001))
pesi = [1 / k for k in elementi]     # pochi molto richiesti
richieste = random.choices(elementi, pesi, k=50000)
for capacita in (10, 100, 1000):
    c = CacheLRU(capacita)
    for r in richieste:
        if c.leggi(r) is None:
            c.scrivi(r, r)
    print(capacita, round(c.successi / len(richieste), 3))

chiamate = 0

@lru_cache(maxsize=128)
def lento(n):
    global chiamate
    chiamate += 1
    return sum(i * i for i in range(n))

for r in richieste[:5000]:
    lento(r % 200)
print(chiamate, lento.cache_info().hits)


import hashlib
import math

class FiltroDiBloom:
    def __init__(self, attesi, errore):
        m = -attesi * math.log(errore) / math.log(2) ** 2
        self.m = math.ceil(m)
        self.k = max(1, round(self.m / attesi * math.log(2)))
        self.bit = bytearray((self.m + 7) // 8)

    def _posizioni(self, elemento):
        impronta = hashlib.sha256(elemento.encode()).digest()
        h1 = int.from_bytes(impronta[:8], 'big')
        h2 = int.from_bytes(impronta[8:16], 'big') | 1
        return [(h1 + i * h2) % self.m for i in range(self.k)]

    def inserisci(self, elemento):
        for p in self._posizioni(elemento):
            self.bit[p >> 3] |= 1 << (p & 7)

    def contiene(self, elemento):
        return all(self.bit[p >> 3] >> (p & 7) & 1
                   for p in self._posizioni(elemento))

n = 10000
f = FiltroDiBloom(n, 0.01)
for i in range(n):
    f.inserisci(f'sito-{i}.example')
print(f.m, f.k, len(f.bit), round(f.m / n, 2))
print(all(f.contiene(f'sito-{i}.example') for i in range(n)))
falsi = sum(f.contiene(f'altro-{i}.example')
            for i in range(100000))
print(falsi / 100000)
