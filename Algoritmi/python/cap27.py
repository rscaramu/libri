# Algoritmi - Roberto Scaramuzzino
# Capitolo 27
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from collections import deque

def topologico_kahn(n, archi):
    adiacenti = [[] for _ in range(n)]
    entranti = [0] * n
    for u, v in archi:
        adiacenti[u].append(v)
        entranti[v] += 1
    coda = deque(v for v in range(n) if entranti[v] == 0)
    ordine = []
    while coda:
        u = coda.popleft()
        ordine.append(u)
        for v in adiacenti[u]:
            entranti[v] -= 1
            if entranti[v] == 0:
                coda.append(v)
    return ordine if len(ordine) == n else None

def topologico_dfs(n, archi):
    adiacenti = [[] for _ in range(n)]
    for u, v in archi:
        adiacenti[u].append(v)
    colore = [0] * n            # 0 bianco, 1 grigio, 2 nero
    ordine = []

    def visita(u):
        colore[u] = 1
        for v in adiacenti[u]:
            if colore[v] == 1:
                return False
            if colore[v] == 0 and not visita(v):
                return False
        colore[u] = 2
        ordine.append(u)
        return True

    for s in range(n):
        if colore[s] == 0 and not visita(s):
            return None
    return ordine[::-1]

capi = ['slip', 'calzini', 'pantaloni', 'scarpe', 'camicia',
        'cintura', 'giacca']
prima = [(0, 2), (0, 3), (1, 3), (2, 3), (2, 5), (4, 5),
         (4, 6), (5, 6)]
print(' '.join(capi[v] for v in topologico_kahn(7, prima)))
print(' '.join(capi[v] for v in topologico_dfs(7, prima)))
ciclo = prima + [(6, 4)]
print(topologico_kahn(7, ciclo), topologico_dfs(7, ciclo))


def durata_progetto(n, archi, durata):
    adiacenti = [[] for _ in range(n)]
    for u, v in archi:
        adiacenti[u].append(v)
    inizio = [0] * n
    da = [None] * n
    for u in topologico_kahn(n, archi):
        for v in adiacenti[u]:
            if inizio[u] + durata[u] > inizio[v]:
                inizio[v] = inizio[u] + durata[u]
                da[v] = u
    fine = [inizio[v] + durata[v] for v in range(n)]
    ultimo = fine.index(max(fine))
    totale = inizio[ultimo] + durata[ultimo]
    critico = []
    while ultimo is not None:
        critico.append(ultimo)
        ultimo = da[ultimo]
    return totale, critico[::-1], inizio

# 0 fondamenta, 1 muri, 2 tetto, 3 impianti, 4 finiture
durata = [4, 6, 3, 5, 2]
vincoli = [(0, 1), (1, 2), (1, 3), (2, 4), (3, 4)]
print(durata_progetto(5, vincoli, durata))


def bipartito(n, archi):
    adiacenti = [[] for _ in range(n)]
    for u, v in archi:
        adiacenti[u].append(v)
        adiacenti[v].append(u)
    colore = [None] * n
    for s in range(n):
        if colore[s] is not None:
            continue
        colore[s] = 0
        coda = deque([s])
        while coda:
            u = coda.popleft()
            for v in adiacenti[u]:
                if colore[v] is None:
                    colore[v] = 1 - colore[u]
                    coda.append(v)
                elif colore[v] == colore[u]:
                    return None
    return colore

quadrato = [(0, 1), (1, 2), (2, 3), (3, 0)]
print(bipartito(4, quadrato))
print(bipartito(4, quadrato + [(0, 2)]))


def componenti_forti(n, archi):
    diretto = [[] for _ in range(n)]
    trasposto = [[] for _ in range(n)]
    for u, v in archi:
        diretto[u].append(v)
        trasposto[v].append(u)
    # prima visita: ordine di completamento (iterativa)
    visto = [False] * n
    ordine = []
    for s in range(n):
        if visto[s]:
            continue
        visto[s] = True
        pila = [(s, 0)]
        while pila:
            u, i = pila[-1]
            if i < len(diretto[u]):
                pila[-1] = (u, i + 1)
                v = diretto[u][i]
                if not visto[v]:
                    visto[v] = True
                    pila.append((v, 0))
            else:
                pila.pop()
                ordine.append(u)
    # seconda visita sul grafo trasposto
    componente = [-1] * n
    k = 0
    for s in reversed(ordine):
        if componente[s] != -1:
            continue
        componente[s] = k
        pila = [s]
        while pila:
            u = pila.pop()
            for v in trasposto[u]:
                if componente[v] == -1:
                    componente[v] = k
                    pila.append(v)
        k += 1
    return k, componente

archi = [(0, 1), (1, 2), (2, 0), (2, 3), (3, 4), (4, 5),
         (5, 3), (6, 5), (6, 7), (7, 6)]
k, componente = componenti_forti(8, archi)
print(k, componente)
gruppi = [[v for v in range(8) if componente[v] == c]
          for c in range(k)]
print(gruppi)
