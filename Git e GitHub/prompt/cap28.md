# Capitolo 28 — Pages, release e Packages

## Prompt 1 — Documentazione su Pages.

```text
Il mio progetto ha la documentazione in Markdown nella
cartella docs/. Voglio pubblicarla con MkDocs e il
tema Material su GitHub Pages, aggiornata a ogni push
su main, con dominio personalizzato docs.esempio.it.
Scrivi mkdocs.yml minimo, il workflow e i passi per il
dominio.
```

## Prompt 2 — Rilascio automatico.

```text
Confronta release-please e semantic-release per un
progetto TypeScript pubblicato su npm, con Conventional
Commits gia' in uso. Per quello che consigli, scrivi il
workflow completo che apre la PR di release, e al
merge crea tag, release GitHub con note e pubblica su
npm con provenance.
```

## Prompt 3 — Immagini su ghcr.io.

```text
Scrivi un workflow che costruisca un'immagine Docker
multi-architettura (amd64 e arm64) del mio servizio,
la pubblichi su ghcr.io con tag "latest", il nome del
ramo e la versione semantica dal tag git, e usi la
cache di build tra esecuzioni.
```

## I limiti

I nomi delle azioni di terzi e le loro opzioni cambiano; verificate sul Marketplace prima di adottare un workflow generato. Le quote e i prezzi di Pages e Packages vanno letti sulla documentazione ufficiale, non chiesti all’assistente.
