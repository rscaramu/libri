# Algoritmi - Roberto Scaramuzzino
# Capitolo 44
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def comprimi_rle(dati):
    uscita, i = [], 0
    while i < len(dati):
        j = i
        while j < len(dati) and dati[j] == dati[i]:
            j += 1
        uscita.append((j - i, dati[i]))
        i = j
    return uscita

def espandi_rle(coppie):
    return ''.join(s * volte for volte, s in coppie)

riga = 'BBBBBBBBBBBBNNNBBBBBBBBBBBBBBBBNBBBBBB'
coppie = comprimi_rle(riga)
print(''.join(f'{v}{s}' for v, s in coppie), len(riga))
print(espandi_rle(coppie) == riga)
parola = comprimi_rle('algoritmo')
print(''.join(f'{v}{s}' for v, s in parola))


import heapq
import math
from collections import Counter

def albero_huffman(frequenze):
    # elementi dell'heap: (frequenza, progressivo, nodo)
    ordinati = sorted(frequenze.items())
    heap = [(f, i, simbolo)
            for i, (simbolo, f) in enumerate(ordinati)]
    heapq.heapify(heap)
    progressivo = len(heap)
    while len(heap) > 1:
        fa, _, a = heapq.heappop(heap)
        fb, _, b = heapq.heappop(heap)
        heapq.heappush(heap, (fa + fb, progressivo, (a, b)))
        progressivo += 1
    return heap[0][2]

def codici(nodo, prefisso='', tabella=None):
    if tabella is None:
        tabella = {}
    if isinstance(nodo, tuple):
        codici(nodo[0], prefisso + '0', tabella)
        codici(nodo[1], prefisso + '1', tabella)
    else:
        tabella[nodo] = prefisso or '0'
    return tabella

def decodifica(bit, albero):
    uscita, nodo = [], albero
    for b in bit:
        nodo = nodo[int(b)]
        if not isinstance(nodo, tuple):
            uscita.append(nodo)
            nodo = albero
    return ''.join(uscita)

testo = 'la mamma ama la lana e la lama ama la mamma'
frequenze = Counter(testo)
albero = albero_huffman(frequenze)
tabella = codici(albero)
for simbolo, f in frequenze.most_common():
    print(repr(simbolo), f, tabella[simbolo])
bit = ''.join(tabella[c] for c in testo)
print(len(bit), len(testo) * 8)
print(decodifica(bit, albero) == testo)
entropia = -sum(f / len(testo) * math.log2(f / len(testo))
                for f in frequenze.values())
print(round(entropia * len(testo), 1))


def comprimi_lz77(dati, finestra=4096, minimo=3):
    uscita, i, n = [], 0, len(dati)
    indice = {}                 # terna -> posizioni recenti
    while i < n:
        migliore_l, migliore_d = 0, 0
        chiave = dati[i:i + minimo]
        for j in reversed(indice.get(chiave, [])):
            if i - j > finestra:
                break
            lung = 0
            while (i + lung < n
                   and dati[j + lung] == dati[i + lung]):
                lung += 1
            if lung > migliore_l:
                migliore_l, migliore_d = lung, i - j
        passo = migliore_l if migliore_l >= minimo else 1
        if passo > 1:
            uscita.append((migliore_d, migliore_l))
        else:
            uscita.append(dati[i])
        for k in range(i, i + passo):
            terna = dati[k:k + minimo]
            indice.setdefault(terna, []).append(k)
        i += passo
    return uscita

def espandi_lz77(codice):
    dati = []
    for e in codice:
        if isinstance(e, tuple):
            distanza, lunghezza = e
            for _ in range(lunghezza):
                dati.append(dati[-distanza])
        else:
            dati.append(e)
    return ''.join(dati)

def mostra(codice):
    return ''.join(f'<{e[0]},{e[1]}>' if isinstance(e, tuple)
                   else e for e in codice)

esempi = ('abracadabra abracadabra', 'a' * 20,
          'ogni algoritmo e un algoritmo')
for esempio in esempi:
    codice = comprimi_lz77(esempio)
    assert espandi_lz77(codice) == esempio
    print(mostra(codice))
