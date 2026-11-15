# Capitolo 26 — Collaudare: i test

## Prompt 1

Ti incollo un modulo completo. Senza scrivere codice, elencami i casi di prova che ritieni necessari: per ogni convalida un caso accettato e uno respinto, per ogni condizionale entrambi i rami, più i casi limite degli ingressi. Per ciascuno indica se basta un test di piano o serve un’applicazione, e perché.

## Prompt 2

Scrivi il file `.tftest.hcl` per i casi che abbiamo concordato. Usa `command = plan` dove possibile ed `expect_failures` per le convalide. Ogni asserzione deve avere un messaggio che dica che cosa ci si aspettava. Non usare funzioni di simulazione, a meno che non te lo chieda.

## Prompt 3

Questo test fallisce con il messaggio che ti incollo. Prima di propormi una correzione, dimmi se secondo te è sbagliato il codice o è sbagliato il test, e che cosa dovrei verificare per deciderlo.
