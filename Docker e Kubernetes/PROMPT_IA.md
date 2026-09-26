# Prompt per l’IA — Manuale completo di Docker e Kubernetes


## Capitolo 1 — Perché i container

**Prompt 1 — Spiegazione per analogia.**

«Spiegami la differenza tra namespace e cgroup nel *kernel* Linux usando un’analogia con un condominio, poi dimmi dove l’analogia smette di funzionare.»

**Prompt 2 — Verifica di una convinzione.**

«Ho letto che un container Ubuntu eseguito su un *host* Fedora usa il *kernel* di Ubuntu. È corretto? Se no, spiegami cosa succede davvero.»

**Prompt 3 — Confronto strutturato.**

«Confronta macchine virtuali e container su cinque dimensioni: isolamento, tempo di avvio, occupazione di memoria, portabilità tra sistemi operativi, superficie d’attacco. Per ogni dimensione indica quale dei due è preferibile e perché.»


## Capitolo 2 — Installare Docker e il primo container

**Prompt 1 — Diagnosi di un comando.**

«Ho eseguito `docker run -d nginx` e poi `curl localhost` mi dà *connection refused*. Il container risulta in esecuzione con `docker ps`. Cosa sto sbagliando?»

**Prompt 2 — Generazione di un’esplorazione.**

«Dammi una sequenza di dieci comandi `docker` per esplorare un container Ubuntu appena avviato e scoprire sperimentalmente quali *namespace* sono attivi. Per ogni comando indica cosa mi aspetto di vedere.»

**Prompt 3 — Lettura di `docker inspect`.**

«Ti incollo l’output di `docker inspect` di un container. Estrai in una tabella: immagine, comando, stato, indirizzo IP, porte pubblicate, volumi montati, variabili d’ambiente. Segnala eventuali configurazioni insolite.»


## Capitolo 3 — Immagini, livelli e registry

**Prompt 1 — Scelta della variante.**

«Devo containerizzare un’applicazione Python 3.12 che usa `psycopg2`, `numpy` e `pillow`. Confronta le varianti `python:3.12-slim` e `python:3.12-alpine` per questa applicazione: dimensione, tempo di costruzione, rischi. Consiglia una scelta motivata.»

**Prompt 2 — Interpretazione di `history`.**

«Ti incollo l’output di `docker image history` di un’immagine. Identifica quali strati contribuiscono di più alla dimensione, quali sembrano ridondanti o migliorabili, e stima quanto si risparmierebbe.»

**Prompt 3 — Politica di etichettatura.**

«Proponi uno schema di etichettatura per le immagini di un’applicazione interna che ha rilasci settimanali e correzioni urgenti occasionali. Devo poter risalire al *commit* Git, distinguere gli ambienti (sviluppo, collaudo, produzione) e garantire che la produzione non cambi immagine senza un’azione esplicita.»


## Capitolo 4 — Il Dockerfile

**Prompt 1 — Generazione guidata.**

«Scrivi un Dockerfile per un’applicazione Node.js 22 con `package.json` e `package-lock.json`. Requisiti: base `-slim`, utente non `root`, ordine delle istruzioni che massimizzi la *cache*, forma exec per `CMD`, `.dockerignore` incluso. Commenta ogni istruzione in una riga.»

**Prompt 2 — Revisione.**

«Ti incollo un Dockerfile. Elenca i problemi in ordine di gravità: sicurezza, correttezza, dimensione dell’immagine, uso della *cache*. Per ciascuno proponi la correzione con il frammento di codice.»

**Prompt 3 — `CMD` contro `ENTRYPOINT`.**

«Ho un’immagine che esegue uno strumento da riga di comando con molte opzioni. Spiegami, con esempi di `docker run`, come dovrei combinare `ENTRYPOINT` e `CMD` perché l’utente possa passare opzioni senza riscrivere il comando base, e come potrebbe comunque sovrascrivere l’*entrypoint* se necessario.»


## Capitolo 5 — Ciclo di vita del container

**Prompt 1 — Diagnosi di un’uscita.**

«Il mio container esce con codice 137 dopo circa dieci secondi da `docker stop`. Il Dockerfile ha `CMD npm start`. Spiega cosa succede e come correggerlo, mostrando il Dockerfile corretto e come verificare che il segnale arrivi all’applicazione Node.»

**Prompt 2 — Dimensionamento.**

«Un servizio Python usa in media 180 MB di memoria con picchi a 300 MB, e occupa il 40% di una CPU con picchi al 120%. Proponi valori per `--memory`, `--memory-swap`, `--cpus` motivando i margini, e indica come misurare se i limiti sono troppo stretti.»

**Prompt 3 — Scrittura di un healthcheck.**

«Scrivi un’istruzione `HEALTHCHECK` per un’immagine PostgreSQL che verifichi non solo che il processo sia vivo ma che accetti connessioni, usando gli strumenti presenti nell’immagine ufficiale. Motiva i valori di intervallo, *timeout*, *start-period* e tentativi per un *database* che impiega fino a trenta secondi ad avviarsi.»


## Capitolo 6 — Volumi e persistenza

**Prompt 1 — Scelta del meccanismo.**

«Per ciascuno di questi casi indica se usare un volume, un *bind mount* o tmpfs, e perché: i dati di un *database* PostgreSQL in produzione; il codice sorgente durante lo sviluppo; un file di configurazione Nginx; una chiave privata usata all’avvio e poi non più; la *cache* di un compilatore tra una costruzione e l’altra.»

**Prompt 2 — Diagnosi dei permessi.**

«Monto la directory corrente in un container Node.js con `-v $(pwd):/app`. I file creati da `npm install` nel container appartengono a `root` sull’*host* e non posso cancellarli. Spiega il meccanismo e proponi tre soluzioni, dalla più semplice alla più corretta.»

**Prompt 3 — Script di backup.**

«Scrivi uno *script* Bash che salva tutti i volumi Docker con nome in archivi `.tgz` datati in una directory `backup/`, usando container temporanei Alpine, e uno *script* simmetrico di ripristino. Gli *script* devono fallire in modo esplicito se un volume non esiste.»


## Capitolo 7 — Le reti di Docker

**Prompt 1 — Progettazione della topologia.**

«Ho un’applicazione con: un *reverse proxy* Nginx esposto su 443, un’API Python, un *worker* che consuma una coda, Redis come coda, PostgreSQL. Progetta le reti Docker in modo che PostgreSQL sia raggiungibile solo dall’API e dal *worker*, Redis solo dall’API e dal *worker*, e Nginx solo dall’API. Indica i comandi `docker network` e le opzioni `--network` per ciascun container.»

**Prompt 2 — Diagnosi di connettività.**

«Il container `web` non raggiunge il container `db`: `connection refused` su `db:5432`. Entrambi sono sulla rete `app-net`. Dammi una sequenza di comandi di diagnosi, dal più probabile al meno probabile, spiegando cosa mi dice ciascun risultato.»

**Prompt 3 — Regole di firewall.**

«Spiega perché `ufw deny 5432` non blocca l’accesso a un PostgreSQL pubblicato con `-p 5432:5432`, e scrivi le regole per la catena `DOCKER-USER` di `iptables` che permettono l’accesso solo dalla sottorete `10.0.0.0/8`.»


## Capitolo 8 — Immagini ottimizzate: multi-stage, cache, BuildKit

**Prompt 1 — Conversione a multi-stage.**

«Ti incollo un Dockerfile per un’applicazione Rust che produce un’immagine da 2 GB. Convertilo in *multi-stage* con l’immagine finale più piccola possibile, mantenendo la *cache* delle dipendenze di Cargo tra le costruzioni con un *cache mount*. Spiega ogni scelta.»

**Prompt 2 — Analisi di `dive`.**

«Ti riporto l’output di `dive` per un’immagine Python. Lo strato 4 aggiunge 300 MB, lo strato 6 ne cancella 280. Spiega perché l’immagine è comunque da 500 MB e riscrivi le istruzioni corrispondenti per evitare lo spreco.»

**Prompt 3 — Scelta della base.**

«Devo scegliere l’immagine di base per un’API Python con `numpy` e `pandas`, in un’azienda che richiede immagini senza vulnerabilità critiche note. Confronta `python:3.12-slim`, `python:3.12-alpine`, `gcr.io/distroless/python3-debian12` e `cgr.dev/chainguard/python`, considerando dimensione, compatibilità dei pacchetti, facilità di diagnosi e frequenza degli aggiornamenti di sicurezza.»


## Capitolo 9 — Docker Compose

**Prompt 1 — Generazione di un file Compose.**

«Scrivi un `compose.yaml` per: un’applicazione Django costruita da Dockerfile locale, PostgreSQL 16 con volume con nome e *healthcheck*, Redis 7 per la *cache*, e un *worker* Celery che usa la stessa immagine di Django con comando diverso. Django deve partire solo quando PostgreSQL e Redis sono sani. Le credenziali vanno in `.env`. Aggiungi un file `compose.override.yaml` per lo sviluppo con *bind mount* del codice.»

**Prompt 2 — Traduzione da comandi.**

«Ti do una serie di comandi `docker network create`, `docker volume create` e `docker run` che avviano un’applicazione. Convertili in un `compose.yaml` equivalente, segnalando le opzioni che non hanno un corrispettivo diretto.»

**Prompt 3 — Revisione.**

«Ti incollo un `compose.yaml`. Segnala: dipendenze senza condizione di salute, volumi anonimi che perderanno dati, porte esposte al mondo che dovrebbero essere interne, valori YAML ambigui, chiavi deprecate.»


## Capitolo 10 — Sicurezza dei container

**Prompt 1 — Hardening di un comando.**

«Ti do un `docker run` per un’API Node.js. Riscrivilo applicando: utente non privilegiato, *filesystem* in sola lettura con le eccezioni necessarie per Node, rimozione di tutte le *capability*, `no-new-privileges`, limiti di memoria e PID. Spiega per ciascuna opzione cosa succederebbe se l’applicazione la violasse.»

**Prompt 2 — Interpretazione di una scansione.**

«Ti incollo l’output di Trivy per la mia immagine. Raggruppa le vulnerabilità per pacchetto, indica quali si risolvono aggiornando l’immagine di base e quali richiedono di aggiornare le dipendenze dell’applicazione, e stima se qualcuna è sfruttabile per un’API HTTP che non esegue codice dell’utente.»

**Prompt 3 — Revisione di un file Compose.**

«Analizza questo `compose.yaml` dal punto di vista della sicurezza: *socket* montati, container privilegiati, porte esposte su tutte le interfacce, segreti in chiaro, immagini senza etichetta, servizi come `root`. Per ciascun problema indica la gravità e la correzione.»


## Capitolo 11 — Registry, distribuzione e firma delle immagini

**Prompt 1 — Scelta del registro.**

«Un’azienda ha il codice su GitHub, i cluster su AWS (EKS) e un requisito di continuità che impone di poter distribuire anche se GitHub è irraggiungibile. Proponi una strategia per i registri: dove pubblicare, come replicare, quali credenziali per la CI e per i nodi EKS, e come gestire la conservazione.»

**Prompt 2 — Politica di conservazione.**

«Scrivi una politica di conservazione per un registro che riceve circa 50 *push* al giorno con etichette `sha-*`, `main`, e occasionali `v1.2.3`. Requisiti: mai eliminare le versioni semantiche, conservare 30 giorni di `sha-*`, mantenere spazio sotto 200 GB. Esprimi la politica in linguaggio naturale e poi nel formato di Harbor.»

**Prompt 3 — Pipeline di firma.**

«Descrivi, passo per passo, come integrare cosign in modalità *keyless* in una GitHub Action che costruisce e pubblica su `ghcr.io`, e come verificare in Kubernetes che solo immagini firmate da quel *workflow* possano essere eseguite.»


## Capitolo 12 — Docker in sviluppo e in CI

**Prompt 1 — Configurazione di sviluppo.**

«Ho un’applicazione FastAPI con PostgreSQL. Scrivi `Dockerfile` (*multi-stage* con stadi `dev` e `prod`), `compose.yaml` e `compose.override.yaml` in modo che in sviluppo il codice sia sincronizzato con `watch`, i test girino con `docker compose run`, e in produzione l’immagine sia minima e non privilegiata.»

**Prompt 2 — Pipeline.**

«Scrivi un *workflow* GitHub Actions che: costruisce l’immagine con *cache*, esegue i test dentro il container con il *database* come servizio Compose, esegue Trivy e fallisce sulle vulnerabilità critiche, pubblica su `ghcr.io` con etichette da `metadata-action` solo sul ramo `main` e sui *tag* `v*`, e firma con cosign in modalità *keyless*.»

**Prompt 3 — Diagnosi di CI lenta.**

«Il mio *pipeline* Docker impiega 12 minuti. Ti incollo il *workflow* e il Dockerfile. Individua le cause probabili (mancanza di *cache*, ordine delle istruzioni, contesto grande, costruzioni ripetute) e stima il guadagno di ogni correzione.»


## Capitolo 13 — Perché un orchestratore: architettura di Kubernetes

**Prompt 1 — Mappa concettuale.**

«Spiegami il ciclo di riconciliazione di Kubernetes con un esempio concreto: cosa succede, componente per componente, dal momento in cui invio un Deployment con tre repliche al momento in cui i tre *pod* girano. Poi cosa succede se un nodo si spegne.»

**Prompt 2 — Traduzione concettuale.**

«Ti do un `compose.yaml` con quattro servizi. Per ciascun servizio e ciascuna chiave, indica l’oggetto o il campo Kubernetes corrispondente, e segnala esplicitamente cosa non ha un equivalente diretto e come si affronta.»

**Prompt 3 — Valutazione di adozione.**

«Un’azienda ha sei applicazioni *web* su tre *server* gestiti con Compose e SSH, un team di quattro persone, e requisiti di disponibilità del 99,5%. Argomenta se e quando conviene passare a Kubernetes, quali costi nascosti considerare (competenze, operatività, tempo) e quale distribuzione sarebbe ragionevole.»


## Capitolo 14 — Un cluster locale con kind e kubectl

**Prompt 1 — Configurazione di kind.**

«Scrivi una configurazione di kind con un *control plane* e tre *worker*, in cui i *worker* abbiano etichette diverse per simulare tre zone di disponibilità, e con le porte 80 e 443 del *control plane* pubblicate sull’*host* per un Ingress controller. Spiega ogni campo.»

**Prompt 2 — Interpretazione di `describe`.**

«Ti incollo l’output di `kubectl describe pod` di un *pod* che non parte. Leggi la sezione Events, identifica la causa, e dimmi cosa correggere nel manifest.»

**Prompt 3 — Estrazione con jsonpath.**

«Scrivi il comando `kubectl get pods -A -o jsonpath` (o `custom-columns`) che elenca, per ogni *pod* del cluster, *namespace*, nome, nodo e immagine di ogni container, in forma tabellare.»


## Capitolo 15 — Pod e ciclo di vita

**Prompt 1 — Diagnosi.**

«Un *pod* è in `CrashLoopBackOff`. `kubectl logs` è vuoto, `--previous` mostra solo `standard_init_linux.go: exec user process caused: no such file or directory`. Il Dockerfile usa `FROM alpine` e copia un binario Go compilato sul mio Mac. Cosa sta succedendo e come lo risolvo?»

**Prompt 2 — Sidecar.**

«Progetta un *pod* con un container applicativo che scrive *log* in `/var/log/app/*.log` e un *sidecar* che li invia a un servizio esterno via HTTP. Usa il *sidecar* nativo della 1.29+, spiega perché è preferibile a un secondo container ordinario, e scrivi il manifest.»

**Prompt 3 — Terminazione.**

«Spiega, con una linea temporale in secondi, cosa succede quando elimino un *pod* con `terminationGracePeriodSeconds: 20`, un `preStop` che dorme 5 secondi e un’applicazione che impiega 10 secondi a chiudere le connessioni dopo `SIGTERM`. Le richieste in corso vengono perse? E se l’applicazione impiegasse 25 secondi?»


## Capitolo 16 — ReplicaSet e Deployment

**Prompt 1 — Generazione.**

«Scrivi un Deployment per un’API Node.js su porta 3000, con tre repliche, *rolling update* senza riduzione di capacità, *readiness probe* su `/health`, etichette raccomandate `app.kubernetes.io/*`, e immagine da `ghcr.io/acme/api:1.4.2`. Commenta i campi non ovvi.»

**Prompt 2 — Scenario di aggiornamento.**

«Ho un Deployment con 6 repliche, `maxSurge: 2`, `maxUnavailable: 1`, `minReadySeconds: 10` e una *readiness probe* che impiega 15 secondi a passare. Descrivi passo per passo quanti *pod* vecchi e nuovi esistono in ogni fase e stima la durata totale del *rolling update*.»

**Prompt 3 — Diagnosi.**

«`kubectl rollout status` è fermo da dieci minuti su "1 out of 3 new replicas have been updated". Elenca le cause possibili in ordine di probabilità, con il comando per verificare ciascuna, e spiega cosa fa `progressDeadlineSeconds`.»


## Capitolo 17 — Service e scoperta dei servizi

**Prompt 1 — Scelta del tipo.**

«Per ciascuno di questi casi indica il tipo di Service e le opzioni: un’API interna chiamata da altri *pod*; un *database* PostgreSQL in cluster; un servizio TCP proprietario da esporre a Internet su AWS; un’applicazione *web* pubblica con tre nomi di dominio; un *database* esterno gestito il cui indirizzo cambia trimestralmente.»

**Prompt 2 — Diagnosi.**

«`curl http://api` da un *pod* nello stesso *namespace* dà `Connection refused`. `nslookup api` risolve. Dammi la sequenza di verifiche (Service, *endpoint*, etichette, porte, *readiness*, NetworkPolicy) con i comandi e cosa concludere da ogni risultato.»

**Prompt 3 — kube-proxy.**

«Spiega come `kube-proxy` in modalità `iptables` realizza un Service ClusterIP con tre *endpoint*: quali catene crea, come ottiene la distribuzione uniforme, e perché il bilanciamento è per connessione. Poi confronta con la modalità IPVS.»


## Capitolo 18 — ConfigMap e Secret

**Prompt 1 — Strategia dei segreti.**

«Un team di cinque persone distribuisce su un cluster EKS con Argo CD. I segreti sono in AWS Secrets Manager. Proponi l’architettura per portarli nei *pod*: External Secrets Operator o Secrets Store CSI Driver? Con quali permessi IAM, come si gestisce la rotazione, e come si evita che un segreto compaia in Git.»

**Prompt 2 — Manifest.**

«Scrivi ConfigMap, Secret e Deployment per un’applicazione che legge `DATABASE_URL` (contiene la *password*), `LOG_LEVEL`, e un file `config.yaml` in `/app/config/`. Il file deve aggiornarsi a caldo; `LOG_LEVEL` può richiedere riavvio. Aggiungi il pattern per far sì che un cambio del ConfigMap scateni il *rolling update*.»

**Prompt 3 — Revisione di sicurezza.**

«Ti incollo un insieme di manifest. Segnala ogni credenziale in chiaro in ConfigMap, variabili `env` con valori sensibili letterali, Secret con `data` in Base64 di valori riconoscibili, e assenza di `imagePullSecrets` per immagini su registri privati.»


## Capitolo 19 — Storage: volumi, PersistentVolume e StorageClass

**Prompt 1 — Scelta dello storage.**

«Per ciascuno di questi casi indica tipo di volume, modalità di accesso, StorageClass consigliata su AWS e `reclaimPolicy`: *cache* di compilazione di un Job; dati di PostgreSQL; file caricati dagli utenti in un’applicazione con 4 repliche; modello di apprendimento automatico da 20 GB letto da 10 *pod*; *log* temporanei di un *sidecar*.»

**Prompt 2 — Recupero.**

«Ho eliminato per errore un PVC il cui PV aveva `reclaimPolicy: Retain`. Il PV è in stato `Released`. Descrivi passo per passo come ricollegarlo a un nuovo PVC senza perdere i dati, con i comandi `kubectl`.»

**Prompt 3 — Migrazione.**

«Devo spostare i dati di un PVC da una StorageClass `gp2` a una `gp3`, per un Deployment con una sola replica, con la minima interruzione. Proponi una procedura con *snapshot* CSI e una alternativa con un Job di copia, e confronta rischi e tempi.»


## Capitolo 20 — Ingress e Gateway API

**Prompt 1 — Ingress completo.**

«Scrivi un Ingress per `ingress-nginx` con tre *host* (`www`, `api`, `admin` sotto `example.com`), TLS via cert-manager con un ClusterIssuer Let’s Encrypt, redirezione forzata a HTTPS, e per `admin` un’autenticazione *basic* da un Secret e una lista di IP consentiti. Indica quali annotazioni sono specifiche di `ingress-nginx`.»

**Prompt 2 — Migrazione a Gateway API.**

«Converti questo Ingress con annotazioni `ingress-nginx` (riscrittura, *canary* al 20%, *timeout* di 60 s) in Gateway più HTTPRoute. Segnala ciò che ha un equivalente standard, ciò che richiede una *policy* specifica dell’implementazione, e ciò che non è ancora esprimibile.»

**Prompt 3 — Diagnosi.**

«`curl https://app.example.com` restituisce 503 dal *controller* Nginx. Il Service ha *endpoint*, il *pod* risponde con `port-forward`. Elenca le cause possibili (percorso, `pathType`, porta del Service, *namespace*, classe, *readiness*) con il comando per verificare ciascuna, e spiega come leggere i *log* del *controller*.»


## Capitolo 21 — Namespace, etichette, selettori e organizzazione

**Prompt 1 — Progettazione dei namespace.**

«Un’azienda ha 3 squadre, 12 microservizi, 3 ambienti, e requisiti di isolamento dei costi per squadra. Proponi uno schema di *namespace*, le etichette a livello di *namespace*, le ResourceQuota per ambiente, e spiega come i *namespace* si mappano su RBAC e NetworkPolicy.»

**Prompt 2 — Schema di etichette.**

«Definisci uno schema di etichette e annotazioni per tutti gli oggetti di un cluster, usando le chiavi `app.kubernetes.io/*` più chiavi aziendali `acme.com/*` per squadra, centro di costo e livello di criticità. Per ogni chiave indica se è un’etichetta o un’annotazione, e perché.»

**Prompt 3 — Pulizia.**

«Scrivi una sequenza di comandi `kubectl` con selettori per: trovare tutti i *pod* non in `Running` fuori da `kube-system`; trovare i Deployment senza l’etichetta `app.kubernetes.io/managed-by`; contare i *pod* per *namespace*; elencare i PVC non montati da alcun *pod*.»


## Capitolo 22 — StatefulSet, DaemonSet, Job e CronJob

**Prompt 1 — StatefulSet reale.**

«Scrivi uno StatefulSet per PostgreSQL 16 con una sola replica, PVC da 10 GiB, `securityContext` con `fsGroup` corretto per l’immagine ufficiale, *password* da Secret, *readiness probe* con `pg_isready`, e un Service *headless* più un Service normale per i client. Spiega perché per più repliche servirebbe un *operator* e quali sono le opzioni (CloudNativePG, Zalando, Crunchy).»

**Prompt 2 — Job indicizzato.**

«Devo elaborare 1000 file in un *bucket* S3 con 10 *pod* in parallelo. Scrivi un Job con `completionMode: Indexed` in cui ogni *pod* elabora i file il cui numero modulo 10 è uguale al proprio indice, con gestione dei fallimenti tramite `podFailurePolicy` che non ritenta sui codici di uscita 2 e 3.»

**Prompt 3 — Migrazioni.**

«Confronta tre modi per eseguire le migrazioni di schema prima di un rilascio su Kubernetes: un Job creato dalla CI, un *init container* nel Deployment, un *hook* Helm `pre-upgrade`. Per ciascuno: cosa succede con più repliche, cosa succede se la migrazione fallisce, come si torna indietro.»


## Capitolo 23 — Probe, risorse e qualità del servizio

**Prompt 1 — Endpoint di salute.**

«Aggiungi all’applicazione Flask guida due *endpoint*: `/healthz`, che risponde 200 senza dipendenze, e `/readyz`, che risponde 200 solo se Redis risponde a `PING` entro 500 ms. Poi scrivi le tre *probe* del Deployment con parametri motivati per un’applicazione che parte in 3 s.»

**Prompt 2 — Dimensionamento.**

«Ti do 7 giorni di metriche di un *pod*: CPU media 0,15 core, p99 0,6, memoria media 210 MiB, massimo 340 MiB. Proponi `requests` e `limits` per tre scenari: servizio critico rivolto agli utenti, *worker* in *background*, ambiente di collaudo con costi da minimizzare. Spiega la classe QoS risultante.»

**Prompt 3 — Incidente.**

«Alle 14:02 il *database* ha avuto 30 secondi di indisponibilità. Alle 14:03 tutti i 12 *pod* dell’API sono stati riavviati e il servizio è rimasto giù 4 minuti. La *liveness* è `httpGet /health` che verifica la connessione al *database*, `periodSeconds: 5`, `failureThreshold: 3`. Ricostruisci la sequenza e proponi la configurazione corretta.»


## Capitolo 24 — Scheduling: affinità, taint, tolleranze e priorità

**Prompt 1 — Progettazione.**

«Un cluster ha 6 nodi in 3 zone; 2 nodi hanno GPU. Devo distribuire: un’API con 6 repliche resistente alla perdita di una zona; un servizio di inferenza che richiede GPU e non deve condividere il nodo con altri *pod* dell’utente; un Job di *batch* che può essere interrotto. Scrivi le sezioni `affinity`, `topologySpreadConstraints`, `tolerations`, `priorityClassName` di ciascuno e i comandi per *taint* ed etichette sui nodi.»

**Prompt 2 — Diagnosi di `Pending`.**

«Ti incollo `kubectl describe pod` di un *pod* `Pending` con l’evento `0/6 nodes are available: 2 node(s) had untolerated taint {gpu: true}, 3 node(s) didn't match pod anti-affinity rules, 1 Insufficient cpu`. Spiega cosa blocca ciascun gruppo di nodi e proponi tre modifiche alternative per sbloccarlo.»

**Prompt 3 — Confronto.**

«Confronta `podAntiAffinity` obbligatoria per `hostname` e `topologySpreadConstraints` con `maxSkew: 1` per `hostname` e `DoNotSchedule`: comportamento con 3 nodi e 3, 4, 6 repliche, durante un *rolling update* con `maxSurge: 1`, e quando un nodo viene rimosso.»


## Capitolo 25 — RBAC, ServiceAccount e sicurezza del cluster

**Prompt 1 — Modello di permessi.**

«Progetta RBAC per un cluster con: amministratori di piattaforma, tre squadre di sviluppo ciascuna con i propri *namespace* per ambiente, una squadra di sicurezza in sola lettura ovunque inclusi i Secret, e un sistema di CI che deve solo aggiornare le immagini dei Deployment. Scrivi i ClusterRole e i *binding*, indicando cosa è per *namespace* e cosa per cluster.»

**Prompt 2 — Audit.**

«Scrivi una sequenza di comandi `kubectl` (con `auth can-i`, `get rolebindings`, `get clusterrolebindings` e `jsonpath`) per elencare tutti i soggetti con `cluster-admin`, tutti quelli che possono leggere Secret in `produzione`, e tutti i ServiceAccount con un ClusterRoleBinding.»

**Prompt 3 — Conformità.**

«Ti incollo un Deployment. Elenca ogni modifica necessaria perché passi il profilo Pod Security `restricted`, e indica per ciascuna se richiede un cambiamento nell’immagine o solo nel manifest.»


## Capitolo 26 — NetworkPolicy e rete del cluster

**Prompt 1 — Insieme di policy.**

«Un *namespace* ha: `frontend` (riceve dall’Ingress), `api` (riceve da `frontend`, chiama `postgres` e un’API esterna su `api.stripe.com:443`), `postgres`, `worker` (chiama `postgres` e `redis`), `redis`. Scrivi le NetworkPolicy per un modello *zero trust* con negazione predefinita in ingresso e uscita, incluso il DNS, e indica cosa non è esprimibile senza estensioni del CNI.»

**Prompt 2 — Diagnosi.**

«Dopo aver applicato una *policy* di *egress* su `api`, `api` non raggiunge più `postgres.database.svc` in un altro *namespace*, ma raggiunge Redis nello stesso *namespace*. Ti incollo la *policy*. Spiega l’errore e correggi.»

**Prompt 3 — Confronto.**

«Confronta NetworkPolicy, CiliumNetworkPolicy e le AuthorizationPolicy di Istio per il requisito "solo il servizio `pagamenti` può chiamare `POST /addebiti` sul servizio `ledger`": cosa ciascuna può esprimere, a quale livello, con quali garanzie di identità.»


## Capitolo 27 — Autoscaling: HPA, VPA e Cluster Autoscaler

**Prompt 1 — Politica di scaling.**

«Un’API ha un carico che sale del 300% in 2 minuti alle 9:00 nei giorni feriali e scende gradualmente dalle 18:00. La latenza p99 deve restare sotto 200 ms. Proponi HPA (metriche, obiettivi, `behavior`), l’eventuale uso di KEDA con un *trigger* `cron`, e il margine di nodi necessario dati 90 s di avvio nodo.»

**Prompt 2 — Diagnosi.**

«L’HPA mostra `<unknown>/70%` da un’ora. Ti incollo `kubectl describe hpa` e il Deployment. Trova la causa tra: `requests` assenti, *metrics server* assente, nome del container errato, metrica personalizzata senza *adapter*.»

**Prompt 3 — Costi.**

«Confronta Cluster Autoscaler e Karpenter su EKS per un cluster con carico variabile tra 20 e 200 *pod* eterogenei: velocità di *scale-up*, efficienza di *bin packing*, gestione delle istanze *spot*, complessità di configurazione. Stima l’ordine di grandezza del risparmio.»


## Capitolo 28 — Osservabilità: log, metriche, tracce

**Prompt 1 — Strumentazione.**

«Aggiungi all’API Express `api-note` del capitolo 8 la strumentazione Prometheus con `prom-client`: contatore per stato e percorso normalizzato, istogramma di latenza con *bucket* adatti a un’API che risponde in 5–500 ms, *gauge* delle note in memoria. Poi scrivi le tre query PromQL per traffico, tasso di errore e p95.»

**Prompt 2 — Allarmi.**

«Progetta cinque PrometheusRule per l’applicazione guida e il suo Redis, basate sui sintomi (disponibilità, latenza, errori, saturazione di Redis, *pod* in riavvio), con soglie e durate motivate e un’annotazione `runbook_url`. Spiega perché non includi un allarme sulla CPU.»

**Prompt 3 — Architettura.**

«Confronta la stack Grafana autogestita (Loki, Prometheus, Tempo) e Datadog per un cluster di 30 nodi con 200 *pod*: costi (stima), sforzo operativo, funzionalità di correlazione, e requisiti sulle applicazioni. Indica il volume di *log* oltre il quale una scelta prevale.»


## Capitolo 29 — Helm

**Prompt 1 — Creazione.**

«Scrivi un *chart* Helm per l’API `api-note` del capitolo 8 con: Deployment con *probe* e risorse parametrizzate, Service, Ingress opzionale con TLS opzionale, HPA opzionale (e `replicas` omesso quando abilitato), ServiceAccount con `automountServiceAccountToken` configurabile, PodDisruptionBudget opzionale, e un test `helm test` che chiama `/note`. Usa gli *helper* raccomandati per nomi ed etichette.»

**Prompt 2 — Revisione.**

«Ti incollo i *template* di un *chart*. Segnala: valori non parametrizzati che dovrebbero esserlo, `nindent` errati, etichette del selettore che includono valori mobili, assenza di `resources`, chiavi di `values.yaml` non documentate, e proponi uno schema `values.schema.json` per validare i valori.»

**Prompt 3 — Migrazione.**

«Ho quindici manifest YAML per un’applicazione in tre ambienti, oggi duplicati in tre directory. Descrivi il procedimento per convertirli in un *chart* con tre file di valori, quali differenze tra ambienti diventano valori e quali restano *template* condizionali, e come verificare che `helm template` produca esattamente i manifest attuali.»


## Capitolo 30 — Kustomize e gestione degli ambienti

**Prompt 1 — Struttura.**

«Progetta una struttura Kustomize per 4 microservizi in 3 ambienti con: base per servizio, overlay per ambiente, componenti opzionali per monitoraggio e NetworkPolicy, generatori di ConfigMap per ambiente. Mostra l’albero delle directory e il contenuto di una kustomization per livello.»

**Prompt 2 — Patch.**

«Scrivi le *patch* Kustomize (indicando se strategic merge o JSON) per: aggiungere un argomento a `args` del container `web`; rimuovere una variabile d’ambiente per nome; cambiare il `topologyKey` della prima regola di anti-affinità; aggiungere un *sidecar*. Spiega per ciascuna perché quel tipo di *patch*.»

**Prompt 3 — Helm dentro Kustomize.**

«Voglio installare il *chart* `bitnami/redis` con Kustomize, con valori per ambiente, e aggiungere una NetworkPolicy e un ServiceMonitor che il *chart* non genera. Scrivi la kustomization con `helmCharts`, gli overlay, e il comando per verificare il risultato.»


## Capitolo 31 — CI/CD e GitOps con Argo CD

**Prompt 1 — Progettazione.**

«Progetta il flusso GitOps per 3 squadre, 12 applicazioni, 3 ambienti e 2 cluster (uno per sviluppo e collaudo, uno per produzione): struttura dei repository, ApplicationSet con generatori, Project di Argo CD con permessi, gestione dei segreti con External Secrets Operator, e il percorso di una modifica dal *commit* alla produzione con i punti di approvazione.»

**Prompt 2 — Diagnosi.**

«Un’Application resta `OutOfSync` con `selfHeal` attivo e nella *diff* vedo solo `metadata.annotations` e `status`. Spiega perché Argo CD e il cluster non convergono, quali campi vanno ignorati con `ignoreDifferences` e come si configura.»

**Prompt 3 — Rollout progressivo.**

«Scrivi un `Rollout` e un `AnalysisTemplate` per l’applicazione guida che aumenti il traffico alla nuova versione del 10% ogni 2 minuti fino al 100%, annullando se il tasso di errori 5xx (da Prometheus) supera il 2% o la latenza p99 supera 300 ms, con integrazione all’Ingress `nginx` per la suddivisione.»


## Capitolo 32 — Estendere Kubernetes: CRD, operator e admission

**Prompt 1 — CRD.**

«Progetta un CRD `Ambiente` (namespaced) che descriva un ambiente di collaudo temporaneo: ramo Git, durata massima, dimensione (`piccolo`/`medio`/`grande`), con schema OpenAPI completo, validazioni CEL (durata ≤ 7 giorni), colonne di stampa e sottorisorsa `status` con fase e URL. Poi descrivi cosa farebbe l’*operator* corrispondente.»

**Prompt 2 — Operator con Kopf.**

«Riscrivi il *controller* `Backup` del capitolo con Kopf: gestori per creazione, aggiornamento e cancellazione, un *timer* per `pianificazione`, aggiornamento dello `status` al completamento del Job osservando il Job stesso, e ritentativo con *backoff* sugli errori transitori. Includi Dockerfile, RBAC e Deployment.»

**Prompt 3 — Policy.**

«Scrivi in tre forme equivalenti — ValidatingAdmissionPolicy con CEL, Kyverno, Gatekeeper con Rego — la regola "ogni Deployment in produzione deve avere l’etichetta `squadra`, almeno 2 repliche, e un PodDisruptionBudget con lo stesso selettore". Segnala cosa una delle tre non sa esprimere.»


## Capitolo 33 — Kubernetes gestito: EKS, GKE, AKS e alternative

**Prompt 1 — Confronto.**

«Confronta EKS, GKE Autopilot e AKS per un’azienda europea con 5 applicazioni, requisiti GDPR, un team di 3 persone senza esperienza operativa Kubernetes, e un *budget* di 2000 €/mese: costo stimato, sforzo operativo, conformità, ecosistema. Poi confronta con DigitalOcean Kubernetes per lo stesso caso.»

**Prompt 2 — Piano di migrazione.**

«Ho un’applicazione con Compose su un VPS (API, *worker*, PostgreSQL, Redis, Nginx). Scrivi il piano per migrarla su un cluster gestito: cosa diventa Deployment, StatefulSet o servizio gestito esterno (per PostgreSQL: *operator* nel cluster o RDS/Cloud SQL?), come si migrano i dati, come si gestisce il DNS per il *cutover*, e come si torna indietro.»

**Prompt 3 — Costi.**

«Un cluster EKS ha 12 nodi m6i.xlarge in tre zone al 35% di uso medio di CPU e 60% di memoria, 8 Service LoadBalancer, 2 TB/mese di traffico tra zone. Proponi cinque interventi per ridurre i costi, stimando il risparmio di ciascuno e il rischio.»


## Capitolo 34 — Progetto finale: dal Dockerfile al cluster

**Prompt 1 — Revisione dell’architettura.**

«Ti descrivo l’architettura del progetto finale [incollare il riassunto]. Fai una revisione critica: punti singoli di guasto, scelte discutibili, cosa manca per un requisito di disponibilità del 99,9%, cosa è sovradimensionato per una squadra di tre persone.»

**Prompt 2 — Runbook.**

«Scrivi il *runbook* per l’allarme `ContatoreErrori5xx`: verifiche in ordine (Redis, *pod*, Ingress, rilascio recente), comandi esatti, criteri per il *rollback* con Argo CD, e cosa scrivere nel *post-mortem*.»

**Prompt 3 — Piano di adozione.**

«Data l’architettura completa, proponi un piano in quattro fasi trimestrali per arrivarci partendo da Compose su un VPS, con i criteri di uscita di ogni fase e le competenze da acquisire.»
