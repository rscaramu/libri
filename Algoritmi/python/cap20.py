# Algoritmi - Roberto Scaramuzzino
# Capitolo 20
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def potenza_veloce(b, e):
    if e == 0:
        return 1
    m = potenza_veloce(b, e // 2)
    return m * m if e % 2 == 0 else m * m * b

def potenza_iterativa(b, e):
    r, passi = 1, 0
    while e > 0:
        if e % 2 == 1:
            r *= b
            passi += 1
        b *= b
        passi += 1
        e //= 2
    return r, passi

print(potenza_veloce(3, 13), 3 ** 13)
print(potenza_iterativa(2, 10))
print(potenza_iterativa(1.0000001, 10 ** 9))


def somma_massima(a, basso=0, alto=None):
    if alto is None:
        alto = len(a) - 1
    if basso == alto:
        return a[basso]
    medio = basso + (alto - basso) // 2
    sinistra = somma_massima(a, basso, medio)
    destra = somma_massima(a, medio + 1, alto)
    s, migliore_s = 0, float('-inf')
    for i in range(medio, basso - 1, -1):
        s += a[i]
        migliore_s = max(migliore_s, s)
    s, migliore_d = 0, float('-inf')
    for i in range(medio + 1, alto + 1):
        s += a[i]
        migliore_d = max(migliore_d, s)
    return max(sinistra, destra, migliore_s + migliore_d)

def kadane(a):
    qui = migliore = a[0]
    inizio = da = a_ = 0
    for i in range(1, len(a)):
        if qui < 0:
            qui, inizio = a[i], i
        else:
            qui += a[i]
        if qui > migliore:
            migliore, da, a_ = qui, inizio, i
    return migliore, da, a_

dati = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
print(somma_massima(dati), kadane(dati))
print(somma_massima([-3, -1, -2]), kadane([-3, -1, -2]))

import random
random.seed(12)
for _ in range(500):
    n = random.randint(1, 15)
    a = [random.randint(-9, 9) for _ in range(n)]
    forza = max(sum(a[i:j]) for i in range(n)
                for j in range(i + 1, n + 1))
    assert somma_massima(a) == kadane(a)[0] == forza
print('500 prove superate')


def voto_di_maggioranza(a):
    candidato, conta = None, 0
    for x in a:
        if conta == 0:
            candidato, conta = x, 1
        elif x == candidato:
            conta += 1
        else:
            conta -= 1
    if a.count(candidato) * 2 > len(a):
        return candidato
    return None

print(voto_di_maggioranza(list('abacaaba')))
print(voto_di_maggioranza(list('abcabc')))
print(voto_di_maggioranza(['x']))


def primo_e_secondo(a):
    # ogni concorrente: (valore, lista degli sconfitti)
    turno = [(x, []) for x in a]
    confronti = 0
    while len(turno) > 1:
        prossimo = []
        for i in range(0, len(turno) - 1, 2):
            p, q = turno[i], turno[i + 1]
            confronti += 1
            if p[0] < q[0]:
                p, q = q, p
            p[1].append(q[0])
            prossimo.append(p)
        if len(turno) % 2 == 1:
            prossimo.append(turno[-1])
        turno = prossimo
    campione, sconfitti = turno[0]
    secondo = sconfitti[0]
    for x in sconfitti[1:]:
        confronti += 1
        if x > secondo:
            secondo = x
    return campione, secondo, confronti

print(primo_e_secondo([7, 3, 9, 1, 8, 2, 6, 5]))
print(primo_e_secondo(list(range(1000)))[2])
