# Capitolo 21 — Fork e pull request

## Prompt 1 — Scrivere la descrizione.

```text
Ecco i commit del mio ramo (git log --oneline main..)
e il diff riassuntivo (git diff --stat main):
[incollate gli output]
Scrivi titolo e descrizione per la pull request, con le
sezioni "Cosa cambia", "Perche'" e "Come verificare",
e la riga "Closes #NN" se dal contesto emerge un'issue.
```

## Prompt 2 — Revisionare un diff.

```text
Ecco il diff di una pull request:
[incollate "git diff main...ramo"]
Fai una revisione come farebbe un collega esperto:
segnala errori, rischi, casi limite non gestiti e
migliorie di leggibilita', separando cio' che blocca
da cio' che e' un suggerimento. Scrivi i commenti gia'
pronti da incollare, uno per riga interessata.
```

## Prompt 3 — Rispondere a una revisione.

```text
Un revisore ha lasciato questo commento sulla mia PR:
[incollate il commento]
Non sono d'accordo perche' [motivo]. Aiutami a scrivere
una risposta cortese e argomentata, che proponga
un'alternativa o chieda un chiarimento, senza suonare
sulla difensiva.
```

## I limiti

Una revisione dell’IA vede solo il diff, non l’architettura del progetto, le convenzioni di squadra né la storia delle decisioni: prendetela come una prima passata che scova errori meccanici, non come sostituto del revisore umano. E non incollate diff di codice proprietario in servizi che non avete il permesso di usare.
