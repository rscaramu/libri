# Algoritmi - Roberto Scaramuzzino
# Capitolo 24
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def sottoinsiemi(a):
    risultato, corrente = [], []

    def esplora(i):
        if i == len(a):
            risultato.append(corrente[:])
            return
        esplora(i + 1)
        corrente.append(a[i])
        esplora(i + 1)
        corrente.pop()

    esplora(0)
    return risultato

def permutazioni(a):
    risultato, corrente = [], []
    usato = [False] * len(a)

    def esplora():
        if len(corrente) == len(a):
            risultato.append(corrente[:])
            return
        for i in range(len(a)):
            if not usato[i]:
                usato[i] = True
                corrente.append(a[i])
                esplora()
                corrente.pop()
                usato[i] = False

    esplora()
    return risultato

print([''.join(x) for x in sottoinsiemi(['a', 'b', 'c'])])
print([''.join(x) for x in permutazioni(['1', '2', '3'])])
print(len(sottoinsiemi(list(range(10)))),
      len(permutazioni(list(range(6)))))


def regine(n):
    soluzioni, nodi = [], 0
    posizione = [0] * n
    colonne, diag1, diag2 = set(), set(), set()

    def esplora(riga):
        nonlocal nodi
        nodi += 1
        if riga == n:
            soluzioni.append(posizione[:])
            return
        for c in range(n):
            if (c in colonne or riga - c in diag1
                    or riga + c in diag2):
                continue
            colonne.add(c)
            diag1.add(riga - c)
            diag2.add(riga + c)
            posizione[riga] = c
            esplora(riga + 1)
            colonne.remove(c)
            diag1.remove(riga - c)
            diag2.remove(riga + c)

    esplora(0)
    return soluzioni, nodi

for n in (4, 6, 8):
    sol, nodi = regine(n)
    print(n, len(sol), nodi)
prima = regine(8)[0][0]
for c in prima:
    print('.' * c + 'R' + '.' * (7 - c))


def cerca_somma(numeri, obiettivo, pota=True):
    a = sorted(numeri, reverse=True)
    nodi = 0
    scelti = []

    def esplora(i, somma, restante):
        nonlocal nodi
        nodi += 1
        if somma == obiettivo:
            return True
        if i == len(a):
            return False
        if pota and (somma > obiettivo
                     or somma + restante < obiettivo):
            return False
        scelti.append(a[i])
        if esplora(i + 1, somma + a[i], restante - a[i]):
            return True
        scelti.pop()
        return esplora(i + 1, somma, restante - a[i])

    trovato = esplora(0, 0, sum(a))
    return (scelti if trovato else None), nodi

numeri = [15, 22, 14, 26, 32, 9, 16, 8, 41, 37, 28, 19, 11,
          24, 33, 45, 6, 13]
for obiettivo in (100, 398):
    con = cerca_somma(numeri, obiettivo)
    senza = cerca_somma(numeri, obiettivo, pota=False)
    print(obiettivo, con[0], con[1], senza[1])


def zaino_bb(pesi, valori, capacita, pota=True):
    ordine = sorted(range(len(pesi)),
                    key=lambda k: valori[k] / pesi[k],
                    reverse=True)
    p = [pesi[k] for k in ordine]
    v = [valori[k] for k in ordine]
    n = len(p)
    migliore, nodi = 0, 0

    def limite(i, peso, valore):
        resto = capacita - peso
        for j in range(i, n):
            if p[j] <= resto:
                valore += v[j]
                resto -= p[j]
            else:
                return valore + v[j] * resto / p[j]
        return valore

    def esplora(i, peso, valore):
        nonlocal migliore, nodi
        nodi += 1
        if valore > migliore:
            migliore = valore
        if i == n:
            return
        if pota and limite(i, peso, valore) <= migliore:
            return
        if peso + p[i] <= capacita:
            esplora(i + 1, peso + p[i], valore + v[i])
        esplora(i + 1, peso, valore)

    esplora(0, 0, 0)
    return migliore, nodi

import random
random.seed(15)
pesi = [random.randint(5, 40) for _ in range(18)]
valori = [random.randint(10, 90) for _ in range(18)]
print(zaino_bb(pesi, valori, 150))
print(zaino_bb(pesi, valori, 150, pota=False))
print(zaino_bb([10, 20, 30], [60, 100, 120], 50))
