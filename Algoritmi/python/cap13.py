# Algoritmi - Roberto Scaramuzzino
# Capitolo 13
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

class InsiemiDisgiunti:
    def __init__(self, n):
        self.genitore = list(range(n))
        self.grandezza = [1] * n
        self.gruppi = n

    def trova(self, x):
        radice = x
        while self.genitore[radice] != radice:
            radice = self.genitore[radice]
        while self.genitore[x] != radice:
            prossimo = self.genitore[x]
            self.genitore[x] = radice
            x = prossimo
        return radice

    def unisci(self, x, y):
        rx, ry = self.trova(x), self.trova(y)
        if rx == ry:
            return False
        if self.grandezza[rx] < self.grandezza[ry]:
            rx, ry = ry, rx
        self.genitore[ry] = rx
        self.grandezza[rx] += self.grandezza[ry]
        self.gruppi -= 1
        return True

    def insieme(self, x, y):
        return self.trova(x) == self.trova(y)

d = InsiemiDisgiunti(8)
for x, y in [(0, 1), (2, 3), (1, 3), (5, 6), (3, 0)]:
    print(x, y, d.unisci(x, y), d.gruppi)
print(d.insieme(0, 2), d.insieme(0, 5), d.insieme(7, 7))
print(d.grandezza[d.trova(2)])


class NodoTrie:
    def __init__(self):
        self.figli = {}
        self.fine = False

class Trie:
    def __init__(self):
        self.radice = NodoTrie()

    def inserisci(self, parola):
        nodo = self.radice
        for c in parola:
            if c not in nodo.figli:
                nodo.figli[c] = NodoTrie()
            nodo = nodo.figli[c]
        nodo.fine = True

    def _scendi(self, s):
        nodo = self.radice
        for c in s:
            if c not in nodo.figli:
                return None
            nodo = nodo.figli[c]
        return nodo

    def contiene(self, parola):
        nodo = self._scendi(parola)
        return nodo is not None and nodo.fine

    def con_prefisso(self, prefisso):
        risultato = []
        partenza = self._scendi(prefisso)
        if partenza is None:
            return risultato
        pila = [(partenza, prefisso)]
        while pila:
            nodo, parola = pila.pop()
            if nodo.fine:
                risultato.append(parola)
            for c in sorted(nodo.figli, reverse=True):
                pila.append((nodo.figli[c], parola + c))
        return risultato

t = Trie()
for p in ('cane', 'casa', 'caso', 'mare', 'cas', 'marea'):
    t.inserisci(p)
print(t.contiene('casa'), t.contiene('ca'), t.contiene('cas'))
print(t.con_prefisso('cas'))
print(t.con_prefisso('ma'), t.con_prefisso('x'))


class Fenwick:
    def __init__(self, n):
        self.n = n
        self.f = [0] * (n + 1)

    def aggiungi(self, i, delta):
        # i: indice da 0 a n-1 della sequenza originale
        i += 1
        while i <= self.n:
            self.f[i] += delta
            i += i & -i

    def prefisso(self, i):
        # somma degli elementi di indice 0..i-1
        s = 0
        while i > 0:
            s += self.f[i]
            i -= i & -i
        return s

    def somma(self, a, b):
        # somma degli elementi di indice a..b compresi
        return self.prefisso(b + 1) - self.prefisso(a)

dati = [5, 2, 9, 3, 7, 1, 4, 6]
p = [0]
for x in dati:
    p.append(p[-1] + x)
print(p[6] - p[2])             # somma di dati[2..5]

fw = Fenwick(len(dati))
for i, x in enumerate(dati):
    fw.aggiungi(i, x)
print(fw.somma(2, 5), fw.somma(0, 7))
fw.aggiungi(3, 10)             # dati[3] passa da 3 a 13
print(fw.somma(2, 5), fw.somma(0, 2))
print([i & -i for i in range(1, 9)])
