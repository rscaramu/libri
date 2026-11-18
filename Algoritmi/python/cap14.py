# Algoritmi - Roberto Scaramuzzino
# Capitolo 14
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def per_selezione(a):
    confronti = spostamenti = 0
    n = len(a)
    for i in range(n - 1):
        m = i
        for j in range(i + 1, n):
            confronti += 1
            if a[j] < a[m]:
                m = j
        if m != i:
            a[i], a[m] = a[m], a[i]
            spostamenti += 2
    return confronti, spostamenti

def per_inserimento(a):
    confronti = spostamenti = 0
    for i in range(1, len(a)):
        x = a[i]
        j = i - 1
        while j >= 0:
            confronti += 1
            if a[j] <= x:
                break
            a[j + 1] = a[j]
            spostamenti += 1
            j -= 1
        a[j + 1] = x
    return confronti, spostamenti

def a_bolle(a):
    confronti = spostamenti = 0
    for i in range(len(a) - 1, 0, -1):
        scambiato = False
        for j in range(i):
            confronti += 1
            if a[j] > a[j + 1]:
                a[j], a[j + 1] = a[j + 1], a[j]
                spostamenti += 2
                scambiato = True
        if not scambiato:
            break
    return confronti, spostamenti

prova = [5, 2, 9, 1, 5, 6]
for ordina in (per_selezione, per_inserimento, a_bolle):
    copia = prova[:]
    ordina(copia)
    print(ordina.__name__, copia)


import random

random.seed(5)
n = 1000
casuale = list(range(n))
random.shuffle(casuale)
quasi = list(range(n))
for _ in range(10):
    i = random.randrange(n - 1)
    quasi[i], quasi[i + 1] = quasi[i + 1], quasi[i]
casi = [
    ('casuale', casuale),
    ('ordinata', list(range(n))),
    ('inversa', list(range(n, 0, -1))),
    ('quasi', quasi),
]
for nome, dati in casi:
    riga = [f'{nome:<9}']
    for ordina in (per_selezione, per_inserimento, a_bolle):
        copia = dati[:]
        c, s = ordina(copia)
        assert copia == sorted(dati)
        riga.append(f'{c:>7}{s:>8}')
    print(' '.join(riga))


def inserimento_binario(a):
    for i in range(1, len(a)):
        x = a[i]
        basso, alto = 0, i
        while basso < alto:
            medio = basso + (alto - basso) // 2
            if a[medio] <= x:
                basso = medio + 1
            else:
                alto = medio
        for j in range(i - 1, basso - 1, -1):
            a[j + 1] = a[j]
        a[basso] = x

def shell(a):
    n = len(a)
    confronti = 0
    h = 1
    while h < n // 3:
        h = 3 * h + 1
    while h >= 1:
        for i in range(h, n):
            x = a[i]
            j = i - h
            while j >= 0:
                confronti += 1
                if a[j] <= x:
                    break
                a[j + h] = a[j]
                j -= h
            a[j + h] = x
        h //= 3
    return confronti

copia = casuale[:]
inserimento_binario(copia)
print(copia == sorted(casuale))
copia = casuale[:]
print(shell(copia), copia == sorted(casuale))
