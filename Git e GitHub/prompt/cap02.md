# Capitolo 2 — Installazione e configurazione

## Prompt 1 — Diagnosi della configurazione.

```text
Ecco l'output di "git config --list --show-origin"
sulla mia macchina Linux:
[incollate l'output]
Segnala impostazioni duplicate, contraddittorie o
potenzialmente problematiche, e spiega per ciascuna
il livello (sistema, globale, locale) da cui proviene.
```

## Prompt 2 — Configurazione per due identità.

```text
Uso lo stesso computer per progetti personali e di
lavoro. Voglio che i repository sotto ~/lavoro/ usino
l'email aziendale e tutti gli altri quella personale,
senza doverlo impostare a mano ogni volta. Mostrami
come farlo con includeIf nel file ~/.gitconfig.
```

## Prompt 3 — Fine riga.

```text
Nel mio team ci sono sviluppatori Windows, macOS e
Linux. Spiegami in modo semplice il problema dei fine
riga in Git, quale valore di core.autocrlf dovrebbe
usare ciascuno e perche' .gitattributes e' una
soluzione migliore.
```

## I limiti

L’assistente non può vedere il vostro file di configurazione né sapere quale versione di Git avete: includete sempre l’output di `git --version` e il contenuto del file quando chiedete una diagnosi. Diffidate di suggerimenti che modificano la configurazione di sistema con `sudo`: non ce n’è quasi mai bisogno.
