# Algoritmi - Roberto Scaramuzzino
# Capitolo 5
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def fattoriale(n):
    if n == 0:
        return 1
    return n * fattoriale(n - 1)

print(fattoriale(5), fattoriale(0), fattoriale(20))


def somma_fino_a(n):
    if n == 0:
        return 0
    return n + somma_fino_a(n - 1)

print(somma_fino_a(500))
try:
    somma_fino_a(100000)
except RecursionError:
    print('pila esaurita')


def hanoi(n, partenza, arrivo, appoggio, mosse):
    if n == 0:
        return
    hanoi(n - 1, partenza, appoggio, arrivo, mosse)
    mosse.append((n, partenza, arrivo))
    hanoi(n - 1, appoggio, arrivo, partenza, mosse)

mosse = []
hanoi(3, 'A', 'C', 'B', mosse)
for disco, da, a in mosse:
    print(f'disco {disco}: {da} -> {a}')

for n in (3, 10, 20):
    m = []
    hanoi(n, 'A', 'C', 'B', m)
    print(n, len(m))


chiamate = 0

def fib(n):
    global chiamate
    chiamate += 1
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)

def fib_memo(n, tabella):
    global chiamate
    chiamate += 1
    if n < 2:
        return n
    if n in tabella:
        return tabella[n]
    tabella[n] = (fib_memo(n - 1, tabella)
                  + fib_memo(n - 2, tabella))
    return tabella[n]

def fib_iterativo(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

for n in (10, 20, 25):
    chiamate = 0
    v1 = fib(n)
    c1 = chiamate
    chiamate = 0
    v2 = fib_memo(n, {})
    c2 = chiamate
    print(n, v1, v2, fib_iterativo(n), c1, c2)


import math

def t2(n):
    return 1 if n <= 1 else 2 * t2(n // 2) + n

def t3(n):
    return 1 if n <= 1 else 3 * t3(n // 2) + n

for k in (4, 8, 12, 16):
    n = 2 ** k
    r2 = t2(n) / (n * math.log2(n))
    r3 = t3(n) / n ** math.log2(3)
    print(f'{n:>6} {t2(n):>8} {r2:.3f} {t3(n):>10} {r3:.3f}')


def somma_ricorsiva(x):
    if isinstance(x, int):
        return x
    return sum(somma_ricorsiva(y) for y in x)

def somma_annidata(lista):
    totale = 0
    pila = [lista]
    while pila:
        x = pila.pop()
        if isinstance(x, int):
            totale += x
        else:
            pila.extend(x)
    return totale

dati = [1, [2, 3, [4]], [[5], 6]]
print(somma_ricorsiva(dati), somma_annidata(dati))

profonda = 7
for _ in range(50000):
    profonda = [profonda]
print(somma_annidata(profonda))
