# Algoritmi - Roberto Scaramuzzino
# Capitolo 30
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from collections import deque

def edmonds_karp(n, archi, s, t):
    residuo = [dict() for _ in range(n)]
    for u, v, capacita in archi:
        residuo[u][v] = residuo[u].get(v, 0) + capacita
        residuo[v].setdefault(u, 0)       # arco inverso
    flusso = 0
    while True:
        genitore = [None] * n
        genitore[s] = s
        coda = deque([s])
        while coda and genitore[t] is None:
            u = coda.popleft()
            for v, c in residuo[u].items():
                if c > 0 and genitore[v] is None:
                    genitore[v] = u
                    coda.append(v)
        if genitore[t] is None:
            break                 # nessun cammino aumentante
        collo, v = float('inf'), t
        while v != s:
            u = genitore[v]
            collo = min(collo, residuo[u][v])
            v = u
        v = t
        while v != s:
            u = genitore[v]
            residuo[u][v] -= collo
            residuo[v][u] += collo
            v = u
        flusso += collo
    # vertici ancora raggiungibili da s: un lato del taglio
    lato = {v for v in range(n) if genitore[v] is not None}
    return flusso, lato

# archi: (da, a, capacita'); 0 sorgente, 5 pozzo
rete = [(0, 1, 16), (0, 2, 13), (1, 2, 10), (2, 1, 4),
        (1, 3, 12), (3, 2, 9), (2, 4, 14), (4, 3, 7),
        (3, 5, 20), (4, 5, 4)]
flusso, lato = edmonds_karp(6, rete, 0, 5)
print(flusso, sorted(lato))
taglio = [(u, v, c) for u, v, c in rete
          if u in lato and v not in lato]
print(taglio, sum(c for _, _, c in taglio))


def accoppiamento(idoneita, numero_posti):
    occupante = [None] * numero_posti

    def sistema(c, visti):
        for p in idoneita[c]:
            if p in visti:
                continue
            visti.add(p)
            if (occupante[p] is None
                    or sistema(occupante[p], visti)):
                occupante[p] = c
                return True
        return False

    assunti = sum(sistema(c, set())
                  for c in range(len(idoneita)))
    return assunti, occupante

# candidato -> posti per cui e' idoneo
idoneita = [[0, 1], [0], [1, 2], [2], [2, 3]]
print(accoppiamento(idoneita, 4))

def con_flusso(idoneita, numero_posti):
    c = len(idoneita)
    s, t = c + numero_posti, c + numero_posti + 1
    archi = [(s, i, 1) for i in range(c)]
    archi += [(c + p, t, 1) for p in range(numero_posti)]
    archi += [(i, c + p, 1) for i in range(c)
              for p in idoneita[i]]
    return edmonds_karp(t + 1, archi, s, t)[0]

print(con_flusso(idoneita, 4))
