# Algoritmi - Roberto Scaramuzzino
# Capitolo 28
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

class InsiemiDisgiunti:
    def __init__(self, n):
        self.genitore = list(range(n))
        self.grandezza = [1] * n

    def trova(self, x):
        radice = x
        while self.genitore[radice] != radice:
            radice = self.genitore[radice]
        while self.genitore[x] != radice:
            self.genitore[x], x = radice, self.genitore[x]
        return radice

    def unisci(self, x, y):
        rx, ry = self.trova(x), self.trova(y)
        if rx == ry:
            return False
        if self.grandezza[rx] < self.grandezza[ry]:
            rx, ry = ry, rx
        self.genitore[ry] = rx
        self.grandezza[rx] += self.grandezza[ry]
        return True

def kruskal(n, archi):
    d = InsiemiDisgiunti(n)
    albero = []
    for peso, u, v in sorted(archi):
        if d.unisci(u, v):
            albero.append((peso, u, v))
            if len(albero) == n - 1:
                break
    return albero

# archi: (peso, u, v)
archi = [(7, 0, 1), (5, 0, 3), (8, 1, 2), (9, 1, 3),
         (7, 1, 4), (5, 2, 4), (15, 3, 4), (6, 3, 5),
         (8, 4, 5), (9, 4, 6), (11, 5, 6)]

def mostra(albero):
    print(' '.join(f'{u}-{v}:{p}' for p, u, v in albero))

albero = kruskal(7, archi)
mostra(albero)
print(sum(peso for peso, u, v in albero))


import heapq

def prim(n, archi, s=0):
    adiacenti = [[] for _ in range(n)]
    for peso, u, v in archi:
        adiacenti[u].append((v, peso))
        adiacenti[v].append((u, peso))
    nell_albero = [False] * n
    heap, albero = [], []

    def aggiungi_vertice(u):
        nell_albero[u] = True
        for v, peso in adiacenti[u]:
            if not nell_albero[v]:
                heapq.heappush(heap, (peso, u, v))

    aggiungi_vertice(s)
    while heap and len(albero) < n - 1:
        peso, u, v = heapq.heappop(heap)
        if not nell_albero[v]:
            albero.append((peso, u, v))
            aggiungi_vertice(v)
    return albero

albero = prim(7, archi)
mostra(albero)
print(sum(peso for peso, u, v in albero))


import random
from itertools import combinations

def minimo_esaustivo(n, archi):
    migliore = None
    for scelta in combinations(archi, n - 1):
        d = InsiemiDisgiunti(n)
        if all(d.unisci(u, v) for _, u, v in scelta):
            costo = sum(p for p, _, _ in scelta)
            if migliore is None or costo < migliore:
                migliore = costo
    return migliore

random.seed(19)
for _ in range(200):
    n = random.randint(2, 6)
    grafo = [(random.randint(1, 9), i, i + 1)
             for i in range(n - 1)]          # connesso
    for _ in range(random.randint(0, 5)):
        u, v = random.sample(range(n), 2)
        grafo.append((random.randint(1, 9), u, v))
    k = sum(p for p, _, _ in kruskal(n, grafo))
    q = sum(p for p, _, _ in prim(n, grafo))
    assert k == q == minimo_esaustivo(n, grafo)
print('200 prove superate')


def raggruppa(n, archi, k):
    d = InsiemiDisgiunti(n)
    gruppi = n
    for peso, u, v in sorted(archi):
        if gruppi == k:
            break
        if d.unisci(u, v):
            gruppi -= 1
    etichette = {}
    return [etichette.setdefault(d.trova(v), len(etichette))
            for v in range(n)]

punti = [1, 2, 3, 10, 11, 12, 30, 31]
distanze = [(abs(punti[i] - punti[j]), i, j)
            for i in range(len(punti))
            for j in range(i + 1, len(punti))]
print(raggruppa(len(punti), distanze, 3))
print(raggruppa(len(punti), distanze, 2))
