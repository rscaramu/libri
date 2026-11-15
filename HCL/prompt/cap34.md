# Capitolo 34 — HCL dall’interno

## Prompt 1

Converti questa configurazione dalla sintassi nativa di HCL alla sintassi JSON accettata da Terraform e OpenTofu in un file `.tf.json`. Ricorda che le espressioni vanno scritte come stringhe con interpolazione. Elencami i punti in cui la conversione non è ovvia, in particolare i blocchi ripetuti e i blocchi annidati.

## Prompt 2

Scrivimi uno script Python che, usando l’uscita di `tofu show -json` applicata a un piano, elenchi le risorse che verrebbero distrutte o sostituite, con l’indirizzo e l’azione. Non analizzare i file `.tf`: usa soltanto il JSON del piano. Indica quali campi leggi e dove sono documentati.

## Prompt 3

Voglio definire con la libreria Go di HCL un piccolo formato di configurazione per la mia applicazione, con i blocchi e gli attributi che ti descrivo. Scrivi le strutture con le annotazioni e il codice che legge un file e stampa gli errori con file e riga. Poi dimmi che cosa, di ciò che offre Terraform, in questo formato non ci sarà.
