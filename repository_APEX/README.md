# Manuale completo di APEX

Materiale per i lettori del volume *Manuale completo di APEX. Dai fondamenti del linguaggio allo sviluppo professionale sulla piattaforma Salesforce* di Roberto Scaramuzzino.

## Contenuto

- `esempi/capNN/testo/` — i listati di ogni capitolo, nell'ordine in cui compaiono. Le classi sono salvate con il proprio nome (`.cls`), i trigger come `.trigger`, i blocchi anonimi come `blocco_NNN.apex`.
- `esempi/capNN/soluzioni/` — le soluzioni degli esercizi proposti (Appendice F).
- `prompt/capNN.md` — i prompt del paragrafo «Con l'IA» di ogni capitolo.
- `ERRATA.md` — le correzioni segnalate dopo la pubblicazione.

## Come usare gli esempi

1. Procuratevi una org gratuita Developer Edition (Capitolo 1 e Appendice A).
2. Le classi e i trigger vanno salvati nella org: dalla Developer Console, oppure copiandoli nella cartella `force-app/main/default` di un progetto Salesforce DX e distribuendoli con `sf project deploy start`.
3. I blocchi anonimi si eseguono dalla Developer Console (*Debug*, *Open Execute Anonymous Window*) oppure con `sf apex run --file nomefile.apex`.
4. Dal Capitolo 14 in poi gli esempi usano i dati creati dalla classe `DatiDiProva` (in `esempi/cap14/testo/`): eseguite una volta `DatiDiProva.crea();`.

Alcuni capitoli (23 e 24) richiedono elementi di configurazione da creare a mano nella org, descritti nel testo: un tipo di metadati personalizzati, un'impostazione personalizzata, due eventi di piattaforma.

## Versione di riferimento

Salesforce Winter '27, API 68.0.

## Avvertenza

Il codice è fornito a scopo didattico, senza garanzie di alcun tipo. Provatelo soltanto in una org di sviluppo, mai in un ambiente con dati reali. Salesforce e Apex sono marchi di Salesforce, Inc.; quest'opera è indipendente e non è approvata né sponsorizzata dal titolare dei marchi.
