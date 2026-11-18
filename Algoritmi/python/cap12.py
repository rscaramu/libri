# Algoritmi - Roberto Scaramuzzino
# Capitolo 12
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def risali(h, i):
    while i > 0 and h[i] < h[(i - 1) // 2]:
        g = (i - 1) // 2
        h[i], h[g] = h[g], h[i]
        i = g

def scendi(h, i, n):
    while True:
        minore = i
        s, d = 2 * i + 1, 2 * i + 2
        if s < n and h[s] < h[minore]:
            minore = s
        if d < n and h[d] < h[minore]:
            minore = d
        if minore == i:
            return
        h[i], h[minore] = h[minore], h[i]
        i = minore

def inserisci(h, x):
    h.append(x)
    risali(h, len(h) - 1)

def estrai_minimo(h):
    if not h:
        raise IndexError('heap vuoto')
    minimo = h[0]
    ultimo = h.pop()
    if h:
        h[0] = ultimo
        scendi(h, 0, len(h))
    return minimo

def costruisci_heap(h):
    for i in range(len(h) // 2 - 1, -1, -1):
        scendi(h, i, len(h))

def e_heap(h):
    for i in range(1, len(h)):
        if h[(i - 1) // 2] > h[i]:
            return False
    return True

h = []
for x in (9, 4, 7, 1, 8, 2):
    inserisci(h, x)
    print(h)
print([estrai_minimo(h) for _ in range(3)], h)

dati = [12, 3, 9, 15, 1, 7, 10, 5, 8]
costruisci_heap(dati)
print(dati, e_heap(dati))


import heapq

def k_maggiori(flusso, k):
    h = []
    for x in flusso:
        if len(h) < k:
            heapq.heappush(h, x)
        elif x > h[0]:
            heapq.heapreplace(h, x)
    return sorted(h, reverse=True)

def fondi_k(sequenze):
    h = []
    for j, s in enumerate(sequenze):
        if s:
            heapq.heappush(h, (s[0], j, 0))
    uscita = []
    while h:
        valore, j, i = heapq.heappop(h)
        uscita.append(valore)
        if i + 1 < len(sequenze[j]):
            heapq.heappush(h, (sequenze[j][i + 1], j, i + 1))
    return uscita

class Mediana:
    def __init__(self):
        self.bassi = []      # heap di massimo (valori negati)
        self.alti = []       # heap di minimo

    def aggiungi(self, x):
        if not self.bassi or x <= -self.bassi[0]:
            heapq.heappush(self.bassi, -x)
        else:
            heapq.heappush(self.alti, x)
        if len(self.bassi) > len(self.alti) + 1:
            x = -heapq.heappop(self.bassi)
            heapq.heappush(self.alti, x)
        elif len(self.alti) > len(self.bassi):
            x = heapq.heappop(self.alti)
            heapq.heappush(self.bassi, -x)

    def mediana(self):
        if len(self.bassi) > len(self.alti):
            return -self.bassi[0]
        return (-self.bassi[0] + self.alti[0]) / 2

print(k_maggiori([5, 1, 9, 3, 7, 8, 2, 6], 3))
print(fondi_k([[1, 4, 9], [2, 3], [], [0, 5, 6, 7]]))
m = Mediana()
for x in (5, 2, 8, 1, 9):
    m.aggiungi(x)
    print(x, m.mediana())
