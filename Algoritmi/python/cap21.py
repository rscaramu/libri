# Algoritmi - Roberto Scaramuzzino
# Capitolo 21
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def resto_goloso(importo, tagli):
    monete = []
    for t in sorted(tagli, reverse=True):
        while importo >= t:
            monete.append(t)
            importo -= t
    return monete

def resto_ottimo(importo, tagli):
    # forza bruta con tabella: minimo numero di monete
    minimo = [0] + [None] * importo
    for v in range(1, importo + 1):
        scelte = [minimo[v - t] for t in tagli
                  if t <= v and minimo[v - t] is not None]
        if scelte:
            minimo[v] = 1 + min(scelte)
    return minimo[importo]

euro = [1, 2, 5, 10, 20, 50, 100, 200]
print(resto_goloso(68, euro), resto_ottimo(68, euro))
strani = [1, 3, 4]
print(resto_goloso(6, strani), resto_ottimo(6, strani))


def seleziona_attivita(attivita):
    scelte = []
    libera_da = float('-inf')
    for inizio, fine in sorted(attivita, key=lambda a: a[1]):
        if inizio >= libera_da:
            scelte.append((inizio, fine))
            libera_da = fine
    return scelte

def per_inizio(attivita):
    scelte, libera_da = [], float('-inf')
    for inizio, fine in sorted(attivita):
        if inizio >= libera_da:
            scelte.append((inizio, fine))
            libera_da = fine
    return scelte

attivita = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9),
            (6, 10), (8, 11), (8, 12), (2, 14), (12, 16)]
print(seleziona_attivita(attivita))
print(per_inizio(attivita))


def zaino_frazionario(merci, capacita):
    totale = 0.0
    ordinate = sorted(merci, key=lambda m: m[1] / m[0],
                      reverse=True)
    for peso, valore in ordinate:
        if capacita == 0:
            break
        presa = min(peso, capacita)
        totale += valore * presa / peso
        capacita -= presa
    return totale

merci = [(10, 60), (20, 100), (30, 120)]     # (peso, valore)
print(zaino_frazionario(merci, 50))

def zaino_intero_goloso(merci, capacita):
    totale = 0
    ordinate = sorted(merci, key=lambda m: m[1] / m[0],
                      reverse=True)
    for peso, valore in ordinate:
        if peso <= capacita:
            totale += valore
            capacita -= peso
    return totale

print(zaino_intero_goloso(merci, 50))        # l'ottimo e' 220


import heapq

def attesa_totale(tempi):
    attesa, trascorso = 0, 0
    for t in tempi:
        attesa += trascorso
        trascorso += t
    return attesa

tempi = [8, 3, 12, 1, 5]
print(attesa_totale(tempi), attesa_totale(sorted(tempi)))

def sale_necessarie(attivita):
    fine_sale = []
    for inizio, fine in sorted(attivita):
        if fine_sale and fine_sale[0] <= inizio:
            heapq.heappop(fine_sale)
        heapq.heappush(fine_sale, fine)
    return len(fine_sale)

print(sale_necessarie(attivita))
print(sale_necessarie([(9, 10), (10, 11), (11, 12)]))
