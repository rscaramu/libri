# Capitolo 31 — Packer: costruire immagini

## Prompt 1

Conosco bene Terraform e non ho mai usato Packer. Spiegami un modello Packer in HCL mettendo a confronto ogni blocco con il suo analogo in Terraform, e soffermati sulle differenze di comportamento: stato, ordine dei blocchi, modo di citare le sorgenti.

## Prompt 2

Scrivimi un modello Packer in formato HCL2 che costruisca un’immagine per la piattaforma che ti indico, con un server web installato. Usa `required_plugins`, variabili per regione e versione, e un nome d’immagine che contenga la data. Segnala con un commento ogni argomento della sorgente di cui non sei certo.

## Prompt 3

Ti incollo un vecchio modello Packer in formato JSON. Convertilo in HCL2, spiegandomi come hai tradotto le variabili utente, i *builder* e i *provisioner*, e ricordami il comando di Packer che fa questa conversione automaticamente, così che io possa confrontare i risultati.
