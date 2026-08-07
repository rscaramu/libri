# Capitolo 20 — Input/output: file, stream, serializzazione

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 19](capitolo-19.md) · [Indice](README.md) · [Capitolo 21 →](capitolo-21.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap20/`](../codice/cap20/).

---

**ES 20.4 — Copia a blocchi**

*Scrivi una funzione che copi un file in blocchi di dimensione fissa,
in modalità binaria, restituendo il numero di byte copiati e
gestendo tutti gli errori. Verifica che funzioni su un file più
grande della memoria che vuoi impiegare.*

```lua
local function copia(origine, destinazione, opzioni)
  opzioni = opzioni or {}
  local blocco = opzioni.blocco or 65536

  local ingresso, err1 = io.open(origine, "rb")
  if ingresso == nil then
    return nil, "lettura: " .. err1
  end
  local chiudiIngresso <close> = ingresso

  local uscita, err2 = io.open(destinazione, "wb")
  if uscita == nil then
    return nil, "scrittura: " .. err2
  end
  local chiudiUscita <close> = uscita

  local totale = 0
  while true do
    local pezzo = ingresso:read(blocco)
    if pezzo == nil or #pezzo == 0 then break end
    local ok, err3 = uscita:write(pezzo)
    if ok == nil then
      return nil, "scrittura interrotta: "
        .. tostring(err3)
    end
    totale = totale + #pezzo
  end

  uscita:flush()
  return totale
end

-- Prepariamo un file di prova di 5 MB
local NOME = "/tmp/prova_copia.bin"
local COPIA = "/tmp/prova_copia_2.bin"

local f = assert(io.open(NOME, "wb"))
local riempimento = string.rep("0123456789", 1024)
for _ = 1, 512 do f:write(riempimento) end
f:close()

for _, blocco in ipairs({1024, 65536, 1048576}) do
  collectgarbage("collect")
  local prima = collectgarbage("count")
  local inizio = os.clock()
  local byte, errore = copia(NOME, COPIA,
    {blocco = blocco})
  local durata = os.clock() - inizio
  local dopo = collectgarbage("count")

  if byte then
    print(string.format(
      "blocco %8d: %d byte, %.4f s, %+.0f KB",
      blocco, byte, durata, dopo - prima))
  else
    print("errore: " .. errore)
  end
end

print(copia("/non/esiste", COPIA))
print(copia(NOME, "/percorso/inesistente/x"))

os.remove(NOME)
os.remove(COPIA)
```

La lettura a blocchi mantiene l’occupazione di memoria **costante**
indipendentemente dalla dimensione del file: in ogni istante è in memoria
un solo blocco. Con `read("a")` l’occupazione sarebbe pari alla
dimensione del file.

I due `<close>` garantiscono la chiusura di entrambi i descrittori su
ogni percorso d’uscita, compreso il ritorno anticipato per errore di
scrittura. Notate che servono **due** variabili distinte: l’attributo si
applica alla dichiarazione, e non si può assegnarlo a una variabile già
esistente.

La modalità binaria è obbligatoria per la portabilità su Windows, dove
altrimenti l’a capo verrebbe tradotto e i byte copiati non
coinciderebbero con quelli letti.

**ES 20.5 — Unire più file**

*Scrivi un programma che unisca più file di testo in uno solo,
aggiungendo prima di ciascuno un’intestazione con il nome e il
numero di righe. Gestisci i file mancanti saltandoli con un avviso
su `io.stderr`.*

```lua
local function unisci(elenco, destinazione)
  local uscita, err = io.open(destinazione, "w")
  if uscita == nil then
    return nil, "impossibile scrivere: " .. err
  end
  local chiudi <close> = uscita

  local uniti, saltati = 0, 0
  local righeTotali = 0

  for _, nome in ipairs(elenco) do
    local ingresso, errAperto = io.open(nome, "r")
    if ingresso == nil then
      io.stderr:write("avviso: salto '", nome,
        "': ", tostring(errAperto), "\n")
      saltati = saltati + 1
    else
      local righe = {}
      for riga in ingresso:lines() do
        righe[#righe + 1] = riga
      end
      ingresso:close()

      uscita:write(string.rep("=", 60), "\n")
      uscita:write("FILE:  ", nome, "\n")
      uscita:write("RIGHE: ", #righe, "\n")
      uscita:write(string.rep("=", 60), "\n")
      for _, riga in ipairs(righe) do
        uscita:write(riga, "\n")
      end
      uscita:write("\n")

      uniti = uniti + 1
      righeTotali = righeTotali + #righe
    end
  end

  return {
    uniti = uniti,
    saltati = saltati,
    righe = righeTotali,
  }
end

local BASE = "/tmp/unione_"
for i = 1, 3 do
  local f = assert(io.open(BASE .. i .. ".txt", "w"))
  for j = 1, i * 2 do
    f:write("file ", i, " riga ", j, "\n")
  end
  f:close()
end

local risultato, errore = unisci({
  BASE .. "1.txt",
  BASE .. "mancante.txt",
  BASE .. "2.txt",
  BASE .. "3.txt",
}, "/tmp/unione_totale.txt")

if risultato then
  print(string.format(
    "uniti=%d saltati=%d righe=%d",
    risultato.uniti, risultato.saltati,
    risultato.righe))
end

local n = 0
for riga in io.lines("/tmp/unione_totale.txt") do
  n = n + 1
  if n <= 6 then print("  " .. riga) end
end
print("  ... totale " .. n .. " righe nel risultato")

for i = 1, 3 do os.remove(BASE .. i .. ".txt") end
os.remove("/tmp/unione_totale.txt")
```

I file mancanti vengono **saltati con un avviso su `io.stderr`**, non
fatti fallire. È la scelta giusta per uno strumento di unione: chi lo usa
preferisce ottenere il risultato parziale con la segnalazione, piuttosto
che nulla.

L’uso di `io.stderr` e non di `print` è essenziale: se l’output del
programma venisse reindirizzato in un file, gli avvisi finirebbero
mescolati ai dati. Su stderr restano visibili a terminale.

Il conteggio delle righe richiede di leggerle tutte prima di scriverne
l’intestazione, motivo per cui si accumulano in una tabella invece di
copiarle direttamente.

**ES 20.6 — Configurazione con ambiente ristretto**

*Scrivi una funzione che legga un file di configurazione in formato
Lua usando `load` con ambiente ristretto, esponendo al file caricato
soltanto un elenco esplicito di funzioni sicure. Verifica che un
file che tenta di chiamare `os.execute` fallisca.*

```lua
local AMBIENTE_SICURO = {
  math = {
    floor = math.floor, ceil = math.ceil,
    abs = math.abs, max = math.max, min = math.min,
    pi = math.pi,
  },
  string = {
    format = string.format, rep = string.rep,
    upper = string.upper, lower = string.lower,
  },
  os = {
    date = os.date,   -- solo la formattazione
  },
  tostring = tostring,
  tonumber = tonumber,
  ipairs = ipairs,
  pairs = pairs,
  type = type,
}

local function caricaConfigurazione(testo, extra)
  local ambiente = {}
  for k, v in pairs(AMBIENTE_SICURO) do
    if type(v) == "table" then
      local copia = {}
      for kk, vv in pairs(v) do copia[kk] = vv end
      ambiente[k] = copia
    else
      ambiente[k] = v
    end
  end
  for k, v in pairs(extra or {}) do
    ambiente[k] = v
  end

  local chunk, errore = load(testo, "configurazione",
    "t", ambiente)
  if chunk == nil then
    return nil, "sintassi: " .. errore
  end

  local ok, risultato = pcall(chunk)
  if not ok then
    return nil, "esecuzione: " .. tostring(risultato)
  end
  if type(risultato) ~= "table" then
    return nil, "la configurazione deve restituire "
      .. "una tabella"
  end

  return risultato
end

local BUONA = [[
local base = 8000
return {
  host = "example.com",
  porta = base + 80,
  soglia = math.floor(3.7),
  etichetta = string.format("v%d.%d", 2, 1),
  generata = os.date("!%Y", 0),
}
]]

local c, e = caricaConfigurazione(BUONA)
if c then
  print("host:      " .. c.host)
  print("porta:     " .. c.porta)
  print("soglia:    " .. c.soglia)
  print("etichetta: " .. c.etichetta)
  print("generata:  " .. c.generata)
end

local CATTIVE = {
  {"os.execute", "os.execute('echo COMPROMESSO')\n"
    .. "return {}"},
  {"io.open", "return {x = io.open('/etc/passwd')}"},
  {"require", "require('os')\nreturn {}"},
  {"load", "return {f = load('return 1')}"},
  {"_G", "return {g = _G}"},
  {"getmetatable", "return {m = getmetatable('')}"},
  {"os.remove", "os.remove('/tmp/x')\nreturn {}"},
  {"sintassi", "return {porta = }"},
}

print()
for _, p in ipairs(CATTIVE) do
  local r, err = caricaConfigurazione(p[2])
  print(string.format("%-14s -> %s", p[1],
    r and "PASSATA (male!)" or err))
end
```

produce:

```text
host:      example.com
porta:     8080
soglia:    3
etichetta: v2.1
generata:  1970

os.execute     -> esecuzione: [string "configurazione"]:1:
attempt to call a nil value (field 'execute')
io.open        -> esecuzione: [string "configurazione"]:1:
attempt to index a nil value (global 'io')
require        -> esecuzione: [string "configurazione"]:1:
attempt to call a nil value (global 'require')
load           -> esecuzione: [string "configurazione"]:1:
attempt to call a nil value (global 'load')
_G             -> PASSATA (male!)
getmetatable   -> esecuzione: [string "configurazione"]:1:
attempt to call a nil value (global 'getmetatable')
os.remove      -> esecuzione: [string "configurazione"]:1:
attempt to call a nil value (field 'remove')
sintassi       -> sintassi: [string "configurazione"]:1:
unexpected symbol near '}'
```

Il caso `_G` è l’unico che **passa**, e va capito bene. `_G` non esiste
nell’ambiente e vale `nil`, quindi `return {g = _G}` restituisce una
tabella con un campo nullo: nessun errore, nessun accesso, controllo di
tipo superato.

Non è una falla — `nil` non dà accesso a nulla — ma è un promemoria
utile: il fatto che una configurazione venga caricata senza errori non
significa che contenga i campi attesi. Il controllo di tipo sulla tabella
restituita non sostituisce la validazione dei suoi contenuti, che è
l’argomento dell’ES 21.1.

`os` è esposto **parzialmente**: la sola `os.date`, che formatta e non
tocca il sistema. È il modello corretto: non «tutto o niente» ma un
elenco esplicito di ciò che serve.

Le sottotabelle vengono **copiate** a ogni caricamento, così che una
configurazione che scriva `math.floor = nil` non danneggi quelle
successive.

**ES 20.7 — Tre modi di leggere un file**

*Confronta le prestazioni di tre modi di leggere un file di centomila
righe: `read("a")` seguito da `gmatch`, `lines` in un ciclo, e
`read(N)` a blocchi con ricostruzione delle righe. Misura tempo e
memoria con `collectgarbage("count")`.*

```lua
local NOME = "/tmp/prova_lettura.txt"
local RIGHE = 100000

local f = assert(io.open(NOME, "w"))
for i = 1, RIGHE do
  f:write("riga numero ", i,
    " con del testo di riempimento\n")
end
f:close()

local function misura(nome, funzione)
  collectgarbage("collect")
  collectgarbage("collect")
  local memPrima = collectgarbage("count")
  local inizio = os.clock()
  local quante = funzione()
  local durata = os.clock() - inizio
  local memDopo = collectgarbage("count")
  print(string.format(
    "%-24s %.4f s  %8.0f KB  righe=%d",
    nome, durata, memDopo - memPrima, quante))
end

misura("read('a') + gmatch", function()
  local file = assert(io.open(NOME, "r"))
  local tutto = file:read("a")
  file:close()
  local n = 0
  for _ in tutto:gmatch("[^\n]+") do n = n + 1 end
  return n
end)

misura("lines() in un ciclo", function()
  local n = 0
  for _ in io.lines(NOME) do n = n + 1 end
  return n
end)

misura("read(N) a blocchi", function()
  local file = assert(io.open(NOME, "rb"))
  local n = 0
  local resto = ""
  while true do
    local pezzo = file:read(65536)
    if pezzo == nil then break end
    local dati = resto .. pezzo
    local ultimo = 1
    while true do
      local i = dati:find("\n", ultimo, true)
      if i == nil then break end
      n = n + 1
      ultimo = i + 1
    end
    resto = dati:sub(ultimo)
  end
  if #resto > 0 then n = n + 1 end
  file:close()
  return n
end)

os.remove(NOME)
```

Le tre strategie hanno profili diversi.

`read("a")` è la **più veloce** perché fa una sola chiamata di sistema,
ma trattiene in memoria l’intero file più le stringhe prodotte da
`gmatch`. Su un file di gigabyte non è praticabile.

`lines()` ha occupazione di memoria **quasi nulla** — una riga alla volta
— ed è la più leggibile. Il costo è una chiamata di funzione per riga.

`read(N)` a blocchi ha memoria costante e controllo fine, ma richiede di
ricostruire a mano le righe che attraversano il confine fra due blocchi.
È la strategia da usare per i formati binari o quando serve elaborare i
byte senza la nozione di riga; per il testo, `lines` fa la stessa cosa
senza il codice di raccordo.

Notate la gestione del `resto`: senza, ogni riga spezzata a metà da un
confine di blocco verrebbe contata due volte o perduta.

**ES 20.8 — CSV con intestazione**

*Estendi il lettore CSV dell’ES 20.2 perché usi la prima riga come
intestazione e restituisca una sequenza di record indicizzati per
nome di colonna, segnalando le righe con un numero di campi diverso
da quello dell’intestazione.*

```lua
local function analizzaRighe(testo, separatore)
  separatore = separatore or ","
  local righe, campi, campo = {}, {}, {}
  local dentro = false
  local i, n = 1, #testo

  local function chiudiCampo()
    campi[#campi + 1] = table.concat(campo)
    campo = {}
  end

  local function chiudiRiga()
    chiudiCampo()
    righe[#righe + 1] = campi
    campi = {}
  end

  while i <= n do
    local c = testo:sub(i, i)
    if dentro then
      if c == '"' then
        if testo:sub(i + 1, i + 1) == '"' then
          campo[#campo + 1] = '"'
          i = i + 2
        else
          dentro = false
          i = i + 1
        end
      else
        campo[#campo + 1] = c
        i = i + 1
      end
    elseif c == '"' and #campo == 0 then
      dentro = true
      i = i + 1
    elseif c == separatore then
      chiudiCampo()
      i = i + 1
    elseif c == "\r" then
      i = i + 1
    elseif c == "\n" then
      chiudiRiga()
      i = i + 1
    else
      campo[#campo + 1] = c
      i = i + 1
    end
  end

  if dentro then return nil, "virgolette non chiuse" end
  if #campo > 0 or #campi > 0 then chiudiRiga() end
  return righe
end

local function leggiRecord(testo, separatore)
  local righe, errore = analizzaRighe(testo, separatore)
  if righe == nil then return nil, errore end
  if #righe == 0 then return {}, {} end

  local intestazione = righe[1]
  local attese = #intestazione

  local visti = {}
  for i, nome in ipairs(intestazione) do
    if nome == "" then
      return nil, "colonna " .. i .. " senza nome"
    end
    if visti[nome] then
      return nil, "colonna duplicata: " .. nome
    end
    visti[nome] = true
  end

  local record = {}
  local problemi = {}

  for r = 2, #righe do
    local riga = righe[r]
    if #riga ~= attese then
      problemi[#problemi + 1] = string.format(
        "riga %d: %d campi invece di %d",
        r, #riga, attese)
    else
      local rec = {}
      for c = 1, attese do
        rec[intestazione[c]] = riga[c]
      end
      rec._riga = r
      record[#record + 1] = rec
    end
  end

  return record, problemi, intestazione
end

local SORGENTE =
  'nome,citta,eta\n'
  .. '"Rossi, Mario",Roma,34\n'
  .. 'Bianchi,Milano,28\n'
  .. 'Corta,Torino\n'
  .. 'Lunga,Napoli,50,extra\n'
  .. 'Verdi,"Reggio\nEmilia",41\n'

local record, problemi, intestazione =
  leggiRecord(SORGENTE)

print("colonne: " .. table.concat(intestazione, ", "))
print("record validi: " .. #record)
for _, r in ipairs(record) do
  print(string.format("  riga %d: %-14s %-14s %s",
    r._riga, r.nome, r.citta, r.eta))
end

print("problemi: " .. #problemi)
for _, p in ipairs(problemi) do
  print("  " .. p)
end

print()
print(leggiRecord("a,a\n1,2\n"))
print(leggiRecord("a,,c\n1,2,3\n"))
```

produce:

```text
colonne: nome, citta, eta
record validi: 3
  riga 2: Rossi, Mario   Roma           34
  riga 3: Bianchi        Milano         28
  riga 6: Verdi          Reggio
Emilia  41
problemi: 2
  riga 4: 2 campi invece di 3
  riga 5: 4 campi invece di 3

nil	colonna duplicata: a
nil	colonna 2 senza nome
```

Le righe con un numero di campi diverso da quello dell’intestazione
vengono **segnalate e scartate**, non riempite con valori nulli né
troncate: entrambe le alternative nasconderebbero un problema nei dati.

Il campo `_riga` conserva il numero di riga originale, che è
l’informazione che serve a chi deve correggere il file sorgente.

La validazione dell’intestazione rifiuta colonne senza nome e colonne
duplicate: entrambe renderebbero i record ambigui, perché due colonne con
lo stesso nome collasserebbero in una chiave sola.

Il record con il campo su due righe funziona, ed è visibile nell’output
dove «Reggio Emilia» occupa due righe.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
