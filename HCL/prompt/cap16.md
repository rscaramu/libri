# Capitolo 16 — Ripetere le risorse: count e for_each

## Prompt 1

Questa risorsa usa `count` su una lista di oggetti. Riscrivila con `for_each`, scegliendo come chiave l’attributo più adatto e motivando la scelta. Scrivi anche i blocchi `moved` necessari perché le istanze esistenti non vengano distrutte, supponendo che la lista attuale sia quella che ti incollo.

## Prompt 2

Ti incollo un errore «Invalid for_each argument» e la configurazione. Individua quale parte della chiave è sconosciuta durante il piano e proponimi una struttura con chiavi statiche che ottenga lo stesso risultato.

## Prompt 3

Ho tre risorse da creare per ogni ambiente e per ogni servizio. Proponimi la struttura dei dati d’ingresso e il valore locale da passare a `for_each`, con chiavi leggibili del tipo `ambiente-servizio`, e mostrami gli indirizzi che compariranno nello stato.
