# Capitolo 24 — Metaprogrammazione: load, _ENV, sandbox, riflessione

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 23](capitolo-23.md) · [Indice](README.md) · [Capitolo 25 →](capitolo-25.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap24/`](../codice/cap24/).

---

**ES 24.4 — Vie di fuga dalla sandbox**

*Trova almeno due vie di fuga dalla sandbox del paragrafo 24.3,
scrivi il codice che le sfrutta, e correggi la sandbox. Verifica che
le correzioni non impediscano gli usi legittimi.*

```lua
local AMBIENTE_INGENUO = {
  print = print,
  string = string,
  math = math,
  table = table,
  pairs = pairs,
  ipairs = ipairs,
  tostring = tostring,
  type = type,
  getmetatable = getmetatable,
  setmetatable = setmetatable,
}

local function eseguiIngenua(codice)
  local f, err = load(codice, "sandbox", "t",
    AMBIENTE_INGENUO)
  if f == nil then return nil, err end
  local ok, r = pcall(f)
  return ok and r or ("errore: " .. tostring(r))
end

print("=== fuga 1: la metatabella delle stringhe ===")
print(eseguiIngenua([[
  local m = getmetatable("")
  local nomi = {}
  for k in pairs(m.__index) do nomi[#nomi + 1] = k end
  table.sort(nomi)
  return "raggiunta la libreria string vera, "
    .. #nomi .. " funzioni"
]]))

print(eseguiIngenua([[
  -- Peggio: si puo' MODIFICARE per tutto il programma
  local m = getmetatable("")
  local originale = m.__index.upper
  m.__index.upper = function(s) return "SABOTATO" end
  local r = ("prova"):upper()
  m.__index.upper = originale
  return r
]]))

print()
print("=== fuga 2: inquinamento dell'ambiente ===")
print(eseguiIngenua([[
  string.nuovaFunzione = "lasciata qui"
  return "scritto in string, condivisa"
]]))
print(eseguiIngenua([[
  return "la esecuzione successiva la vede: "
    .. tostring(string.nuovaFunzione)
]]))

print()
print("=== la versione corretta ===")

local function soloLettura(tabella, nomi)
  local copia = {}
  for _, n in ipairs(nomi) do copia[n] = tabella[n] end
  return setmetatable({}, {
    __index = copia,
    __newindex = function()
      error("libreria in sola lettura", 2)
    end,
    __metatable = false,
  })
end

local function eseguiSicura(codice)
  local ambiente = {
    print = print,
    pairs = pairs,
    ipairs = ipairs,
    tostring = tostring,
    type = type,
    -- getmetatable e setmetatable NON esposti
    string = soloLettura(string, {"format", "rep",
      "sub", "upper", "lower", "len", "byte", "char"}),
    math = soloLettura(math, {"floor", "ceil", "abs",
      "max", "min", "sqrt", "pi"}),
    table = soloLettura(table, {"concat", "insert",
      "remove", "sort"}),
  }

  local f, err = load(codice, "sandbox", "t", ambiente)
  if f == nil then return nil, err end
  local ok, r = pcall(f)
  return ok and r or ("errore: " .. tostring(r))
end

print(eseguiSicura([[
  return getmetatable("") and "raggiunta" or "bloccata"
]]))
print(eseguiSicura([[
  string.sabotaggio = 1
  return "scritto"
]]))
print(eseguiSicura([[
  return "uso legittimo: " .. string.format("%d", 42)
]]))
print(eseguiSicura([[
  return "anche questo: " .. table.concat({1,2,3}, "-")
]]))
```

produce:

```text
=== fuga 1: la metatabella delle stringhe ===
raggiunta la libreria string vera, 17 funzioni
SABOTATO

=== fuga 2: inquinamento dell'ambiente ===
scritto in string, condivisa
la esecuzione successiva la vede: lasciata qui

=== la versione corretta ===
errore: [string "sandbox"]:1: attempt to call a nil
value (global 'getmetatable')
errore: [string "sandbox"]:1: libreria in sola lettura
uso legittimo: 42
anche questo: 1-2-3
```

Le due fughe sono entrambe reali e serie.

La **metatabella delle stringhe** è condivisa da tutte le stringhe del
programma, e `getmetatable("")` la restituisce. Da lì si raggiunge la
libreria `string` **vera**, non la copia esposta nella sandbox. Peggio:
la si può modificare, e la modifica ha effetto su tutto il programma
ospite, non solo sul codice in sandbox.

L’**inquinamento dell’ambiente** avviene perché la tabella `string`
esposta è la stessa istanza a ogni esecuzione. Un chunk che vi scrive
lascia tracce visibili a quelli successivi, e può sostituire una funzione
con una propria.

La versione corretta rimuove `getmetatable` e `setmetatable`
dall’ambiente — al punto che il tentativo di chiamarli produce *attempt
to call a nil value* — ed espone le librerie tramite proxy in sola
lettura con `__metatable = false`, che impedisce anche di recuperare la
metatabella del proxy stesso.

Gli usi legittimi continuano a funzionare: la sandbox è più stretta, non
più povera.

**ES 24.5 — Motore di modelli compilato una volta**

*Correggi il motore di modelli del paragrafo 24.4 perché compili una
volta sola, e misura la differenza di prestazioni su mille rese
dello stesso modello.*

```lua
local function compila(modello)
  local pezzi = {"local _r = {}\n"}
  local posizione = 1

  while true do
    local inizio, fine, espressione =
      modello:find("{{(.-)}}", posizione)
    if inizio == nil then break end

    local testo = modello:sub(posizione, inizio - 1)
    if #testo > 0 then
      pezzi[#pezzi + 1] = string.format(
        "_r[#_r+1] = %q\n", testo)
    end
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = tostring(%s)\n", espressione)
    posizione = fine + 1
  end

  local coda = modello:sub(posizione)
  if #coda > 0 then
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = %q\n", coda)
  end
  pezzi[#pezzi + 1] = "return table.concat(_r)\n"

  local sorgente = table.concat(pezzi)

  -- COMPILAZIONE UNA VOLTA SOLA
  local ambiente = {tostring = tostring, table = table}
  local funzione, errore = load(sorgente, "modello",
    "t", ambiente)
  if funzione == nil then
    return nil, errore
  end

  -- Trova l'indice dell'upvalue _ENV
  local indiceEnv
  for i = 1, math.huge do
    local nome = debug.getupvalue(funzione, i)
    if nome == nil then break end
    if nome == "_ENV" then indiceEnv = i break end
  end

  return function(dati)
    local suo = setmetatable(
      {tostring = tostring, table = table},
      {__index = dati})
    debug.setupvalue(funzione, indiceEnv, suo)
    return funzione()
  end
end

local function compilaOgniVolta(modello)
  -- Versione dell'ES precedente: ricompila a ogni resa
  local pezzi = {"local _r = {}\n"}
  local posizione = 1
  while true do
    local inizio, fine, espressione =
      modello:find("{{(.-)}}", posizione)
    if inizio == nil then break end
    local testo = modello:sub(posizione, inizio - 1)
    if #testo > 0 then
      pezzi[#pezzi + 1] = string.format(
        "_r[#_r+1] = %q\n", testo)
    end
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = tostring(%s)\n", espressione)
    posizione = fine + 1
  end
  local coda = modello:sub(posizione)
  if #coda > 0 then
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = %q\n", coda)
  end
  pezzi[#pezzi + 1] = "return table.concat(_r)\n"
  local sorgente = table.concat(pezzi)

  return function(dati)
    local ambiente = setmetatable(
      {tostring = tostring, table = table},
      {__index = dati})
    local f = load(sorgente, "modello", "t", ambiente)
    return f()
  end
end

local MODELLO = "Gentile {{nome}}, il totale e' "
  .. "{{totale}} euro, con sconto {{totale * 0.1}}."

local veloce = compila(MODELLO)
local lenta = compilaOgniVolta(MODELLO)

local DATI = {nome = "Anna", totale = 250}

print(veloce(DATI))
print(lenta(DATI))
print("stesso risultato: "
  .. tostring(veloce(DATI) == lenta(DATI)))

local N = 10000

for _, p in ipairs({{"compilata una volta", veloce},
    {"ricompilata ogni volta", lenta}}) do
  collectgarbage("collect")
  local inizio = os.clock()
  local ultimo
  for i = 1, N do
    ultimo = p[2](DATI)
  end
  local durata = os.clock() - inizio
  print(string.format("%-26s %.4f s  (%d rese)",
    p[1], durata, N))
end
```

La differenza è di **un ordine di grandezza**: compilare un chunk
richiede l’analisi lessicale, sintattica e la generazione del bytecode, e
ripeterlo diecimila volte per lo stesso modello è puro spreco.

La tecnica per riusare la funzione compilata è quella dell’ES 24.2:
sostituire l’upvalue `_ENV` con un ambiente nuovo a ogni resa, invece di
ricompilare.

C’è un limite da dichiarare: la funzione restituita **non è
rientrante**. Due rese concorrenti — per esempio da due coroutine —
condividerebbero la stessa funzione compilata e si sovrascriverebbero
l’ambiente a vicenda. Per la rientranza servirebbe una copia della
funzione per contesto, che in Lua puro non si ottiene.

**ES 24.6 — Upvalue per nome**

*Scrivi una funzione che, data una funzione qualunque, restituisca
l’elenco dei suoi upvalue con nome e valore, e una che ne
sostituisca uno per nome invece che per indice. Verifica su una
closure con tre upvalue.*

```lua
local function elencaUpvalue(f)
  if type(f) ~= "function" then
    return nil, "atteso una funzione"
  end
  local r = {}
  for i = 1, math.huge do
    local nome, valore = debug.getupvalue(f, i)
    if nome == nil then break end
    r[#r + 1] = {
      indice = i, nome = nome, valore = valore,
      tipo = type(valore),
    }
  end
  return r
end

local function impostaUpvalue(f, nome, valore)
  for i = 1, math.huge do
    local n = debug.getupvalue(f, i)
    if n == nil then break end
    if n == nome then
      debug.setupvalue(f, i, valore)
      return true, i
    end
  end
  return false, "upvalue non trovato: " .. nome
end

local function leggiUpvalue(f, nome)
  for i = 1, math.huge do
    local n, v = debug.getupvalue(f, i)
    if n == nil then break end
    if n == nome then return v, i end
  end
  return nil, "upvalue non trovato: " .. nome
end

local function creaContatore(iniziale, passo, etichetta)
  local valore = iniziale
  local incrementi = 0
  return function()
    incrementi = incrementi + 1
    valore = valore + passo
    return etichetta .. "=" .. valore
      .. " (" .. incrementi .. " incrementi)"
  end
end

local c = creaContatore(0, 5, "contatore")

print("stato iniziale:")
for _, u in ipairs(elencaUpvalue(c)) do
  print(string.format("  %d. %-12s %-8s %s",
    u.indice, u.nome, u.tipo, tostring(u.valore)))
end

print()
print(c())
print(c())

print()
print("dopo due chiamate:")
for _, u in ipairs(elencaUpvalue(c)) do
  print(string.format("  %d. %-12s %s",
    u.indice, u.nome, tostring(u.valore)))
end

print()
print("modifica per nome:")
print("  " .. tostring(impostaUpvalue(c, "passo", 100)))
print("  " .. tostring(impostaUpvalue(c, "etichetta",
  "MODIFICATO")))
print("  " .. tostring(impostaUpvalue(c, "inesistente",
  1)))

print()
print(c())
print("valore letto per nome: "
  .. tostring(leggiUpvalue(c, "valore")))

print()
print("condivisione fra due closure:")
local function creaCoppia()
  local condiviso = 0
  return function() condiviso = condiviso + 1
    return condiviso end,
    function() return condiviso end
end

local incrementa, leggi = creaCoppia()
incrementa()
incrementa()
print("  leggi(): " .. leggi())
impostaUpvalue(incrementa, "condiviso", 100)
print("  dopo aver modificato l'upvalue di incrementa,")
print("  leggi() vede: " .. leggi())
print("  perche' e' lo STESSO upvalue")
```

L’ultima parte è quella più istruttiva: modificando l’upvalue attraverso
una delle due closure, **anche l’altra vede il nuovo valore**. Le due
funzioni non hanno copie separate della variabile: hanno riferimenti allo
stesso upvalue, esattamente come descritto nel paragrafo 9.6.

`debug.upvalueid` permette di verificarlo direttamente, restituendo un
identificatore uguale per upvalue condivisi.

La ricerca per nome invece che per indice rende il codice indipendente
dall’ordine in cui il compilatore ha assegnato gli upvalue, che non è
garantito e può cambiare con la versione.

Va ripetuto l’avvertimento del paragrafo 24.5: questa capacità dimostra
che l’incapsulamento tramite closure è una **convenzione**, non una
garanzia. Se `debug` è raggiungibile, nessuno stato è davvero privato.

**ES 24.7 — Tracciatore di copertura**

*Implementa un tracciatore di copertura che, dato un file Lua,
riporti quali righe sono state effettivamente eseguite e quali no.
Usa l’hook per riga e `debug.getinfo` per filtrare sul file voluto.*

```lua
local Copertura = {}
Copertura.__index = Copertura

function Copertura.nuova(filtro)
  return setmetatable({
    filtro = filtro,
    eseguite = {},
    attiva = false,
  }, Copertura)
end

function Copertura:avvia()
  if self.attiva then return self end
  self.attiva = true
  local eseguite = self.eseguite
  local filtro = self.filtro

  debug.sethook(function(_, riga)
    local info = debug.getinfo(2, "S")
    if info == nil then return end
    local sorgente = info.short_src
    if filtro and not sorgente:find(filtro, 1, true) then
      return
    end
    local perFile = eseguite[sorgente]
    if perFile == nil then
      perFile = {}
      eseguite[sorgente] = perFile
    end
    perFile[riga] = (perFile[riga] or 0) + 1
  end, "l")

  return self
end

function Copertura:ferma()
  debug.sethook()
  self.attiva = false
  return self
end

function Copertura:rapporto(sorgente, testo)
  local perFile = self.eseguite[sorgente] or {}
  local righe = {}
  local numero = 0
  local eseguibili, coperte = 0, 0

  for riga in (testo .. "\n"):gmatch("(.-)\n") do
    numero = numero + 1
    local pulita = riga:match("^%s*(.-)%s*$")
    local eseguibile = pulita ~= ""
      and not pulita:match("^%-%-")
      and pulita ~= "end"
      and pulita ~= "else"
      and not pulita:match("^local function")
      and not pulita:match("^function")

    local quante = perFile[numero]
    local marcatore

    if quante then
      marcatore = string.format("%4dx", quante)
      coperte = coperte + 1
      eseguibili = eseguibili + 1
    elseif eseguibile then
      marcatore = "  !!!"
      eseguibili = eseguibili + 1
    else
      marcatore = "     "
    end

    righe[#righe + 1] = string.format("%s %3d| %s",
      marcatore, numero, riga)
  end

  local percentuale = 0
  if eseguibili > 0 then
    percentuale = coperte / eseguibili * 100
  end

  righe[#righe + 1] = ""
  righe[#righe + 1] = string.format(
    "copertura: %d/%d righe (%.1f%%)",
    coperte, eseguibili, percentuale)

  return table.concat(righe, "\n")
end

local SORGENTE = [[
local function classifica(n)
  if n < 0 then
    return "negativo"
  elseif n == 0 then
    return "zero"
  elseif n < 10 then
    return "piccolo"
  else
    return "grande"
  end
end

local risultati = {}
for _, v in ipairs({5, 0, 100}) do
  risultati[#risultati + 1] = classifica(v)
end
return table.concat(risultati, " ")
]]

local NOME = "/tmp/copertura_prova.lua"
local f = assert(io.open(NOME, "w"))
f:write(SORGENTE)
f:close()

local chunk = assert(loadfile(NOME))

local c = Copertura.nuova("copertura_prova")
c:avvia()
local risultato = chunk()
c:ferma()

print("risultato: " .. tostring(risultato))
print()
print(c:rapporto(NOME, SORGENTE))

os.remove(NOME)
```

Il rapporto marca con `!!!` le righe eseguibili mai eseguite. Nel caso di
prova, il ramo `n < 0` non viene mai raggiunto, perché i valori provati
sono cinque, zero e cento.

La classificazione delle righe **eseguibili** è approssimata: righe
vuote, commenti, `end` e `else` non generano istruzioni e vanno escluse,
altrimenti la percentuale risulta artificialmente bassa. Uno strumento
serio come `luacov` fa questa distinzione consultando le informazioni di
debug del chunk compilato invece che il testo.

L’hook per riga è quello che rallenta di più, come segnalato nel
paragrafo 24.6: va usato per la misura della copertura e mai in
produzione.

**ES 24.8 — Generatore di costruttori compilati**

*Scrivi un generatore che, data la descrizione di un record con nomi
e tipi di campo, produca il sorgente di un costruttore con
validazione e lo compili con `load`. Confronta le prestazioni con
una versione generica che valida scorrendo una tabella di regole.*

```lua
local function generaCostruttore(nome, campi)
  local righe = {
    "local setmetatable, type, error, format = ...",
    "local M = {}",
    "M.__index = M",
    "M.__nome = " .. string.format("%q", nome),
    "return M, function(dati)",
    "  dati = dati or {}",
  }

  for _, c in ipairs(campi) do
    local chiave = string.format("%q", c.nome)

    if c.obbligatorio then
      righe[#righe + 1] = string.format(
        "  if dati[%s] == nil then return nil, "
        .. "%q end", chiave,
        nome .. ": campo obbligatorio " .. c.nome)
    end

    if c.tipo then
      righe[#righe + 1] = string.format(
        "  if dati[%s] ~= nil and type(dati[%s]) "
        .. "~= %q then return nil, format(%q, "
        .. "type(dati[%s])) end",
        chiave, chiave, c.tipo,
        nome .. ": " .. c.nome .. " deve essere "
          .. c.tipo .. ", ricevuto %s", chiave)
    end
  end

  righe[#righe + 1] = "  return setmetatable({"
  for _, c in ipairs(campi) do
    local chiave = string.format("%q", c.nome)
    if c.predefinito ~= nil then
      righe[#righe + 1] = string.format(
        "    [%s] = dati[%s] ~= nil and dati[%s] "
        .. "or %s,", chiave, chiave, chiave,
        type(c.predefinito) == "string"
          and string.format("%q", c.predefinito)
          or tostring(c.predefinito))
    else
      righe[#righe + 1] = string.format(
        "    [%s] = dati[%s],", chiave, chiave)
    end
  end
  righe[#righe + 1] = "  }, M)"
  righe[#righe + 1] = "end"

  local sorgente = table.concat(righe, "\n")
  local chunk, errore = load(sorgente,
    "costruttore:" .. nome, "t")
  if chunk == nil then
    return nil, errore .. "\n--- sorgente ---\n"
      .. sorgente
  end

  return chunk(setmetatable, type, error, string.format)
end

local function costruttoreGenerico(nome, campi)
  local M = {}
  M.__index = M
  M.__nome = nome
  return M, function(dati)
    dati = dati or {}
    for _, c in ipairs(campi) do
      local v = dati[c.nome]
      if v == nil and c.obbligatorio then
        return nil, nome .. ": campo obbligatorio "
          .. c.nome
      end
      if v ~= nil and c.tipo
         and type(v) ~= c.tipo then
        return nil, string.format(
          "%s: %s deve essere %s, ricevuto %s",
          nome, c.nome, c.tipo, type(v))
      end
    end
    local istanza = {}
    for _, c in ipairs(campi) do
      local v = dati[c.nome]
      if v == nil then v = c.predefinito end
      istanza[c.nome] = v
    end
    return setmetatable(istanza, M)
  end
end

local CAMPI = {
  {nome = "nome", tipo = "string", obbligatorio = true},
  {nome = "eta", tipo = "number", predefinito = 0},
  {nome = "attivo", tipo = "boolean",
   predefinito = true},
}

local _, creaCompilato = generaCostruttore("Utente",
  CAMPI)
local _, creaGenerico = costruttoreGenerico("Utente",
  CAMPI)

local u = creaCompilato({nome = "Anna", eta = 34})
print(u.nome, u.eta, u.attivo)

print(creaCompilato({}))
print(creaCompilato({nome = "x", eta = "trenta"}))
print(creaGenerico({}))

local N = 500000
for _, p in ipairs({{"compilato", creaCompilato},
    {"generico", creaGenerico}}) do
  collectgarbage("collect")
  local inizio = os.clock()
  for i = 1, N do
    p[2]({nome = "x", eta = i})
  end
  print(string.format("%-12s %.4f s", p[1],
    os.clock() - inizio))
end
```

Il costruttore **compilato** è più veloce, perché i controlli sono
istruzioni dirette invece di un ciclo su una tabella di regole: non c’è
alcuna iterazione, alcun accesso a `c.tipo`, alcun confronto con `nil`
sulle regole.

Il costruttore **generico** è più lento ma ha vantaggi concreti: le
regole si possono cambiare a runtime, il codice è leggibile e
verificabile, e non richiede `load`.

Notate un difetto del generatore: il predefinito è applicato con
l’idioma `dati[k] ~= nil and dati[k] or predefinito`, che sbaglia quando
il valore fornito è `false` — il problema del Capitolo 6, comparso ancora
una volta. Nel campo `attivo`, passare `false` produrrebbe `true`. È
lasciato di proposito: correggerlo richiede di generare un `if` completo
invece di un’espressione, ed è un buon esercizio aggiuntivo.

Il codice generato viene passato attraverso `load` con modo `"t"` e senza
ambiente, ricevendo le funzioni necessarie come argomenti del chunk: è
più sicuro che esporre l’ambiente globale.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
