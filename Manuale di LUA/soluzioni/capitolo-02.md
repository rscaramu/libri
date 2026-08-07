# Capitolo 2 — Installare Lua e usare l’interprete

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 1](capitolo-01.md) · [Indice](README.md) · [Capitolo 3 →](capitolo-03.md)

I 3 sorgenti eseguibili di questo capitolo sono in
[`codice/cap02/`](../codice/cap02/).

---

**ES 2.4 — Verificare l’installazione**

*Installa Lua sul tuo sistema con il metodo che preferisci, poi
verifica l’installazione stampando la versione del linguaggio, i
percorsi di ricerca dei moduli e la data corrente. Scrivi i tre
comandi esatti che hai usato.*

I tre comandi:

```lua
print(_VERSION)
print(package.path)
print(os.date("%Y-%m-%d %H:%M:%S"))
```

Oppure dalla riga di comando, in un colpo solo:

```text
lua -e 'print(_VERSION); print(package.path);
        print(os.date())'
```

Ricordate la distinzione: `_VERSION` è la versione del **linguaggio**,
`lua -v` quella della **release**. Su un sistema Debian potreste avere
`_VERSION` che dice `Lua 5.4` e `lua -v` che dice `Lua 5.4.6`.

**ES 2.5 — Tutti gli indici di `arg`**

*Scrivi un programma che stampi tutti gli elementi della tabella
`arg`, compresi quelli con indice zero e negativo. Esegui il
programma con l’opzione `-i` dell’interprete e con almeno due
argomenti, e spiega che cosa contiene ciascun indice.*

```lua
local minimo, massimo = 0, 0
for k in pairs(arg) do
  if k < minimo then minimo = k end
  if k > massimo then massimo = k end
end

for i = minimo, massimo do
  print(string.format("arg[%2d] = %s", i,
    tostring(arg[i])))
end
```

Eseguendo `lua -i prova.lua uno due` si ottiene qualcosa come:

```text
arg[-2] = lua
arg[-1] = -i
arg[ 0] = prova.lua
arg[ 1] = uno
arg[ 2] = due
```

Gli indici negativi contengono l’interprete e le sue opzioni, l’indice
zero il nome dello script, gli indici positivi gli argomenti veri. Notate
che il ciclo deve partire dal minimo trovato e non da un valore fisso,
perché il numero di opzioni varia.

L’uso di `pairs` e non di `ipairs` è obbligato: `ipairs` si fermerebbe al
primo indice mancante e non vedrebbe mai gli indici negativi né lo zero.

**ES 2.6 — `luac -p` contro `lua`**

*Crea un file Lua con un errore di sintassi volontario alla decima
riga. Verificalo con `luac -p` e confronta il messaggio di errore
con quello che ottieni eseguendolo con `lua`. Le due segnalazioni
sono identiche? In quale situazione pratica preferiresti l’una
all’altra?*

I due messaggi sono **identici** nella sostanza: entrambi riportano il
nome del file, il numero di riga e la descrizione dell’errore
sintattico, perché entrambi usano lo stesso analizzatore.

La differenza sta in che cosa accade dopo. `lua` compila **ed esegue**:
se il file ha un errore di sintassi non esegue nulla, ma se il file è
sintatticamente corretto e ha effetti collaterali — scrive file, invia
richieste, cancella dati — quegli effetti avvengono. `luac -p` si ferma
dopo la compilazione.

Le situazioni in cui si preferisce `luac -p`:

**Nella verifica automatica.** Un gancio di pre-commit che controlla la
sintassi di tutti i file modificati non deve eseguirli.

**Su script che modificano lo stato.** Verificare la sintassi di uno
script di migrazione eseguendolo sarebbe controproducente.

**Su file che richiedono un ambiente.** Uno script Neovim o LÖVE non gira
fuori dal suo ambiente: `lua` fallirebbe su `vim` o `love` inesistenti,
mascherando gli errori di sintassi veri.

**Per verificare più file rapidamente.** `luac -p src/*.lua` controlla
tutto in un comando.

**ES 2.7 — Compilare Lua dai sorgenti**

*Compila Lua dai sorgenti seguendo le istruzioni del paragrafo 2.4,
usando l’opzione `make local` per non toccare il sistema. Misura
quanto tempo impiega la compilazione e confrontalo con quello di un
altro linguaggio che conosci. Che cosa ti dice questa differenza sul
progetto di Lua?*

Sulla macchina su cui è stato preparato questo manuale, la compilazione
completa di Lua 5.4.8 richiede circa **dieci secondi**, comprendendo
l’interprete, il compilatore e la libreria.

Per confronto, un compilatore Rust o un interprete Python completo
richiedono decine di minuti; il kernel Linux ore.

Che cosa dice questa differenza sul progetto di Lua:

**Il codice è piccolo.** Trentamila righe di C comprese le
intestazioni e i commenti, che scendono a circa ventimila contando le
sole righe di codice, contro i milioni di progetti comparabili.

**Non ci sono dipendenze.** Nessuna libreria esterna, nessun sistema di
configurazione che sonda l’ambiente. Il `Makefile` ha poche decine di
righe.

**Il codice è portabile per costruzione.** C ANSI puro, senza estensioni
del compilatore: se avete un compilatore C conforme, Lua compila.

Queste tre proprietà sono la ragione per cui Lua gira su tutto, dai
supercomputer ai microcontrollori, e per cui incorporarlo in
un’applicazione è un’operazione di minuti e non di giorni. È il progetto
stesso a essere piccolo, non solo il linguaggio.

**ES 2.8 — I tre tipi di commento**

*Scrivi un file che dimostri i tre tipi di commento visti nel
capitolo — di riga, di blocco e il blocco disattivabile — e
predisponilo in modo che, cambiando un solo carattere, il programma
stampi un messaggio diverso. Aggiungi commenti che spieghino a un
lettore inesperto che cosa deve cambiare.*

```lua
-- Commento di riga: arriva a fine riga.

--[[
Commento di blocco: puo' contenere
piu' righe.
]]

-- Per cambiare messaggio, aggiungete o togliete
-- UN SOLO trattino all'inizio del blocco che segue:
-- tre trattini attivano il codice, due lo commentano.

---[[
print("VERSIONE A attiva")
--]]

--[[
print("VERSIONE B attiva")
--]]
```

Per invertire, si toglie un trattino dalla riga `---[[` del primo blocco
e se ne aggiunge uno alla riga `--[[` del secondo.

Il meccanismo funziona perché la riga di chiusura `--]]` è ambivalente:
se un blocco è aperto la chiude, se non lo è vale come commento di riga
ordinario. È questa simmetria a permettere di attivare e disattivare
cambiando un solo carattere.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
