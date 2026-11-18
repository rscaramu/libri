# Algoritmi - Roberto Scaramuzzino
# Capitolo 8
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def bilanciate(s):
    coppie = {')': '(', ']': '[', '}': '{'}
    pila = []
    for c in s:
        if c in '([{':
            pila.append(c)
        elif c in coppie:
            if not pila or pila.pop() != coppie[c]:
                return False
    return not pila

for prova in ('a[i] = f(x) * {y}', '([)]', '((', ')', ''):
    print(repr(prova), bilanciate(prova))


def valuta_postfissa(espressione):
    pila = []
    for s in espressione.split():
        if s in '+-*/':
            b = pila.pop()
            a = pila.pop()
            if s == '+':
                pila.append(a + b)
            elif s == '-':
                pila.append(a - b)
            elif s == '*':
                pila.append(a * b)
            else:
                pila.append(a / b)
        else:
            pila.append(float(s))
    if len(pila) != 1:
        raise ValueError('espressione mal formata')
    return pila.pop()

print(valuta_postfissa('3 4 + 2 *'))
print(valuta_postfissa('10 2 8 * + 3 -'))
print(valuta_postfissa('7 2 /'))


class CodaCircolare:
    def __init__(self, capacita=4):
        self.dati = [None] * capacita
        self.testa = 0
        self.n = 0

    def _raddoppia(self):
        vecchia = len(self.dati)
        nuovi = [None] * (2 * vecchia)
        for i in range(self.n):
            nuovi[i] = self.dati[(self.testa + i) % vecchia]
        self.dati, self.testa = nuovi, 0

    def accoda(self, x):
        if self.n == len(self.dati):
            self._raddoppia()
        fondo = (self.testa + self.n) % len(self.dati)
        self.dati[fondo] = x
        self.n += 1

    def estrai(self):
        if self.n == 0:
            raise IndexError('coda vuota')
        x = self.dati[self.testa]
        self.dati[self.testa] = None
        self.testa = (self.testa + 1) % len(self.dati)
        self.n -= 1
        return x

q = CodaCircolare()
for x in 'abcd':
    q.accoda(x)
print(q.estrai(), q.estrai())
q.accoda('e')
q.accoda('f')
print(q.dati, q.testa)
q.accoda('g')
print(q.dati, q.testa)
print([q.estrai() for _ in range(q.n)])


class CodaDuePile:
    def __init__(self):
        self.ingresso = []
        self.uscita = []

    def accoda(self, x):
        self.ingresso.append(x)

    def estrai(self):
        if not self.uscita:
            while self.ingresso:
                self.uscita.append(self.ingresso.pop())
        if not self.uscita:
            raise IndexError('coda vuota')
        return self.uscita.pop()

q = CodaDuePile()
for x in (1, 2, 3):
    q.accoda(x)
print(q.estrai())
q.accoda(4)
print(q.estrai(), q.estrai(), q.estrai())


from collections import deque

def massimi_finestra(a, k):
    d = deque()
    risultato = []
    for i in range(len(a)):
        while d and a[d[-1]] <= a[i]:
            d.pop()
        d.append(i)
        if d[0] <= i - k:
            d.popleft()
        if i >= k - 1:
            risultato.append(a[d[0]])
    return risultato

dati = [4, 2, 12, 3, 8, 7, 1, 9]
print(massimi_finestra(dati, 3))
print([max(dati[i:i + 3]) for i in range(len(dati) - 2)])
print(massimi_finestra(dati, 1) == dati)
