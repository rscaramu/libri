# Capitolo 8 — Stringhe: interpolazione, direttive, heredoc

## Prompt 1

Voglio generare con HCL un file di testo come quello che ti incollo, a partire da una lista di oggetti con attributi `nome` e `ip`. Scrivi il modello come heredoc, usando la direttiva `for` e le tilde necessarie perché non restino righe vuote. Poi mostrami il risultato atteso per due elementi.

## Prompt 2

Ti incollo uno script di shell che devo incorporare in una configurazione Terraform/OpenTofu dentro uno heredoc. Individua tutte le sequenze che HCL interpreterebbe come interpolazioni o direttive e proteggile, lasciando invariato il resto. Elencami le righe che hai modificato.

## Prompt 3

In questa configurazione un documento JSON è costruito con uno heredoc e interpolazioni. Riscrivilo usando `jsonencode` su un valore HCL equivalente e spiegami quali ingressi avrebbero rotto la versione originale.
