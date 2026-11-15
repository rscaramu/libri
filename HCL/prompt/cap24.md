# Capitolo 24 — Ambienti: workspace, file di variabili, cartelle

## Prompt 1

Ti descrivo il mio contesto: quante persone lavorano sull’infrastruttura, quanti ambienti servono, se la produzione deve stare in un account separato, quanto spesso si creano ambienti temporanei. Confronta per questo caso workspace, file di variabili e cartelle per ambiente, con vantaggi, rischi e una raccomandazione motivata. Dimmi anche quali informazioni ti mancano per essere più preciso.

## Prompt 2

Scrivimi uno script di shell che riceve come unico argomento il nome dell’ambiente, verifica che esistano il file `AMBIENTE.tfvars` e il file `AMBIENTE.backend.hcl`, esegue `init` con il backend giusto e poi `plan` con le variabili giuste. Deve rifiutarsi di procedere se l’ambiente è `produzione` e non viene data una conferma esplicita.

## Prompt 3

In questa configurazione ci sono undici condizioni su `terraform.workspace`. Elencale, raggruppale per tipo di differenza e proponimi come sostituirle con una mappa di impostazioni per ambiente, o con variabili, senza cambiare il comportamento attuale.
