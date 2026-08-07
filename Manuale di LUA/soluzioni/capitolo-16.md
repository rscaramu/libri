# Capitolo 16 — Moduli, require e organizzazione del codice

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 15](capitolo-15.md) · [Indice](README.md) · [Capitolo 17 →](capitolo-17.md)

I 6 sorgenti eseguibili di questo capitolo sono in
[`codice/cap16/`](../codice/cap16/).

---

**ES 16.4 — Modulo di utilità per le stringhe**

*Scrivi un modulo di utilità per le stringhe con le funzioni che Lua
non ha: divisione su separatore, rimozione degli spazi, verifica di
prefisso e suffisso, capitalizzazione. Esporta solo le funzioni
pubbliche e verifica dall’esterno che le ausiliarie interne non
siano raggiungibili.*

```lua
local M = {}

local function eSpazio(c)
  return c == " " or c == "\t" or c == "\n"
    or c == "\r" or c == "\v" or c == "\f"
end

local function proteggi(s)
  return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
end

function M.dividi(s, separatore, massimo)
  if type(s) ~= "string" then
    return nil, "primo argomento non e' una stringa"
  end
  separatore = separatore or ","
  if separatore == "" then
    return nil, "separatore vuoto"
  end

  local pezzi = {}
  local pattern = proteggi(separatore)
  local posizione = 1

  while true do
    if massimo and #pezzi >= massimo - 1 then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    local inizio, fine = s:find(pattern, posizione)
    if inizio == nil then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    pezzi[#pezzi + 1] = s:sub(posizione, inizio - 1)
    posizione = fine + 1
  end

  return pezzi
end

function M.taglia(s, dove)
  if type(s) ~= "string" then
    return nil, "atteso una stringa"
  end
  dove = dove or "entrambi"
  local a, b = 1, #s
  if dove ~= "destra" then
    while a <= b and eSpazio(s:sub(a, a)) do
      a = a + 1
    end
  end
  if dove ~= "sinistra" then
    while b >= a and eSpazio(s:sub(b, b)) do
      b = b - 1
    end
  end
  return s:sub(a, b)
end

function M.iniziaCon(s, prefisso)
  if #prefisso > #s then return false end
  return s:sub(1, #prefisso) == prefisso
end

function M.finisceCon(s, suffisso)
  if #suffisso == 0 then return true end
  if #suffisso > #s then return false end
  return s:sub(-#suffisso) == suffisso
end

function M.capitalizza(s)
  if s == "" then return s end
  return s:sub(1, 1):upper() .. s:sub(2):lower()
end

function M.titolo(s)
  local pezzi = {}
  for parola in s:gmatch("%S+") do
    pezzi[#pezzi + 1] = M.capitalizza(parola)
  end
  return table.concat(pezzi, " ")
end

function M.riempi(s, larghezza, carattere, aSinistra)
  carattere = carattere or " "
  local mancanti = larghezza - #s
  if mancanti <= 0 then return s end
  local riempimento = carattere:rep(mancanti)
  if aSinistra then return riempimento .. s end
  return s .. riempimento
end

return M
```

L’uso, con la verifica che le ausiliarie non siano raggiungibili:

```lua
package.preload["testo"] = function()
  -- qui andrebbe il modulo sopra
  return require("testo_reale")
end

local testo = require("testo")

print(table.concat(testo.dividi("a,b,c"), "|"))
print(table.concat(testo.dividi("a.b.c", "."), "|"))
print(table.concat(testo.dividi("a,b,c", ",", 2), "|"))
print("[" .. testo.taglia("  ciao  ") .. "]")
print("[" .. testo.taglia("  ciao  ", "sinistra") .. "]")
print(testo.iniziaCon("programmazione", "pro"))
print(testo.finisceCon("file.txt", ".txt"))
print(testo.titolo("mARIO rossi VERDI"))
print("[" .. testo.riempi("ab", 6, ".") .. "]")
print("[" .. testo.riempi("ab", 6, ".", true) .. "]")

print("eSpazio raggiungibile? "
  .. tostring(testo.eSpazio))
print("proteggi raggiungibile? "
  .. tostring(testo.proteggi))
```

Le due funzioni ausiliarie sono `local` e non compaiono nella tabella
restituita: `testo.eSpazio` e `testo.proteggi` valgono `nil`. Non c’è
alcun modo, dall’esterno, di raggiungerle o di sostituirle, il che
significa che possono essere modificate in una versione futura senza
rompere il codice altrui.

La protezione del separatore con `proteggi` è ciò che rende `dividi`
corretta su separatori come il punto: senza, `.` verrebbe interpretato
come pattern e dividerebbe a ogni carattere.

**ES 16.5 — Ispezionare l’ambiente dei moduli**

*Scrivi un programma che stampi `package.path`, `package.cpath` e
l’elenco completo delle chiavi di `package.loaded` all’avvio. Poi
carica un modulo tuo e stampa di nuovo l’elenco, evidenziando che
cosa è cambiato.*

```lua
local function elencaCaricati()
  local nomi = {}
  for nome in pairs(package.loaded) do
    nomi[#nomi + 1] = nome
  end
  table.sort(nomi)
  return nomi
end

local function insieme(elenco)
  local s = {}
  for _, v in ipairs(elenco) do s[v] = true end
  return s
end

print("=== package.path ===")
for percorso in package.path:gmatch("[^;]+") do
  print("  " .. percorso)
end

print()
print("=== package.cpath ===")
for percorso in package.cpath:gmatch("[^;]+") do
  print("  " .. percorso)
end

print()
print("=== moduli caricati all'avvio ===")
local prima = elencaCaricati()
for _, n in ipairs(prima) do print("  " .. n) end
print("  totale: " .. #prima)

package.preload["mio.modulo"] = function()
  return {versione = "1.0"}
end
package.preload["mio.altro"] = function()
  return {}
end

local m = require("mio.modulo")

print()
print("=== dopo require('mio.modulo') ===")
local dopo = elencaCaricati()
local eraPresente = insieme(prima)
for _, n in ipairs(dopo) do
  if not eraPresente[n] then
    print("  NUOVO: " .. n)
  end
end
print("  totale: " .. #dopo)

print()
print("mio.altro registrato in preload ma non caricato: "
  .. tostring(package.loaded["mio.altro"]))
print("package.preload ha mio.altro: "
  .. tostring(package.preload["mio.altro"] ~= nil))
print("cercatori registrati: " .. #package.searchers)
print("separatori (package.config, prima riga): "
  .. package.config:match("^[^\n]+"))
```

I moduli caricati all’avvio sono quelli della libreria standard, aperti
dall’interprete: `_G`, `coroutine`, `debug`, `io`, `math`, `os`,
`package`, `string`, `table`, `utf8`.

Dopo il `require`, `mio.modulo` compare in `package.loaded`, mentre
`mio.altro` no: registrare un caricatore in `package.preload` **non**
carica il modulo, lo rende soltanto disponibile.

`package.searchers` contiene quattro cercatori: quello di `preload`,
quello per i moduli Lua, quello per le librerie C, e quello per i
sottomoduli di librerie C già caricate.

`package.config` è una stringa multiriga il cui primo carattere è il
separatore di percorso della piattaforma: la barra su Unix, la barra
rovesciata su Windows.

**ES 16.6 — Dipendenza circolare a quattro moduli**

*Costruisci un progetto a quattro moduli con una dipendenza circolare
voluta, documenta l’errore esatto che ottieni, e risolvilo estraendo
un quinto modulo. Disegna il grafo delle dipendenze prima e dopo.*

```lua
-- Situazione di partenza: A -> B -> C -> D -> B
package.preload["a"] = function()
  local b = require("b")
  return {nome = function() return "a+" .. b.nome() end}
end

package.preload["b"] = function()
  local c = require("c")
  return {nome = function() return "b+" .. c.nome() end}
end

package.preload["c"] = function()
  local d = require("d")
  return {nome = function() return "c+" .. d.nome() end}
end

package.preload["d"] = function()
  local b = require("b")   -- CICLO: torna a b
  return {nome = function() return "d+" .. b.nome() end}
end

local ok, errore = pcall(require, "a")
print("con il ciclo: " .. tostring(ok) .. "  "
  .. tostring(errore))

-- Soluzione: estrarre in un quinto modulo cio' che
-- D chiede a B
for _, n in ipairs({"a", "b", "c", "d"}) do
  package.loaded[n] = nil
end

package.preload["comune"] = function()
  return {base = function() return "COMUNE" end}
end

package.preload["b"] = function()
  local c = require("c")
  local comune = require("comune")
  return {
    nome = function()
      return "b+" .. c.nome()
    end,
    base = comune.base,
  }
end

package.preload["d"] = function()
  local comune = require("comune")
  return {
    nome = function() return "d+" .. comune.base() end,
  }
end

local a = require("a")
print("senza il ciclo: " .. a.nome())
```

produce:

```text
con il ciclo: false  C stack overflow
senza il ciclo: a+b+c+d+COMUNE
```

Il grafo prima:

```text
a --> b --> c --> d
      ^                |
      +----------------+
```

Il grafo dopo:

```text
a --> b --> c --> d
      |               |
      +--> comune <---+
```

Il ciclo si spezza estraendo in `comune` la parte di `b` di cui `d` aveva
bisogno. Il grafo risultante è **aciclico**: si può disegnare con tutte
le frecce che puntano verso il basso.

Notate che il modulo estratto contiene ciò che era condiviso, non una
copia: `b` continua a esporre `base`, ma delegando a `comune`. Chi usava
`b.base` non se ne accorge.

**ES 16.7 — Ricaricare un modulo**

*Scrivi una funzione che, dato il nome di un modulo, lo ricarichi da
zero rimuovendolo da `package.loaded`, e dimostra con un esempio
perché i riferimenti già ottenuti dal chiamante continuano a puntare
alla versione vecchia.*

```lua
local versione = 1

package.preload["contatore"] = function()
  local n = 0
  local v = versione
  return {
    incrementa = function()
      n = n + 1
      return n
    end,
    versione = function() return v end,
  }
end

local function ricarica(nome)
  package.loaded[nome] = nil
  return require(nome)
end

local vecchio = require("contatore")
vecchio.incrementa()
vecchio.incrementa()

print("vecchio: versione " .. vecchio.versione()
  .. ", contatore " .. vecchio.incrementa())

versione = 2
local nuovo = ricarica("contatore")

print("nuovo:   versione " .. nuovo.versione()
  .. ", contatore " .. nuovo.incrementa())

print("vecchio dopo il ricarico: versione "
  .. vecchio.versione() .. ", contatore "
  .. vecchio.incrementa())

print("sono lo stesso oggetto? "
  .. tostring(vecchio == nuovo))
print("require restituisce il nuovo? "
  .. tostring(require("contatore") == nuovo))
```

produce:

```text
vecchio: versione 1, contatore 3
nuovo:   versione 2, contatore 1
vecchio dopo il ricarico: versione 1, contatore 4
sono lo stesso oggetto? false
require restituisce il nuovo? true
```

Il riferimento `vecchio` continua a puntare alla **prima** tabella, con
il proprio stato e la propria versione. Il ricaricamento crea un oggetto
nuovo e aggiorna `package.loaded`, ma non tocca in alcun modo i
riferimenti già distribuiti.

È il motivo dell’avvertenza del paragrafo 16.3: nei sistemi con
ricaricamento a caldo, dopo un ricarico convivono la versione vecchia e
quella nuova, e i comportamenti incoerenti che ne derivano sono
difficilissimi da diagnosticare.

La soluzione adottata dai sistemi che lo supportano davvero è **non
conservare mai il riferimento**: si chiama `require` a ogni uso,
accettando il costo di una ricerca in `package.loaded`.

**ES 16.8 — Modulo finto per i test**

*Usa `package.preload` per sostituire un modulo con una versione
finta durante un test, verificando che il codice sotto esame chiami
le funzioni attese con gli argomenti attesi, senza toccare il modulo
reale.*

```lua
-- Il modulo reale, che invia messaggi
package.preload["posta"] = function()
  return {
    invia = function(destinatario, oggetto, corpo)
      -- In produzione qui ci sarebbe una connessione
      error("il modulo reale non deve essere usato "
        .. "nei test", 0)
    end,
  }
end

-- Il codice sotto esame
package.preload["notifiche"] = function()
  local posta = require("posta")
  local M = {}

  function M.benvenuto(utente)
    if type(utente) ~= "table" or not utente.email then
      return nil, "utente senza indirizzo"
    end
    return posta.invia(utente.email,
      "Benvenuto, " .. (utente.nome or "utente"),
      "Grazie per esserti registrato.")
  end

  function M.promemoria(utente, scadenza)
    if not utente.email then
      return nil, "utente senza indirizzo"
    end
    return posta.invia(utente.email,
      "Promemoria",
      "Scadenza: " .. tostring(scadenza))
  end

  return M
end

-- Il modulo finto, installato PRIMA del require
local chiamate = {}

package.loaded["posta"] = {
  invia = function(destinatario, oggetto, corpo)
    chiamate[#chiamate + 1] = {
      destinatario = destinatario,
      oggetto = oggetto,
      corpo = corpo,
    }
    return true
  end,
}

local notifiche = require("notifiche")

notifiche.benvenuto({email = "a@example.com",
  nome = "Anna"})
notifiche.promemoria({email = "b@example.com"},
  "2026-09-01")

local r, e = notifiche.benvenuto({nome = "Senza posta"})
print("senza indirizzo: " .. tostring(r) .. " " .. e)

print("messaggi inviati: " .. #chiamate)
for i, c in ipairs(chiamate) do
  print(string.format("  %d. a=%s oggetto=%s",
    i, c.destinatario, c.oggetto))
end

local atteso = "Benvenuto, Anna"
print("primo oggetto corretto? "
  .. tostring(chiamate[1].oggetto == atteso))
print("il modulo reale non e' mai stato chiamato: "
  .. "confermato dall'assenza di errori")
```

produce:

```text
senza indirizzo: nil utente senza indirizzo
messaggi inviati: 2
  1. a=a@example.com oggetto=Benvenuto, Anna
  2. a=b@example.com oggetto=Promemoria
primo oggetto corretto? true
```

La sostituzione avviene scrivendo direttamente in `package.loaded`
**prima** che il modulo sotto esame venga caricato. Quando `notifiche`
esegue `require("posta")`, trova la voce già presente e non consulta né
`package.preload` né il filesystem.

Il modulo reale solleva un errore se invocato: è una **rete di
sicurezza** che rende impossibile un test che invii messaggi veri per
distrazione.

Il modulo finto registra le chiamate, permettendo di verificare non solo
che il codice funzioni ma che abbia chiamato le funzioni giuste con gli
argomenti giusti. È la tecnica delle spie del Capitolo 29, realizzata a
mano.

L’ordine conta: se `notifiche` fosse stato caricato prima
dell’installazione del finto, avrebbe già catturato il riferimento al
modulo reale nella propria variabile locale, e la sostituzione non
avrebbe effetto.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
