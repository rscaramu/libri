# Algoritmi - Roberto Scaramuzzino
# Capitolo 43
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

TABELLA = {
    ('inizio', 'segno'): 'segno',
    ('inizio', 'cifra'): 'intero',
    ('segno', 'cifra'): 'intero',
    ('intero', 'cifra'): 'intero',
    ('intero', 'virgola'): 'virgola',
    ('virgola', 'cifra'): 'frazione',
    ('frazione', 'cifra'): 'frazione',
}
FINALI = {'intero', 'frazione'}

def classe(c):
    if c in '+-':
        return 'segno'
    if c.isdigit():
        return 'cifra'
    if c == ',':
        return 'virgola'
    return 'altro'

def numero_valido(s):
    stato = 'inizio'
    for c in s:
        stato = TABELLA.get((stato, classe(c)))
        if stato is None:
            return False
    return stato in FINALI

for prova in ('42', '-3,14', '+0,5', '3,', ',5', '--2',
              '1,2,3', ''):
    print(repr(prova), numero_valido(prova))


def tokenizza(testo):
    token, i, n = [], 0, len(testo)
    while i < n:
        c = testo[i]
        if c.isspace():
            i += 1
        elif c.isdigit():
            j = i
            while j < n and (testo[j].isdigit()
                             or testo[j] == '.'):
                j += 1
            token.append(('NUM', float(testo[i:j]), i))
            i = j
        elif c.isalpha():
            j = i
            while j < n and testo[j].isalnum():
                j += 1
            token.append(('NOME', testo[i:j], i))
            i = j
        elif c in '+-*/^()':
            token.append(('SIM', c, i))
            i += 1
        else:
            raise SyntaxError(f'carattere {c!r} in {i}')
    return token

PREC = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
DESTRA = {'^'}

def in_postfissa(token):
    uscita, pila = [], []
    for tipo, valore, pos in token:
        if tipo == 'NUM':
            uscita.append(valore)
        elif valore in PREC:
            while pila and pila[-1] in PREC and (
                    PREC[pila[-1]] > PREC[valore]
                    or (PREC[pila[-1]] == PREC[valore]
                        and valore not in DESTRA)):
                uscita.append(pila.pop())
            pila.append(valore)
        elif valore == '(':
            pila.append(valore)
        elif valore == ')':
            while pila and pila[-1] != '(':
                uscita.append(pila.pop())
            if not pila:
                raise SyntaxError(f'")" di troppo in {pos}')
            pila.pop()
        else:
            raise SyntaxError(f'{valore!r} inatteso in {pos}')
    while pila:
        if pila[-1] == '(':
            raise SyntaxError('"(" non chiusa')
        uscita.append(pila.pop())
    return uscita

def valuta_postfissa(simboli):
    pila = []
    for s in simboli:
        if isinstance(s, float):
            pila.append(s)
            continue
        b, a = pila.pop(), pila.pop()
        if s == '+':
            pila.append(a + b)
        elif s == '-':
            pila.append(a - b)
        elif s == '*':
            pila.append(a * b)
        elif s == '/':
            pila.append(a / b)
        else:
            pila.append(a ** b)
    return pila.pop()

def mostra(simboli):
    return ' '.join(f'{s:g}' if isinstance(s, float) else s
                    for s in simboli)

for testo in ('3 + 4 * 2', '(3 + 4) * 2', '8 - 3 - 2',
              '2 ^ 3 ^ 2', '10 / (4 - 2) * 3'):
    post = in_postfissa(tokenizza(testo))
    print(f'{testo:<18} {mostra(post):<16}',
          valuta_postfissa(post))


class Analizzatore:
    def __init__(self, testo, variabili=None):
        fine = ('FINE', None, len(testo))
        self.token = tokenizza(testo) + [fine]
        self.i = 0
        self.variabili = variabili or {}

    def corrente(self):
        return self.token[self.i][1]

    def avanza(self):
        self.i += 1

    def errore(self, messaggio):
        pos = self.token[self.i][2]
        raise SyntaxError(f'{messaggio} in posizione {pos}')

    def espressione(self):
        valore = self.termine()
        while self.corrente() in ('+', '-'):
            op = self.corrente()
            self.avanza()
            destra = self.termine()
            if op == '+':
                valore = valore + destra
            else:
                valore = valore - destra
        return valore

    def termine(self):
        valore = self.fattore()
        while self.corrente() in ('*', '/'):
            op = self.corrente()
            self.avanza()
            destra = self.fattore()
            if op == '*':
                valore = valore * destra
            else:
                valore = valore / destra
        return valore

    def fattore(self):
        tipo, valore, _ = self.token[self.i]
        if tipo == 'NUM':
            self.avanza()
            return valore
        if tipo == 'NOME':
            if valore not in self.variabili:
                self.errore(f'nome {valore!r} sconosciuto')
            self.avanza()
            return self.variabili[valore]
        if valore == '(':
            self.avanza()
            risultato = self.espressione()
            if self.corrente() != ')':
                self.errore('attesa ")"')
            self.avanza()
            return risultato
        if valore == '-':
            self.avanza()
            return -self.fattore()
        self.errore('atteso un numero o "("')

def calcola(testo, **variabili):
    a = Analizzatore(testo, variabili)
    valore = a.espressione()
    if a.token[a.i][0] != 'FINE':
        a.errore('testo inatteso')
    return valore

print(calcola('3 + 4 * 2'), calcola('-(2 + 3) * -4'))
print(calcola('r * i * i', r=470.0, i=0.02))
for sbagliata in ('3 + * 4', '(1 + 2', '2 3', '4 / x'):
    try:
        calcola(sbagliata)
    except SyntaxError as e:
        print(repr(sbagliata), '->', e)


import re
import time

motivo = re.compile(r'[+-]?\d+(,\d+)?')
for prova in ('-3,14', '3,', '1,2,3'):
    print(prova, motivo.fullmatch(prova) is not None)

specifiche = [('NUM', r'\d+(\.\d+)?'),
              ('NOME', r'[A-Za-z]\w*'),
              ('SIM', r'[-+*/^()]'), ('SPAZIO', r'\s+')]
unico = '|'.join(f'(?P<{nome}>{espr})'
                 for nome, espr in specifiche)
print(' '.join(f'{m.lastgroup}:{m.group()}'
               for m in re.finditer(unico, 'r1 * (i+2.5)')
               if m.lastgroup != 'SPAZIO'))

pericoloso = re.compile(r'(a+)+b')
tempi = {}
for n in (14, 22):
    inizio = time.perf_counter()
    pericoloso.match('a' * n)
    tempi[n] = time.perf_counter() - inizio
print(tempi[22] > 20 * tempi[14])
