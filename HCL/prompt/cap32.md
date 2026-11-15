# Capitolo 32 — Nomad: descrivere i carichi di lavoro

## Prompt 1

Conosco Terraform e sto imparando Nomad. Spiegami la gerarchia `job`, `group`, `task` con un esempio minimo commentato, e dimmi per ciascuno dei tre livelli quali decisioni si prendono lì: replica, collocazione, risorse, rete.

## Prompt 2

Scrivimi un job Nomad di tipo `service` per l’applicazione che ti descrivo: immagine, porta, numero di copie, variabili d’ambiente. Includi controllo di salute e aggiornamento progressivo con ritorno automatico. Per ogni interpolazione che usi, indica in un commento se viene risolta da HCL alla lettura o da Nomad all’esecuzione.

## Prompt 3

Questo job resta in stato `pending` e non viene collocato. Ti incollo il file e l’uscita di `nomad job plan` e di `nomad job status`. Aiutami a capire quale requisito non è soddisfatto: risorse, vincoli, datacenter, driver.
