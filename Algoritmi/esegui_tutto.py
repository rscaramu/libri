#!/usr/bin/env python3
# Esegue tutti i capitoli e segnala quelli che falliscono.
import pathlib
import subprocess
import sys

qui = pathlib.Path(__file__).resolve().parent
falliti = []
for f in sorted((qui / 'python').glob('cap*.py')):
    r = subprocess.run([sys.executable, str(f)],
                       capture_output=True, text=True)
    esito = 'ok' if r.returncode == 0 else 'ERRORE'
    print(f'{f.name}: {esito}')
    if r.returncode != 0:
        falliti.append(f.name)
        print(r.stderr.strip().splitlines()[-1])
print()
print('Capitoli eseguiti senza errori:',
      len(list((qui / 'python').glob('cap*.py'))) - len(falliti))
if falliti:
    print('Da controllare:', ', '.join(falliti))
    sys.exit(1)
