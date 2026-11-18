# Algoritmi - Roberto Scaramuzzino
# Capitolo 7
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def inserisci_in(a, n, p, x):
    for i in range(n - 1, p - 1, -1):
        a[i + 1] = a[i]
    a[p] = x
    return n + 1

def elimina_da(a, n, p):
    for i in range(p, n - 1):
        a[i] = a[i + 1]
    a[n - 1] = None
    return n - 1

a = [10, 20, 30, 40, None, None]
n = 4
n = inserisci_in(a, n, 1, 15)
print(a, n)
n = elimina_da(a, n, 0)
print(a, n)


class Nodo:
    def __init__(self, chiave, succ=None):
        self.chiave = chiave
        self.succ = succ

class Lista:
    def __init__(self):
        self.testa = None

    def inserisci_in_testa(self, x):
        self.testa = Nodo(x, self.testa)

    def cerca(self, x):
        nodo = self.testa
        while nodo is not None and nodo.chiave != x:
            nodo = nodo.succ
        return nodo

    def elimina(self, x):
        prec, nodo = None, self.testa
        while nodo is not None and nodo.chiave != x:
            prec, nodo = nodo, nodo.succ
        if nodo is None:
            return False
        if prec is None:
            self.testa = nodo.succ
        else:
            prec.succ = nodo.succ
        return True

    def rovescia(self):
        prec, nodo = None, self.testa
        while nodo is not None:
            prossimo = nodo.succ
            nodo.succ = prec
            prec, nodo = nodo, prossimo
        self.testa = prec

    def elementi(self):
        risultato = []
        nodo = self.testa
        while nodo is not None:
            risultato.append(nodo.chiave)
            nodo = nodo.succ
        return risultato

lista = Lista()
for x in (40, 30, 20, 10):
    lista.inserisci_in_testa(x)
print(lista.elementi())
print(lista.cerca(30) is not None)
print(lista.cerca(99) is not None)
print(lista.elimina(10), lista.elimina(30), lista.elimina(99))
print(lista.elementi())
lista.rovescia()
print(lista.elementi())


class NodoDoppio:
    def __init__(self, chiave=None):
        self.chiave = chiave
        self.prec = self
        self.succ = self

def inserisci_dopo(p, x):
    nodo = NodoDoppio(x)
    nodo.prec, nodo.succ = p, p.succ
    p.succ.prec = nodo
    p.succ = nodo
    return nodo

def stacca(nodo):
    nodo.prec.succ = nodo.succ
    nodo.succ.prec = nodo.prec

def contenuto(sentinella):
    risultato, nodo = [], sentinella.succ
    while nodo is not sentinella:
        risultato.append(nodo.chiave)
        nodo = nodo.succ
    return risultato

s = NodoDoppio()                    # sentinella: lista vuota
a = inserisci_dopo(s, 'a')
c = inserisci_dopo(a, 'c')
b = inserisci_dopo(a, 'b')
print(contenuto(s))
stacca(b)
stacca(a)
print(contenuto(s))


class ArrayDinamico:
    def __init__(self):
        self.capacita = 1
        self.n = 0
        self.dati = [None]

    def _ridimensiona(self, nuova):
        b = [None] * nuova
        for i in range(self.n):
            b[i] = self.dati[i]
        self.dati, self.capacita = b, nuova

    def aggiungi(self, x):
        if self.n == self.capacita:
            self._ridimensiona(2 * self.capacita)
        self.dati[self.n] = x
        self.n += 1

    def togli_ultimo(self):
        if self.n == 0:
            raise IndexError('array vuoto')
        self.n -= 1
        x = self.dati[self.n]
        self.dati[self.n] = None
        if self.capacita > 1 and self.n <= self.capacita // 4:
            self._ridimensiona(self.capacita // 2)
        return x

    def leggi(self, i):
        if not 0 <= i < self.n:
            raise IndexError('indice fuori dai limiti')
        return self.dati[i]

v = ArrayDinamico()
for x in range(9):
    v.aggiungi(x * x)
print(v.n, v.capacita, v.leggi(8))
for _ in range(6):
    v.togli_ultimo()
print(v.n, v.capacita, v.leggi(2))
