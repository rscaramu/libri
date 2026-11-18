# Algoritmi - Roberto Scaramuzzino
# Capitolo 32
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

def mcd(a, b):
    passi = 0
    while b != 0:
        a, b = b, a % b
        passi += 1
    return abs(a), passi

def mcm(a, b):
    return a // mcd(a, b)[0] * b

print(mcd(1071, 462), mcd(17, 5), mcd(0, 9))
print(mcd(832040, 514229))        # Fibonacci consecutivi
print(mcm(4, 6), mcm(21, 6))

def semplifica(numeratore, denominatore):
    d = mcd(numeratore, denominatore)[0]
    return numeratore // d, denominatore // d

print(semplifica(462, 1071))


def euclide_esteso(a, b):
    r0, r1 = a, b
    x0, x1 = 1, 0
    y0, y1 = 0, 1
    while r1 != 0:
        q = r0 // r1
        r0, r1 = r1, r0 - q * r1
        x0, x1 = x1, x0 - q * x1
        y0, y1 = y1, y0 - q * y1
    return r0, x0, y0

d, x, y = euclide_esteso(240, 46)
print(d, x, y, 240 * x + 46 * y)

def diofantea(a, b, c):
    d, x, y = euclide_esteso(a, b)
    if c % d != 0:
        return None
    k = c // d
    return x * k, y * k

# pagare 100 con tagli da 12 e da 7 (anche "dando il resto")
print(diofantea(12, 7, 100), diofantea(12, 8, 30))


def potenza_modulare(b, e, m):
    r = 1
    b %= m
    while e > 0:
        if e % 2 == 1:
            r = r * b % m
        b = b * b % m
        e //= 2
    return r

print(potenza_modulare(7, 222, 10))       # ultima cifra
print(potenza_modulare(3, 10 ** 100, 1000007))
print(pow(3, 10 ** 100, 1000007))


def inverso_modulare(a, m):
    d, x, _ = euclide_esteso(a % m, m)
    if d != 1:
        raise ValueError('inverso inesistente')
    return x % m

print(inverso_modulare(3, 7), 3 * inverso_modulare(3, 7) % 7)
p = 1000000007
x = inverso_modulare(123456, p)
print(x, 123456 * x % p, pow(123456, p - 2, p) == x)
print(pow(3, -1, 7))            # Python 3.8 e successivi
try:
    inverso_modulare(4, 6)
except ValueError as e:
    print(e)


def resto_cinese(resti, moduli):
    x, m = resti[0], moduli[0]
    for a, n in zip(resti[1:], moduli[1:]):
        t = (a - x) * inverso_modulare(m, n) % n
        x += m * t
        m *= n
    return x, m

x, m = resto_cinese([2, 3, 2], [3, 5, 7])
print(x, m, x % 3, x % 5, x % 7)

# un intero grande ricostruito dai suoi resti
moduli = [1000003, 1000033, 1000037, 1000039]
segreto = 123456789012345678901
resti = [segreto % n for n in moduli]
print(resto_cinese(resti, moduli)[0] == segreto)


def iban_valido(iban):
    s = iban.replace(' ', '').upper()
    s = s[4:] + s[:4]
    numero = ''.join(str(int(c, 36)) for c in s)
    return int(numero) % 97 == 1

print(iban_valido('IT60 X054 2811 1010 0000 0123 456'))
print(iban_valido('IT60 X054 2811 1010 0000 0123 465'))
