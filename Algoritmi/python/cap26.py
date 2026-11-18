# Algoritmi - Roberto Scaramuzzino
# Capitolo 26
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def liste_di_adiacenza(n, archi, orientato=False):
    adiacenti = [[] for _ in range(n)]
    for u, v in archi:
        adiacenti[u].append(v)
        if not orientato:
            adiacenti[v].append(u)
    return adiacenti

def matrice_di_adiacenza(n, archi, orientato=False):
    m = [[0] * n for _ in range(n)]
    for u, v in archi:
        m[u][v] = 1
        if not orientato:
            m[v][u] = 1
    return m

archi = [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4), (5, 6)]
grafo = liste_di_adiacenza(7, archi)
for u, vicini in enumerate(grafo):
    print(u, vicini)
print(matrice_di_adiacenza(7, archi)[3])


from collections import deque

def visita_in_ampiezza(grafo, s):
    distanza = [None] * len(grafo)
    genitore = [None] * len(grafo)
    distanza[s] = 0
    coda = deque([s])
    ordine = []
    while coda:
        u = coda.popleft()
        ordine.append(u)
        for v in grafo[u]:
            if distanza[v] is None:
                distanza[v] = distanza[u] + 1
                genitore[v] = u
                coda.append(v)
    return distanza, genitore, ordine

def cammino(genitore, s, t):
    if t != s and genitore[t] is None:
        return None                 # t non raggiungibile
    percorso = [t]
    while percorso[-1] != s:
        percorso.append(genitore[percorso[-1]])
    return percorso[::-1]

distanza, genitore, ordine = visita_in_ampiezza(grafo, 0)
print(ordine)
print(distanza)
print(cammino(genitore, 0, 4), cammino(genitore, 0, 6))


def labirinto(mappa, partenza, arrivo):
    righe, colonne = len(mappa), len(mappa[0])
    genitore = {partenza: None}
    coda = deque([partenza])
    while coda:
        r, c = coda.popleft()
        if (r, c) == arrivo:
            break
        for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nr, nc = r + dr, c + dc
            if (0 <= nr < righe and 0 <= nc < colonne
                    and mappa[nr][nc] != '#'
                    and (nr, nc) not in genitore):
                genitore[(nr, nc)] = (r, c)
                coda.append((nr, nc))
    if arrivo not in genitore:
        return None
    passi, casella = 0, arrivo
    disegno = [list(riga) for riga in mappa]
    while genitore[casella] is not None:
        casella = genitore[casella]
        passi += 1
        if casella != partenza:
            disegno[casella[0]][casella[1]] = '*'
    return passi, [''.join(riga) for riga in disegno]

mappa = ['S..#....',
         '.#.#.##.',
         '.#...#..',
         '.####.#.',
         '......#A']
passi, disegno = labirinto(mappa, (0, 0), (4, 7))
print(passi)
for riga in disegno:
    print(riga)


def profondita_ricorsiva(grafo, s):
    visitato = [False] * len(grafo)
    ingresso, uscita = [], []

    def visita(u):
        visitato[u] = True
        ingresso.append(u)
        for v in grafo[u]:
            if not visitato[v]:
                visita(v)
        uscita.append(u)

    visita(s)
    return ingresso, uscita

def profondita_iterativa(grafo, s):
    visitato = [False] * len(grafo)
    visitato[s] = True
    ingresso, uscita = [s], []
    pila = [(s, 0)]
    while pila:
        u, i = pila[-1]
        if i < len(grafo[u]):
            pila[-1] = (u, i + 1)
            v = grafo[u][i]
            if not visitato[v]:
                visitato[v] = True
                ingresso.append(v)
                pila.append((v, 0))
        else:
            pila.pop()
            uscita.append(u)
    return ingresso, uscita

print(profondita_ricorsiva(grafo, 0))
print(profondita_iterativa(grafo, 0))

lungo = [[i + 1] if i < 99999 else [] for i in range(100000)]
print(len(profondita_iterativa(lungo, 0)[0]))


def componenti(grafo):
    n = len(grafo)
    componente = [-1] * n
    k = 0
    for s in range(n):
        if componente[s] != -1:
            continue
        componente[s] = k
        pila = [s]
        while pila:
            u = pila.pop()
            for v in grafo[u]:
                if componente[v] == -1:
                    componente[v] = k
                    pila.append(v)
        k += 1
    return k, componente

print(componenti(grafo))

def conta_isole(mappa):
    righe, colonne = len(mappa), len(mappa[0])
    vista = [[False] * colonne for _ in range(righe)]
    mosse = ((1, 0), (-1, 0), (0, 1), (0, -1))
    isole = 0
    for r in range(righe):
        for c in range(colonne):
            if mappa[r][c] != 'X' or vista[r][c]:
                continue
            isole += 1
            vista[r][c] = True
            pila = [(r, c)]
            while pila:
                y, x = pila.pop()
                for dy, dx in mosse:
                    ny, nx = y + dy, x + dx
                    if (0 <= ny < righe and 0 <= nx < colonne
                            and mappa[ny][nx] == 'X'
                            and not vista[ny][nx]):
                        vista[ny][nx] = True
                        pila.append((ny, nx))
    return isole

print(conta_isole(['XX..X',
                   'X...X',
                   '..X..',
                   '...XX']))
