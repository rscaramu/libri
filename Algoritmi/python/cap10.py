# Algoritmi - Roberto Scaramuzzino
# Capitolo 10
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from collections import deque

class Nodo:
    def __init__(self, chiave):
        self.chiave = chiave
        self.sinistro = None
        self.destro = None

def inserisci(radice, k):
    nuovo = Nodo(k)
    if radice is None:
        return nuovo
    nodo = radice
    while True:
        if k == nodo.chiave:
            return radice
        if k < nodo.chiave:
            if nodo.sinistro is None:
                nodo.sinistro = nuovo
                return radice
            nodo = nodo.sinistro
        else:
            if nodo.destro is None:
                nodo.destro = nuovo
                return radice
            nodo = nodo.destro

def cerca(radice, k):
    nodo = radice
    while nodo is not None and nodo.chiave != k:
        if k < nodo.chiave:
            nodo = nodo.sinistro
        else:
            nodo = nodo.destro
    return nodo

def minimo(nodo):
    while nodo.sinistro is not None:
        nodo = nodo.sinistro
    return nodo

def elimina(nodo, k):
    if nodo is None:
        return None
    if k < nodo.chiave:
        nodo.sinistro = elimina(nodo.sinistro, k)
    elif k > nodo.chiave:
        nodo.destro = elimina(nodo.destro, k)
    else:
        if nodo.sinistro is None:
            return nodo.destro
        if nodo.destro is None:
            return nodo.sinistro
        s = minimo(nodo.destro)
        nodo.chiave = s.chiave
        nodo.destro = elimina(nodo.destro, s.chiave)
    return nodo

def simmetrica(nodo, uscita):
    if nodo is not None:
        simmetrica(nodo.sinistro, uscita)
        uscita.append(nodo.chiave)
        simmetrica(nodo.destro, uscita)
    return uscita

def per_livelli(radice):
    uscita, coda = [], deque()
    if radice is not None:
        coda.append(radice)
    while coda:
        nodo = coda.popleft()
        uscita.append(nodo.chiave)
        if nodo.sinistro is not None:
            coda.append(nodo.sinistro)
        if nodo.destro is not None:
            coda.append(nodo.destro)
    return uscita

radice = None
for k in (50, 30, 70, 20, 40, 60, 80, 35):
    radice = inserisci(radice, k)
print(simmetrica(radice, []))
print(per_livelli(radice))
print(cerca(radice, 40) is not None)
print(cerca(radice, 45) is None)
print(minimo(radice).chiave)
for k in (20, 30, 50):
    radice = elimina(radice, k)
    print(k, per_livelli(radice))


def tetto(radice, k):
    migliore, nodo = None, radice
    while nodo is not None:
        if nodo.chiave == k:
            return nodo.chiave
        if nodo.chiave > k:
            migliore = nodo.chiave
            nodo = nodo.sinistro
        else:
            nodo = nodo.destro
    return migliore

def intervallo(nodo, a, b, uscita):
    if nodo is None:
        return uscita
    if a < nodo.chiave:
        intervallo(nodo.sinistro, a, b, uscita)
    if a <= nodo.chiave <= b:
        uscita.append(nodo.chiave)
    if nodo.chiave < b:
        intervallo(nodo.destro, a, b, uscita)
    return uscita

radice = None
for k in (50, 30, 70, 20, 40, 60, 80, 35):
    radice = inserisci(radice, k)
print(tetto(radice, 36), tetto(radice, 60), tetto(radice, 81))
print(intervallo(radice, 33, 65, []))


import random

def altezza(radice):
    # visita per livelli: nessun rischio per la pila
    if radice is None:
        return -1
    livello, h = [radice], -1
    while livello:
        h += 1
        prossimo = []
        for nodo in livello:
            if nodo.sinistro is not None:
                prossimo.append(nodo.sinistro)
            if nodo.destro is not None:
                prossimo.append(nodo.destro)
        livello = prossimo
    return h

def costruisci(chiavi):
    radice = None
    for k in chiavi:
        radice = inserisci(radice, k)
    return radice

n = 2000
ordinate = list(range(n))
casuali = ordinate[:]
random.seed(3)
random.shuffle(casuali)
print(altezza(costruisci(ordinate)))
print(altezza(costruisci(casuali)))
