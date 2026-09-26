# Capitolo 6 — Annullare e recuperare

## Prompt 1 — Scegliere il comando.

```text
Ho fatto tre commit su main che non ho ancora inviato
a nessuno. Il secondo contiene un file con una password.
Voglio che quel file non compaia in nessun commit della
storia, mantenendo il resto delle modifiche. Quale
sequenza di comandi uso? Spiega ogni passo e dimmi
quali sono reversibili.
```

## Prompt 2 — Interpretare il reflog.

```text
Ecco l'output di "git reflog" dopo che ho eseguito
alcuni comandi di cui non sono sicuro:
[incollate l'output]
Ricostruisci in ordine cronologico che cosa e' successo
e dimmi a quale voce devo tornare per recuperare il
commit intitolato "Aggiunge il modulo pagamenti".
```

## Prompt 3 — reset o revert.

```text
Spiegami con un esempio concreto la differenza tra
git reset e git revert, quando e' obbligatorio usare
revert e che cosa succede ai colleghi se uso reset su
commit che ho gia' condiviso.
```

## I limiti

Gli assistenti propongono `reset --hard` con grande facilità, perché è la risposta più breve a molte domande. Prima di eseguire un comando distruttivo suggerito dall’IA, chiedetele esplicitamente «questo comando può cancellare lavoro non registrato?» e fate un commit provvisorio. L’IA non può vedere il vostro reflog: incollatelo.
