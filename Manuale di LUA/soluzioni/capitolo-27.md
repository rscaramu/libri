# Capitolo 27 — LuaJIT: prestazioni, FFI, differenze

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 26](capitolo-26.md) · [Indice](README.md) · [Capitolo 28 →](capitolo-28.md)

I 4 sorgenti eseguibili di questo capitolo sono in
[`codice/cap27/`](../codice/cap27/).

---

**ES 27.4 — Rapporto delle differenze fra implementazioni**

*Scrivi un programma che, eseguito sia su Lua 5.4 sia su LuaJIT,
stampi un rapporto completo delle differenze osservate: presenza
degli interi, comportamento di `1/0` e `0/0`, risultato di
`math.floor(2^53)`, presenza di `table.pack`, formato di
`string.format("%q", ...)`.*

```lua
local function prova(nome, codice)
  local f, errore = load("return " .. codice)
  if f == nil then
    f, errore = load(codice)
  end
  if f == nil then
    return nome, "ERRORE DI SINTASSI"
  end
  local ok, r = pcall(f)
  if not ok then
    return nome, "errore: " .. tostring(r)
  end
  return nome, tostring(r)
end

local CASI = {
  {"presenza di math.type", "math.type ~= nil"},
  {"math.type(1)", "math.type and math.type(1)"},
  {"math.type(1.0)", "math.type and math.type(1.0)"},
  {"1/0", "1/0"},
  {"-1/0", "-1/0"},
  {"0/0 e' NaN", "0/0 ~= 0/0"},
  {"3/1", "3/1"},
  {"2^2", "2^2"},
  {"math.floor(2^53)", "math.floor(2^53)"},
  {"2^53 == 2^53+1", "2^53 == 2^53+1"},
  {"maxinteger", "math.maxinteger"},
  {"maxinteger + 1", "math.maxinteger and " ..
    "math.maxinteger + 1"},
  {"table.pack presente", "table.pack ~= nil"},
  {"unpack globale", "rawget(_G, 'unpack') ~= nil"},
  {"table.unpack presente", "table.unpack ~= nil"},
  {"format %q su 1/3", "string.format('%q', 1/3)"},
  {"format %q su a\\nb",
    "string.format('%q', 'a\\nb')"},
  {"tostring(0.1)", "tostring(0.1)"},
  {"tostring(1e300*1e300)", "tostring(1e300*1e300)"},
  {"utf8 presente", "utf8 ~= nil"},
  {"bit presente", "rawget(_G, 'bit') ~= nil"},
  {"jit presente", "rawget(_G, 'jit') ~= nil"},
  {"setfenv presente",
    "rawget(_G, 'setfenv') ~= nil"},
  {"divisione intera", "17 // 5"},
  {"operatore and bit a bit", "5 & 3"},
  {"attributo const", "local x <const> = 1 return x"},
  {"goto", "do goto x ::x:: end return 'ok'"},
  {"_ENV", "_ENV ~= nil"},
  {"warn presente", "rawget(_G, 'warn') ~= nil"},
  {"coroutine.close", "coroutine.close ~= nil"},
  {"table.create", "table.create ~= nil"},
  {"os.date campo isdst",
    "tostring(os.date('*t').isdst)"},
}

print("_VERSION = " .. _VERSION)
local j = rawget(_G, "jit")
if j then print("jit.version = " .. j.version) end
print(string.rep("-", 56))

for _, c in ipairs(CASI) do
  local nome, risultato = prova(c[1], c[2])
  print(string.format("%-26s %s", nome, risultato))
end
```

produce, su Lua 5.4:

```text
_VERSION = Lua 5.4
--------------------------------------------------------
presenza di math.type      true
math.type(1)               integer
math.type(1.0)             float
1/0                        inf
-1/0                       -inf
0/0 e' NaN                 true
3/1                        3.0
2^2                        4.0
math.floor(2^53)           9007199254740992
2^53 == 2^53+1             true
maxinteger                 9223372036854775807
maxinteger + 1             -9223372036854775808
table.pack presente        true
unpack globale             false
table.unpack presente      true
format %q su 1/3           0x1.5555555555555p-2
format %q su a\nb          "a\
b"
tostring(0.1)              0.1
tostring(1e300*1e300)      inf
utf8 presente              true
bit presente               false
jit presente               false
setfenv presente           false
divisione intera           3
operatore and bit a bit    1
attributo const            1
goto                       ok
_ENV                       true
warn presente              true
coroutine.close            true
table.create               false
os.date campo isdst        false
```

Su LuaJIT 2.1 i risultati differirebbero in modo prevedibile: `math.type`
assente, `3/1` uguale a `3`, `math.maxinteger` assente, `bit` e `jit`
presenti, `setfenv` presente, e gli ultimi cinque casi
sintattici — divisione intera, operatore bit a bit, attributo `const` —
segnalati come errore di sintassi.

Il caso `2^53 == 2^53+1` è quello che riserva la sorpresa: risulta
**vero anche su Lua 5.4**, dove ci si aspetterebbe che due interi
distinti siano diversi.

La ragione sta nell’operatore `^`, che in Lua restituisce **sempre un
float**, anche quando gli operandi sono interi e il risultato è esatto.
`2^53` è quindi un float, e `2^53 + 1` è un’addizione in virgola mobile
che non cambia il valore, perché due elevato alla cinquantatreesima è il
primo intero il cui successore non è rappresentabile in doppia
precisione.

Scrivendo `math.tointeger(2^53) == math.tointeger(2^53) + 1` il
risultato sarebbe `false`, perché l’aritmetica sarebbe intera. È un
promemoria utile: in Lua l’elevamento a potenza è un’operazione in
virgola mobile, e usarla per calcolare potenze di due destinate a essere
interi introduce silenziosamente la semantica dei float.

La struttura del programma merita una nota: ogni caso è compilato con
`load` **separatamente**, così che un errore di sintassi in uno non
impedisca l’esecuzione degli altri. Scrivere `17 // 5` direttamente nel
sorgente renderebbe l’intero file non compilabile su LuaJIT, che è
esattamente il problema che il programma vuole diagnosticare.

**ES 27.5 — Riscrittura portabile**

*Prendi una funzione qualunque scritta nei capitoli precedenti che
usi interi, `//` o operatori bit a bit e riscrivila in forma
portabile. Verifica che i risultati coincidano su almeno venti casi
di prova.*

```lua
local function operazioniBit()
  local bit = rawget(_G, "bit") or rawget(_G, "bit32")
  if bit then
    return bit.band, bit.bor, bit.bxor,
           bit.lshift, bit.rshift
  end
  if math.type then
    local f = load([[
      return function(a,b) return a & b end,
             function(a,b) return a | b end,
             function(a,b) return a ~ b end,
             function(a,n) return a << n end,
             function(a,n) return a >> n end
    ]])
    return f()
  end
  local function bin(a, b, op)
    local r, p = 0, 1
    while a > 0 or b > 0 do
      if op(a % 2, b % 2) == 1 then r = r + p end
      a = math.floor(a / 2)
      b = math.floor(b / 2)
      p = p * 2
    end
    return r
  end
  return
    function(a, b) return bin(a, b, function(x, y)
      return (x == 1 and y == 1) and 1 or 0 end) end,
    function(a, b) return bin(a, b, function(x, y)
      return (x == 1 or y == 1) and 1 or 0 end) end,
    function(a, b) return bin(a, b, function(x, y)
      return x ~= y and 1 or 0 end) end,
    function(a, n) return math.floor(a * 2 ^ n) end,
    function(a, n) return math.floor(a / 2 ^ n) end
end

local band, bor, bxor, lshift, rshift = operazioniBit()

local function divInt(a, b)
  return math.floor(a / b)
end

-- Versione ORIGINALE, solo Lua 5.3+
local function coloreOriginale(r, g, b)
  return (r << 16) | (g << 8) | b
end

local function componentiOriginale(colore)
  return (colore >> 16) & 255,
         (colore >> 8) & 255,
         colore & 255
end

-- Versione PORTABILE
local function colorePortabile(r, g, b)
  return bor(bor(lshift(r, 16), lshift(g, 8)), b)
end

local function componentiPortabile(colore)
  return band(rshift(colore, 16), 255),
         band(rshift(colore, 8), 255),
         band(colore, 255)
end

local function checksumOriginale(s)
  local h = 5381
  for i = 1, #s do
    h = ((h << 5) + h + s:byte(i)) & 0xFFFFFFFF
  end
  return h
end

local function checksumPortabile(s)
  local h = 5381
  for i = 1, #s do
    h = band(lshift(h, 5) + h + s:byte(i), 0xFFFFFFFF)
  end
  return h
end

print(string.format("%-8s %-8s %-8s %-12s %-12s %s",
  "R", "G", "B", "ORIGINALE", "PORTABILE", "ESITO"))

math.randomseed(7)
local errori = 0

for prova = 1, 20 do
  local r, g, b
  if prova <= 6 then
    local fissi = {
      {0, 0, 0}, {255, 255, 255}, {255, 0, 0},
      {0, 255, 0}, {0, 0, 255}, {128, 64, 32},
    }
    r, g, b = table.unpack(fissi[prova])
  else
    r = math.random(0, 255)
    g = math.random(0, 255)
    b = math.random(0, 255)
  end

  local o = coloreOriginale(r, g, b)
  local p = colorePortabile(r, g, b)

  local ro, go, bo = componentiOriginale(o)
  local rp, gp, bp = componentiPortabile(p)

  local ok = o == p and ro == rp and go == gp
    and bo == bp and ro == r and go == g and bo == b
  if not ok then errori = errori + 1 end

  print(string.format("%-8d %-8d %-8d %-12d %-12d %s",
    r, g, b, o, p, ok and "ok" or "DIVERSI"))
end

print()
local testi = {"", "a", "Lua", "programmazione",
  string.rep("x", 100)}
for _, t in ipairs(testi) do
  local a = checksumOriginale(t)
  local b = checksumPortabile(t)
  print(string.format("checksum %-18s %12d %12d %s",
    "[" .. t:sub(1, 14) .. "]", a, b,
    a == b and "ok" or "DIVERSI"))
end

print()
print("divisione intera:")
for _, coppia in ipairs({{17, 5}, {-7, 2}, {7, -2},
    {-7, -2}, {0, 3}}) do
  local a, b = coppia[1], coppia[2]
  local originale = load("return " .. a .. " // " .. b)
  local o = originale and originale() or "n/d"
  local p = divInt(a, b)
  print(string.format("  %3d // %3d = %-6s %-6s %s",
    a, b, tostring(o), tostring(p),
    tostring(o) == tostring(p) and "ok" or "DIVERSI"))
end
print()
print("errori totali: " .. errori)
```

Le venti verifiche sui colori e le cinque sui checksum devono dare
risultati identici fra le due versioni.

La divisione intera merita attenzione: `math.floor(a / b)` riproduce
correttamente la semantica di `//` sui negativi, perché entrambe
arrotondano verso il basso. Sui cinque casi provati, compresi tutti i
segni, i risultati coincidono anche nel **tipo**, perché in Lua 5.3 e
successivi `math.floor` restituisce un intero quando il risultato è
rappresentabile.

Su LuaJIT, dove gli interi non esistono, la stessa espressione produce un
float. Il codice resta corretto nel valore, ma chi usa il risultato come
chiave di tabella, lo passa a `string.format("%d", ...)` o lo confronta
con `tostring` scoprirà la differenza. È il limite dichiarato nel
Capitolo 27: senza interi la portabilità completa è impossibile, e ciò
che si può garantire è il valore, non il tipo.

**ES 27.6 — table.insert contro assegnazione diretta**

*Scrivi un banco di prova che misuri il costo di `table.insert`
contro l’assegnazione diretta a `t[#t + 1]`, e commenta perché il
rapporto fra le due può differire fra PUC-Lua e LuaJIT.*

```lua
local N = 3000000

local prove = {
  {"t[#t + 1] = v", function()
    local t = {}
    for i = 1, N do t[#t + 1] = i end
    return #t
  end},
  {"table.insert(t, v)", function()
    local t = {}
    for i = 1, N do table.insert(t, i) end
    return #t
  end},
  {"table.insert localizzata", function()
    local inserisci = table.insert
    local t = {}
    for i = 1, N do inserisci(t, i) end
    return #t
  end},
  {"indice esplicito", function()
    local t = {}
    local n = 0
    for i = 1, N do
      n = n + 1
      t[n] = i
    end
    return n
  end},
}

local riferimento
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or durata
  print(string.format("%-28s %.4f s  %5.2fx  (%d)",
    p[1], durata, durata / riferimento, r))
end
```

Su PUC-Lua l’ordine tipico è: indice esplicito il più veloce,
`t[#t + 1]` poco dietro, `table.insert` sensibilmente più lento perché è
una chiamata a una funzione C che deve anche decidere se è stata invocata
con due o tre argomenti.

La localizzazione di `table.insert` riduce la differenza ma non la
elimina: risparmia la ricerca del campo, non la chiamata.

**Su LuaJIT il rapporto può essere diverso**, e la ragione è
interessante. Il compilatore a tracce riconosce `t[#t + 1] = v` come un
motivo noto e lo compila in modo molto efficiente, mentre le chiamate a
funzioni C sono più difficili da inserire nella traccia. Il divario fra
le due forme tende quindi ad **aumentare** su LuaJIT invece di ridursi.

L’indice esplicito è il più veloce ovunque, perché evita anche il calcolo
di `#t`, che pur essendo logaritmico non è gratuito. È la forma da usare
nei cicli caldi, a costo di una variabile in più.

**ES 27.7 — Funzioni NYI**

*Documenta, cercando nella documentazione ufficiale di LuaJIT, almeno
cinque funzioni della libreria standard classificate come NYI, e
spiega per ciascuna quale alternativa compilabile esiste.*

Le funzioni classificate come NYI variano fra le versioni di LuaJIT, e
l’elenco autorevole è quello sul sito del progetto. Cinque casi
storicamente rilevanti, con le alternative.

**`string.gmatch`.** L’iterazione sui pattern non è compilabile. In un
ciclo caldo che analizza molte righe, la traccia si interrompe a ogni
iterazione. L’alternativa è `string.find` con posizione esplicita in un
ciclo `while`, che è compilabile, oppure spostare l’analisi fuori dal
percorso caldo elaborando i dati una volta e memorizzando il risultato.

**`table.sort` con funzione di confronto.** L’ordinamento chiama la
funzione di confronto dal C, e quella chiamata interrompe la traccia.
L’alternativa è la tecnica *decora, ordina, spoglia* dell’ES 11.8, che
riduce i confronti a quelli sulla chiave precalcolata, oppure ordinare
fuori dal ciclo caldo.

**`pcall` in certi contesti.** Nelle versioni più vecchie di LuaJIT
`pcall` non era compilabile affatto; nella 2.1 lo è in molti casi ma non
in tutti. L’alternativa è spostare la protezione all’esterno del ciclo:
proteggere l’intero blocco invece di ogni iterazione.

**`select` con un indice variabile.** `select("#", ...)` è compilabile,
`select(n, ...)` con `n` calcolato non lo è. L’alternativa è
`table.pack` una volta sola fuori dal ciclo e l’accesso per indice
alla tabella risultante.

**`coroutine.resume` e `coroutine.yield`.** Lo scambio di controllo non è
compilabile, e una traccia non può attraversare una sospensione.
L’alternativa, quando le prestazioni contano, è ristrutturare
l’algoritmo per non usare coroutine nel percorso caldo, per esempio
raccogliendo i dati in una tabella e iterandola normalmente.

Il metodo per verificarli resta quello del paragrafo 27.3: eseguire con
`luajit -jv` e leggere i messaggi di interruzione della traccia, che
nominano la funzione responsabile.

**ES 27.8 — Strato di compatibilità per `<close>`**

*Scrivi uno strato di compatibilità per `<close>`: una funzione
`conRisorsa` che su Lua 5.4 usi l’attributo e su LuaJIT usi `pcall`
più rilascio esplicito, con la stessa interfaccia e le stesse
garanzie in caso di errore.*

```lua
local haClose = load("local x <close> = nil") ~= nil

local function verificaChiudibile(risorsa)
  if type(risorsa) == "table" then
    local m = getmetatable(risorsa)
    if m and type(m.__close) == "function" then
      return true
    end
    if type(risorsa.chiudi) == "function" then
      return true
    end
  end
  return false, "la risorsa deve avere __close "
    .. "o un metodo chiudi"
end

local function chiudi(risorsa, errore)
  local m = getmetatable(risorsa)
  if m and type(m.__close) == "function" then
    return m.__close(risorsa, errore)
  end
  return risorsa:chiudi(errore)
end

local conRisorsa

if haClose then
  conRisorsa = load([[
    local verifica, chiudi = ...
    return function(costruttore, azione)
      local risorsa, errore = costruttore()
      if risorsa == nil then
        return nil, errore or "costruzione fallita"
      end
      local ok, motivo = verifica(risorsa)
      if not ok then
        -- non si chiude cio' che non e' chiudibile
        return nil, motivo
      end
      local guardia <close> = risorsa
      return azione(risorsa)
    end
  ]])(verificaChiudibile, chiudi)
else
  conRisorsa = function(costruttore, azione)
    local risorsa, errore = costruttore()
    if risorsa == nil then
      return nil, errore or "costruzione fallita"
    end
    local ok, motivo = verificaChiudibile(risorsa)
    if not ok then
      return nil, motivo
    end

    local risultati = table.pack(pcall(azione, risorsa))

    local okChiusura, erroreChiusura = pcall(chiudi,
      risorsa, risultati[1] and nil or risultati[2])

    if not risultati[1] then
      error(risultati[2], 0)
    end
    if not okChiusura then
      error(erroreChiusura, 0)
    end
    return table.unpack(risultati, 2, risultati.n)
  end
end

-- Prove
local eventi = {}

local function creaRisorsa(nome)
  return setmetatable({nome = nome}, {
    __close = function(r, errore)
      eventi[#eventi + 1] = string.format(
        "chiusa %s (errore: %s)", r.nome,
        tostring(errore))
    end,
    __index = {
      usa = function(r) return "uso di " .. r.nome end,
    },
  })
end

print("implementazione: "
  .. (haClose and "nativa con <close>"
    or "simulata con pcall"))
print()

eventi = {}
local r = conRisorsa(
  function() return creaRisorsa("A") end,
  function(risorsa) return risorsa:usa(), "secondo" end)
print("uso normale: " .. tostring(r))
for _, e in ipairs(eventi) do print("  " .. e) end

print()
eventi = {}
local ok, errore = pcall(conRisorsa,
  function() return creaRisorsa("B") end,
  function() error("guasto nell'azione", 0) end)
print("con errore: ok=" .. tostring(ok)
  .. " errore=" .. tostring(errore))
for _, e in ipairs(eventi) do print("  " .. e) end

print()
eventi = {}
print("costruzione fallita: "
  .. tostring(select(2, conRisorsa(
    function() return nil, "risorsa non disponibile" end,
    function() return "mai" end))))

print()
eventi = {}
print("risorsa non chiudibile: "
  .. tostring(select(2, conRisorsa(
    function() return {} end,
    function() return "mai" end))))
```

produce, su Lua 5.4:

```text
implementazione: nativa con <close>

uso normale: uso di A
  chiusa A (errore: nil)

con errore: ok=false errore=guasto nell'azione
  chiusa B (errore: guasto nell'azione)

costruzione fallita: risorsa non disponibile

risorsa non chiudibile: la risorsa deve avere __close
o un metodo chiudi
```

La garanzia offerta è la stessa nelle due implementazioni: la risorsa
viene chiusa sia in caso di successo sia in caso di errore, e l’errore si
propaga al chiamante dopo la chiusura. Notate che il metametodo `__close`
riceve **il motivo dell’errore** come secondo argomento, il che permette
a una risorsa di comportarsi diversamente a seconda che la chiusura
avvenga per uscita ordinata o per guasto: una transazione, per esempio,
si confermerebbe nel primo caso e si annullerebbe nel secondo.

Ci sono però due differenze da dichiarare.

Nella versione simulata la chiusura avviene **dopo** che `pcall` ha già
srotolato lo stack, quindi il messaggio d’errore non contiene più la
traccia del punto originale a meno di catturarla con `xpcall`. Con
`<close>` nativo la chiusura avviene durante lo srotolamento.

La versione simulata non gestisce l’uscita per `break` o `goto` da un
ciclo che circondi la chiamata, perché non c’è alcun ciclo: la funzione
non può essere interrotta a metà. Con `<close>` nativo, invece, uscire da
un blocco in qualunque modo chiude la variabile.

Il codice che usa `<close>` è compilato con `load` per la ragione del
paragrafo 27.2: scriverlo direttamente nel sorgente lo renderebbe non
compilabile su LuaJIT, e l’errore sarebbe di sintassi, non catturabile.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
