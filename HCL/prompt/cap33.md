# Capitolo 33 — Vault e Consul: politiche e configurazioni

## Prompt 1

Ti incollo una politica di Vault. Elencami, percorso per percorso, che cosa permette e che cosa vieta, tenendo conto della precedenza del percorso più specifico e di `deny`. Poi dimmi quali percorsi dovrei provare con `vault token capabilities` per verificarla, e quale risultato dovrei ottenere per ciascuno.

## Prompt 2

Un’applicazione deve poter leggere i propri segreti dell’ambiente di collaudo, elencarne le chiavi, e nient’altro. Scrivimi la politica minima per il motore di segreti a versioni montato su `secret/`, e spiegami perché compaiono i segmenti `data` e `metadata`.

## Prompt 3

Ho dieci applicazioni con politiche identiche a meno del nome. Mostrami come generarle da Terraform con il provider `vault`, un modello e `for_each`, e dimmi quali vantaggi e quali rischi ha gestire le politiche in questo modo rispetto ai file caricati a mano.
