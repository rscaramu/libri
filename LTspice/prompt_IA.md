# Manuale completo di LTspice – Prompt per l’IA

## Capitolo 1 – Simulare un circuito: SPICE e LTspice

- Spiegami riga per riga questa netlist SPICE, indicando per ogni componente il tipo, i nodi a cui è collegato e il significato del valore. Poi calcola a mano la tensione di ogni nodo e confrontala con i risultati che ti incollo sotto.

- Ho installato LTspice 26 su Linux con Wine. Scrivimi uno script Bash che esegua in modalità batch tutte le netlist .cir di una cartella e, per ognuna, stampi le righe del file .log che contengono errori o avvisi.

- Elencami cinque situazioni in cui una simulazione SPICE di un circuito con soli resistori e generatori ideali dà un risultato diverso dalla misura su un prototipo reale, e per ognuna indicami come modificare la netlist per tenerne conto.

## Capitolo 2 – L’ambiente di lavoro

- Questa è la netlist generata da LTspice per un mio schema. Dimmi quali nodi hanno un nome automatico (N001, N002 e così via), quali componenti sono collegati a ciascuno e suggeriscimi nomi significativi da assegnare con le etichette.

- Ti incollo il contenuto di un file .asc di LTspice. Descrivi a parole il circuito che rappresenta, elencando i componenti, i loro valori e i collegamenti, e segnalami se qualche terminale sembra non collegato.

- Spiegami la differenza tra le modalità esperta, assistita e super esperta di modifica dei componenti in LTspice, e per ognuna dammi un esempio concreto di situazione in cui conviene usarla.

## Capitolo 3 – La netlist

- Scrivimi una netlist per LTspice 26, non per altri simulatori SPICE, di un ponte di Wheatstone alimentato a 5 V con tre resistori da 10 kΩ e un quarto resistore parametrico Rx definito con .param. Usa nomi di nodo significativi, commenta ogni riga con il punto e virgola e calcola a mano la tensione di sbilanciamento per Rx = 10,5 kΩ.

- Ecco una netlist e il messaggio di errore che LTspice scrive nel log. Spiegami che cosa significa il segno ^ sotto la riga, qual è la causa dell’errore e come correggerlo, senza cambiare nient’altro nella netlist.

- Controlla questa netlist: elenca tutti i nodi con il numero di volte in cui compaiono, segnala quelli che compaiono una volta sola e quelli che non hanno un percorso in continua verso la massa, e verifica che nessun valore usi M per mega o una virgola come separatore decimale.

## Capitolo 4 – Componenti passivi e sorgenti indipendenti

- Scrivimi la specifica di un generatore PULSE di LTspice per un’onda quadra da 0 a 3,3 V a 25 kHz con ciclo di lavoro del 30%, fronti di 100 ns e nessun ritardo. Spiegami come hai calcolato Ton e Tperiod e verifica che la somma di Ton e dei fronti non superi il periodo.

- Voglio modellare in LTspice un condensatore ceramico multistrato da 10 μF con ESR di 3 mΩ ed ESL di 0,5 nH. Scrivimi la riga di netlist e calcola la frequenza di risonanza serie del componente.

- Ho questa riga di netlist con un generatore PWL che usa REPEAT e tempi relativi. Elencami, in una tabella, i primi dodici punti tempo-valore che il generatore produce, e dimmi che valore assume dopo l’ultimo punto.

## Capitolo 5 – Il punto di lavoro

- Ecco la netlist di uno stadio a emettitore comune e il blocco di informazioni che LTspice scrive nel log con .options logopinfo. Spiegami il significato di ogni grandezza, dimmi in quale zona di funzionamento si trova il transistor e calcola il guadagno di tensione approssimato dello stadio usando Gm e le resistenze del circuito.

- Calcola a mano il punto di lavoro di questo circuito con un diodo, usando prima il modello a caduta costante di 0,7 V e poi due iterazioni del metodo di Newton sulla caratteristica esponenziale con IS = 2,5 nA e N = 1,75. Confronta i tre risultati con il valore che ti incollo, ottenuto con LTspice.

- Questo circuito ha due stati stabili. Scrivimi le direttive .nodeset per portare la simulazione in ciascuno dei due stati e spiegami perché, senza di esse, LTspice potrebbe restituire uno stato intermedio.

## Capitolo 6 – Il visualizzatore di forme d’onda

- In una simulazione LTspice di un alimentatore ho le tracce V(in), V(out), I(D1) e I(C1). Scrivimi le espressioni per tracciare nel visualizzatore la potenza istantanea nel diodo, il rendimento istantaneo e l’ondulazione picco-picco dell’uscita, spiegandomi come leggerle.

- Scrivimi le direttive .meas che misurano, nell’intervallo tra 80 ms e 100 ms, il valore medio e il valore efficace della corrente nel condensatore C1, la potenza media nel resistore Rload e l’energia dissipata nel diodo D1.

- Hai accesso alla simulazione aperta in LTspice tramite MCP. Leggi i dati della forma d’onda V(out) e dimmi valore massimo, valore minimo e istante in cui la tensione attraversa per la prima volta il 90% del valore finale. Riportami i numeri esatti e dimmi come li hai ricavati.

## Capitolo 7 – La scansione in continua

- Scrivimi una netlist LTspice che tracci le caratteristiche di trasferimento di un MOSFET a canale N della libreria standard: la corrente di drain in funzione della tensione gate-source da 0 a 5 V, per tensioni drain-source di 1, 2, 5 e 10 V. Usa una scansione annidata e indicami come leggere la tensione di soglia sul grafico.

- Questa è una tabella di valori ottenuta con una scansione .dc della tensione di un diodo in funzione della corrente, da 1 nA a 100 mA. Stima dalla pendenza della zona centrale il coefficiente di emissione N e, dalla curvatura ad alta corrente, la resistenza serie. Spiegami i passaggi del calcolo.

- Ho un regolatore Zener con resistore serie da 220 Ω e carico variabile. Scrivimi una netlist con due scansioni annidate che mostri la tensione d’uscita in funzione della corrente di carico, da 0 a 30 mA, per tre tensioni d’ingresso diverse, e dimmi che cosa mi aspetto di vedere.

## Capitolo 8 – L’analisi nel tempo

- Questa simulazione LTspice di un oscillatore a 2 MHz con .tran 10m impiega molti minuti e la forma d’onda appare spigolosa. Ecco la netlist e il log. Suggeriscimi un valore di dTmax adeguato, spiegami come stimarlo e dimmi se conviene usare Tstart per ridurre il file dei risultati.

- Spiegami la differenza tra simulare l’accensione di un circuito con il modificatore startup, con uic e con un generatore PWL che sale da zero all’alimentazione in 1 ms. Per ognuno dei tre metodi dimmi che cosa succede ai condensatori e ai transistor all’istante zero.

- Scrivimi le direttive .meas per misurare, sulla risposta al gradino della tensione V(out), la sovraelongazione percentuale rispetto al valore finale, il tempo di salita dal 10% al 90% e il tempo di assestamento entro il 2%, sapendo che il gradino parte a 1 ms e il valore finale è 3,3 V.

## Capitolo 9 – L’analisi in frequenza

- Ricava la funzione di trasferimento del filtro RLC passa-banda di questa netlist, scrivila nella forma standard con pulsazione naturale e fattore di merito, e calcola la frequenza centrale e la banda a −3 dB. Poi confronta i tuoi risultati con le misure che LTspice ha riportato nel log.

- Questo è il diagramma di Bode di uno stadio a emettitore comune simulato in LTspice: guadagno di 36 dB a centro banda, taglio inferiore a 64 Hz e superiore a 1,7 MHz. Spiegami quali componenti determinano ciascuna delle due frequenze di taglio e come modificheresti il circuito per portare il taglio inferiore sotto i 20 Hz.

- Scrivimi le direttive .meas per misurare, in un’analisi .ac di un filtro, la frequenza di picco, il guadagno di picco in decibel, la banda a −3 dB e lo sfasamento alla frequenza di picco espresso in gradi, usando il formato cartesiano per evitare ambiguità.

## Capitolo 10 – Funzioni di trasferimento e rumore

- Ho eseguito .noise su un preamplificatore e LTspice riporta un rumore riportato all’ingresso di 5,5 nV/√Hz a 1 kHz, con una resistenza di sorgente di 1 kΩ. Calcolami il fattore di rumore e la cifra di rumore dello stadio a quella frequenza e spiegami come interpretarli.

- Scrivimi le direttive .meas NOISE per calcolare il rumore integrato in uscita e all’ingresso nella banda da 300 Hz a 3,4 kHz e il rapporto segnale/rumore in decibel per un segnale d’ingresso di 2 mV efficaci.

- Spiegami perché il rumore integrato di un filtro RC passa-basso vale √(kT/C) e non dipende da R, e suggeriscimi una simulazione LTspice con .step che lo dimostri variando R su tre decadi.

## Capitolo 11 – L’analisi di Fourier

- Ti incollo la tabella di Fourier che LTspice ha scritto nel log per l’uscita di un amplificatore a 1 kHz. Calcola l’ampiezza di ciascuna armonica in dB rispetto alla fondamentale, dimmi se la distorsione è prevalentemente pari o dispari e quale tipo di non linearità del circuito può produrla.

- Scrivimi una netlist LTspice per misurare la distorsione armonica di uno stadio a emettitore comune a 1 kHz al variare dell’ampiezza d’ingresso, da 1 mV a 50 mV, con le direttive .four e .step, e spiegami perché la distorsione cresce con l’ampiezza.

- Voglio ascoltare l’effetto di un filtro passa-alto da 300 Hz su un file audio. Scrivimi la netlist LTspice che legge il file ingresso.wav, applica il filtro e scrive il risultato in uscita.wav a 16 bit e 44,1 kHz, e dimmi quanto deve durare la simulazione per un brano di 5 secondi.

## Capitolo 12 – La convergenza

- La mia simulazione LTspice si ferma con «Time step too small» a 1,2 ms con il messaggio «trouble with instance Q3». Ti incollo la netlist e il log completo. Indicami le possibili cause legate al circuito, in ordine di probabilità, e per ciascuna una modifica che posso fare per verificarla, prima di toccare le opzioni del simulatore.

- Ho attivato convreport e il log riporta questi punteggi di difficoltà per componenti e nodi. Spiegami come interpretarli e quali nodi o componenti dovrei esaminare per primi.

- In questo circuito ho una sorgente comportamentale con un’espressione if() che commuta bruscamente tra due valori. Riscrivila in forma continua usando una funzione smussata, come tanh, con una larghezza di transizione regolabile, e spiegami come scegliere la larghezza.

## Capitolo 13 – I diodi

- Dal datasheet di un diodo Schottky ricavo questi punti: 0,30 V a 10 mA, 0,38 V a 100 mA, 0,52 V a 1 A, capacità di 80 pF a 0 V. Ricavami i parametri Is, N, Rs e Cjo di un modello SPICE per LTspice, spiegando ogni passaggio, e scrivimi la direttiva .model con `Eg=0.69` e `Xti=2`, tipici degli Schottky.

- Scrivimi una netlist LTspice che confronti il recupero inverso di un 1N4148 e di un 1N4007 della libreria standard nello stesso circuito di prova, in due rami separati, e che misuri con .meas il picco della corrente inversa e il tempo in cui questa torna al 10% del picco.

- Ho un raddrizzatore a ponte con condensatore da 4700 μF e carico da 2 A. Calcolami l’ondulazione attesa e la corrente di picco nei diodi in funzione della resistenza del trasformatore, e scrivimi una netlist con .step per verificarlo con tre valori di resistenza.

## Capitolo 14 – I transistor bipolari

- Ti incollo il modello SPICE di un transistor bipolare. Spiegami il significato fisico di ciascun parametro, dimmi quali effetti il modello descrive e quali no, e suggeriscimi le simulazioni LTspice per verificare il guadagno di corrente, la tensione di Early e la frequenza di transizione.

- Progetta uno stadio a emettitore comune con il 2N3904 alimentato a 9 V, con corrente di collettore di 1 mA, guadagno di tensione di circa 20 con un resistore di emettitore non bypassato e massima escursione simmetrica in uscita. Dammi i valori normalizzati E24 dei resistori e la netlist LTspice per verificare il punto di lavoro e il guadagno.

- Spiegami perché uno specchio di Wilson ha una resistenza d’uscita molto più alta dello specchio semplice e scrivimi una netlist LTspice che confronti le due configurazioni con la stessa corrente di riferimento, misurando la resistenza d’uscita con una scansione .dc.

## Capitolo 15 – I transistor a effetto di campo

- Dal datasheet di un MOSFET a canale N ricavo: tensione di soglia 2,5 V, resistenza in conduzione 20 mΩ a Vgs = 10 V, capacità d’ingresso 1500 pF, capacità di trasferimento inversa 120 pF a 25 V e 600 pF a 1 V, carica di gate totale 30 nC. Proponi i parametri di un modello VDMOS per LTspice, spiegando quali sono ricavati dai dati e quali stimati.

- Un MOSFET con carica di gate di 26 nC è pilotato da un driver da 10 V con resistenza d’uscita di 2 Ω attraverso un resistore di gate da 10 Ω. Stima la durata del plateau di Miller e il tempo di accensione, e scrivimi le direttive .meas per misurarli in LTspice.

- Spiegami la differenza tra un interruttore S di LTspice con isteresi positiva e uno con isteresi negativa, con un esempio di netlist per ciascuno, e dimmi quale usare per modellare un relè e quale per un transistor in commutazione.

## Capitolo 16 – Gli amplificatori operazionali

- Progetta un amplificatore invertente con guadagno −20 e impedenza d’ingresso di 10 kΩ per un segnale audio di 0,5 V di picco, alimentato a ±12 V. Scegli un amplificatore operazionale della libreria di LTspice adatto all’audio, verifica che la banda e la velocità di risposta siano sufficienti per 20 kHz e scrivimi la netlist con l’ordine dei nodi corretto.

- Calcolami le soglie di un trigger di Schmitt non invertente con un amplificatore alimentato a 5 V con uscita rail-to-rail, con soglie di 2 V e 3 V, e scrivimi le due direttive .dc, una crescente e una decrescente, per verificarle in LTspice.

- Spiegami le differenze tra i modelli UniversalOpAmp di livello 1, 2, 3 e 4 di LTspice e dimmi quale usare per studiare la stabilità di un inseguitore con un carico capacitivo di 1 nF.

## Capitolo 17 – Sottocircuiti e librerie

- Trasforma questa netlist di una cella di filtro Sallen-Key passa-basso in un sottocircuito LTspice con parametri fc e Q, calcolando i valori dei condensatori dalle formule del filtro con resistori uguali da 10 kΩ, e scrivimi una netlist che ne usi due in cascata per un filtro di Butterworth del quarto ordine.

- Ti incollo un sottocircuito di un costruttore. Elencami i terminali con il loro significato probabile, dimmi quali modelli e parametri locali contiene, e scrivimi il richiamo X per collegarlo correttamente in un circuito con alimentazioni a ±12 V.

- Suggeriscimi un’organizzazione delle cartelle per una libreria personale di LTspice con simboli, modelli scaricati dai costruttori e sottocircuiti miei, e dimmi quali percorsi aggiungere nella scheda Search Paths delle impostazioni.

## Capitolo 18 – I modelli di terze parti

- Ti incollo un modello SPICE scritto per PSpice. Individua eventuali costrutti che LTspice non supporta o interpreta in modo diverso, come primitive digitali, operatori ^ o funzioni con nomi diversi, e proponimi una versione compatibile con LTspice, segnando ogni riga modificata con un commento.

- Questo è il file del modello di un amplificatore operazionale di un costruttore. Dimmi l’ordine dei terminali della riga .subckt, quale simbolo di LTspice posso usare senza modifiche e quali grandezze dovrei verificare con un banco di prova per controllare che il modello sia collegato correttamente.

- Scrivimi un banco di prova LTspice per verificare un nuovo modello di MOSFET a canale N: tensione di soglia a 250 μA, resistenza in conduzione a Vgs = 10 V e Id = 5 A, e capacità d’ingresso a Vds = 25 V, con le misure .meas per ciascuna grandezza.

## Capitolo 19 – Parametri ed espressioni

- Riscrivi questa netlist di un filtro attivo Sallen-Key in forma parametrica, con parametri di progetto fc, Q e il valore comune dei resistori, e con i condensatori calcolati dalle formule. Aggiungi .options logparams e spiegami come verificare che i valori calcolati siano quelli attesi.

- Scrivimi una funzione .func per LTspice che arrotondi un valore di resistenza al valore normalizzato più vicino della serie E24, usando log10, floor e select, e un esempio di netlist che la usi.

- Spiegami la visibilità dinamica delle funzioni .func in LTspice con un esempio diverso da quello della guida, e dimmi in quali casi può causare errori difficili da individuare.

## Capitolo 20 – Le scansioni dei parametri

- Ti incollo la tabella delle misure .meas che LTspice ha scritto nel log dopo una simulazione con .step di due parametri annidati, R e C. Riorganizzala in una tabella a doppia entrata, con R sulle righe e C sulle colonne, e dimmi quale combinazione soddisfa meglio la specifica di un tempo di salita compreso tra 1,5 e 2 ms.

- Scrivimi una netlist LTspice che confronti con .step e select() tre amplificatori operazionali della libreria standard, il LT1001, il LT1028 e il LT1007, in un amplificatore non invertente con guadagno 10, misurando banda, velocità di risposta e distorsione a 10 kHz. Controlla che i tre modelli abbiano lo stesso ordine dei terminali.

- Ho una scansione .step con 200 valori di un parametro e una misura per ciascuno. Spiegami come esportare la tabella delle misure dal log di LTspice in un file CSV e come tracciarla con Python.

## Capitolo 21 – Le misure automatiche

- Scrivimi le direttive .meas di LTspice per misurare, su un’uscita V(out) di un convertitore che si accende all’istante zero, il valore medio e l’ondulazione picco-picco a regime, tra 8 e 10 ms, e l’istante in cui l’uscita entra per l’ultima volta nella fascia del 2% attorno al valore finale di 5 V.

- Ho questo circuito LTspice con un MOSFET IRF540, un diodo di ricircolo e un induttore. Scrivimi un insieme di misure che controlli automaticamente i limiti di tensione, corrente e potenza dei tre componenti secondo i valori massimi dei datasheet, e che produca una misura finale uguale a 1 se tutti i limiti sono rispettati.

- Nel log di LTspice questa misura in frequenza restituisce (29.8dB,180°) mentre mi aspettavo una fase di −31 gradi. Spiegami perché e come ottenere il numero che voglio.

## Capitolo 22 – Tolleranze, Monte Carlo e caso peggiore

- Ho un filtro attivo Sallen-Key passa-basso del secondo ordine con R1 = R2 = 10 kΩ all’1% e C1 = 22 nF, C2 = 10 nF al 5%. Scrivimi una netlist LTspice per un’analisi Monte Carlo di 300 prove che misuri la frequenza a −3 dB e il picco del modulo, con le tolleranze gaussiane a 3 sigma.

- Ti incollo la tabella delle misure di un’analisi Monte Carlo di LTspice con 500 prove. Calcola media, deviazione standard, minimo e massimo, stima la percentuale di circuiti fuori dalla specifica 1550–1650 Hz e dimmi se la distribuzione sembra gaussiana.

- Spiegami in quali casi l’analisi del caso peggiore a combinazioni estreme può non trovare il vero caso peggiore, e proponimi un esempio di circuito semplice in cui succede, da verificare in LTspice.

## Capitolo 23 – La temperatura

- Spiegami da dove viene il coefficiente di temperatura di circa −2 mV/°C della tensione di una giunzione percorsa da corrente costante, partendo dall’equazione del diodo e dalla dipendenza di IS dalla temperatura, e dimmi quali parametri del modello SPICE lo determinano.

- Ho un modello SPICE di un LED rosso con IS, N e RS ma senza EG e XTI. Quali valori è ragionevole usare per un LED all’arseniuro di gallio e fosforo, e come posso verificarli in LTspice confrontando la tensione a 20 mA a 25 e a 85 °C con quella del datasheet?

- Questo riferimento a bandgap simulato in LTspice dà 0 V a tutte le temperature. Ecco la netlist. Spiegami perché e proponimi due soluzioni, una per la simulazione e una per il circuito reale.

## Capitolo 24 – Automatizzare le simulazioni

- Scrivimi un programma Python che, per ogni file .cir di una cartella, esegua LTspice in modalità batch con il percorso che ti indico, legga dal log tutte le misure .meas, comprese quelle fallite, e produca un file CSV con una riga per netlist e una colonna per misura.

- Ho il file .raw binario di una simulazione LTspice con .step di 20 passi. Scrivimi una funzione Python che lo legga senza librerie esterne oltre a NumPy, divida i passi, e tracci con Matplotlib la tensione V(out) di tutti i passi sullo stesso grafico, con una legenda che riporti il valore del parametro letto dal log.

- Usando il server MCP di LTspice, apri lo schema del regolatore che ho in uso, esegui la simulazione, leggi dal log le misure del rendimento e dell’ondulazione e riportamele in una tabella. Non modificare lo schema.

## Capitolo 25 – Le sorgenti comportamentali

- Scrivimi una sorgente comportamentale LTspice che rappresenti un sensore di pressione con uscita 0,5 V a 0 bar e 4,5 V a 10 bar, con una non linearità quadratica dell’1% a metà scala, una saturazione morbida a 0,2 e 4,8 V, e la pressione rappresentata dalla tensione del nodo p in volt per bar.

- Questa netlist con una sorgente comportamentale si ferma con «Time step too small». Ecco la netlist. Individua se c’è un anello algebrico o una discontinuità che lo causa, e proponimi una modifica che rappresenti meglio il dispositivo reale invece di nascondere il problema.

- Traduci in sintassi LTspice queste righe di un modello scritto per un altro simulatore, segnalandomi ogni funzione o operatore che in LTspice ha un significato diverso: E1 out 0 VALUE={V(in)^2/(1+V(in)^2)}.

## Capitolo 26 – Generatori controllati e funzioni di trasferimento

- Ricavami la funzione di trasferimento di un filtro passa-banda di Sallen-Key con guadagno unitario, frequenza centrale 2 kHz e fattore di merito 5, e scrivimela come generatore E di LTspice con l’opzione Laplace, usando ** per le potenze.

- Ho un processo industriale con funzione di trasferimento e^(−2s)/(1 + 10s). Scrivimi un modello LTspice con un generatore di Laplace, spiegami come scegliere window e nfft per una simulazione di 100 s, e proponimi un circuito equivalente con una linea di ritardo e un filtro RC per controllare il risultato.

- Questa netlist con generatori F e H dà correnti di segno opposto a quello che mi aspetto. Ecco la netlist. Spiegami la convenzione dei segni dei sensori e dei generatori controllati in LTspice e correggi i segni.

## Capitolo 27 – Simulare sistemi dinamici

- Scrivimi le equazioni di stato di un pendolo inverso su un carrello, con massa del carrello M, massa del pendolo m e lunghezza l, e traducile in una netlist LTspice con un condensatore da 1 F e una sorgente comportamentale di corrente per ogni variabile di stato. Indica le condizioni iniziali con .ic.

- Ho un motore in corrente continua con questi dati di targa: 24 V, 3000 giri al minuto a vuoto, corrente a vuoto 0,2 A, corrente di spunto 15 A, costante di tempo meccanica 25 ms. Ricavami Ra, ke, kt, J e b in unità del Sistema internazionale, mostrandomi i passaggi.

- Spiegami perché una simulazione del sistema di Lorenz dà valori diversi di x dopo 30 s se cambio la tolleranza, e quali grandezze posso invece considerare affidabili.

## Capitolo 28 – Retroazione e stabilità

- Ho un regolatore di tensione lineare con un transistor PNP di passaggio e un amplificatore d’errore. Indicami in quale punto dell’anello inserire il generatore di prova per misurare il guadagno d’anello con LTspice, motivando la scelta in base alle impedenze, e scrivimi le misure .meas per il margine di fase e di guadagno.

- Questo è il guadagno d’anello di un amplificatore misurato in LTspice: attraversamento a 2 MHz con margine di fase di 28°, un polo a 400 kHz e uno a 3 MHz. Proponimi due modi diversi di compensarlo per ottenere 60° di margine e dimmi, per ciascuno, che cosa si perde.

- Spiegami la relazione tra il margine di fase e la sovraelongazione della risposta al gradino per un sistema del secondo ordine, con una tabella per 30, 45, 60 e 75 gradi, e dimmi in quali casi reali la relazione non vale.

## Capitolo 29 – Regolatori PID e compensazione

- Ho un processo con funzione di trasferimento e^(−0,5s)/(1 + 4s)(1 + s). Proponimi le tarature di un regolatore PID con il metodo di Ziegler e Nichols e con il metodo del modello interno, con una costante di tempo dell’anello chiuso di 2 s, e scrivimi una netlist LTspice per confrontarle, con il regolatore realizzato con integratori a condensatore e non con funzioni di Laplace.

- Spiegami tre tecniche per evitare la carica eccessiva dell’integratore in un regolatore PI con attuatore saturabile: integrazione condizionata, retroazione dal limite, limitazione dell’integratore. Per ciascuna dimmi come si scrive con sorgenti comportamentali di LTspice.

- Questo è il log di una simulazione LTspice di un anello di controllo di temperatura con un PID: la sovraelongazione è del 35% e il tempo di assestamento di 12 minuti. Suggeriscimi come modificare Kp, Ti e Td per ridurre la sovraelongazione sotto il 10% senza allungare troppo l’assestamento, spiegando l’effetto di ciascuna modifica.

## Capitolo 30 – Circuiti digitali e a segnali misti

- Progettami un contatore sincrono a tre bit con flip-flop D e porte logiche, e scrivimelo come netlist LTspice con dispositivi A: ricorda che i terminali sono otto, che il flip-flop ha D sul terminale 1 e il clock sul 3, e che gli ingressi a livello basso non vanno collegati al terminale comune.

- Spiegami come scegliere il resistore e il condensatore di un oscillatore con un 74HC14 per ottenere 1 kHz, tenendo conto delle soglie tipiche a 3,3 V di alimentazione e della loro dispersione, e dimmi quale tolleranza di frequenza posso aspettarmi.

- Ho un microcontrollore che genera un PWM a 20 kHz per pilotare un MOSFET. Scrivimi una netlist LTspice in cui il microcontrollore è rappresentato da una porta A con livelli a 3,3 V, ritardo e resistenza d’uscita realistici, e il MOSFET pilota un carico induttivo.

## Capitolo 31 – Trasformatori e alimentatori lineari

- Devo progettare un alimentatore lineare da 12 V e 1 A con un regolatore a tre terminali. Calcolami la tensione del secondario del trasformatore, la capacità di filtro per un’ondulazione di 2 V picco-picco, la potenza dissipata nel regolatore alla tensione di rete massima, +10%, e scrivimi una netlist LTspice per verificarlo.

- Spiegami la differenza tra il modello di induttore non lineare con l’espressione del flusso e il modello di Chan con isteresi in LTspice, e dimmi quale usare per un induttore di un convertitore buck che lavora vicino alla saturazione.

- Ho bisogno di simulare un trasformatore con nucleo saturabile in LTspice, ma la mutua induttanza non è supportata tra induttori non lineari. Proponimi un modello equivalente con un induttore non lineare di magnetizzazione e un trasformatore ideale fatto di generatori E e F, e spiegami come collegarli.

## Capitolo 32 – Convertitori a commutazione

- Ho un convertitore buck da 12 a 5 V, 2 A, 200 kHz, con L = 22 μH e un condensatore d’uscita da 100 μF con ESR di 0,1 Ω, controllato in modo tensione con una rampa da 1 V. Progettami la rete di compensazione di tipo II per un attraversamento a 30 kHz con almeno 50° di margine di fase, mostrandomi i passaggi, e scrivimi un modello medio per LTspice per verificarla.

- Spiegami la differenza tra il controllo in modo tensione e il controllo in modo corrente di un convertitore buck, e perché il secondo semplifica la compensazione. Proponimi una netlist LTspice con componenti elementari per il controllo in modo corrente di picco, con la rampa di compensazione.

- Nella simulazione del mio convertitore con un integrato di Analog Devices la tensione d’uscita oscilla a una frequenza molto più bassa di quella di commutazione. Elencami le possibili cause, distinguendo tra instabilità dell’anello, oscillazioni sub-armoniche e artefatti numerici, e dimmi quali simulazioni fare per distinguerle.

## Capitolo 33 – Filtri attivi, oscillatori e linee di trasmissione

- Progettami un filtro passa-basso di Chebyshev del sesto ordine con ondulazione di 0,5 dB e taglio a 10 kHz, con celle di Sallen-Key a guadagno unitario e resistori da 10 kΩ. Dammi le frequenze e i fattori di merito delle tre celle, i condensatori calcolati e quelli normalizzati della serie E24, e scrivimi la netlist LTspice con la verifica dell’ondulazione in banda.

- Spiegami come stabilizzare l’ampiezza di un oscillatore a ponte di Wien con un JFET usato come resistenza variabile e un rivelatore di picco, e scrivimi una netlist LTspice che misuri la distorsione armonica a regime confrontandola con la soluzione a diodi.

- Ho una pista su circuito stampato di 15 cm, con impedenza caratteristica di 65 Ω, pilotata da un’uscita logica con 20 Ω di resistenza e tempi di salita di 1 ns, e chiusa sull’ingresso di un integrato. Scrivimi una netlist LTspice con una linea T per vedere le riflessioni e proponimi una terminazione serie e una parallela, confrontandole.

## Capitolo 34 – Un progetto completo

- Ti incollo la specifica della mia catena di misura per estensimetri, con sei requisiti numerati. Per ciascun requisito proponimi l’analisi LTspice adatta e le direttive .meas che producono un numero da confrontare con il limite, e segnalami i requisiti che non si possono verificare con il macromodello dell’amplificatore operazionale.

- Scrivimi un programma Python che esegua in batch con LTspice un elenco di netlist, legga le misure dai file .log, comprese le tabelle prodotte da .step, e produca un riepilogo dei requisiti in un file CSV con valore, limite, margine ed esito, segnalando con un errore le misure mancanti o fallite.

- Ecco il riepilogo dei requisiti del mio progetto: il requisito sulla sovraelongazione è rispettato con poco margine. Proponimi tre modifiche del filtro che lo migliorino, spiegandomi per ciascuna l’effetto sugli altri requisiti, e scrivimi le righe da cambiare nel sottocircuito.

