# Prompt dei paragrafi «Con l’IA»

I prompt sono riportati capitolo per capitolo. Il testo fra parentesi quadre indica il materiale da incollare.

## Capitolo 1 — Che cos’è Laravel

**Prompt 1.** Sono uno sviluppatore PHP che non ha mai usato un framework. Spiegami in non più di venti righe che cosa fa Laravel al posto mio in una tipica pagina che legge dati da un database e li mostra in una tabella HTML, confrontando i passaggi con il PHP senza framework.

**Prompt 2.** Devo scegliere fra Laravel e Symfony per un gestionale interno con circa trenta tabelle, due sviluppatori e nessuna esigenza particolare di prestazioni. Elenca tre argomenti a favore di ciascuno e indica quali informazioni ti mancano per consigliarmi.

**Prompt 3.** Questo articolo descrive come configurare un *middleware* in Laravel. Dimmi a quale versione di Laravel si riferisce, da quali indizi lo deduci e che cosa è cambiato in Laravel 13. [incollare l’articolo]


## Capitolo 2 — Il PHP che serve a Laravel

**Prompt 1.** Spiegami riga per riga questo frammento di PHP 8.3 tratto da un progetto Laravel 13. Per ogni costrutto che non esisteva in PHP 7 indica il nome e la versione in cui è stato introdotto. [incollare il codice]

**Prompt 2.** Riscrivi questa classe PHP 7 in PHP 8.3 idiomatico: promozione delle proprietà nel costruttore, tipi su parametri e valori restituiti, `readonly` dove possibile, `match` al posto di `switch`, enum al posto delle costanti. Non cambiare il comportamento e segnala ogni punto in cui potrebbe cambiare. [incollare la classe]

**Prompt 3.** Ricevo l’errore `Class "App\Http\Controllers\Book" not found` in un progetto Laravel 13. Elenca in ordine di probabilità le cause possibili e, per ciascuna, il controllo da fare.


## Capitolo 3 — Installazione e primo progetto

**Prompt 1.** Sto installando Laravel 13 su Ubuntu 24.04 con PHP 8.3. Il comando `composer create-project laravel/laravel scaffale` termina con questo errore: [incollare l’errore]. Indica la causa più probabile e i comandi per risolverla, uno alla volta, spiegando che cosa fa ciascuno.

**Prompt 2.** Ho clonato da Git un progetto Laravel 13 esistente. Elenca, nell’ordine corretto, tutti i comandi da eseguire per farlo funzionare in locale con SQLite, e per ciascuno spiega perché serve.

**Prompt 3.** Descrivi la funzione di ogni cartella e di ogni file nella radice di un progetto Laravel 13 nuovo, in una tabella a due colonne. Segnala esplicitamente che cosa è cambiato rispetto a Laravel 10.


## Capitolo 4 — Artisan e la configurazione

**Prompt 1.** In un progetto Laravel 13 devo creare tutto il necessario per una nuova entità `Loan` (prestito): modello, migrazione, factory, seeder, controller risorsa, classi di validazione e policy. Dammi il minor numero possibile di comandi Artisan e spiega ogni opzione usata.

**Prompt 2.** Questo è il mio file `.env.example` di un progetto Laravel 13. Segnala le variabili mancanti rispetto a un’installazione standard, quelle con valori inadatti alla produzione e quelle che contengono per errore dati reali. [incollare il file]

**Prompt 3.** Nel mio progetto Laravel 13 la funzione `env('SERVIZIO_CHIAVE')` restituisce il valore giusto in locale e `null` sul server. Spiega la causa e mostra come correggere il codice creando una voce in un file di configurazione.


## Capitolo 5 — Il ciclo di vita di una richiesta

**Prompt 1.** Descrivi passo per passo che cosa accade in un’applicazione Laravel 13 dal momento in cui il browser richiede `/books/12` a quando riceve l’HTML. Per ogni passo indica il file o la classe coinvolti, distinguendo ciò che appartiene al framework da ciò che scrivo io.

**Prompt 2.** Questo è il mio `AppServiceProvider`. Individua le operazioni che non dovrebbero stare nel metodo `register` o che sono troppo costose per essere eseguite a ogni richiesta, e proponi dove spostarle. [incollare la classe]

**Prompt 3.** Sto portando un progetto da Laravel 10 a Laravel 13. Questi sono i miei `app/Http/Kernel.php` e `app/Exceptions/Handler.php`. Mostrami il contenuto equivalente di `bootstrap/app.php`. [incollare i file]


## Capitolo 6 — Il routing

**Prompt 1.** Progetta le rotte Laravel 13 per la gestione dei prestiti di una biblioteca: elenco, nuovo prestito, restituzione, rinnovo, storico per utente. Usa nomi secondo la convenzione `risorsa.azione`, i metodi HTTP corretti e un gruppo con prefisso `admin` protetto dal middleware `auth`. Per ogni rotta spiega la scelta del metodo.

**Prompt 2.** Questo è il mio file `routes/web.php`. Individua: rotte irraggiungibili per via dell’ordine, parametri privi di vincoli che dovrebbero averne, nomi mancanti o non conformi alla convenzione, ripetizioni eliminabili con i gruppi. Non riscrivere il file: elenca i problemi con il numero di riga. [incollare il file]

**Prompt 3.** La rotta `PUT /books/{book}` del mio progetto Laravel 13 risponde 405 quando invio il modulo di modifica. Questo è il modulo Blade e questa la definizione della rotta. Trova la causa. [incollare entrambi]


## Capitolo 7 — I controller

**Prompt 1.** Scrivi per Laravel 13 un controller risorsa completo `AuthorController` per il modello `Author` (campi `name`, `country`, `birth_year`). Usa il route model binding, i tipi di ritorno, `to_route` per i reindirizzamenti e un messaggio flash dopo ogni modifica. La validazione mettila per ora nel controller con `$request->validate()`. Non generare le viste.

**Prompt 2.** Questo controller è diventato troppo lungo. Senza modificarne il comportamento, proponi come suddividerlo: quali parti spostare in form request, quali in classi di servizio, quali in controller ad azione singola. Prima elenca il piano, poi attendi la mia conferma prima di scrivere codice. [incollare il controller]

**Prompt 3.** Nel mio progetto Laravel 13 l’azione `show(Book $libro)` riceve sempre un modello vuoto, senza errori. Questa è la rotta. Spiega la causa. [incollare la rotta]


## Capitolo 8 — Richieste e risposte

**Prompt 1.** In un controller Laravel 13 devo leggere questi dati da un modulo di ricerca: testo libero `q`, anno minimo e massimo, una casella «solo disponibili», un elenco di identificativi di categoria. Mostrami come leggerli con i metodi tipizzati di `Request`, gestendo l’assenza di ciascun campo, senza usare la validazione.

**Prompt 2.** Questa azione Laravel 13 restituisce una vista dopo aver salvato i dati di un modulo. Spiega perché è un problema, riscrivila secondo lo schema Post/Redirect/Get con un messaggio flash, e indica come mostrarlo nella vista di destinazione. [incollare l’azione]

**Prompt 3.** Devo far scaricare un file CSV con tutti i prestiti (potenzialmente centomila righe) da un’applicazione Laravel 13. Confronta tre soluzioni: comporre la stringa in memoria, `streamDownload` con `cursor`, generazione in coda con invio per posta. Per ciascuna indica consumo di memoria, complessità e quando sceglierla.


## Capitolo 9 — I middleware

**Prompt 1.** Scrivi per Laravel 13 un middleware `EnsureProfileIsComplete` che reindirizzi alla rotta `profile.edit` gli utenti autenticati privi di numero di telefono, escludendo la rotta stessa e quella di uscita per evitare cicli. Mostra anche la registrazione dell’alias in `bootstrap/app.php` e un esempio d’uso su un gruppo di rotte.

**Prompt 2.** Questa è l’uscita di `php artisan route:list -v` per una rotta del mio progetto Laravel 13. Spiega, nell’ordine di esecuzione, che cosa fa ciascun middleware elencato e quali potrebbero essere superflui per una rotta che restituisce solo JSON pubblico. [incollare l’uscita]

**Prompt 3.** Devo portare a Laravel 13 questo `app/Http/Kernel.php` di un progetto Laravel 9. Scrivi la sezione `withMiddleware` equivalente per `bootstrap/app.php`, indicando quali voci non servono più perché ora sono predefinite. [incollare il file]


## Capitolo 10 — Blade: le viste

**Prompt 1.** Converti questa pagina HTML statica in una vista Blade per Laravel 13. I dati sono in una variabile `$books`, collezione di modelli `Book` con le proprietà `title`, `year`, `price` e la relazione `author`. Usa `@forelse`, `route()` per i collegamenti, il formato italiano per i prezzi. Non aggiungere stili né classi che non siano già presenti. [incollare l’HTML]

**Prompt 2.** Esamina questa vista Blade e segnala: stampe con `{!! !!}` di dati che potrebbero provenire dall’utente, moduli privi di `@csrf` o di `@method`, indirizzi scritti a mano invece che con `route()`, logica che dovrebbe stare nel controller. Per ogni problema indica la riga e la correzione. [incollare la vista]

**Prompt 3.** Questa vista Blade mostra un elenco di prestiti e accede a `$loan->book->author->name` dentro un `@foreach`. Spiega quante query vengono eseguite con cento prestiti e come deve cambiare il controller per ridurle.


## Capitolo 11 — Componenti Blade e layout

**Prompt 1.** Queste tre viste Blade di un progetto Laravel 13 contengono frammenti HTML quasi identici. Individua i frammenti ripetuti, proponi per ciascuno un componente anonimo con le relative `@props`, e mostra come cambiano le viste. Mantieni invariato l’HTML prodotto. [incollare le viste]

**Prompt 2.** Scrivi un componente Blade anonimo `forms.select` per Laravel 13: proprietà `name`, `label`, `options` (array valore-etichetta), `selected`; deve riproporre il valore con `old()`, mostrare l’errore di validazione e inoltrare gli altri attributi all’elemento `<select>`. Aggiungi un esempio d’uso.

**Prompt 3.** Converti questo layout basato su `@extends`, `@section` e `@yield` in un componente `<x-layout>` con slot. Elenca le modifiche da fare in ogni vista che lo usa e segnala i casi che non si convertono in modo meccanico. [incollare il layout e una vista]


## Capitolo 12 — La validazione

**Prompt 1.** Scrivi per Laravel 13 la form request `StoreLoanRequest` per registrare un prestito. Campi: `book_id` (libro esistente e disponibile), `user_id` (utente esistente), `due_at` (data futura, non oltre 60 giorni da oggi). Aggiungi messaggi in italiano e un controllo `after` che impedisca più di cinque prestiti attivi per utente. Commenta ogni regola.

**Prompt 2.** Queste sono le regole di validazione di un modulo. Elenca dieci valori in ingresso che dovrebbero essere respinti ma che queste regole lasciano passare, oppure che dovrebbero essere accettati ma vengono respinti. Per ciascuno indica la correzione. [incollare le regole]

**Prompt 3.** Dato questo schema di tabella, genera le regole di validazione Laravel 13 coerenti con tipi, lunghezze e vincoli delle colonne, distinguendo le regole per la creazione da quelle per la modifica. [incollare la migrazione]


## Capitolo 13 — Sessione, errori e log

**Prompt 1.** Questo è un estratto di `storage/logs/laravel.log` di un’applicazione Laravel 13. Per ogni errore distinto indica: che cosa è successo in parole semplici, quale riga del mio codice (non del framework) è la più probabile origine, e quale verifica fare per prima. [incollare l’estratto, dopo aver rimosso dati personali e segreti]

**Prompt 2.** Scrivi per Laravel 13 un’eccezione `LoanLimitReached` con un metodo `render` che, per le richieste normali, riporti l’utente alla pagina precedente con un messaggio flash e, per quelle che attendono JSON, risponda con il codice 409 e un corpo JSON. Mostra come sollevarla da un controller.

**Prompt 3.** I miei utenti segnalano errori 419 saltuari sul modulo di prestito di un’applicazione Laravel 13 con sessioni su database dietro un bilanciatore di carico. Elenca le cause possibili in ordine di probabilità, con il controllo da eseguire per ciascuna.


## Capitolo 14 — Database e migrazioni

**Prompt 1.** Devo aggiungere a un’applicazione Laravel 13 per biblioteche la gestione delle prenotazioni: un utente può prenotare un libro in prestito ad altri e viene servito in ordine di arrivo; una prenotazione può essere annullata o scadere. Proponi la tabella con colonne, tipi, indici e chiavi esterne, scrivi la migrazione completa di `down`, e motiva la scelta del comportamento alla cancellazione di libri e utenti.

**Prompt 2.** Rivedi questa migrazione Laravel 13. Segnala: tipi inadatti (in particolare per importi e date), colonne che dovrebbero essere `nullable` o avere un valore predefinito, indici mancanti rispetto alle query che elenco sotto, chiavi esterne senza comportamento alla cancellazione, metodo `down` che non annulla esattamente `up`. [incollare la migrazione e le query]

**Prompt 3.** Ho una tabella `books` con 2 milioni di righe in MySQL 8. Devo rendere obbligatoria la colonna `publisher`, oggi `nullable`. Descrivi la sequenza di migrazioni e operazioni sui dati che minimizza il blocco della tabella, e i rischi di ciascun passo.


## Capitolo 15 — Il Query Builder

**Prompt 1.** Converti questa query SQL nel Query Builder di Laravel 13, usando i metodi dedicati al posto delle espressioni grezze ovunque sia possibile, e segnalando i punti in cui l’espressione grezza resta necessaria. [incollare la query]

**Prompt 2.** Scrivi con il Query Builder di Laravel 13 una query che restituisca, per ogni mese degli ultimi dodici, il numero di prestiti registrati e il numero di quelli restituiti in ritardo, dalla tabella `loans` (colonne `loaned_at`, `due_at`, `returned_at`). Il database è MySQL 8. Mostra anche l’SQL prodotto.

**Prompt 3.** Questa è l’uscita di `EXPLAIN` per una query lenta del mio progetto. Spiega che cosa indica riga per riga e quale indice aggiungere, scrivendo la migrazione Laravel 13 corrispondente. [incollare la query e l’uscita di EXPLAIN]


## Capitolo 16 — Eloquent: i modelli

**Prompt 1.** Data questa migrazione Laravel 13, scrivi il modello Eloquent corrispondente: attributo `Fillable` con le sole colonne che ha senso compilare da un modulo, metodo `casts` con le conversioni appropriate per ogni colonna, trait necessari. Spiega per ogni colonna esclusa da `Fillable` perché l’hai esclusa. [incollare la migrazione]

**Prompt 2.** Rivedi questo controller Laravel 13 dal punto di vista dell’uso di Eloquent: individua assegnazioni di massa con dati non validati, record caricati solo per essere contati o aggiornati, uso di `find` dove serve `findOrFail`, confronti errati con valori convertiti da cast. [incollare il controller]

**Prompt 3.** Voglio introdurre l’eliminazione reversibile sul modello `Author` di un’applicazione Laravel 13 già in produzione. Elenca tutti i punti dell’applicazione da rivedere (vincoli di unicità, relazioni, regole di validazione `exists` e `unique`, rapporti) e scrivi la migrazione.


## Capitolo 17 — Eloquent: le relazioni

**Prompt 1.** Questi sono i modelli e le migrazioni di un’applicazione Laravel 13. Elenca tutte le relazioni Eloquent che si possono dedurre dalle chiavi esterne, indicando per ciascuna i due metodi da aggiungere ai modelli, e segnala le relazioni già dichiarate ma incoerenti con lo schema. [incollare modelli e migrazioni]

**Prompt 2.** Questo controller e questa vista Blade di un’applicazione Laravel 13 producono, secondo il registro delle query, 214 query per una pagina con 50 righe. Individua ogni accesso a relazioni non caricate in anticipo e riscrivi la sola query del controller con gli opportuni `with`, `withCount` e vincoli. [incollare controller e vista]

**Prompt 3.** Devo ottenere con Eloquent, in Laravel 13, gli utenti che hanno almeno un prestito scaduto e non restituito, con il numero di tali prestiti e la data di scadenza più vecchia, ordinati per quest’ultima. Scrivi la query usando `whereHas`, `withCount` e `withMin`, e mostra l’SQL che ne risulta.


## Capitolo 18 — Eloquent avanzato e collezioni

**Prompt 1.** Riscrivi questo ciclo `foreach` con accumulatori usando i metodi delle collezioni di Laravel 13. Poi indica quali operazioni conviene spostare nella query Eloquent anziché eseguirle in memoria, e riscrivi di conseguenza. [incollare il codice]

**Prompt 2.** Nel mio progetto Laravel 13 la condizione «prestito scaduto» (non restituito e con scadenza passata) è ripetuta in sei punti fra controller e viste. Scrivi per il modello `Loan` uno scope locale con l’attributo `Scope` e un metodo `isOverdue()`, e mostra come cambia ciascuno di questi sei frammenti. [incollare i frammenti]

**Prompt 3.** Spiega passo per passo che cosa restituisce questa catena di metodi su una collezione, indicando il contenuto dopo ogni metodo per un piccolo insieme di dati d’esempio che scegli tu. [incollare la catena]


## Capitolo 19 — Factory, seeder e paginazione

**Prompt 1.** Data questa migrazione e questo modello Laravel 13, scrivi la factory con valori Faker plausibili per ogni colonna, rispettando i vincoli (unicità, intervalli, chiavi esterne tramite altre factory), e aggiungi tre stati utili per i test, motivandone la scelta. [incollare migrazione e modello]

**Prompt 2.** Scrivi un seeder Laravel 13 che inserisca venti classici della letteratura italiana del Novecento con autore, anno, numero di pagine approssimativo e una o due categorie. Usa dati fissi in un array, rendi il seeder rieseguibile senza doppioni e non usare Faker. Segnala i dati di cui non sei sicuro.

**Prompt 3.** L’elenco dei prestiti della mia applicazione Laravel 13 usa `paginate(50)` su una tabella da 3 milioni di righe e le ultime pagine impiegano diversi secondi. Spiega la causa, confronta `simplePaginate` e `cursorPaginate` per questo caso e mostra le modifiche a controller e vista.


## Capitolo 20 — Contenitore, provider e facade

**Prompt 1.** Questa classe di un’applicazione Laravel 13 crea le proprie dipendenze con `new` e chiama direttamente un servizio esterno. Riscrivila in modo che riceva le dipendenze per iniezione e dipenda da un’interfaccia; scrivi l’interfaccia, l’implementazione reale, un’implementazione finta per i test e il legame in un service provider. [incollare la classe]

**Prompt 2.** Spiegami con un esempio concreto la differenza fra `bind`, `singleton` e `scoped` nel contenitore di Laravel 13, mostrando per ciascuno quante volte viene eseguito il costruttore in una richiesta HTTP che risolve il servizio tre volte, e che cosa cambia con Laravel Octane.

**Prompt 3.** Ricevo l’errore `Target [App\Contracts\PaymentGateway] is not instantiable while building [App\Http\Controllers\CheckoutController]`. Elenca le cause possibili in ordine di probabilità e i controlli da fare, sapendo che il progetto è Laravel 13.


## Capitolo 21 — L’autenticazione

**Prompt 1.** Rivedi questo controller di accesso scritto a mano per Laravel 13 dal punto di vista della sicurezza. Verifica in particolare: rigenerazione della sessione, messaggi d’errore che rivelano l’esistenza di un account, limitazione dei tentativi, gestione della funzione «ricordami», uscita. Per ogni problema indica la gravità e la correzione. [incollare il controller e le rotte]

**Prompt 2.** Ho un’applicazione Laravel 13 con viste Blade e nessuno starter kit. Voglio aggiungere Fortify per accesso, registrazione, recupero della password e verifica dell’indirizzo. Elenca i passi nell’ordine giusto, i file che vengono creati, le viste che devo scrivere io con i nomi dei campi e delle rotte a cui inviano i dati.

**Prompt 3.** Spiegami come funziona il recupero della password in Laravel 13: quali tabelle sono coinvolte, che cosa contiene il collegamento inviato per posta, come viene verificato il gettone, quando scade e quali attacchi previene ciascuna di queste scelte.


## Capitolo 22 — L’autorizzazione

**Prompt 1.** Questa tabella descrive chi può fare che cosa in un’applicazione Laravel 13 per biblioteche (ruoli: socio, bibliotecario, direttore; risorse: libri, prestiti, utenti). Scrivi le policy corrispondenti, usando `Response::deny` con un messaggio dove la regola non dipende dal ruolo, e segnala le caselle della tabella che sono ambigue o in contraddizione fra loro. [incollare la tabella]

**Prompt 2.** Questi sono i controller e le rotte di un’applicazione Laravel 13. Per ogni azione che legge o modifica un record individuato da un parametro della rotta, indica se esiste un controllo di autorizzazione e, in caso contrario, quale utente potrebbe accedere a quale dato altrui. Presenta il risultato in una tabella. [incollare controller e rotte]

**Prompt 3.** Scrivi i test Laravel 13 (PHPUnit) per `LoanPolicy`: per ciascun metodo, un caso per ogni ruolo e, dove rilevante, per il proprietario e per un estraneo. Usa le factory con gli stati `librarian` e `director` del modello `User`.


## Capitolo 23 — Eventi, listener e observer

**Prompt 1.** Questa azione di un controller Laravel 13 esegue l’operazione principale e cinque conseguenze. Distingui ciò che deve restare nell’azione, perché essenziale e da eseguire nella stessa transazione, da ciò che conviene spostare in listener, indicando per ciascun listener se deve essere sincrono o in coda e perché. Poi scrivi l’evento e i listener. [incollare l’azione]

**Prompt 2.** Scrivi per Laravel 13 un observer del modello `Loan` che: alla creazione imposti la scadenza se assente; alla restituzione (quando `returned_at` passa da nullo a valorizzato) renda disponibile il libro; impedisca l’eliminazione di un prestito non restituito. Usa l’attributo `ObservedBy` e indica quali operazioni di massa aggirerebbero l’observer.

**Prompt 3.** Nella mia applicazione Laravel 13 un listener in coda fallisce ogni tanto con `ModelNotFoundException` subito dopo la creazione del record. Spiega la causa più probabile e le possibili correzioni.


## Capitolo 24 — Code e job

**Prompt 1.** Questa azione di un controller Laravel 13 genera un PDF e lo invia per posta, impiegando alcuni secondi. Trasformala in un job in coda: scrivi il job con gli attributi `Tries`, `Backoff` e `Timeout`, il metodo `failed`, e l’azione modificata. Indica quali dati passare al costruttore e perché, e in quali punti il job potrebbe non essere idempotente. [incollare l’azione]

**Prompt 2.** Devo importare in un’applicazione Laravel 13 un file CSV di 200.000 righe caricato dall’utente. Proponi un’architettura con job in coda che non esaurisca la memoria, mostri l’avanzamento, tolleri righe errate senza fermarsi e possa essere ripresa dopo un’interruzione. Confronta un job unico, una catena e un lotto.

**Prompt 3.** Questa è la configurazione di Supervisor e di `config/queue.php` di un’applicazione Laravel 13 in produzione, e questi sono i valori di timeout dei job. Verifica la coerenza fra `retry_after`, `--timeout`, `stopwaitsecs` e i timeout dei singoli job, e spiega le conseguenze di ogni incoerenza. [incollare le configurazioni]


## Capitolo 25 — Posta e notifiche

**Prompt 1.** Scrivi in italiano, con tono cortese e formale e usando il «voi», il testo di tre messaggi per una biblioteca: conferma di prestito, promemoria a tre giorni dalla scadenza, sollecito dopo la scadenza. Per ciascuno fornisci oggetto, testo in Markdown adatto a una vista `x-mail::message` di Laravel 13 (senza rientri) e l’elenco delle variabili da sostituire.

**Prompt 2.** Scrivi per Laravel 13 una notifica `LoanDueSoon` da inviare tre giorni prima della scadenza di un prestito, sui canali `mail` e `database`, in coda, con il metodo `via` che esclude la posta per gli utenti che hanno disattivato i promemoria (colonna booleana `wants_reminders`). Aggiungi il test con `Notification::fake()`.

**Prompt 3.** I messaggi inviati dalla mia applicazione Laravel 13 tramite SMTP finiscono spesso fra gli indesiderati. Elenca le verifiche da fare su SPF, DKIM e DMARC del dominio, sul contenuto dei messaggi e sulla configurazione di Laravel, in ordine di importanza.


## Capitolo 26 — File, archiviazione e cache

**Prompt 1.** Scrivi per Laravel 13 la gestione completa del caricamento della copertina di un libro: regole di validazione con la classe `File`, salvataggio sul disco `public`, eliminazione del file precedente in caso di sostituzione e alla cancellazione definitiva del libro, attributo calcolato per l’indirizzo con immagine predefinita. Elenca poi i rischi di sicurezza che questa soluzione copre e quelli che restano.

**Prompt 2.** Questa pagina di cruscotto di un’applicazione Laravel 13 esegue dodici query di aggregazione a ogni visita. Proponi una strategia di cache: quali risultati raggruppare sotto la stessa chiave, quali durate, come invalidare quando cambiano i dati di origine, e dove conviene `Cache::flexible`. Mostra il codice. [incollare il controller]

**Prompt 3.** La mia applicazione Laravel 13 passa da un server a tre dietro un bilanciatore di carico. Elenca tutto ciò che oggi dipende dal disco locale o dalla memoria del singolo server (file caricati, sessioni, cache, code, registri, pianificazione) e, per ciascuna voce, la modifica necessaria.


## Capitolo 27 — Comandi Artisan e pianificazione

**Prompt 1.** Scrivi per Laravel 13 un comando Artisan `catalog:import {file}` che importi libri da un file CSV con colonne titolo, autore, anno, pagine. Deve: validare ogni riga e scartare quelle errate elencandole alla fine; creare gli autori mancanti; mostrare una barra di avanzamento; offrire un’opzione `--dry-run`; restituire un codice d’uscita diverso da zero se ci sono stati scarti. Usa gli attributi `Signature` e `Description`.

**Prompt 2.** Questa è la tabella cron di un vecchio server. Traduci ogni riga nella corrispondente dichiarazione `Schedule` di Laravel 13 per `routes/console.php`, usando i metodi di frequenza dedicati dove esistono, e segnala le righe che richiedono `withoutOverlapping`, `onOneServer` o `runInBackground`, motivando. [incollare la tabella]

**Prompt 3.** Ho dieci attività pianificate in un’applicazione Laravel 13 su due server. Proponi una strategia di sorveglianza: che cosa registrare, quali agganci usare, come accorgermi che il pianificatore non gira affatto.


## Capitolo 28 — Vite, asset e starter kit

**Prompt 1.** Applica classi di Tailwind CSS 4 a questa vista Blade di un progetto Laravel 13 per ottenere una griglia di schede adattiva: una colonna su telefono, due su tavoletta, tre su schermo grande. Non modificare la struttura né il contenuto; usa solo classi standard di Tailwind, scritte per intero. Poi indica quali gruppi di classi ripetuti converrebbe estrarre in componenti Blade. [incollare la vista]

**Prompt 2.** Devo scegliere fra Blade con Alpine.js, Livewire 4 e Inertia 3 con Vue per un gestionale di biblioteca con circa quaranta schermate, molte tabelle filtrabili e pochi elementi molto interattivi. Il gruppo è di due sviluppatori esperti di PHP, con poca esperienza di JavaScript. Confronta le tre opzioni rispetto a curva di apprendimento, manutenzione, prestazioni percepite e test, e indica quali informazioni ti mancano.

**Prompt 3.** La mia applicazione Laravel 13 in produzione mostra le pagine senza stili e nella console del browser compaiono richieste fallite verso `localhost:5173`. Elenca le cause possibili e i controlli da fare sul server.


## Capitolo 29 — Livewire

**Prompt 1.** Scrivi per Livewire 4 e Laravel 13 un componente a file singolo che mostri la tabella dei prestiti con: ricerca per titolo con ritardo di 300 ms, filtro per stato (in corso, in ritardo, restituiti), ordinamento cliccando sulle intestazioni, paginazione, parametri conservati nell’indirizzo, azione «restituito» protetta dalla policy. Usa `#[Computed]` per i dati e `wire:key` sulle righe.

**Prompt 2.** Rivedi questo componente Livewire 4 dal punto di vista della sicurezza: proprietà pubbliche che espongono dati riservati o che dovrebbero essere `#[Locked]`, azioni prive di autorizzazione, parametri delle azioni non validati, dati del browser usati senza rileggere dal database. Per ogni problema spiega come potrebbe essere sfruttato. [incollare il componente]

**Prompt 3.** Converti questo componente scritto per Livewire 2 nella sintassi di Livewire 4, come componente a file singolo. Elenca prima le differenze che applicherai, poi riscrivi. [incollare classe e vista]


## Capitolo 30 — Inertia con Vue e React

**Prompt 1.** Scrivi per Laravel 13 e Inertia 3 con Vue 3 (Composition API, `script setup`) la pagina di modifica di un libro: controller con azioni `edit` e `update`, form request, componente `Books/Edit.vue` con `useForm`, errori accanto ai campi, pulsante disattivato durante l’invio, messaggio flash dopo il salvataggio. Invia al componente solo i campi necessari e calcola i permessi sul server.

**Prompt 2.** Converti questa vista Blade con il suo controller in una pagina Inertia 3 con React 19. Elenca prima i dati che il componente deve ricevere, distinguendo quelli da condividere globalmente nel middleware, poi scrivi controller e componente. [incollare vista e controller]

**Prompt 3.** Questa azione Laravel restituisce a un componente Inertia l’intero modello `User` con le sue relazioni. Individua i dati che non dovrebbero arrivare al browser e riscrivi l’azione inviando una struttura minima. [incollare l’azione]


## Capitolo 31 — API REST, Sanctum e JSON:API

**Prompt 1.** Progetta l’API REST per i prestiti di un’applicazione Laravel 13: elenco dei prestiti dell’utente, creazione, restituzione, rinnovo. Per ogni operazione indica metodo, indirizzo, corpo della richiesta, codici di risposta e un esempio JSON. Poi scrivi rotte, controller, form request e risorse, usando Sanctum con abilità e le policy esistenti. Motiva le scelte per le operazioni che non sono CRUD.

**Prompt 2.** Genera la descrizione OpenAPI 3.1 in YAML di queste rotte, a partire dai controller, dalle form request e dalle risorse che incollo. Per ogni risposta d’errore (401, 403, 404, 422, 429) includi lo schema e un esempio. Segnala i punti in cui il codice non permette di dedurre lo schema con certezza. [incollare i file]

**Prompt 3.** Rivedi questa API Laravel 13 dal punto di vista della compatibilità futura: campi che espongono dettagli interni, strutture difficili da estendere, assenza di paginazione o di versione, codici di stato impropri. Per ogni osservazione proponi la correzione meno invasiva. [incollare rotte, controller e risorse]


## Capitolo 32 — I test

**Prompt 1.** Scrivi i test funzionali PHPUnit per Laravel 13 di questo controller, usando `RefreshDatabase` e le factory. Per ogni azione copri: ospite, utente senza permesso, utente con permesso, dati non validi (un test per regola significativa), caso limite. Usa nomi che descrivono il comportamento. Prima elenca i casi che intendi coprire e attendi la mia conferma. [incollare controller, form request, policy e rotte]

**Prompt 2.** Questo test fallisce in modo intermittente in integrazione continua. Individua le possibili fonti di non determinismo (tempo, dati casuali, ordine di esecuzione, stato condiviso, ordinamento non specificato nelle query) e proponi la correzione per ciascuna. [incollare il test e il codice provato]

**Prompt 3.** Questa è la segnalazione di un difetto e questo il codice coinvolto. Scrivi prima un test che riproduca il difetto e che oggi fallisca, spiegando perché fallisce; solo dopo proponi la correzione. [incollare segnalazione e codice]


## Capitolo 33 — Laravel e l’intelligenza artificiale

**Prompt 1.** Voglio aggiungere a un’applicazione Laravel 13 per biblioteche, con Laravel AI SDK, un assistente che risponda alle domande dei soci sul catalogo e sui propri prestiti. Progetta: le istruzioni dell’agente, gli strumenti necessari con i loro parametri, i controlli di autorizzazione in ciascuno strumento, la gestione dello storico della conversazione. Per ogni strumento indica che cosa potrebbe andare storto se l’utente tentasse di manipolare il modello.

**Prompt 2.** Scrivi le istruzioni di sistema, in italiano, per un agente che classifica i libri in una fra cinque categorie a partire da titolo e descrizione, e lo schema della risposta strutturata. Poi proponi dieci casi di prova, compresi cinque ambigui, con la risposta attesa e la motivazione.

**Prompt 3.** Esamina questo strumento di un agente Laravel AI SDK dal punto di vista della sicurezza: dati che espone, azioni che compie, assenza di controlli sull’utente autenticato, possibilità di abuso tramite istruzioni iniettate nel testo. [incollare lo strumento]


## Capitolo 34 — Sicurezza, prestazioni e messa in produzione

**Prompt 1.** Rivedi questo script di rilascio di un’applicazione Laravel 13 con code su Redis e pianificatore. Verifica: ordine dei passi, comandi mancanti, comandi pericolosi in produzione, gestione degli errori (lo script si ferma al primo fallimento?), finestra in cui convivono codice vecchio e nuovo. Proponi una versione corretta e spiega ogni modifica. [incollare lo script]

**Prompt 2.** Prepara una lista di controllo di sicurezza per la messa in produzione di un’applicazione Laravel 13 esposta a Internet, divisa in: configurazione dell’applicazione, server web, database, segreti, dipendenze, copie di sicurezza, sorveglianza. Per ogni voce indica come verificarla con un comando o un controllo concreto.

**Prompt 3.** Questa pagina di un’applicazione Laravel 13 impiega tre secondi. Ti fornisco il controller, la vista, l’elenco delle query con i tempi e l’uscita di EXPLAIN per le due più lente. Indica le cause in ordine di impatto e le correzioni, distinguendo quelle certe da quelle da verificare con una misura. [incollare il materiale]

