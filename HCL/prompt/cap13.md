# Capitolo 13 — I provider e il blocco terraform

## Prompt 1

Scrivimi un file `versions.tf` per un progetto che usa i provider `local`, `random` e `tls` di HashiCorp. Usa per ciascuno l’operatore `~>` sulla versione maggiore corrente che conosci, dichiara esplicitamente che i numeri vanno verificati sul registro, e spiegami in una riga per vincolo quali versioni accetta e quali rifiuta.

## Prompt 2

Ti incollo l’errore che ottengo da `tofu init` dopo aver clonato un progetto di un collega che lavora su macOS, mentre io sono su Linux. Spiegami che cosa c’entra il file `.terraform.lock.hcl` e dammi il comando per aggiungere le impronte di entrambe le piattaforme.

## Prompt 3

Devo creare risorse in due regioni con lo stesso provider. Mostrami la struttura con un blocco predefinito e uno con alias, e una risorsa per ciascuna regione. Non inventare argomenti: se non sei sicuro di un nome, scrivi un commento che mi rimanda alla documentazione.
