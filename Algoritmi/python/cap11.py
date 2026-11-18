# Algoritmi - Roberto Scaramuzzino
# Capitolo 11
# I blocchi sono nell'ordine del libro e si eseguono in sequenza.

class NodoAVL:
    def __init__(self, chiave):
        self.chiave = chiave
        self.sinistro = None
        self.destro = None
        self.altezza = 0

def alt(nodo):
    return -1 if nodo is None else nodo.altezza

def aggiorna(nodo):
    s, d = alt(nodo.sinistro), alt(nodo.destro)
    nodo.altezza = 1 + max(s, d)

def fattore(nodo):
    return alt(nodo.sinistro) - alt(nodo.destro)

def ruota_destra(y):
    x = y.sinistro
    y.sinistro = x.destro
    x.destro = y
    aggiorna(y)
    aggiorna(x)
    return x

def ruota_sinistra(x):
    y = x.destro
    x.destro = y.sinistro
    y.sinistro = x
    aggiorna(x)
    aggiorna(y)
    return y

def bilancia(nodo):
    aggiorna(nodo)
    f = fattore(nodo)
    if f > 1:
        if fattore(nodo.sinistro) < 0:
            nodo.sinistro = ruota_sinistra(nodo.sinistro)
        return ruota_destra(nodo)
    if f < -1:
        if fattore(nodo.destro) > 0:
            nodo.destro = ruota_destra(nodo.destro)
        return ruota_sinistra(nodo)
    return nodo

def inserisci_avl(nodo, k):
    if nodo is None:
        return NodoAVL(k)
    if k < nodo.chiave:
        nodo.sinistro = inserisci_avl(nodo.sinistro, k)
    elif k > nodo.chiave:
        nodo.destro = inserisci_avl(nodo.destro, k)
    return bilancia(nodo)

def elimina_avl(nodo, k):
    if nodo is None:
        return None
    if k < nodo.chiave:
        nodo.sinistro = elimina_avl(nodo.sinistro, k)
    elif k > nodo.chiave:
        nodo.destro = elimina_avl(nodo.destro, k)
    else:
        if nodo.sinistro is None:
            return nodo.destro
        if nodo.destro is None:
            return nodo.sinistro
        s = nodo.destro
        while s.sinistro is not None:
            s = s.sinistro
        nodo.chiave = s.chiave
        nodo.destro = elimina_avl(nodo.destro, s.chiave)
    return bilancia(nodo)

def in_ordine(nodo, uscita):
    if nodo is not None:
        in_ordine(nodo.sinistro, uscita)
        uscita.append(nodo.chiave)
        in_ordine(nodo.destro, uscita)
    return uscita

def e_avl(nodo):
    # controlla l'invariante su tutto l'albero
    if nodo is None:
        return True
    return (abs(fattore(nodo)) <= 1
            and e_avl(nodo.sinistro) and e_avl(nodo.destro))

radice = None
for k in (10, 20, 30, 40, 50, 25):
    radice = inserisci_avl(radice, k)
    print(k, radice.chiave, radice.altezza)

radice = None
for k in range(2000):
    radice = inserisci_avl(radice, k)
print(radice.altezza, e_avl(radice))
for k in range(0, 2000, 2):
    radice = elimina_avl(radice, k)
rimaste = len(in_ordine(radice, []))
print(radice.altezza, e_avl(radice), rimaste)


class NodoRN:
    def __init__(self, chiave):
        self.chiave = chiave
        self.sinistro = None
        self.destro = None
        self.rosso = True

def rosso(nodo):
    return nodo is not None and nodo.rosso

def rn_ruota_sinistra(h):
    x = h.destro
    h.destro = x.sinistro
    x.sinistro = h
    x.rosso, h.rosso = h.rosso, True
    return x

def rn_ruota_destra(h):
    x = h.sinistro
    h.sinistro = x.destro
    x.destro = h
    x.rosso, h.rosso = h.rosso, True
    return x

def inverti_colori(h):
    h.rosso = True
    h.sinistro.rosso = False
    h.destro.rosso = False

def inserisci_rn(h, k):
    if h is None:
        return NodoRN(k)
    if k < h.chiave:
        h.sinistro = inserisci_rn(h.sinistro, k)
    elif k > h.chiave:
        h.destro = inserisci_rn(h.destro, k)
    if rosso(h.destro) and not rosso(h.sinistro):
        h = rn_ruota_sinistra(h)
    if rosso(h.sinistro) and rosso(h.sinistro.sinistro):
        h = rn_ruota_destra(h)
    if rosso(h.sinistro) and rosso(h.destro):
        inverti_colori(h)
    return h

def inserisci(radice, k):
    radice = inserisci_rn(radice, k)
    radice.rosso = False
    return radice

def neri(nodo):
    # altezza nera, oppure -1 se una regola e' violata
    if nodo is None:
        return 1
    if rosso(nodo) and (rosso(nodo.sinistro)
                        or rosso(nodo.destro)):
        return -1
    s, d = neri(nodo.sinistro), neri(nodo.destro)
    if s < 0 or s != d:
        return -1
    return s + (0 if nodo.rosso else 1)

def altezza(nodo):
    if nodo is None:
        return -1
    s, d = altezza(nodo.sinistro), altezza(nodo.destro)
    return 1 + max(s, d)

radice = None
for k in range(2000):
    radice = inserisci(radice, k)
print(altezza(radice), neri(radice), radice.rosso)
