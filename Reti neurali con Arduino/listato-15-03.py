# listato-15-03.py — La soglia sui dati normali: media più tre deviazioni standard. Con dati normali ben distribuiti, circa l'1% delle finestre normali la supera: è il tasso di falsi allarmi da mettere in conto e da abbattere con il debouncing.

err = ((ae.predict(Xn) - Xn) ** 2).mean(1)           # per finestra
soglia = err.mean() + 3 * err.std()                  # regola 3 sigma
print(f"errore normale: {err.mean():.3f} ± {err.std():.3f}"
      f"  soglia: {soglia:.3f}")
# quante finestre normali supererebbero la soglia?
print((err > soglia).mean())                          # circa 1 su 100
