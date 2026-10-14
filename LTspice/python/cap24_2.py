def passi(dati):
    nomi = list(dati)
    x = np.real(dati[nomi[0]])
    inizi = [0] + [i for i in range(1, len(x))
                   if x[i] < x[i - 1]]
    fini = inizi[1:] + [len(x)]
    return [{n: dati[n][a:b] for n in nomi}
            for a, b in zip(inizi, fini)]
