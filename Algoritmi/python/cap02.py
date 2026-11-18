# Algoritmi - Roberto Scaramuzzino
# Capitolo 2
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def rovescia(a):
    i, j = 0, len(a) - 1
    while i < j:
        a[i], a[j] = a[j], a[i]
        i += 1
        j -= 1

dati = [1, 2, 3, 4, 5]
rovescia(dati)
print(dati)


print(7 // 2, 7 % 2)
print(-7 // 2, -7 % 2)
print(7 / 2)
print(2 ** 100)


class Nodo:
    def __init__(self, chiave, succ=None):
        self.chiave = chiave
        self.succ = succ

n2 = Nodo(20)
n1 = Nodo(10, n2)
print(n1.chiave, n1.succ.chiave, n2.succ)


a = [1, 2, 3]
b = a          # stesso oggetto
c = a[:]       # copia
b[0] = 99
print(a, b, c)

griglia = [[0] * 3] * 2      # due volte la stessa riga
griglia[0][0] = 7
print(griglia)

griglia = [[0] * 3 for _ in range(2)]   # due righe distinte
griglia[0][0] = 7
print(griglia)
