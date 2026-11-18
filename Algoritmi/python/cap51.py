# Algoritmi - Roberto Scaramuzzino
# Capitolo 51
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

from itertools import product

def verifica(formula, assegnazione):
    # termine k > 0: variabile k; k < 0: la sua negazione
    for clausola in formula:
        if not any(assegnazione[abs(t)] == (t > 0)
                   for t in clausola):
            return False
    return True

def cerca(formula, n):
    provate = 0
    for valori in product((False, True), repeat=n):
        provate += 1
        assegnazione = dict(enumerate(valori, start=1))
        if verifica(formula, assegnazione):
            return assegnazione, provate
    return None, provate

# (x1 o x2) e (non x1 o x3)
#   e (non x2 o non x3) e (x1 o non x3)
formula = [[1, 2], [-1, 3], [-2, -3], [1, -3]]
print(cerca(formula, 3))
print(verifica(formula, {1: True, 2: True, 3: True}))

impossibile = [[1, 2], [1, -2], [-1, 2], [-1, -2]]
print(cerca(impossibile, 2))

def piccioni(n):
    # n + 1 piccioni in n buche: insoddisfacibile
    def v(p, b):
        return p * n + b + 1
    f = [[v(p, b) for b in range(n)] for p in range(n + 1)]
    for b in range(n):
        for p in range(n + 1):
            for q in range(p + 1, n + 1):
                f.append([-v(p, b), -v(q, b)])
    return f, n * (n + 1)

for n in (2, 3, 4):
    f, variabili = piccioni(n)
    print(n, variabili, len(f), cerca(f, variabili)[1])


from itertools import combinations

def indipendente(archi, s):
    return not any(u in s and v in s for u, v in archi)

def copertura(archi, s):
    return all(u in s or v in s for u, v in archi)

def massimo_indipendente(n, archi):
    for k in range(n, 0, -1):
        for s in combinations(range(n), k):
            if indipendente(archi, set(s)):
                return set(s)
    return set()

def minima_copertura(n, archi):
    for k in range(n + 1):
        for s in combinations(range(n), k):
            if copertura(archi, set(s)):
                return set(s)

n = 7
archi = [(0, 1), (0, 2), (1, 2), (1, 3), (2, 4), (3, 4),
         (3, 5), (4, 6), (5, 6)]
ind = massimo_indipendente(n, archi)
cop = minima_copertura(n, archi)
print(sorted(ind), sorted(cop), len(ind) + len(cop) == n)
print(copertura(archi, set(range(n)) - ind))

complementare = [(u, v) for u, v in combinations(range(n), 2)
                 if (u, v) not in archi]
cricca = massimo_indipendente(n, complementare)
coppie = combinations(sorted(cricca), 2)
print(sorted(cricca), all((u, v) in archi for u, v in coppie))
