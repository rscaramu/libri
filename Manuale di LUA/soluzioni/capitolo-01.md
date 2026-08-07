# Capitolo 1 — Che cos’è Lua e perché esiste

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[Indice](README.md) · [Capitolo 2 →](capitolo-02.md)

---

**ES 1.4 — Tre applicazioni che usano Lua**

*Cerca in rete tre applicazioni o giochi che usano Lua e che non sono
citati in questo capitolo. Per ciascuno scrivi in tre righe a che
cosa serve Lua in quel contesto specifico: configurazione, logica di
gioco, estensione, interfaccia utente o altro.*

Una risposta possibile, fra le moltissime.

**Kong**, il gateway per API costruito su OpenResty. Lua vi svolge il
ruolo di logica di estensione: ogni plugin — autenticazione,
limitazione, trasformazione delle richieste, registrazione — è un modulo
Lua che si inserisce nelle fasi di elaborazione di nginx. È il caso in
cui Lua non è un accessorio ma il linguaggio in cui è scritta l’intera
superficie configurabile del prodotto.

**Awesome WM**, un gestore di finestre per X11. L’intera configurazione
è un programma Lua eseguito all’avvio: la disposizione delle finestre, le
scorciatoie, la barra di stato, il comportamento al collegamento di un
monitor. Qui Lua sostituisce completamente il file di configurazione,
secondo il modello del Capitolo 25.

**Tarantool**, un database in memoria con motore applicativo integrato.
Le stored procedure si scrivono in Lua, che gira dentro il processo del
database con accesso diretto ai dati. Il ruolo è quello dello scripting
lato server, analogo a quello di Redis ma molto più esteso.

Altri esempi validi: Vim con l’interfaccia Lua, VLC per le estensioni,
Rspamd per le regole antispam, Prosody che è interamente scritto in Lua,
Snort e Suricata per le regole di analisi, Grafana Loki per alcune
trasformazioni, i firmware NodeMCU e Tasmota.

**ES 1.5 — Cinque funzionalità assenti dalla libreria standard**

*Il capitolo afferma che Lua ha una libreria standard volutamente
spartana. Elenca cinque funzionalità che dareste per scontate in un
linguaggio moderno e che Lua non fornisce nativamente. Per ciascuna,
indica come pensi che un programma Lua reale risolva il problema.*

**JSON.** Non c’è né codifica né decodifica. I programmi reali usano
`dkjson`, che è Lua puro e portabile, oppure `lua-cjson`, che è un modulo
C molto più veloce. In OpenResty `cjson` è già presente. È l’assenza più
sentita, perché JSON è il formato di scambio dominante.

**Richieste HTTP.** Non c’è alcun client. Si usa LuaSocket con LuaSec per
il TLS, oppure `lua-http`, oppure `resty.http` in OpenResty. Negli script
di sistema è frequente vedere una chiamata a `curl` tramite `io.popen`,
che funziona ma non è portabile e ha i problemi di sicurezza discussi nel
Capitolo 20.

**Elenco delle cartelle.** `io` sa aprire i file ma non sa dire quali
esistono. Serve LuaFileSystem, oppure `io.popen` con `ls` o `dir`. È
un’assenza sorprendente per chi arriva da qualunque altro linguaggio.

**Espressioni regolari.** Ci sono i pattern, che sono più semplici e
coprono la maggior parte dei casi, ma per l’alternanza e le grammatiche
serve LPeg.

**Framework di test.** Non c’è nulla: si usa `busted`, oppure ci si
scrive quaranta righe come nel Capitolo 29.

Se ne potrebbero aggiungere altre: date avanzate, crittografia,
compressione, socket, thread, espressioni razionali, numeri a precisione
arbitraria.

**ES 1.6 — Perché LuaJIT complica la vita a chi scrive un manuale**

*Spiega in un paragrafo, come se stessi rispondendo a un collega,
perché l’esistenza di LuaJIT complica la vita di chi scrive un
manuale su Lua. Immagina di dover decidere quale versione insegnare
a un gruppo di principianti che vogliono usare LÖVE 2D.*

La difficoltà è che «Lua» non identifica un linguaggio solo.

Un manuale deve scegliere una versione di riferimento. Scegliendo Lua
5.4, si insegna il linguaggio corrente con interi, operatori bit a bit,
`<const>` e `<close>`, e `_ENV`. Ma il lettore che apre LÖVE 2D scopre
che metà di quelle cose non esiste, perché LÖVE usa LuaJIT, cioè Lua 5.1
con alcune aggiunte.

Scegliendo Lua 5.1 si insegnerebbe un linguaggio del 2006, con
`setfenv`, `unpack` globale e nessun intero, che è obsoleto per chiunque
non usi LuaJIT.

Non c’è una scelta che accontenti entrambi, perché non si tratta di
differenze marginali: riguardano i numeri, l’ambiente, la gestione delle
risorse.

Per un gruppo di principianti che vogliono usare LÖVE 2D la scelta
migliore è comunque **insegnare Lua 5.4 e segnalare le differenze**,
per tre ragioni. La prima è che la stragrande maggioranza del codice —
tabelle, funzioni, closure, metatabelle, pattern, coroutine — è identica.
La seconda è che LuaJIT è un caso particolare, e capire prima la regola e
poi l’eccezione è più efficace del contrario. La terza è che un giorno
quei principianti scriveranno anche codice fuori da LÖVE, e avranno
imparato il linguaggio corrente.

La strategia adottata da questo manuale è esattamente questa: base 5.4,
box dedicati per le differenze, e un capitolo intero, il 27, che tratta
LuaJIT prima dei capitoli che lo usano.

**ES 1.7 — Nomi di linguaggi scritti scorrettamente**

*Il nome «Lua» non è un acronimo e va scritto con la sola iniziale
maiuscola. Cerca almeno altri due linguaggi di programmazione il cui
nome viene comunemente scritto in modo scorretto e spiega qual è la
grafia corretta e perché.*

**Bash** si scrive con la sola iniziale maiuscola. È un acronimo —
*Bourne Again SHell* — ma il nome del programma è `bash` e il nome
proprio è Bash, non BASH. Lo stesso vale per **Perl**: era
retroattivamente glossato come *Practical Extraction and Report
Language*, ma il nome è Perl, e `perl` minuscolo indica l’eseguibile. La
comunità usa la distinzione in modo sistematico.

**Python** si scrive Python, mai PYTHON: prende il nome dai Monty Python
e non è un acronimo.

**Haskell**, **Rust**, **Elixir**, **Scala**, **Kotlin**, **Swift** sono
tutti nomi propri e vanno scritti con la sola iniziale maiuscola.

Casi che vanno invece in maiuscolo, perché sono veri acronimi: **SQL**,
**HTML**, **PHP** (che oggi sta per *PHP: Hypertext Preprocessor*),
**COBOL**, **FORTRAN** nelle versioni antiche, mentre le versioni moderne
si scrivono **Fortran**.

Un caso limite interessante è **JavaScript**, che ha una maiuscola
interna e non va scritto Javascript né JAVASCRIPT.

**ES 1.8 — Scaletta per convincere un responsabile tecnico**

*Immagina di dover convincere il responsabile tecnico di un progetto
ad adottare Lua come linguaggio di scripting per il vostro prodotto.
Scrivi una scaletta di sei punti per una presentazione di cinque
minuti, includendo almeno un punto onesto sugli svantaggi.*

Una scaletta possibile per cinque minuti.

**Uno. Il problema che risolviamo.** Ogni modifica al comportamento del
prodotto richiede oggi una ricompilazione e un rilascio. I clienti
chiedono personalizzazioni che non possiamo dare senza toccare il codice.

**Due. La proposta.** Incorporare un interprete Lua ed esporre le parti
configurabili come API. Le personalizzazioni diventano script, non
rilasci.

**Tre. Perché Lua e non altri.** Il binario cresce di poche centinaia di
kilobyte contro decine di megabyte di un Python incorporato. L’avvio è
istantaneo. Compila ovunque con un compilatore C. La licenza è MIT,
quindi nessun vincolo. Ed è il linguaggio che l’industria dei videogiochi
usa da vent’anni esattamente per questo scopo.

**Quattro. Il costo.** Circa due settimane per l’integrazione di base e
l’API iniziale, più la documentazione. Serve competenza sull’API C, che
possiamo acquisire.

**Cinque. Gli svantaggi, onestamente.** La libreria standard è minima:
per JSON, HTTP e filesystem servono dipendenze aggiuntive. L’ecosistema è
molto più piccolo di quello di Python. Non c’è tipizzazione statica,
quindi gli errori negli script emergono a runtime, ed è nostra
responsabilità che uno script difettoso non faccia crollare il prodotto.
E c’è la frammentazione fra Lua e LuaJIT, che va decisa all’inizio.

**Sei. Il passo successivo.** Un prototipo su una sola funzionalità, con
un tempo definito, per valutare sul concreto prima di impegnarsi.

La quinta voce è quella che rende credibile l’intera presentazione. Una
proposta senza svantaggi dichiarati suggerisce che chi la fa non ha
valutato il problema.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
