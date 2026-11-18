# Algoritmi - Roberto Scaramuzzino
# Capitolo 39
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

import math

def passo_eulero(f, t, y, h):
    return y + h * f(t, y)

def passo_heun(f, t, y, h):
    k1 = f(t, y)
    k2 = f(t + h, y + h * k1)
    return y + h * (k1 + k2) / 2

def passo_rk4(f, t, y, h):
    k1 = f(t, y)
    k2 = f(t + h / 2, y + h / 2 * k1)
    k3 = f(t + h / 2, y + h / 2 * k2)
    k4 = f(t + h, y + h * k3)
    return y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6

def integra(passo, f, t0, y0, t1, n):
    h = (t1 - t0) / n
    y = y0
    for i in range(n):
        y = passo(f, t0 + i * h, y, h)
    return y

def raffreddamento(t, temperatura):
    return -0.1 * (temperatura - 20.0)      # legge di Newton

vero = 20 + 70 * math.exp(-0.1 * 10)        # dopo 10 minuti
print(round(vero, 6))
print('   n    Eulero      Heun       RK4')
for n in (5, 10, 20, 40):
    errori = [abs(integra(p, raffreddamento, 0, 90.0, 10, n)
                  - vero)
              for p in (passo_eulero, passo_heun, passo_rk4)]
    print(f'{n:>4} ' + ' '.join(f'{e:9.1e}' for e in errori))


def rk4_vettore(f, t, y, h):
    def piu(a, b, c):
        return [u + c * w for u, w in zip(a, b)]
    k1 = f(t, y)
    k2 = f(t + h / 2, piu(y, k1, h / 2))
    k3 = f(t + h / 2, piu(y, k2, h / 2))
    k4 = f(t + h, piu(y, k3, h))
    return [u + h * (a + 2 * b + 2 * c + d) / 6
            for u, a, b, c, d in zip(y, k1, k2, k3, k4)]

def eulero_vettore(f, t, y, h):
    return [u + h * d for u, d in zip(y, f(t, y))]

def oscillatore(t, stato):
    x, v = stato
    return [v, -x]                  # k/m = 1

def energia(stato):
    x, v = stato
    return (x * x + v * v) / 2

for nome, passo in (('Eulero', eulero_vettore),
                    ('RK4', rk4_vettore)):
    stato, h = [1.0, 0.0], 0.1
    for i in range(628):            # circa dieci periodi
        stato = passo(oscillatore, i * h, stato, h)
    print(nome, [round(v, 4) for v in stato],
          round(energia(stato), 4))
print([round(math.cos(62.8), 4), round(-math.sin(62.8), 4)])


def semi_implicito(x, v, h):
    v = v - h * x
    x = x + h * v
    return x, v

x, v = 1.0, 0.0
minima, massima = 1.0, 0.0
for _ in range(100000):
    x, v = semi_implicito(x, v, 0.1)
    e = (x * x + v * v) / 2
    minima, massima = min(minima, e), max(massima, e)
print(round(minima, 4), round(massima, 4))


def rigida(t, y):
    return -1000.0 * (y - math.cos(t))

def eulero_implicito(t, y, h):
    # y1 = y + h * (-1000) * (y1 - cos(t + h)), risolta per y1
    k = 1000.0 * h
    return (y + k * math.cos(t + h)) / (1 + k)

for h in (0.0005, 0.0019, 0.0021, 0.01):
    n = round(1.0 / h)
    y = 0.0
    for i in range(n):
        y = passo_eulero(rigida, i * h, y, h)
    print(h, f'{y:.4g}')

y, h = 0.0, 0.1
for i in range(10):
    y = eulero_implicito(i * h, y, h)
print(h, round(y, 4), round(math.cos(1.0), 4))
