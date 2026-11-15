# Capitolo 6 — Variabili, valori locali e output

## Prompt 1

Ti incollo una configurazione HCL piena di valori scritti direttamente nel codice. Individua quelli che ha senso trasformare in variabili d’ingresso e quelli che conviene trasformare in valori locali, motivando ogni scelta. Poi scrivi i blocchi `variable` con tipo esplicito, descrizione in italiano e valore predefinito ragionevole.

## Prompt 2

Scrivi un blocco `variable` di tipo `object` per descrivere una macchina virtuale: nome obbligatorio, numero di CPU facoltativo con valore 2, memoria in GB facoltativa con valore 4, elenco di dischi facoltativo e vuoto se omesso. Usa `optional` e non usare `any`. Aggiungi un esempio di file `.tfvars` che imposta solo il nome.

## Prompt 3

Ho una variabile definita in tre posti: con `default`, in `terraform.tfvars` e con `TF_VAR_`. Spiegami quale valore viene usato e perché, e suggeriscimi un comando per scoprire da dove arriva il valore effettivo.
