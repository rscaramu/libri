# Materiali per *Calcolo delle probabilità e statistica*

Fogli di calcolo di accompagnamento al manuale per le scuole superiori di **Roberto Scaramuzzino**.

I file riprendono i dati e gli esempi del **Capitolo 17 — Statistica e probabilità con il foglio di calcolo**. Servono per provare subito le formule senza doverle ricopiare, e per verificare che i risultati coincidano con quelli calcolati a mano nel libro.

## Come si scaricano

Dalla pagina del file, il pulsante **Download raw file** (l'icona con la freccia verso il basso, in alto a destra). Oppure, per prendere tutto in una volta, il pulsante verde **Code** e poi **Download ZIP**.

## I file

| File | Che cosa contiene | Capitoli |
|---|---|---|
| `01-indici-di-sintesi.xlsx` | I 25 voti della classe e tutti gli indici: media, mediana, moda, quartili, varianza e deviazione standard | 4, 6, 7, 17 |
| `02-tabella-di-frequenza.xlsx` | La tabella di frequenza costruita con CONTA.SE, con relative, percentuali e cumulate | 4, 17 |
| `03-calcolo-combinatorio.xlsx` | Fattoriale, disposizioni, combinazioni, con le verifiche di simmetria e della formula di Stifel | 8, 17 |
| `04-distribuzione-binomiale.xlsx` | L'intera distribuzione binomiale al variare di n e p, con probabilità singole e cumulate | 13, 17 |
| `05-distribuzione-normale.xlsx` | Sostituisce la tavola dell'Appendice B: aree, valori critici e domanda inversa | 14, 17 |
| `06-correlazione-e-regressione.xlsx` | Correlazione, pendenza, intercetta, R² e previsione sui dati del libro | 15, 17 |
| `07-simulazioni.xlsx` | Mille lanci di una moneta e cinquecento lanci di due dadi, da rilanciare con F9 | 9, 16, 17 |

## Come si usano

**Le celle gialle sono le uniche da modificare.** Contengono i dati e i parametri: cambiandole, tutto il resto del foglio si ricalcola da solo. Le celle in grassetto contengono formule: conviene lasciarle stare, e semmai fare clic sopra per leggere nella barra della formula come sono scritte.

Nei file `07-simulazioni.xlsx` il tasto **F9** rigenera tutti i numeri casuali. Premilo più volte e osserva quanto oscillano i risultati: è la legge dei grandi numeri vista in azione.

## Excel, LibreOffice, Google Fogli

I file sono in formato `.xlsx` standard e si aprono con Microsoft Excel, LibreOffice Calc, Google Fogli, Numbers e OnlyOffice.

I nomi delle funzioni sono tradotti automaticamente dal programma secondo la lingua di installazione: chi ha Excel in italiano vedrà `MEDIA` e `DEV.ST.P`, chi lo ha in inglese vedrà `AVERAGE` e `STDEV.P`. È la stessa formula, e il file resta compatibile in entrambi i casi.

Se apri i file con Google Fogli, ricorda che le simulazioni si aggiornano da sole a ogni modifica, senza bisogno di premere F9.

## Verifica

Tutte le formule sono state eseguite e i risultati confrontati con i calcoli svolti a mano nel manuale. Alcuni valori di controllo, utili per accorgersi subito se qualcosa è stato modificato per errore:

- `01` — media 6,6 · deviazione standard della popolazione 1,4967 · deviazione standard campionaria 1,5275
- `02` — la somma delle frequenze relative deve valere esattamente 1,00
- `03` — con n = 20 e k = 3 le combinazioni sono 1140, e le due righe di verifica devono dare lo stesso numero
- `04` — con n = 10 e p = 0,5 la probabilità di 6 successi è 0,2051, e la somma della colonna vale 1,0000
- `05` — con μ = 0, σ = 1 e x = 2 l'area a sinistra è 0,9772, come nella tavola dell'Appendice B
- `06` — r = 0,9839 · pendenza 1,1 · intercetta 2,4 · R² = 0,968

## Avvertenza

I dati impiegati sono di fantasia e servono solo a scopo didattico. I fogli non sostituiscono lo studio dei capitoli: il foglio di calcolo esegue qualunque formula gli si chieda, anche una sbagliata, ed è chi lo usa a dover sapere quale sia quella giusta.

## Licenza

Da definire. Se vuoi che gli insegnanti possano usarli e adattarli liberamente citando la fonte, la scelta più comune è **Creative Commons BY-NC-SA 4.0**: aggiungi un file `LICENSE` con il testo della licenza e sostituisci questa riga.

---

© Roberto Scaramuzzino. Materiali di accompagnamento al manuale *Calcolo delle probabilità e statistica*.
