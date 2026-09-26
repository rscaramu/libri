import signal
import sys
import time

fermato = False


def gestisci(sig, frame):
    global fermato
    print(f"Ricevuto segnale {sig}, chiudo con grazia...")
    fermato = True


signal.signal(signal.SIGTERM, gestisci)
signal.signal(signal.SIGINT, gestisci)

print("Servizio avviato")
while not fermato:
    time.sleep(0.5)
print("Connessioni chiuse, esco")
sys.exit(0)
