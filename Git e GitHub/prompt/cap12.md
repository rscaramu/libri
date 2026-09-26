# Capitolo 12 — Ignorare file e attributi

## Prompt 1 — Generare un .gitignore.

```text
Il mio progetto usa Python 3.12 con un ambiente
virtuale in .venv, Visual Studio Code, e produce
documentazione con Sphinx in docs/_build. Lavoro su
macOS ma i colleghi usano Windows. Scrivi un .gitignore
completo e commentato, separando le regole del progetto
da quelle che dovrei mettere nel file globale personale.
```

## Prompt 2 — Diagnosi.

```text
Il file src/config/local.json continua a comparire in
"git status" anche se e' nel .gitignore. Ecco il
.gitignore e l'output di "git check-ignore -v" e di
"git ls-files | grep local":
[incollate gli output]
Spiega la causa e i comandi per risolvere.
```

## Prompt 3 — .gitattributes per un team misto.

```text
Scrivi un .gitattributes per un progetto con script
bash, file .bat, immagini PNG e JPEG, documenti PDF e
sorgenti Java, che garantisca fine riga corretti su
tutte le piattaforme e diff leggibili. Spiega ogni
riga e come normalizzare i file gia' registrati.
```

## I limiti

Un `.gitignore` generato dall’IA è un buon punto di partenza ma può includere modelli che ignorano file legittimi del vostro progetto (per esempio `*.db` in un progetto che versiona un database di esempio). Rileggetelo e verificate con `git status --ignored` che non manchi nulla di importante.
