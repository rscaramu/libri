# Capitolo 30 — Sicurezza della catena di fornitura

## Prompt 1 — Audit di un workflow.

```text
Ecco un workflow GitHub Actions:
[incollate il file]
Fai una revisione di sicurezza: permessi eccessivi,
azioni non fissate all'hash, iniezione nelle
espressioni, uso improprio di pull_request_target,
segreti esposti. Per ogni problema mostra la riga e
la correzione.
```

## Prompt 2 — Configurare Dependabot.

```text
Il mio monorepo ha un backend Python in /api, un
frontend npm in /web, un Dockerfile e workflow di
Actions. Scrivi dependabot.yml con aggiornamenti
settimanali raggruppati per tipo, limite di PR aperte
e ignorando gli aggiornamenti major di React. Spiega
come attivare l'auto-merge sicuro per le patch.
```

## Prompt 3 — Rispondere a una vulnerabilita’.

```text
Qualcuno mi ha segnalato privatamente una
vulnerabilita' in un mio pacchetto npm pubblico.
Descrivi passo per passo la gestione con GitHub:
advisory privata, fork temporaneo, correzione, CVE,
release, comunicazione agli utenti, e cosa non fare.
```

## I limiti

Una revisione di sicurezza dell’IA trova i problemi noti e ricorrenti, non quelli specifici del vostro sistema; non sostituisce un’analisi da parte di chi conosce l’applicazione. E non incollate mai in un prompt segreti, token o dettagli di una vulnerabilità non ancora corretta.
