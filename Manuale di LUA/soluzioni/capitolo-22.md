# Capitolo 22 — Le coroutine: concorrenza cooperativa

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 21](capitolo-21.md) · [Indice](README.md) · [Capitolo 23 →](capitolo-23.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap22/`](../codice/cap22/).

---

**ES 22.4 — Permutazioni come iteratore**

*Scrivi un iteratore basato su coroutine che produca tutte le
permutazioni di una sequenza, e usalo per trovare la prima
permutazione che soddisfa una condizione, interrompendo la
generazione.*

```lua
local function permutazioni(sequenza)
  local n = #sequenza

  return coroutine.wrap(function()
    local corrente = {}
    local usati = {}

    local function passo(profondita)
      if profondita > n then
        local copia = {}
        table.move(corrente, 1, n, 1, copia)
        coroutine.yield(copia)
        return
      end
      for i = 1, n do
        if not usati[i] then
          usati[i] = true
          corrente[profondita] = sequenza[i]
          passo(profondita + 1)
          usati[i] = false
        end
      end
    end

    passo(1)
  end)
end

local function testo(t)
  return table.concat(t, "")
end

io.write("tutte le permutazioni di abc: ")
for p in permutazioni({"a", "b", "c"}) do
  io.write(testo(p), " ")
end
io.write("\n")

-- Ricerca con interruzione
local numeri = {1, 2, 3, 4, 5, 6, 7}
local esaminate = 0
local trovata = nil

for p in permutazioni(numeri) do
  esaminate = esaminate + 1
  -- Cerchiamo la prima permutazione in cui
  -- ogni elemento e' diverso dalla sua posizione
  local ok = true
  for i = 1, #p do
    if p[i] == i then ok = false break end
  end
  if ok then
    trovata = p
    break
  end
end

print("permutazioni esaminate: " .. esaminate)
print("trovata: " .. table.concat(trovata, " "))

local totali = 1
for i = 2, #numeri do totali = totali * i end
print("permutazioni totali possibili: " .. totali)
print(string.format("risparmio: %.2f%%",
  (1 - esaminate / totali) * 100))
```

produce:

```text
tutte le permutazioni di abc: abc acb bac bca cab cba
permutazioni esaminate: 748
trovata: 2 1 4 3 6 7 5
permutazioni totali possibili: 5040
risparmio: 85.16%
```

Il punto della tecnica è nell’ultima parte: la ricerca si ferma alla
settecentoquarantottesima permutazione su cinquemilaquaranta possibili,
risparmiando l’ottantacinque per cento del lavoro.

Con una funzione che restituisse la **lista completa** delle
permutazioni, tutte e cinquemilaquaranta verrebbero generate e
memorizzate prima di poterne esaminare una sola. Su sequenze di dieci
elementi le permutazioni sono oltre tre milioni, e la lista non starebbe
in memoria.

La copia della permutazione corrente prima di `yield` è necessaria: senza,
il chiamante riceverebbe un riferimento alla tabella di lavoro, che il
generatore continua a modificare.

**ES 22.5 — Coda di lavoro con priorità**

*Implementa una coda di lavoro con priorità basata su coroutine, in
cui ogni compito dichiara la propria priorità cedendo il controllo,
e lo schedulatore esegue sempre il compito pronto con priorità più
alta.*

```lua
local Schedulatore = {}
Schedulatore.__index = Schedulatore

function Schedulatore.nuovo()
  return setmetatable({
    compiti = {},
    prossimoId = 0,
    passi = 0,
  }, Schedulatore)
end

function Schedulatore:aggiungi(nome, priorita, funzione)
  self.prossimoId = self.prossimoId + 1
  self.compiti[#self.compiti + 1] = {
    id = self.prossimoId,
    nome = nome,
    priorita = priorita,
    co = coroutine.create(funzione),
    pronto = true,
  }
  return self.prossimoId
end

function Schedulatore:prossimo()
  local migliore = nil
  for _, c in ipairs(self.compiti) do
    if c.pronto
       and coroutine.status(c.co) == "suspended" then
      if migliore == nil
         or c.priorita > migliore.priorita
         or (c.priorita == migliore.priorita
             and c.id < migliore.id) then
        migliore = c
      end
    end
  end
  return migliore
end

function Schedulatore:esegui(massimo)
  massimo = massimo or 1000
  local traccia = {}

  while self.passi < massimo do
    local c = self:prossimo()
    if c == nil then break end

    self.passi = self.passi + 1
    local ok, nuovaPriorita = coroutine.resume(c.co,
      c.priorita)

    if not ok then
      traccia[#traccia + 1] = string.format(
        "%s ERRORE: %s", c.nome, tostring(nuovaPriorita))
      c.pronto = false
    elseif coroutine.status(c.co) == "dead" then
      traccia[#traccia + 1] = c.nome .. " terminato"
      c.pronto = false
    else
      traccia[#traccia + 1] = string.format(
        "%s (p=%d)", c.nome, c.priorita)
      if type(nuovaPriorita) == "number" then
        c.priorita = nuovaPriorita
      end
    end
  end

  return traccia
end

local s = Schedulatore.nuovo()

s:aggiungi("urgente", 10, function()
  for i = 1, 3 do
    coroutine.yield(10)
  end
end)

s:aggiungi("normale", 5, function()
  for i = 1, 3 do
    coroutine.yield(5)
  end
end)

s:aggiungi("crescente", 1, function(p)
  for i = 1, 4 do
    p = coroutine.yield(p + 4)
  end
end)

s:aggiungi("rotto", 8, function()
  coroutine.yield(8)
  error("compito difettoso")
end)

for i, riga in ipairs(s:esegui(30)) do
  print(string.format("%2d. %s", i, riga))
end
```

Lo schedulatore sceglie sempre il compito **pronto con priorità più
alta**, e a parità di priorità quello con identificatore minore, che
garantisce un ordine deterministico.

Il compito «crescente» parte con priorità uno e la aumenta a ogni
sospensione restituendo un valore maggiore: dopo alcuni passi supera gli
altri e viene eseguito per primo. È il meccanismo di
*invecchiamento* che si usa nei sistemi reali per evitare che i compiti
a bassa priorità restino indefinitamente in attesa.

Il compito difettoso viene rimosso dopo l’errore, senza abbattere lo
schedulatore: `coroutine.resume` restituisce `false` e il controllo torna
al ciclo.

**ES 22.6 — Costo dello scambio di controllo**

*Confronta con `os.clock` il costo di un milione di scambi di
controllo fra due coroutine, di un milione di chiamate di funzione
ordinarie e di un milione di iterazioni di un `for` numerico.
Commenta i rapporti ottenuti.*

```lua
local N = 1000000

local function misura(nome, f)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f()
  local durata = os.clock() - inizio
  return {nome = nome, durata = durata, risultato = r}
end

local prove = {}

prove[#prove + 1] = misura("ciclo for puro", function()
  local s = 0
  for i = 1, N do s = s + 1 end
  return s
end)

local function unaFunzione() return 1 end
prove[#prove + 1] = misura("chiamata di funzione",
  function()
    local s = 0
    for i = 1, N do s = s + unaFunzione() end
    return s
  end)

prove[#prove + 1] = misura("coroutine.wrap", function()
  local co = coroutine.wrap(function()
    while true do coroutine.yield(1) end
  end)
  local s = 0
  for i = 1, N do s = s + co() end
  return s
end)

prove[#prove + 1] = misura("resume esplicito", function()
  local co = coroutine.create(function()
    while true do coroutine.yield(1) end
  end)
  local s = 0
  for i = 1, N do
    local ok, v = coroutine.resume(co)
    s = s + v
  end
  return s
end)

local riferimento = prove[1].durata
for _, p in ipairs(prove) do
  print(string.format("%-24s %.4f s  %6.2fx  (%d)",
    p.nome, p.durata, p.durata / riferimento,
    p.risultato))
end

collectgarbage("collect")
local prima = collectgarbage("count")
local coroutines = {}
for i = 1, 10000 do
  coroutines[i] = coroutine.create(function()
    coroutine.yield()
  end)
  coroutine.resume(coroutines[i])
end
collectgarbage("collect")
local dopo = collectgarbage("count")
print(string.format(
  "10000 coroutine sospese: %.0f KB (%.0f byte "
  .. "ciascuna)", dopo - prima,
  (dopo - prima) * 1024 / 10000))
```

I rapporti tipici: la chiamata di funzione costa poche volte il ciclo
puro, lo scambio con `coroutine.wrap` alcune volte la chiamata di
funzione, e `resume` esplicito un poco di più perché restituisce anche il
booleano di esito.

Il numero da tenere a mente è quello finale: una coroutine sospesa
occupa circa **un kilobyte**, e diecimila ne occupano poco meno di
undici megabyte. È una cifra che rende praticabile l’architettura a un
compito per connessione, impensabile nei sistemi a thread.

Il confronto con i thread del sistema operativo, che questo programma non
può fare, è di ordini di grandezza: un thread costa tipicamente un
megabyte di stack riservato e uno scambio di contesto che coinvolge il
kernel.

**ES 22.7 — Da iteratore a lista e ritorno**

*Scrivi una funzione che trasformi un iteratore basato su coroutine
in una lista, e una che faccia il contrario, e verifica che la
composizione delle due sia l’identità su almeno tre strutture
diverse.*

```lua
local function aLista(iteratore, ...)
  local r = {}
  local n = 0
  if select("#", ...) > 0 then
    -- forma completa: iteratore, stato, controllo
    for v in iteratore, ... do
      n = n + 1
      r[n] = v
    end
  else
    for v in iteratore do
      n = n + 1
      r[n] = v
    end
  end
  r.n = n
  return r
end

local function aIteratore(lista)
  return coroutine.wrap(function()
    local n = lista.n or #lista
    for i = 1, n do
      coroutine.yield(lista[i])
    end
  end)
end

local function uguali(a, b)
  local na = a.n or #a
  local nb = b.n or #b
  if na ~= nb then return false end
  for i = 1, na do
    if a[i] ~= b[i] then return false end
  end
  return true
end

-- Tre iteratori di natura diversa
local function daSequenza(t)
  local i = 0
  return function()
    i = i + 1
    return t[i]
  end
end

local function daPattern(testo)
  return testo:gmatch("%a+")
end

local function fibonacci(quanti)
  return coroutine.wrap(function()
    local a, b = 0, 1
    for _ = 1, quanti do
      coroutine.yield(a)
      a, b = b, a + b
    end
  end)
end

local casi = {
  {"sequenza", function()
    return daSequenza({10, 20, 30, 40})
  end},
  {"pattern", function()
    return daPattern("il gatto sul tetto")
  end},
  {"fibonacci", function() return fibonacci(8) end},
  {"vuoto", function()
    return daSequenza({})
  end},
}

for _, c in ipairs(casi) do
  local lista1 = aLista(c[2]())
  local lista2 = aLista(aIteratore(lista1))

  local pezzi = {}
  for i = 1, lista1.n do
    pezzi[i] = tostring(lista1[i])
  end

  print(string.format("%-12s n=%d  [%s]  identita': %s",
    c[1], lista1.n, table.concat(pezzi, " "),
    tostring(uguali(lista1, lista2))))
end

-- Caso con nil in mezzo
print()
local conNil = coroutine.wrap(function()
  coroutine.yield(1)
  coroutine.yield(nil)
  coroutine.yield(3)
end)
local l = aLista(conNil)
print("con un nil in mezzo: n=" .. l.n)
print("l'iterazione si e' fermata al nil, come deve:")
print("il for generico termina al primo nil.")
```

produce:

```text
sequenza     n=4  [10 20 30 40]  identita': true
pattern      n=4  [il gatto sul tetto]  identita': true
fibonacci    n=8  [0 1 1 2 3 5 8 13]  identita': true
vuoto        n=0  []  identita': true

con un nil in mezzo: n=1
l'iterazione si e' fermata al nil, come deve:
il for generico termina al primo nil.
```

La composizione è l’identità su tutti e quattro i casi, compreso quello
vuoto.

Il caso finale mostra il **limite strutturale**: il `for` generico
termina al primo `nil`, quindi un iteratore che produca `nil` come valore
legittimo non è convertibile in lista senza perdite. È lo stesso problema
del `nil` nelle sequenze, visto nel Capitolo 10, e la soluzione è la
stessa: incapsulare i valori, per esempio producendo tabelle a un
elemento invece di valori nudi.

Il campo `n` esplicito nella lista serve proprio a non dipendere da `#`,
che su una sequenza con buchi non è affidabile.

**ES 22.8 — `wrap` contro `create`**

*Dimostra con un programma la differenza fra `wrap` e `create` nella
gestione degli errori e nella possibilità di interrogare lo stato.
Includi un caso in cui una coroutine con una risorsa `<close>` viene
abbandonata, e mostra l’effetto di `coroutine.close`.*

```lua
print("=== 1. Gestione degli errori ===")

local conCreate = coroutine.create(function()
  error("guasto interno")
end)
local ok, messaggio = coroutine.resume(conCreate)
print("create: resume restituisce " .. tostring(ok)
  .. ", " .. tostring(messaggio))
print("  stato dopo l'errore: "
  .. coroutine.status(conCreate))

local conWrap = coroutine.wrap(function()
  error("guasto interno")
end)
local ok2, messaggio2 = pcall(conWrap)
print("wrap: l'errore si propaga, pcall lo cattura: "
  .. tostring(ok2))

print()
print("=== 2. Interrogazione dello stato ===")

local co = coroutine.create(function()
  coroutine.yield(1)
  coroutine.yield(2)
end)
print("create: " .. coroutine.status(co))
coroutine.resume(co)
print("  dopo un resume: " .. coroutine.status(co))

local w = coroutine.wrap(function()
  coroutine.yield(1)
end)
print("wrap: non esiste alcun modo di interrogare")
print("  lo stato, perche' si riceve solo la funzione.")

print()
print("=== 3. Chiamata dopo la fine ===")

local finito = coroutine.create(function() return 1 end)
coroutine.resume(finito)
print("create: " .. tostring(coroutine.resume(finito)))

local finitoW = coroutine.wrap(function() return 1 end)
finitoW()
print("wrap: " .. tostring(pcall(finitoW)))

print()
print("=== 4. Abbandono con risorsa <close> ===")

local rilasciata = false

local function creaConRisorsa()
  return coroutine.create(function()
    local guardia <close> = setmetatable({}, {
      __close = function()
        rilasciata = true
        print("  risorsa rilasciata")
      end
    })
    coroutine.yield("primo")
    coroutine.yield("secondo")
    return "fine"
  end)
end

local abbandonata = creaConRisorsa()
coroutine.resume(abbandonata)
print("sospesa, risorsa ancora aperta: "
  .. tostring(not rilasciata))

print("chiamiamo coroutine.close:")
local okChiusura = coroutine.close(abbandonata)
print("  close ha restituito " .. tostring(okChiusura))
print("  risorsa rilasciata: " .. tostring(rilasciata))
print("  stato: " .. coroutine.status(abbandonata))

rilasciata = false
local perGc = creaConRisorsa()
coroutine.resume(perGc)
perGc = nil
collectgarbage("collect")
collectgarbage("collect")
print("senza close, dopo la raccolta: "
  .. tostring(rilasciata))
```

produce:

```text
=== 1. Gestione degli errori ===
create: resume restituisce false, ...: guasto interno
  stato dopo l'errore: dead
wrap: l'errore si propaga, pcall lo cattura: false

=== 2. Interrogazione dello stato ===
create: suspended
  dopo un resume: suspended
wrap: non esiste alcun modo di interrogare
  lo stato, perche' si riceve solo la funzione.

=== 3. Chiamata dopo la fine ===
create: false
wrap: false

=== 4. Abbandono con risorsa <close> ===
sospesa, risorsa ancora aperta: true
chiamiamo coroutine.close:
  risorsa rilasciata
  close ha restituito true
  risorsa rilasciata: true
  stato: dead

senza close, dopo la raccolta: false
```

Le tre differenze richieste sono tutte visibili.

Con `create`, `resume` non solleva **mai**: restituisce `false` più il
messaggio, e la coroutine passa allo stato `dead`. Con `wrap` l’errore si
propaga al chiamante come qualunque altro errore, e va catturato con
`pcall`.

Lo stato è interrogabile solo con `create`, perché `wrap` restituisce
una funzione e l’oggetto coroutine non è accessibile.

Sulla chiamata dopo la fine, `create` restituisce ordinatamente `false`
più il messaggio; `wrap` solleva un errore.

L’ultima parte è la più istruttiva, e il risultato smentisce
l’aspettativa: **dopo due raccolte complete la risorsa non è stata
rilasciata**. In teoria Lua 5.4 chiude le coroutine irraggiungibili
eseguendo i loro `<close>` pendenti; in pratica il momento dipende da
quando il raccoglitore decide che la coroutine è davvero irraggiungibile,
e due chiamate a `collectgarbage("collect")` non bastano a garantirlo.

È esattamente la ragione per cui `coroutine.close` esiste. Affidarsi al
raccoglitore per il rilascio delle risorse significa non sapere quando —
o se — avverrà, mentre `close` è immediato, deterministico e restituisce
l’esito. Nel terzo caso della sezione quattro il rilascio è avvenuto
sulla riga in cui l’abbiamo chiesto; nel quarto non è avvenuto affatto
entro la fine del programma.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
