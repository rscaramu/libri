# Algoritmi - Roberto Scaramuzzino
# Capitolo 46
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def accendi(x, i):
    return x | (1 << i)

def spegni(x, i):
    return x & ~(1 << i)

def inverti(x, i):
    return x ^ (1 << i)

def leggi(x, i):
    return (x >> i) & 1

registro = 0b00010100
registro = accendi(registro, 0)
registro = spegni(registro, 4)
registro = inverti(registro, 7)
print(f'{registro:08b}')
print(leggi(registro, 2), leggi(registro, 1))

colore = 0xFF8040                    # rosso, verde, blu
rosso = (colore >> 16) & 0xFF
verde = (colore >> 8) & 0xFF
blu = colore & 0xFF
print(rosso, verde, blu)
print(hex(rosso << 16 | verde << 8 | blu))

LETTURA, SCRITTURA, ESECUZIONE = 4, 2, 1
permessi = LETTURA | SCRITTURA
print(bool(permessi & SCRITTURA), bool(permessi & ESECUZIONE))


def conta_bit(x):
    n = 0
    while x:
        x &= x - 1
        n += 1
    return n

def potenza_di_due(x):
    return x > 0 and x & (x - 1) == 0

x = 0b10110100
print(f'{x & (x - 1):08b} {x & -x:08b}', conta_bit(x))
print([n for n in range(1, 70) if potenza_di_due(n)])
basso = x & -x
print(x.bit_count(), x.bit_length(), basso.bit_length() - 1)

def sottoinsiemi_di(m):
    s, elenco = m, []
    while True:
        elenco.append(f'{s:04b}')
        if s == 0:
            return elenco
        s = (s - 1) & m

print(sottoinsiemi_di(0b1010))

def elementi(insieme):
    risultato = []
    while insieme:
        basso = insieme & -insieme
        risultato.append(basso.bit_length() - 1)
        insieme ^= basso
    return risultato

a, b = 0b101101, 0b011001
print(elementi(a), elementi(b))
print(elementi(a | b), elementi(a & b), elementi(a & ~b))


def spaiato(a):
    r = 0
    for x in a:
        r ^= x
    return r

print(spaiato([7, 3, 5, 3, 7, 9, 5]))

def mancante(a):
    r = len(a)
    for i, x in enumerate(a):
        r ^= i ^ x
    return r

print(mancante([3, 0, 1, 5, 4]))

dischi = [0b10110010, 0b01101100, 0b11100001]
parita = dischi[0] ^ dischi[1] ^ dischi[2]
# il secondo disco e' andato perduto
ricostruito = dischi[0] ^ dischi[2] ^ parita
print(f'{ricostruito:08b}', ricostruito == dischi[1])


def in_gray(n):
    return n ^ (n >> 1)

def da_gray(g):
    n = 0
    while g:
        n ^= g
        g >>= 1
    return n

print([f'{in_gray(n):03b}' for n in range(8)])
print(all(da_gray(in_gray(n)) == n for n in range(1000)))

class ArrayDiBit:
    def __init__(self, n):
        self.parole = [0] * ((n + 63) // 64)

    def accendi(self, i):
        self.parole[i >> 6] |= 1 << (i & 63)

    def spegni(self, i):
        self.parole[i >> 6] &= ~(1 << (i & 63))

    def leggi(self, i):
        return self.parole[i >> 6] >> (i & 63) & 1

    def quanti(self):
        return sum(p.bit_count() for p in self.parole)

bit = ArrayDiBit(1000)
for i in range(0, 1000, 7):
    bit.accendi(i)
bit.spegni(70)
print(bit.leggi(63), bit.leggi(64), bit.leggi(70))
print(bit.quanti())
print(len(bit.parole))
