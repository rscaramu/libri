# Capitolo 28 — LuaRocks e l’ecosistema dei pacchetti

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 27](capitolo-27.md) · [Indice](README.md) · [Capitolo 29 →](capitolo-29.md)

I 6 sorgenti eseguibili di questo capitolo sono in
[`codice/cap28/`](../codice/cap28/).

---

**ES 28.3 — Rockspec con moduli Lua e C**

*Scrivi il rockspec per un progetto che contenga sia moduli Lua sia
un modulo C con due file sorgente, e verificane l’installazione in
un albero temporaneo.*

```lua
package = "misto"
version = "0.3.0-1"

source = {
  url = "git+https://example.com/rs/misto.git",
  tag = "v0.3.0",
}

description = {
  summary = "Utilita' miste con un nucleo in C",
  detailed = [[
    Funzioni di supporto in Lua puro piu' un modulo C
    che implementa le operazioni piu' pesanti.
  ]],
  homepage = "https://example.com/rs/misto",
  license = "MIT",
  maintainer = "Roberto Scaramuzzino",
}

dependencies = {
  "lua >= 5.3, < 5.5",
}

build = {
  type = "builtin",
  modules = {
    -- moduli Lua puri
    ["misto"] = "src/misto.lua",
    ["misto.util"] = "src/misto/util.lua",
    ["misto.formato"] = "src/misto/formato.lua",

    -- modulo C con due sorgenti
    ["misto.nucleo"] = {
      sources = {
        "csrc/nucleo.c",
        "csrc/aiuto.c",
      },
      incdirs = {"csrc"},
      libraries = {"m"},
      defines = {"MISTO_VERSIONE=\"0.3.0\""},
    },
  },
  copy_directories = {"doc"},
}
```

La struttura del progetto corrispondente:

```text
misto/
  misto-0.3.0-1.rockspec
  src/
    misto.lua
    misto/
      util.lua
      formato.lua
  csrc/
    nucleo.c
    nucleo.h
    aiuto.c
  doc/
    manuale.md
  spec/
    misto_spec.lua
```

La verifica in un albero temporaneo, che è il punto dell’esercizio:

```text
# 1. costruzione e installazione isolata
luarocks install --tree=/tmp/prova-misto \
  ./misto-0.3.0-1.rockspec

# 2. quali file sono finiti dove
find /tmp/prova-misto -name "*.lua" -o -name "*.so"

# 3. il modulo si carica davvero?
eval "$(luarocks path --tree=/tmp/prova-misto --bin)"
lua -e 'local m = require("misto")
        print(m._VERSIONE)
        local n = require("misto.nucleo")
        print(n.versione())'

# 4. pulizia
rm -rf /tmp/prova-misto
```

Tre osservazioni sul rockspec.

Il **nome del modulo C** determina il nome della funzione di apertura:
`misto.nucleo` richiede `luaopen_misto_nucleo`, con il punto sostituito
da una sottolineatura. Sbagliare questo nome produce l’errore *module
'misto.nucleo' not found* nonostante la libreria sia stata compilata e
installata, ed è l’errore più frequente al primo modulo C.

I **`defines`** passano macro al compilatore: qui la versione, così che
il codice C possa esporla senza duplicarla.

Le **`libraries`** elencano le librerie di sistema da collegare, senza il
prefisso `lib` e senza estensione: `"m"` diventa `-lm`.

Il vincolo su `lua` è dichiarato come intervallo perché il codice usa gli
interi, introdotti nella 5.3, ma non è stato provato sulla 5.5.

**ES 28.4 — Confronto fra librerie JSON**

*Confronta tre librerie JSON per Lua su: velocità di codifica e
decodifica su un documento di un megabyte, gestione dei numeri
interi grandi, comportamento sui riferimenti circolari, distinzione
fra array vuoto e oggetto vuoto.*

Il confronto va eseguito sul proprio sistema, ma le dimensioni da
misurare e i risultati attesi si possono descrivere con precisione.

**Velocità.** Su un documento di un megabyte, `lua-cjson` è tipicamente
da dieci a trenta volte più veloce di `dkjson` in codifica e in
decodifica, perché il primo è un modulo C e il secondo è Lua puro. Il
divario si riduce su documenti piccoli, dove il costo di caricamento e le
chiamate attraverso il confine C pesano relativamente di più.

**Interi grandi.** È il punto in cui le tre librerie divergono di più.
JSON non distingue interi da float, e ciascuna libreria decide: `dkjson`
tende a produrre float per tutti i numeri, perdendo la precisione oltre i
cinquantatré bit; `lua-cjson` produce interi quando il valore è intero e
la versione di Lua li supporta. Un identificatore a sessantaquattro bit
proveniente da un servizio esterno può quindi essere **corrotto
silenziosamente** dalla decodifica. La verifica decisiva è codificare
`9007199254740993` e rileggerlo.

**Riferimenti circolari.** `dkjson` con l’opzione predefinita entra in
ricorsione fino a esaurire lo stack; `lua-cjson` ha un limite di
profondità configurabile e solleva un errore. Nessuna delle due li
gestisce con riferimenti simbolici, che JSON non prevede.

**Array vuoto contro oggetto vuoto.** È l’ambiguità strutturale
descritta nell’ES 25.7: `{}` in Lua può diventare `[]` o `{}` in JSON.
`dkjson` produce `{}` per difetto e offre un valore sentinella per
forzare l’array; `lua-cjson` produce `{}` e ha
`cjson.empty_array_mark`. Un servizio che si aspetta un array e riceve
un oggetto vuoto rifiuta la richiesta, ed è un bug che compare solo
quando la collezione è vuota.

La conclusione pratica: **provate la libreria sui vostri dati reali**
prima di adottarla, con particolare attenzione agli identificatori
numerici grandi e alle collezioni vuote.

**ES 28.5 — Verifica dell’ambiente**

*Scrivi uno script che verifichi l’ambiente di sviluppo di un
progetto: versione di Lua, versione di LuaRocks, presenza di tutte
le dipendenze dichiarate nel rockspec, e coerenza fra la versione di
Lua di LuaRocks e quella dell’interprete.*

```lua
local function esegui(comando)
  local f = io.popen(comando .. " 2>&1")
  if f == nil then return nil end
  local uscita = f:read("a")
  f:close()
  return (uscita:gsub("%s+$", ""))
end

local function analizzaRockspec(percorso)
  local f = io.open(percorso, "r")
  if f == nil then
    return nil, "rockspec non leggibile: " .. percorso
  end
  local testo = f:read("a")
  f:close()

  local ambiente = {}
  local chunk, errore = load(testo, "rockspec", "t",
    ambiente)
  if chunk == nil then
    return nil, "rockspec malformato: " .. errore
  end
  local ok, err = pcall(chunk)
  if not ok then
    return nil, "rockspec non eseguibile: "
      .. tostring(err)
  end

  return ambiente
end

local function confrontaVersioni(a, b)
  local ma, na = a:match("(%d+)%.(%d+)")
  local mb, nb = b:match("(%d+)%.(%d+)")
  if ma == nil or mb == nil then return nil end
  ma, na = tonumber(ma), tonumber(na)
  mb, nb = tonumber(mb), tonumber(nb)
  if ma ~= mb then return ma < mb and -1 or 1 end
  if na ~= nb then return na < nb and -1 or 1 end
  return 0
end

local problemi = {}
local avvisi = {}

print("=== ambiente Lua ===")
print("  _VERSION:        " .. _VERSION)
local versioneLua = _VERSION:match("(%d+%.%d+)")

local percorsi = 0
for _ in package.path:gmatch("[^;]+") do
  percorsi = percorsi + 1
end
print("  voci in package.path:  " .. percorsi)

local cpercorsi = 0
for _ in package.cpath:gmatch("[^;]+") do
  cpercorsi = cpercorsi + 1
end
print("  voci in package.cpath: " .. cpercorsi)

print()
print("=== LuaRocks ===")
local versioneRocks = esegui("luarocks --version")
if versioneRocks == nil
   or versioneRocks:find("not found") then
  problemi[#problemi + 1] = "luarocks non trovato "
    .. "nel PATH"
  print("  NON TROVATO")
else
  print("  " .. (versioneRocks:match("^[^\n]+") or "?"))

  local versioneConfigurata = esegui(
    "luarocks config lua_version")
  print("  configurato per Lua: "
    .. tostring(versioneConfigurata))

  if versioneConfigurata
     and versioneConfigurata ~= versioneLua then
    problemi[#problemi + 1] = string.format(
      "DISCORDANZA: luarocks e' configurato per Lua "
      .. "%s ma l'interprete e' %s",
      versioneConfigurata, versioneLua)
  end
end

print()
print("=== dipendenze dichiarate ===")

local ROCKSPEC = "/tmp/verifica_ambiente.rockspec"
local f = assert(io.open(ROCKSPEC, "w"))
f:write([[
package = "esempio"
version = "1.0.0-1"
source = {url = "git+https://example.com/x.git"}
dependencies = {
  "lua >= 5.3",
  "luafilesystem >= 1.8",
  "dkjson >= 2.5",
  "inspect",
}
build = {type = "builtin", modules = {}}
]])
f:close()

local spec, errore = analizzaRockspec(ROCKSPEC)
if spec == nil then
  problemi[#problemi + 1] = errore
else
  for _, dichiarata in ipairs(spec.dependencies or {}) do
    local nome, vincolo =
      dichiarata:match("^(%S+)%s*(.*)$")

    if nome == "lua" then
      local minimo = vincolo:match("(%d+%.%d+)")
      local esito = "?"
      if minimo then
        local c = confrontaVersioni(versioneLua, minimo)
        if c == nil then
          esito = "vincolo non interpretabile"
        elseif c < 0 then
          esito = "NON SODDISFATTO"
          problemi[#problemi + 1] = string.format(
            "serve Lua %s, presente %s",
            minimo, versioneLua)
        else
          esito = "ok"
        end
      end
      print(string.format("  %-18s %-14s %s",
        nome, vincolo, esito))
    else
      local ok = pcall(require, nome)
      if not ok then
        avvisi[#avvisi + 1] = "modulo non caricabile: "
          .. nome
      end
      print(string.format("  %-18s %-14s %s",
        nome, vincolo,
        ok and "presente" or "ASSENTE"))
    end
  end
end

os.remove(ROCKSPEC)

print()
print("=== esito ===")
if #problemi == 0 then
  print("  nessun problema bloccante")
else
  for _, p in ipairs(problemi) do
    print("  PROBLEMA: " .. p)
  end
end
for _, a in ipairs(avvisi) do
  print("  avviso:   " .. a)
end
```

Il controllo decisivo è quello sulla **discordanza di versione** fra
LuaRocks e l’interprete, che è la causa numero uno dei fallimenti di
`require` descritti nel paragrafo 28.2. Uno strumento che lo verifica
all’avvio del progetto risparmia ore di diagnosi.

Il rockspec viene analizzato eseguendolo con `load` in un ambiente
**vuoto**: è un file Lua, e le sue dichiarazioni diventano variabili
globali di quell’ambiente. È lo stesso meccanismo del Capitolo 20, ed è
il motivo per cui il formato dei rockspec è così semplice.

La verifica delle dipendenze usa `pcall(require, nome)`: è approssimata,
perché non controlla la versione installata, ma distingue il caso
«assente» da «presente», che è l’informazione che serve per primo.

**ES 28.6 — Usare una libreria dell’ecosistema**

*Prendi una delle librerie citate nel paragrafo 28.5, installala, e
scrivi un programma che ne usi almeno cinque funzioni diverse,
documentando che cosa la libreria offre in più rispetto a quanto
scrivereste a mano.*

L’esercizio chiedeva di installare una libreria e documentare che cosa
offre in più rispetto al codice scritto a mano. Prendiamo
**LuaFileSystem**, che è la dipendenza più diffusa in assoluto.

```lua
local lfs = require("lfs")

-- 1. Elencare una cartella
print("=== contenuto della cartella corrente ===")
for voce in lfs.dir(".") do
  if voce ~= "." and voce ~= ".." then
    local attributi = lfs.attributes(voce)
    if attributi then
      print(string.format("  %-30s %-10s %10d",
        voce, attributi.mode, attributi.size))
    end
  end
end

-- 2. Attributi completi di un file
print()
print("=== attributi ===")
local a = lfs.attributes("/etc/hosts")
if a then
  print("  modo:       " .. a.mode)
  print("  dimensione: " .. a.size)
  print("  modificato: "
    .. os.date("%Y-%m-%d %H:%M", a.modification))
  print("  permessi:   " .. tostring(a.permissions))
end

-- 3. Creare e rimuovere cartelle
print()
print("=== creazione ===")
local percorso = "/tmp/prova_lfs/annidata"
print("  mkdir ricorsivo a mano:")
local parziale = ""
for pezzo in percorso:gmatch("[^/]+") do
  parziale = parziale .. "/" .. pezzo
  local esiste = lfs.attributes(parziale, "mode")
  if esiste == nil then
    local ok, errore = lfs.mkdir(parziale)
    print("    creata " .. parziale .. ": "
      .. tostring(ok))
  end
end

-- 4. Cartella corrente
print()
print("=== cartella corrente ===")
local prima = lfs.currentdir()
print("  prima: " .. prima)
lfs.chdir("/tmp")
print("  dopo:  " .. lfs.currentdir())
lfs.chdir(prima)

-- 5. Ricorsione su un albero
print()
print("=== scansione ricorsiva ===")
local function scandisci(radice, profondita, fuori)
  fuori = fuori or {}
  profondita = profondita or 0
  if profondita > 5 then return fuori end

  for voce in lfs.dir(radice) do
    if voce ~= "." and voce ~= ".." then
      local completo = radice .. "/" .. voce
      local modo = lfs.attributes(completo, "mode")
      if modo == "directory" then
        fuori[#fuori + 1] = {tipo = "d",
          percorso = completo}
        scandisci(completo, profondita + 1, fuori)
      elseif modo == "file" then
        fuori[#fuori + 1] = {tipo = "f",
          percorso = completo}
      end
    end
  end
  return fuori
end

local voci = scandisci("/tmp/prova_lfs")
for _, v in ipairs(voci) do
  print("  " .. v.tipo .. " " .. v.percorso)
end

lfs.rmdir("/tmp/prova_lfs/annidata")
lfs.rmdir("/tmp/prova_lfs")
```

Che cosa offre rispetto al codice scritto a mano.

**L’elenco delle cartelle è impossibile in Lua puro.** Non esiste alcuna
funzione della libreria standard che lo faccia. L’alternativa senza
LuaFileSystem è `io.popen("ls")` su Unix e `io.popen("dir")` su Windows,
con tutti i problemi di portabilità, di analisi dell’output e di
sicurezza sui nomi che contengono spazi o caratteri speciali.

**Gli attributi sono altrettanto irraggiungibili.** Dimensione, data di
modifica, permessi, tipo di voce: nulla di questo è accessibile con `io`,
che sa solo aprire un file e dire se l’apertura è riuscita.

**La creazione e rimozione di cartelle** richiederebbe anch’essa
`os.execute` con i problemi di cui sopra.

**La cartella corrente** non è nemmeno leggibile in Lua puro.

Il rapporto costo-beneficio è quindi nettamente a favore della
dipendenza: LuaFileSystem fornisce capacità che **non si possono
riprodurre**, non semplicemente comodità. È la differenza fra una
dipendenza giustificata e una superflua.

**ES 28.7 — Candidati alternativi in ordine di preferenza**

*Estendi il caricatore dell’ES 28.2 perché supporti più candidati
alternativi per la stessa funzionalità, provandoli in ordine di
preferenza, e riporti quale è stato effettivamente scelto.*

```lua
local Dipendenze = {}
Dipendenze.__index = Dipendenze

function Dipendenze.nuove()
  return setmetatable({
    risolte = {},
    tentativi = {},
  }, Dipendenze)
end

function Dipendenze:risolvi(nomeLogico, candidati)
  if self.risolte[nomeLogico] ~= nil then
    return self.risolte[nomeLogico].modulo,
           self.risolte[nomeLogico].scelto
  end

  local storia = {}

  for _, c in ipairs(candidati) do
    if c.ricaduta then
      local modulo = c.ricaduta()
      storia[#storia + 1] = {nome = c.nome,
        esito = "ricaduta usata"}
      self.tentativi[nomeLogico] = storia
      self.risolte[nomeLogico] = {modulo = modulo,
        scelto = c.nome}
      return modulo, c.nome
    end

    local ok, modulo = pcall(require, c.nome)

    if not ok then
      storia[#storia + 1] = {nome = c.nome,
        esito = "non installato"}
    elseif type(modulo) == "boolean" then
      storia[#storia + 1] = {nome = c.nome,
        esito = "caricato ma non restituisce nulla"}
    elseif c.verifica then
      local valido, motivo = c.verifica(modulo)
      if valido then
        storia[#storia + 1] = {nome = c.nome,
          esito = "SCELTO"}
        self.tentativi[nomeLogico] = storia
        self.risolte[nomeLogico] = {
          modulo = c.adatta and c.adatta(modulo)
            or modulo,
          scelto = c.nome,
        }
        return self.risolte[nomeLogico].modulo, c.nome
      end
      storia[#storia + 1] = {nome = c.nome,
        esito = "verifica fallita: "
          .. tostring(motivo)}
    else
      storia[#storia + 1] = {nome = c.nome,
        esito = "SCELTO"}
      self.tentativi[nomeLogico] = storia
      self.risolte[nomeLogico] = {
        modulo = c.adatta and c.adatta(modulo)
          or modulo,
        scelto = c.nome,
      }
      return self.risolte[nomeLogico].modulo, c.nome
    end
  end

  self.tentativi[nomeLogico] = storia
  return nil, "nessun candidato disponibile"
end

function Dipendenze:rapporto(nomeLogico)
  local righe = {"risoluzione di '" .. nomeLogico .. "':"}
  for i, t in ipairs(self.tentativi[nomeLogico] or {}) do
    righe[#righe + 1] = string.format("  %d. %-14s %s",
      i, t.nome, t.esito)
  end
  local r = self.risolte[nomeLogico]
  righe[#righe + 1] = "  => " .. (r and r.scelto
    or "NESSUNO")
  return table.concat(righe, "\n")
end

local dip = Dipendenze.nuove()

local json = dip:risolvi("json", {
  {nome = "cjson",
   verifica = function(m)
     if type(m.encode) ~= "function" then
       return false, "manca encode"
     end
     return true
   end},
  {nome = "dkjson",
   verifica = function(m)
     if type(m.encode) ~= "function" then
       return false, "manca encode"
     end
     return true
   end,
   adatta = function(m)
     return {encode = m.encode, decode = m.decode}
   end},
  {nome = "json",
   verifica = function(m)
     return type(m.encode) == "function"
   end},
  {nome = "(interno)",
   ricaduta = function()
     local function codifica(v)
       local t = type(v)
       if v == nil then return "null" end
       if t == "boolean" or t == "number" then
         return tostring(v)
       end
       if t == "string" then
         return '"' .. v:gsub('"', '\\"') .. '"'
       end
       if t ~= "table" then return "null" end
       local n = #v
       local pezzi = {}
       if n > 0 then
         for i = 1, n do pezzi[i] = codifica(v[i]) end
         return "[" .. table.concat(pezzi, ",") .. "]"
       end
       local chiavi = {}
       for k in pairs(v) do chiavi[#chiavi + 1] = k end
       table.sort(chiavi, function(a, b)
         return tostring(a) < tostring(b)
       end)
       for _, k in ipairs(chiavi) do
         pezzi[#pezzi + 1] = codifica(tostring(k))
           .. ":" .. codifica(v[k])
       end
       return "{" .. table.concat(pezzi, ",") .. "}"
     end
     return {encode = codifica, _ricaduta = true}
   end},
})

print(dip:rapporto("json"))
print()
print("uso: " .. json.encode({
  nome = "prova", valori = {1, 2, 3}, attivo = true,
}))
print("e' la ricaduta interna: "
  .. tostring(json._ricaduta == true))
```

produce, su un sistema senza alcuna libreria JSON installata:

```text
risoluzione di 'json':
  1. cjson          non installato
  2. dkjson         non installato
  3. json           non installato
  4. (interno)      ricaduta usata
  => (interno)

uso: {"attivo":true,"nome":"prova",
"valori":[1,2,3]}
e' la ricaduta interna: true
```

Tre elementi progettuali.

I candidati sono provati **nell’ordine dichiarato**, che esprime la
preferenza: prima il più veloce, poi i più portabili, infine la ricaduta
interna.

Il campo `adatta` permette di **uniformare l’interfaccia**: se due
librerie offrono la stessa funzionalità con nomi diversi, l’adattatore
le riporta a un’interfaccia comune, e il resto del programma non sa quale
sia stata scelta.

Il rapporto documenta **ogni tentativo con il suo esito**, non solo la
scelta finale. È l’informazione che serve quando un utente segnala che il
programma è lento: sapere che ha ripiegato sulla ricaduta interna invece
di usare `cjson` risolve il caso in un secondo.

**ES 28.8 — Progetto con busted, luacheck e luacov**

*Configura un progetto con `busted`, `luacheck` e `luacov`, scrivi un
`Makefile` con i bersagli per test, analisi e copertura, e verifica
che l’analizzatore statico segnali una variabile globale introdotta
di proposito.*

La struttura completa:

```text
progetto/
  progetto-1.0.0-1.rockspec
  Makefile
  .luacheckrc
  .luacov
  src/
    progetto.lua
  spec/
    progetto_spec.lua
```

Il `Makefile`:

```text
LUA ?= lua
TREE ?= ./moduli

.PHONY: tutto lint test copertura pulisci deps

tutto: lint test

deps:
	luarocks install --tree=$(TREE) busted
	luarocks install --tree=$(TREE) luacheck
	luarocks install --tree=$(TREE) luacov

lint:
	@echo "--- analisi statica ---"
	luacheck src spec

test:
	@echo "--- test ---"
	busted --verbose

copertura:
	@echo "--- copertura ---"
	busted --coverage
	luacov
	@tail -25 luacov.report.out

pulisci:
	rm -f luacov.stats.out luacov.report.out
```

Il file `.luacheckrc`:

```lua
std = "lua54"
max_line_length = 79
codes = true

files["spec/**/*.lua"] = {
  std = "+busted",
}

exclude_files = {
  "moduli/**",
  ".luarocks/**",
}
```

Il modulo con l’errore introdotto di proposito:

```lua
local M = {}

function M.somma(a, b)
  return a + b
end

function M.media(elenco)
  if #elenco == 0 then return nil, "elenco vuoto" end
  local totale = 0
  for i = 1, #elenco do
    totale = totale + elenco[i]
  end
  return totale / #elenco
end

function M.calcolaSbagliata(x)
  -- ERRORE DI PROPOSITO: manca 'local'
  risultato = x * 2
  return risultato
end

function M.conVariabileInutile(x)
  local mai_usata = x * 100
  return x + 1
end

return M
```

Eseguendo `luacheck src` si ottiene:

```text
Checking src/progetto.lua                    2 warnings

    src/progetto.lua:18:3: (W111) setting non-standard
    global variable 'risultato'
    src/progetto.lua:23:9: (W211) unused variable
    'mai_usata'

Total: 2 warnings / 0 errors in 1 file
```

La prima segnalazione è quella che l’esercizio chiedeva di verificare, ed
è il tipo di errore che **nessun test intercetta**: la funzione
restituisce il valore giusto e i test passano. Ma la variabile globale
resta, è condivisa fra tutte le chiamate, e in un programma con coroutine
o con più moduli produce interferenze difficilissime da diagnosticare.

La seconda segnalazione è meno grave ma altrettanto utile: una variabile
calcolata e mai usata è quasi sempre il residuo di una modifica
incompleta, e talvolta il sintomo di una riga dimenticata.

L’ordine dei bersagli nel `Makefile` non è casuale: `lint` viene prima di
`test`, secondo il consiglio del paragrafo 29.4. L’analisi statica è
istantanea e intercetta gli errori più stupidi; far girare prima i test
significa aspettare per scoprire un errore di battitura.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
