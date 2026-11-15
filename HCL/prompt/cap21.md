# Capitolo 21 — Lo stato

## Prompt 1

Ti incollo l’uscita di `tofu state list` e la descrizione della ristrutturazione che voglio fare: rinominare due risorse e spostarne tre in un modulo. Scrivimi il piano di lavoro passo per passo, con le copie di sicurezza da fare prima, e dimmi per quali passaggi posso usare blocchi `moved` invece dei comandi `state mv`.

## Prompt 2

Il piano mi segnala «Objects have changed outside of OpenTofu» per queste risorse; ti incollo la parte rilevante, ripulita dai dati riservati. Aiutami a capire se la modifica esterna va accettata, adeguando la configurazione, o annullata, e quali comandi corrispondono a ciascuna scelta.

## Prompt 3

Spiegami la differenza fra `tofu state rm`, `tofu destroy -target` e la rimozione del blocco dalla configurazione, in termini di che cosa accade allo stato, alla configurazione e all’oggetto reale. Fai una tabella.
