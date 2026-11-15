# Capitolo 12 — Codifica, file, date, rete e gestione degli errori

## Prompt 1

Ti incollo una politica di accesso in JSON. Riscrivila come valore HCL passato a `jsonencode`, sostituendo con riferimenti a variabili i tre identificativi che ti indico. Non cambiare l’ordine logico delle istruzioni e segnala eventuali chiavi che in HCL richiedono le virgolette.

## Prompt 2

Devo dividere la rete 172.16.0.0/20 in sei sottoreti uguali per altrettanti laboratori e riservarne due più piccole per la gestione. Proponimi lo schema con `cidrsubnet` o `cidrsubnets`, mostrami la tabella degli indirizzi risultanti e spiegami come verificare ciascuno nella console.

## Prompt 3

Ho un file CSV con colonne `nome`, `ruolo` e `quota`. Scrivimi i valori locali che lo leggono con `csvdecode`, convertono la quota in numero e producono una mappa indicizzata per nome. Indica dove un valore mancante o non numerico farebbe fallire la configurazione e come proteggersi.
