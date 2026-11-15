# Manuale completo di HCL

Materiale per i lettori del volume *Manuale completo di HCL — Dai fondamenti del linguaggio all’infrastruttura come codice con Terraform e OpenTofu* di Roberto Scaramuzzino.

## Che cosa contiene

- `esempi/` — i blocchi di codice del libro, capitolo per capitolo, nell'ordine in cui compaiono. I file `esempio-NN.tf` sono configurazioni o frammenti; i file `sessione-NN.txt` riportano comandi del terminale o sessioni della console con la relativa uscita.
- `prompt/` — le richieste per l'assistente IA proposte alla fine di ogni capitolo, pronte da copiare.
- `ERRATA.md` — le correzioni segnalate dopo la pubblicazione.

Il testo del libro non è incluso.

## Come usare gli esempi

Gli esempi sono stati eseguiti con OpenTofu 1.11 e ricontrollati con la versione 1.12; valgono per Terraform 1.x sostituendo il comando `tofu` con `terraform`, salvo dove il libro segnala una differenza.

Molti file sono frammenti che illustrano un costrutto e non configurazioni complete: vanno letti insieme al capitolo. Per provare una configurazione completa, copiatela in una cartella vuota con il nome `main.tf` ed eseguite:

```console
tofu init
tofu validate
tofu plan
```

La maggior parte degli esempi usa provider che non richiedono un account (`local`, `random`, `time`, `archive`, `terraform`). Quelli che usano il provider `docker` richiedono Docker installato per essere applicati. Quelli che usano `aws`, `azurerm` o `google`, in particolare nel capitolo 29, richiedono un account presso il fornitore e creano risorse a pagamento: leggete le avvertenze del capitolo prima di applicarli.

## Indice

| Cap. | Titolo | Esempi | Prompt |
|---|---|---|---|
| 1 | Che cos’è HCL e a che cosa serve | [esempi](esempi/cap01) | [prompt](prompt/cap01.md) |
| 2 | L’ambiente di lavoro | [esempi](esempi/cap02) | [prompt](prompt/cap02.md) |
| 3 | La sintassi di base | [esempi](esempi/cap03) | [prompt](prompt/cap03.md) |
| 4 | I tipi primitivi: stringhe, numeri, booleani | [esempi](esempi/cap04) | [prompt](prompt/cap04.md) |
| 5 | I tipi composti: liste, insiemi, mappe, oggetti, tuple | [esempi](esempi/cap05) | [prompt](prompt/cap05.md) |
| 6 | Variabili, valori locali e output | [esempi](esempi/cap06) | [prompt](prompt/cap06.md) |
| 7 | Operatori ed espressioni condizionali | [esempi](esempi/cap07) | [prompt](prompt/cap07.md) |
| 8 | Stringhe: interpolazione, direttive, heredoc | [esempi](esempi/cap08) | [prompt](prompt/cap08.md) |
| 9 | Espressioni for e splat | [esempi](esempi/cap09) | [prompt](prompt/cap09.md) |
| 10 | Funzioni per stringhe e numeri | [esempi](esempi/cap10) | [prompt](prompt/cap10.md) |
| 11 | Funzioni per collezioni | [esempi](esempi/cap11) | [prompt](prompt/cap11.md) |
| 12 | Codifica, file, date, rete e gestione degli errori | [esempi](esempi/cap12) | [prompt](prompt/cap12.md) |
| 13 | I provider e il blocco terraform | [esempi](esempi/cap13) | [prompt](prompt/cap13.md) |
| 14 | Risorse e sorgenti di dati | [esempi](esempi/cap14) | [prompt](prompt/cap14.md) |
| 15 | Dipendenze e grafo di esecuzione | [esempi](esempi/cap15) | [prompt](prompt/cap15.md) |
| 16 | Ripetere le risorse: count e for_each | [esempi](esempi/cap16) | [prompt](prompt/cap16.md) |
| 17 | I blocchi dinamici | [esempi](esempi/cap17) | [prompt](prompt/cap17.md) |
| 18 | Ciclo di vita, condizioni e controlli | [esempi](esempi/cap18) | [prompt](prompt/cap18.md) |
| 19 | I moduli: scriverli e usarli | [esempi](esempi/cap19) | [prompt](prompt/cap19.md) |
| 20 | Comporre i moduli e usare i registri | [esempi](esempi/cap20) | [prompt](prompt/cap20.md) |
| 21 | Lo stato | [esempi](esempi/cap21) | [prompt](prompt/cap21.md) |
| 22 | Backend, stato remoto e blocco | [esempi](esempi/cap22) | [prompt](prompt/cap22.md) |
| 23 | Ristrutturare: moved, import, removed | [esempi](esempi/cap23) | [prompt](prompt/cap23.md) |
| 24 | Ambienti: workspace, file di variabili, cartelle | [esempi](esempi/cap24) | [prompt](prompt/cap24.md) |
| 25 | Stile, formattazione e convenzioni | [esempi](esempi/cap25) | [prompt](prompt/cap25.md) |
| 26 | Collaudare: i test | [esempi](esempi/cap26) | [prompt](prompt/cap26.md) |
| 27 | Sicurezza e segreti | [esempi](esempi/cap27) | [prompt](prompt/cap27.md) |
| 28 | Automazione e integrazione continua | [esempi](esempi/cap28) | [prompt](prompt/cap28.md) |
| 29 | I provider cloud in pratica: AWS, Azure, Google Cloud | [esempi](esempi/cap29) | [prompt](prompt/cap29.md) |
| 30 | Diagnosi, debug e prestazioni | [esempi](esempi/cap30) | [prompt](prompt/cap30.md) |
| 31 | Packer: costruire immagini | [esempi](esempi/cap31) | [prompt](prompt/cap31.md) |
| 32 | Nomad: descrivere i carichi di lavoro | [esempi](esempi/cap32) | [prompt](prompt/cap32.md) |
| 33 | Vault e Consul: politiche e configurazioni | [esempi](esempi/cap33) | [prompt](prompt/cap33.md) |
| 34 | HCL dall’interno | [esempi](esempi/cap34) | [prompt](prompt/cap34.md) |

## Segnalazioni

Errori e suggerimenti si possono segnalare aprendo una *issue* in questo repository.
