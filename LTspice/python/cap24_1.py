import numpy as np

def leggi_raw(nome):
    dati = open(nome, "rb").read()
    fine = dati.find("Binary:\n".encode("utf-16-le"))
    testa = dati[:fine].decode("utf-16-le")
    corpo = dati[fine + 16:]
    righe = testa.splitlines()
    def campo(chiave):
        return [r for r in righe if r.startswith(chiave)][0]
    nvar = int(campo("No. Variables").split(":")[1])
    npun = int(campo("No. Points").split(":")[1])
    flags = campo("Flags")
    k = righe.index("Variables:")
    nomi = [r.split("\t")[2]
            for r in righe[k + 1:k + 1 + nvar]]
    if "complex" in flags:
        tipo = np.dtype([(n, "<c16") for n in nomi])
    else:
        tipo = np.dtype([(nomi[0], "<f8")] +
                        [(n, "<f4") for n in nomi[1:]])
    tab = np.frombuffer(corpo, dtype=tipo, count=npun)
    return {n: np.array(tab[n]) for n in nomi}
