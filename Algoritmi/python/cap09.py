# Algoritmi - Roberto Scaramuzzino
# Capitolo 9
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def hash_stringa(s, m):
    h = 0
    for c in s:
        h = (h * 31 + ord(c)) % 2 ** 32
    return h % m

for parola in ('casa', 'cosa', 'saca', 'algoritmo', ''):
    print(repr(parola), hash_stringa(parola, 16))


class TabellaHash:
    def __init__(self, m=4):
        self.m = m
        self.n = 0
        self.tabella = [[] for _ in range(m)]

    def _h(self, k):
        return hash_stringa(k, self.m)

    def cerca(self, k):
        for chiave, valore in self.tabella[self._h(k)]:
            if chiave == k:
                return valore
        return None

    def inserisci(self, k, v):
        lista = self.tabella[self._h(k)]
        for i in range(len(lista)):
            if lista[i][0] == k:
                lista[i] = (k, v)
                return
        lista.append((k, v))
        self.n += 1
        if self.n > 0.75 * self.m:
            self._ridimensiona(2 * self.m)

    def elimina(self, k):
        lista = self.tabella[self._h(k)]
        for i in range(len(lista)):
            if lista[i][0] == k:
                lista[i] = lista[-1]
                lista.pop()
                self.n -= 1
                return True
        return False

    def _ridimensiona(self, nuova):
        vecchia = self.tabella
        self.m = nuova
        self.tabella = [[] for _ in range(nuova)]
        for lista in vecchia:
            for k, v in lista:
                self.tabella[self._h(k)].append((k, v))

t = TabellaHash()
nomi = ['uno', 'due', 'tre', 'quattro', 'cinque']
for i, nome in enumerate(nomi):
    t.inserisci(nome, i + 1)
print(t.n, t.m)
print(t.cerca('tre'), t.cerca('sei'))
t.inserisci('tre', 33)
print(t.elimina('due'), t.elimina('due'), t.cerca('tre'), t.n)
print([len(lista) for lista in t.tabella])


VUOTA = None
LAPIDE = ('<lapide>', None)

class TabellaAperta:
    def __init__(self, m=8):
        self.m = m
        self.n = 0           # chiavi presenti
        self.usate = 0       # chiavi presenti piu' lapidi
        self.tabella = [VUOTA] * m

    def _posizione(self, k):
        i = hash_stringa(k, self.m)
        while self.tabella[i] is not VUOTA:
            voce = self.tabella[i]
            if voce is not LAPIDE and voce[0] == k:
                return i
            i = (i + 1) % self.m
        return -1

    def cerca(self, k):
        i = self._posizione(k)
        return None if i < 0 else self.tabella[i][1]

    def inserisci(self, k, v):
        i = self._posizione(k)
        if i >= 0:
            self.tabella[i] = (k, v)
            return
        if 2 * (self.usate + 1) > self.m:
            self._ricostruisci(2 * self.m)
        i = hash_stringa(k, self.m)
        while (self.tabella[i] is not VUOTA
               and self.tabella[i] is not LAPIDE):
            i = (i + 1) % self.m
        if self.tabella[i] is VUOTA:
            self.usate += 1
        self.tabella[i] = (k, v)
        self.n += 1

    def elimina(self, k):
        i = self._posizione(k)
        if i < 0:
            return False
        self.tabella[i] = LAPIDE
        self.n -= 1
        return True

    def _ricostruisci(self, nuova):
        voci = [x for x in self.tabella
                if x is not VUOTA and x is not LAPIDE]
        self.m, self.n, self.usate = nuova, 0, 0
        self.tabella = [VUOTA] * nuova
        for k, v in voci:
            self.inserisci(k, v)

t = TabellaAperta()
for i, nome in enumerate(['uno', 'due', 'tre', 'quattro']):
    t.inserisci(nome, i + 1)
print([None if x is None else x[0] for x in t.tabella])
print(t.elimina('due'), t.cerca('quattro'), t.cerca('due'))
t.inserisci('cinque', 5)
print(t.n, t.usate, t.m, t.cerca('cinque'))


def due_addendi(a, s):
    visti = {}
    for i, x in enumerate(a):
        if s - x in visti:
            return visti[s - x], i
        visti[x] = i
    return None

print(due_addendi([8, 3, 11, 5, 7], 12))
print(due_addendi([8, 3, 11, 5, 7], 6))
print(due_addendi([3, 3], 6))

def conta_parole(testo):
    conteggio = {}
    for parola in testo.lower().split():
        conteggio[parola] = conteggio.get(parola, 0) + 1
    return conteggio

frase = 'il gatto e il cane e il topo'
c = conta_parole(frase)
print(sorted(c.items(), key=lambda p: (-p[1], p[0]))[:3])
