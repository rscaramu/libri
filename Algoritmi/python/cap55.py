# Algoritmi - Roberto Scaramuzzino
# Capitolo 55
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def amdahl(s, p):
    return 1 / (s + (1 - s) / p)

print('    s      p=4     p=16     p=64   p=1024   limite')
for s in (0.5, 0.1, 0.01):
    valori = [amdahl(s, p) for p in (4, 16, 64, 1024)]
    riga = ' '.join(f'{v:8.2f}' for v in valori)
    print(f'{s:5.2f} {riga} {1 / s:8.0f}')


from collections import Counter
from concurrent.futures import ThreadPoolExecutor

def conta_parole(blocco):
    return Counter(blocco.split())

def fondi(a, b):
    a.update(b)
    return a

documenti = ['il gatto e il cane', 'il cane e il topo',
             'un gatto un topo e un cane', 'il topo']
with ThreadPoolExecutor(max_workers=4) as esecutore:
    parziali = list(esecutore.map(conta_parole, documenti))
totale = Counter()
for p in parziali:
    totale = fondi(totale, p)
print(sorted(totale.items(), key=lambda c: (-c[1], c[0]))[:4])

def media_a_blocchi(dati, blocchi):
    passo = -(-len(dati) // blocchi)
    pezzi = [dati[i:i + passo]
             for i in range(0, len(dati), passo)]
    parziali = [(sum(b), len(b)) for b in pezzi]
    somma = sum(s for s, _ in parziali)
    quanti = sum(n for _, n in parziali)
    medie = [s / n for s, n in parziali]
    return somma / quanti, sum(medie) / len(medie)

prova = [1, 2, 3, 4, 5, 6, 100]
giusta, sbagliata = media_a_blocchi(prova, 3)
print(round(giusta, 2), round(sbagliata, 2))


def prefisse_parallele(a):
    # simulazione: a ha lunghezza potenza di due
    n = len(a)
    s = [0] * n + list(a)             # foglie in fondo
    livelli = 0
    larghezza = n // 2
    while larghezza >= 1:             # salita
        for v in range(larghezza, 2 * larghezza):
            s[v] = s[2 * v] + s[2 * v + 1]
        larghezza //= 2
        livelli += 1
    p = [0] * (2 * n)
    larghezza = 1
    while larghezza < n:              # discesa
        for v in range(larghezza, 2 * larghezza):
            p[2 * v] = p[v]
            p[2 * v + 1] = p[v] + s[2 * v]
        larghezza *= 2
        livelli += 1
    return [p[n + i] + a[i] for i in range(n)], livelli

dati = [3, 1, 4, 1, 5, 9, 2, 6]
print(prefisse_parallele(dati))

def filtra(a, condizione):
    segni = [1 if condizione(x) else 0 for x in a]
    posti, _ = prefisse_parallele(segni)
    uscita = [None] * posti[-1]
    for i, x in enumerate(a):         # scritture indipendenti
        if segni[i]:
            uscita[posti[i] - 1] = x
    return uscita

print(filtra(dati, lambda x: x % 2 == 1))
print(prefisse_parallele(list(range(1024)))[1])
