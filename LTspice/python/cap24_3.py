from leggi_raw import leggi_raw, passi

d = leggi_raw("rc.raw")
t, v = d["time"], d["V(out)"]
t10 = np.interp(0.1, v[t < 5e-3], t[t < 5e-3])
t90 = np.interp(0.9, v[t < 5e-3], t[t < 5e-3])
print(f"salita 10-90%: {(t90 - t10) * 1e3:.4f} ms")

for p in passi(leggi_raw("rca.raw")):
    f, g = np.real(p["frequency"]), np.abs(p["V(out)"])
    fc = np.interp(-0.5, -g**2, f)
    print(f"punti: {len(f)}, taglio: {fc:.1f} Hz")
