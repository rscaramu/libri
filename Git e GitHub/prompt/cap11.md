# Capitolo 11 — Rebase interattivo e riscrittura della storia

## Prompt 1 — Redigere l’elenco delle istruzioni.

```text
Ecco la storia del mio ramo dal punto di divergenza
da main (git log --oneline --reverse main..HEAD):
[incollate l'output]
Proponi come riorganizzarla in commit logici: quali
fondere, quali rinominare, quali eliminare. Scrivi
l'elenco di istruzioni per "git rebase -i" gia' pronto
e i nuovi messaggi.
```

## Prompt 2 — Dividere un commit.

```text
Un commit del mio ramo contiene sia una nuova funzione
sia una correzione non correlata, in file diversi.
Spiegami passo per passo come dividerlo in due commit
usando "edit" nel rebase interattivo, incluso l'uso di
git reset e git add -p.
```

## Prompt 3 — Rimuovere un segreto.

```text
Ho registrato per errore un file config/secrets.yml con
credenziali sei mesi fa; il repository e' su GitHub e
lo usano altre quattro persone. Elenca tutti i passi
necessari (git filter-repo, coordinamento con i colleghi,
push forzato, revoca delle credenziali) nell'ordine
giusto e con i comandi esatti.
```

## I limiti

L’IA può proporre un elenco di istruzioni ragionevole leggendo i titoli, ma non sa quali commit dipendono da quali: un riordino apparentemente sensato può produrre conflitti o commit intermedi che non compilano. Usate `--exec` con i test per verificarlo. E ricordate che nessun consiglio sulla rimozione di un segreto sostituisce la revoca del segreto stesso.
