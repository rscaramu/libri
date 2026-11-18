# Capitolo 55 — Algoritmi paralleli

## Prompt 1

Devo accelerare questo calcolo: [descrizione o codice]. Analizzalo: quali parti sono indipendenti, quale frazione è intrinsecamente sequenziale, quale accelerazione massima posso aspettarmi secondo la legge di Amdahl su [numero] unità. Indica se ricade in uno schema noto (compiti indipendenti, map-reduce, divide et impera, somme prefisse) e lo strumento di più alto livello in [linguaggio] che lo realizza senza lucchetti espliciti.

## Prompt 2

Esamina questo codice concorrente: [codice]. Elenca ogni dato condiviso fra più compiti e, per ciascuno, chi lo legge e chi lo scrive. Individua le possibili condizioni di gara e gli stalli, descrivendo per ognuno una sequenza precisa di passi che lo provoca, e proponi una riscrittura che elimini la condivisione invece di proteggerla.

## Prompt 3

Ho parallelizzato questo programma e l’accelerazione su [numero] unità è soltanto [valore]. Aiutami a capire perché: quali misure fare per distinguere fra parte sequenziale, costo di creazione dei compiti, contesa sulla memoria, lucchetti e, in Python, il blocco dell’interprete. Indica per ciascuna causa il rimedio.
