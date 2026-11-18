# Algoritmi - Roberto Scaramuzzino
# Capitolo 42
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def tabella_edit(a, b):
    n, m = len(a), len(b)
    d = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(n + 1):
        d[i][0] = i
    for j in range(m + 1):
        d[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if a[i - 1] == b[j - 1]:
                d[i][j] = d[i - 1][j - 1]
            else:
                d[i][j] = 1 + min(d[i - 1][j - 1],
                                  d[i - 1][j], d[i][j - 1])
    return d

def operazioni(a, b):
    d = tabella_edit(a, b)
    i, j, passi = len(a), len(b), []
    while i > 0 or j > 0:
        if i > 0 and j > 0 and a[i - 1] == b[j - 1]:
            i, j = i - 1, j - 1
        elif (i > 0 and j > 0
              and d[i][j] == d[i - 1][j - 1] + 1):
            passi.append(f'{a[i - 1]}>{b[j - 1]}')
            i, j = i - 1, j - 1
        elif i > 0 and d[i][j] == d[i - 1][j] + 1:
            passi.append(f'-{a[i - 1]}')
            i -= 1
        else:
            passi.append(f'+{b[j - 1]}')
            j -= 1
    return passi[::-1]

def distanza(a, b):
    if len(a) < len(b):
        a, b = b, a
    prima = list(range(len(b) + 1))
    for i in range(1, len(a) + 1):
        riga = [i] + [0] * len(b)
        for j in range(1, len(b) + 1):
            if a[i - 1] == b[j - 1]:
                riga[j] = prima[j - 1]
            else:
                riga[j] = 1 + min(prima[j - 1], prima[j],
                                  riga[j - 1])
        prima = riga
    return prima[-1]

for riga in tabella_edit('casa', 'cassa'):
    print(riga)
print(' '.join(operazioni('algortimo', 'algoritmo')))
print(' '.join(operazioni('sabato', 'domenica')))
print(' '.join(operazioni('cassa', 'casa')))
print(distanza('sabato', 'domenica'), distanza('', 'abc'),
      distanza('uguale', 'uguale'))


def sottosequenza_comune(a, b):
    n, m = len(a), len(b)
    lung = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if a[i - 1] == b[j - 1]:
                lung[i][j] = lung[i - 1][j - 1] + 1
            else:
                lung[i][j] = max(lung[i - 1][j],
                                 lung[i][j - 1])
    return lung

def comune(a, b):
    lung = sottosequenza_comune(a, b)
    i, j, s = len(a), len(b), []
    while i > 0 and j > 0:
        if a[i - 1] == b[j - 1]:
            s.append(a[i - 1])
            i, j = i - 1, j - 1
        elif lung[i - 1][j] >= lung[i][j - 1]:
            i -= 1
        else:
            j -= 1
    return s[::-1]

def diff(vecchio, nuovo):
    lung = sottosequenza_comune(vecchio, nuovo)
    i, j, righe = len(vecchio), len(nuovo), []
    while i > 0 or j > 0:
        if i > 0 and j > 0 and vecchio[i - 1] == nuovo[j - 1]:
            righe.append('  ' + vecchio[i - 1])
            i, j = i - 1, j - 1
        elif j > 0 and (i == 0
                        or lung[i][j - 1] >= lung[i - 1][j]):
            righe.append('+ ' + nuovo[j - 1])
            j -= 1
        else:
            righe.append('- ' + vecchio[i - 1])
            i -= 1
    return righe[::-1]

print(''.join(comune('ALGORITMO', 'LOGARITMO')))
vecchio = ['def area(r):', '    pi = 3.14',
           '    return pi * r * r', '', 'print(area(2))']
nuovo = ['import math', '', 'def area(r):',
         '    return math.pi * r * r', '', 'print(area(2))']
for riga in diff(vecchio, nuovo):
    print(riga)


def ricerca_approssimata(testo, motivo, k):
    m = len(motivo)
    prima = [0] * (len(testo) + 1)       # prima riga a zero
    for i in range(1, m + 1):
        riga = [i] + [0] * len(testo)
        for j in range(1, len(testo) + 1):
            if motivo[i - 1] == testo[j - 1]:
                riga[j] = prima[j - 1]
            else:
                riga[j] = 1 + min(prima[j - 1], prima[j],
                                  riga[j - 1])
        prima = riga
    return [(j, prima[j]) for j in range(1, len(testo) + 1)
            if prima[j] <= k]

testo = 'il algortimo di ordinamneto e un algoritmo'
print(ricerca_approssimata(testo, 'algoritmo', 2))
print(ricerca_approssimata(testo, 'ordinamento', 2))

dizionario = ['algoritmo', 'logaritmo', 'ritmo', 'algebra',
              'aritmetica', 'algoritmi']

def suggerisci(parola, k=2):
    vicine = [(distanza(parola, p), p) for p in dizionario
              if abs(len(p) - len(parola)) <= k]
    return sorted((d, p) for d, p in vicine if d <= k)

print(suggerisci('algortimo'))
print(suggerisci('logaritmi'))
