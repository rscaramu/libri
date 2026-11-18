# Algoritmi - Roberto Scaramuzzino
# Capitolo 29
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import heapq

def liste(n, archi, orientato=True):
    adiacenti = [[] for _ in range(n)]
    for u, v, w in archi:
        adiacenti[u].append((v, w))
        if not orientato:
            adiacenti[v].append((u, w))
    return adiacenti

def dijkstra(adiacenti, s):
    inf = float('inf')
    distanza = [inf] * len(adiacenti)
    predecessore = [None] * len(adiacenti)
    distanza[s] = 0
    heap = [(0, s)]
    while heap:
        d, u = heapq.heappop(heap)
        if d > distanza[u]:
            continue
        for v, w in adiacenti[u]:
            if d + w < distanza[v]:
                distanza[v] = d + w
                predecessore[v] = u
                heapq.heappush(heap, (distanza[v], v))
    return distanza, predecessore

def cammino(predecessore, s, t):
    percorso = [t]
    while percorso[-1] != s:
        if predecessore[percorso[-1]] is None:
            return None
        percorso.append(predecessore[percorso[-1]])
    return percorso[::-1]

# archi: (da, a, peso)
strade = [(0, 1, 7), (0, 2, 9), (0, 5, 14), (1, 2, 10),
          (1, 3, 15), (2, 3, 11), (2, 5, 2), (3, 4, 6),
          (4, 5, 9)]
grafo = liste(7, strade, orientato=False)
distanza, predecessore = dijkstra(grafo, 0)
print(distanza)
print(cammino(predecessore, 0, 4))
print(cammino(predecessore, 0, 6))


negativi = [(0, 1, 2), (0, 2, 5), (2, 1, -4), (1, 3, 1)]
grafo_negativo = liste(4, negativi)
print(dijkstra(grafo_negativo, 0)[0])

def dijkstra_classico(adiacenti, s):
    # un vertice sistemato non viene piu' riaperto
    inf = float('inf')
    distanza = [inf] * len(adiacenti)
    distanza[s] = 0
    sistemato = [False] * len(adiacenti)
    heap = [(0, s)]
    while heap:
        d, u = heapq.heappop(heap)
        if sistemato[u]:
            continue
        sistemato[u] = True
        for v, w in adiacenti[u]:
            if not sistemato[v] and d + w < distanza[v]:
                distanza[v] = d + w
                heapq.heappush(heap, (distanza[v], v))
    return distanza

print(dijkstra_classico(grafo_negativo, 0))


def bellman_ford(n, archi, s):
    inf = float('inf')
    distanza = [inf] * n
    distanza[s] = 0
    for _ in range(n - 1):
        cambiato = False
        for u, v, w in archi:
            if distanza[u] + w < distanza[v]:
                distanza[v] = distanza[u] + w
                cambiato = True
        if not cambiato:
            break
    for u, v, w in archi:
        if distanza[u] + w < distanza[v]:
            return None             # ciclo negativo
    return distanza

print(bellman_ford(4, negativi, 0))
ciclo = negativi + [(3, 2, 2)]      # 2 -> 1 -> 3 -> 2 vale -1
print(bellman_ford(4, ciclo, 0))


def floyd_warshall(n, archi):
    inf = float('inf')
    d = [[inf] * n for _ in range(n)]
    prossimo = [[None] * n for _ in range(n)]
    for i in range(n):
        d[i][i] = 0
    for u, v, w in archi:
        if w < d[u][v]:
            d[u][v] = w
            prossimo[u][v] = v
    for k in range(n):
        for i in range(n):
            if d[i][k] == inf:
                continue
            for j in range(n):
                if d[i][k] + d[k][j] < d[i][j]:
                    d[i][j] = d[i][k] + d[k][j]
                    prossimo[i][j] = prossimo[i][k]
    return d, prossimo

def percorso(prossimo, i, j):
    if i != j and prossimo[i][j] is None:
        return None
    strada = [i]
    while i != j:
        i = prossimo[i][j]
        strada.append(i)
    return strada

d, prossimo = floyd_warshall(4, negativi)
for riga in d:
    print(riga)
print(percorso(prossimo, 0, 3), percorso(prossimo, 3, 0))


import random

random.seed(20)
for _ in range(300):
    n = random.randint(1, 7)
    archi = [(random.randrange(n), random.randrange(n),
              random.randint(0, 9))
             for _ in range(random.randint(0, 14))]
    tutte = floyd_warshall(n, archi)[0]
    grafo = liste(n, archi)
    for s in range(n):
        assert dijkstra(grafo, s)[0] == tutte[s]
        assert bellman_ford(n, archi, s) == tutte[s]
print('300 prove superate')
