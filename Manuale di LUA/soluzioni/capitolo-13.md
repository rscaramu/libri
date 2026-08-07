# Capitolo 13 — Le metatabelle: cambiare le regole del gioco

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 12](capitolo-12.md) · [Indice](README.md) · [Capitolo 14 →](capitolo-14.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap13/`](../codice/cap13/).

---

**ES 13.4 — Insieme con metametodi aritmetici**

*Implementa un tipo insieme con i metametodi aritmetici, usando `+`
per l’unione, `*` per l’intersezione, `-` per la differenza, `<=`
per l’inclusione e `#` per la cardinalità. Verifica che `<` produca
l’inclusione stretta senza definire un metametodo apposito.*

```lua
local Insieme = {}
Insieme.__index = Insieme
Insieme.__nome = "Insieme"

local function nuovo(da)
  local i = setmetatable({elementi = {}, n = 0}, Insieme)
  if da then
    for _, v in ipairs(da) do
      if i.elementi[v] == nil then
        i.elementi[v] = true
        i.n = i.n + 1
      end
    end
  end
  return i
end

function Insieme:contiene(v)
  return self.elementi[v] == true
end

function Insieme:aggiungi(v)
  if self.elementi[v] == nil then
    self.elementi[v] = true
    self.n = self.n + 1
  end
  return self
end

Insieme.__add = function(a, b)
  local r = nuovo()
  for v in pairs(a.elementi) do r:aggiungi(v) end
  for v in pairs(b.elementi) do r:aggiungi(v) end
  return r
end

Insieme.__mul = function(a, b)
  local piccolo, grande = a, b
  if b.n < a.n then piccolo, grande = b, a end
  local r = nuovo()
  for v in pairs(piccolo.elementi) do
    if grande.elementi[v] then r:aggiungi(v) end
  end
  return r
end

Insieme.__sub = function(a, b)
  local r = nuovo()
  for v in pairs(a.elementi) do
    if not b.elementi[v] then r:aggiungi(v) end
  end
  return r
end

Insieme.__le = function(a, b)
  if a.n > b.n then return false end
  for v in pairs(a.elementi) do
    if not b.elementi[v] then return false end
  end
  return true
end

Insieme.__lt = function(a, b)
  return a.n < b.n and Insieme.__le(a, b)
end

Insieme.__eq = function(a, b)
  if a.n ~= b.n then return false end
  for v in pairs(a.elementi) do
    if not b.elementi[v] then return false end
  end
  return true
end

Insieme.__len = function(a) return a.n end

Insieme.__tostring = function(a)
  local v = {}
  for e in pairs(a.elementi) do v[#v + 1] = tostring(e) end
  table.sort(v)
  return "{" .. table.concat(v, ",") .. "}"
end

local A = nuovo({1, 2, 3, 4})
local B = nuovo({3, 4, 5})
local C = nuovo({3, 4})

print("A       = " .. tostring(A))
print("B       = " .. tostring(B))
print("A + B   = " .. tostring(A + B))
print("A * B   = " .. tostring(A * B))
print("A - B   = " .. tostring(A - B))
print("#A      = " .. #A)
print("C <= A  = " .. tostring(C <= A))
print("A <= C  = " .. tostring(A <= C))
print("C <  A  = " .. tostring(C < A))
print("A <  A  = " .. tostring(A < A))
print("A == A  = " .. tostring(A == nuovo({4,3,2,1})))
```

produce:

```text
A       = {1,2,3,4}
B       = {3,4,5}
A + B   = {1,2,3,4,5}
A * B   = {3,4}
A - B   = {1,2}
#A      = 4
C <= A  = true
A <= C  = false
C <  A  = true
A <  A  = false
A == A  = true
```

L’esercizio chiedeva se `<` si ottenesse gratuitamente definendo solo
`__le`. La risposta è **no**: rimuovendo `__lt` dal codice sopra, la riga
`C < A` produce l’errore *attempt to compare two table values*.

In Lua 5.4 l’operatore `<` cerca `__lt` e, se non lo trova, **non**
ripiega su `__le`. In versioni molto più vecchie esisteva una derivazione
per negazione — `a < b` come `not (b <= a)` — ma è stata rimossa perché
scorretta in presenza di ordini parziali, che è esattamente il caso
dell’inclusione fra insiemi: due insiemi possono essere entrambi non
inclusi l’uno nell’altro.

`__lt` va quindi definito, e l’inclusione stretta si calcola come
inclusione più disuguaglianza di cardinalità: è più economico che
confrontare due volte.

Notate `A < A` che vale `false`: l’inclusione stretta di un insieme in sé
stesso non vale, come deve essere per un ordine stretto.

L’ottimizzazione in `__mul`, che scorre l’insieme più piccolo, è quella
suggerita nel paragrafo 12.3: il costo dipende da quanto si scorre, non
da quanto si consulta.

**ES 13.5 — Ordine di inserimento preservato**

*Scrivi una funzione che, data una tabella, restituisca un proxy che
registri l’ordine di inserimento delle chiavi e fornisca un
iteratore che le scorra in quell’ordine, risolvendo così il problema
dell’ordine imprevedibile di `pairs`.*

```lua
local function tabellaOrdinata()
  local dati = {}
  local ordine = {}
  local posizione = {}

  local proxy = setmetatable({}, {
    __index = function(_, k)
      return dati[k]
    end,

    __newindex = function(_, k, v)
      if v == nil then
        if dati[k] ~= nil then
          dati[k] = nil
          local i = posizione[k]
          table.remove(ordine, i)
          posizione[k] = nil
          for j = i, #ordine do
            posizione[ordine[j]] = j
          end
        end
        return
      end

      if dati[k] == nil then
        ordine[#ordine + 1] = k
        posizione[k] = #ordine
      end
      dati[k] = v
    end,

    __len = function() return #ordine end,
  })

  local function coppie()
    local i = 0
    return function()
      i = i + 1
      local k = ordine[i]
      if k == nil then return nil end
      return k, dati[k]
    end
  end

  return proxy, coppie
end

local t, coppie = tabellaOrdinata()

t.zeta = 1
t.alfa = 2
t.mu = 3
t.beta = 4

io.write("ordine di inserimento: ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.alfa = 99
io.write("dopo aggiornamento:    ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.mu = nil
io.write("dopo rimozione di mu:  ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.omega = 5
io.write("dopo nuovo inserimento:")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

print("lunghezza: " .. #t)
print("lettura diretta: " .. t.alfa)
```

produce:

```text
ordine di inserimento: zeta=1 alfa=2 mu=3 beta=4
dopo aggiornamento:    zeta=1 alfa=99 mu=3 beta=4
dopo rimozione di mu:  zeta=1 alfa=99 beta=4
dopo nuovo inserimento:zeta=1 alfa=99 beta=4 omega=5
```

L’aggiornamento di una chiave esistente **non cambia** la sua posizione
nell’ordine: è la convenzione più comune, ma va dichiarata perché
l’alternativa — spostare in fondo — è altrettanto plausibile.

La rimozione richiede di rinumerare le posizioni successive, il che la
rende costosa in proporzione al numero di chiavi. Con rimozioni
frequenti converrebbe segnare la voce come cancellata e compattare
periodicamente.

La funzione `coppie` è restituita separatamente perché `pairs` sul proxy
non funzionerebbe: la tabella è vuota, e `__pairs` non esiste in Lua 5.4.

**ES 13.6 — Matrice con `__index` a due livelli**

*Implementa un tipo matrice con `__index` a due livelli, in modo che
`m[2][3]` funzioni, `__add` e `__mul` fra matrici, e `__mul` fra
matrice e scalare. Gestisci gli errori di dimensione incompatibile.*

```lua
local Matrice = {}
Matrice.__index = Matrice

local Riga = {}
Riga.__index = function(riga, colonna)
  if type(colonna) ~= "number" then return nil end
  local m = rawget(riga, "matrice")
  local r = rawget(riga, "indice")
  if colonna < 1 or colonna > m.colonne then
    error("colonna fuori intervallo: " .. colonna, 2)
  end
  return m.dati[(r - 1) * m.colonne + colonna]
end
Riga.__newindex = function(riga, colonna, valore)
  local m = rawget(riga, "matrice")
  local r = rawget(riga, "indice")
  if type(colonna) ~= "number"
     or colonna < 1 or colonna > m.colonne then
    error("colonna fuori intervallo: "
      .. tostring(colonna), 2)
  end
  m.dati[(r - 1) * m.colonne + colonna] = valore
end
Riga.__len = function(riga)
  return rawget(riga, "matrice").colonne
end

local function nuova(righe, colonne, riempimento)
  local m = setmetatable({
    righe = righe,
    colonne = colonne,
    dati = {},
    righeCache = {},
  }, Matrice)

  for i = 1, righe * colonne do
    m.dati[i] = riempimento or 0
  end

  for i = 1, righe do
    m.righeCache[i] = setmetatable(
      {matrice = m, indice = i}, Riga)
  end

  return m
end

Matrice.__index = function(m, k)
  if type(k) == "number" then
    local cache = rawget(m, "righeCache")
    local riga = cache and cache[k]
    if riga == nil then
      error("riga fuori intervallo: " .. k, 2)
    end
    return riga
  end
  return Matrice[k]
end

Matrice.__add = function(a, b)
  if a.righe ~= b.righe or a.colonne ~= b.colonne then
    error("dimensioni incompatibili", 2)
  end
  local r = nuova(a.righe, a.colonne)
  for i = 1, #a.dati do
    r.dati[i] = a.dati[i] + b.dati[i]
  end
  return r
end

Matrice.__mul = function(a, b)
  if type(b) == "number" then a, b = b, a end
  if type(a) == "number" then
    local r = nuova(b.righe, b.colonne)
    for i = 1, #b.dati do r.dati[i] = b.dati[i] * a end
    return r
  end

  if a.colonne ~= b.righe then
    error(string.format(
      "dimensioni incompatibili: %dx%d per %dx%d",
      a.righe, a.colonne, b.righe, b.colonne), 2)
  end

  local r = nuova(a.righe, b.colonne)
  for i = 1, a.righe do
    for j = 1, b.colonne do
      local s = 0
      for k = 1, a.colonne do
        s = s + a.dati[(i - 1) * a.colonne + k]
          * b.dati[(k - 1) * b.colonne + j]
      end
      r.dati[(i - 1) * r.colonne + j] = s
    end
  end
  return r
end

Matrice.__tostring = function(m)
  local righe = {}
  for i = 1, m.righe do
    local pezzi = {}
    for j = 1, m.colonne do
      pezzi[j] = string.format("%7.2f",
        m.dati[(i - 1) * m.colonne + j])
    end
    righe[i] = table.concat(pezzi)
  end
  return table.concat(righe, "\n")
end

local a = nuova(2, 3)
a[1][1] = 1  a[1][2] = 2  a[1][3] = 3
a[2][1] = 4  a[2][2] = 5  a[2][3] = 6

local b = nuova(3, 2)
b[1][1] = 7   b[1][2] = 8
b[2][1] = 9   b[2][2] = 10
b[3][1] = 11  b[3][2] = 12

print("a =") print(tostring(a))
print("a[2][3] = " .. a[2][3])
print("a * b =") print(tostring(a * b))
print("a * 2 =") print(tostring(2 * a))
print("righe di a: " .. #a[1] .. " colonne")

print(pcall(function() return a[5] end))
print(pcall(function() return a[1][9] end))
print(pcall(function() return a * a end))
```

Il meccanismo a due livelli richiede che `m[i]` restituisca un **oggetto
riga** e che `riga[j]` acceda alla cella. Le righe sono create una volta
sola alla costruzione e conservate in cache: crearle a ogni accesso
alloccherebbe una tabella per ogni `m[i][j]`, il che sarebbe
catastrofico in un ciclo.

`Matrice.__index` è una **funzione** perché deve distinguere gli accessi
numerici, che restituiscono righe, da quelli con chiave stringa, che
devono trovare i metodi.

L’uso di `rawget` dentro i metametodi della riga è obbligatorio: senza,
leggere `riga.matrice` invocherebbe di nuovo `__index` e produrrebbe
ricorsione infinita.

**ES 13.7 — Le regole di `__gc`**

*Dimostra sperimentalmente le regole di `__gc` descritte nel
paragrafo 13.10: che il metametodo deve essere presente al momento
di `setmetatable`, e che aggiungerlo dopo non ha effetto. Verifica
anche che cosa succede se il metametodo solleva un errore.*

```lua
local eventi = {}

-- Caso 1: __gc presente al momento di setmetatable
local function conGc()
  local meta = {
    __gc = function() eventi[#eventi + 1] = "A: gc" end
  }
  local o = setmetatable({}, meta)
  return o
end

-- Caso 2: __gc aggiunto DOPO setmetatable
local function gcTardivo()
  local meta = {}
  local o = setmetatable({}, meta)
  meta.__gc = function()
    eventi[#eventi + 1] = "B: gc"
  end
  return o
end

-- Caso 3: setmetatable ripetuto dopo aver aggiunto __gc
local function gcRiassegnato()
  local meta = {}
  local o = setmetatable({}, meta)
  meta.__gc = function()
    eventi[#eventi + 1] = "C: gc"
  end
  setmetatable(o, meta)
  return o
end

-- Caso 4: __gc che solleva un errore
local function gcConErrore()
  return setmetatable({}, {
    __gc = function()
      eventi[#eventi + 1] = "D: prima dell'errore"
      error("guasto nel finalizzatore")
    end
  })
end

do
  local a = conGc()
  local b = gcTardivo()
  local c = gcRiassegnato()
  local d = gcConErrore()
end

collectgarbage("collect")
collectgarbage("collect")

table.sort(eventi)
print("eventi registrati:")
for _, e in ipairs(eventi) do print("  " .. e) end

print()
print("A presente? " .. tostring(
  eventi[1] and true or false))
```

I risultati attesi.

**A** viene finalizzato: `__gc` era nella metatabella al momento di
`setmetatable`, quindi l’oggetto è stato marcato per la finalizzazione.

**B non viene finalizzato.** Aggiungere `__gc` alla metatabella dopo non
ha alcun effetto, perché la marcatura avviene solo durante
`setmetatable`.

**C viene finalizzato**, perché la seconda chiamata a `setmetatable`
avviene quando `__gc` è già presente: è il modo di recuperare il caso B.

**D** registra l’evento e poi solleva un errore. Lua **non propaga**
l’errore: genera un avviso, visibile con `warn("@on")`, e prosegue con
gli altri finalizzatori. Il programma non si interrompe.

L’ultimo comportamento è la ragione dell’avvertenza del paragrafo 23.6:
un finalizzatore che fallisce lo fa in silenzio, e non ci si può fare
affidamento per operazioni la cui riuscita conta.

**ES 13.8 — Registrare le letture di chiavi assenti**

*Scrivi una tabella che registri automaticamente ogni lettura di una
chiave assente, per aiutare a trovare gli errori di battitura nei
nomi dei campi. Rendila attivabile e disattivabile a runtime e
verifica quanto rallenta un ciclo di un milione di accessi.*

```lua
local function conTracciamento(reale)
  local mancanti = {}
  local attivo = true
  local letture = 0

  local proxy = setmetatable({}, {
    __index = function(_, k)
      letture = letture + 1
      local v = reale[k]
      if v == nil and attivo then
        mancanti[k] = (mancanti[k] or 0) + 1
      end
      return v
    end,
    __newindex = function(_, k, v)
      reale[k] = v
    end,
    __len = function() return #reale end,
  })

  local controllo = {
    attiva = function() attivo = true end,
    disattiva = function() attivo = false end,
    rapporto = function()
      local elenco = {}
      for k, n in pairs(mancanti) do
        elenco[#elenco + 1] = {chiave = k, quante = n}
      end
      table.sort(elenco, function(a, b)
        if a.quante ~= b.quante then
          return a.quante > b.quante
        end
        return tostring(a.chiave) < tostring(b.chiave)
      end)
      return elenco, letture
    end,
    azzera = function()
      mancanti = {}
      letture = 0
    end,
  }

  return proxy, controllo
end

local dati = {nome = "Anna", eta = 34, citta = "Roma"}
local t, ctrl = conTracciamento(dati)

print(t.nome)
print(tostring(t.cognome))
print(tostring(t.et))
print(tostring(t.et))
print(tostring(t.indirizo))

local elenco, letture = ctrl.rapporto()
print("letture totali: " .. letture)
print("chiavi assenti richieste:")
for _, v in ipairs(elenco) do
  print(string.format("  %-12s %d volte",
    tostring(v.chiave), v.quante))
end

-- Costo del tracciamento
local N = 1000000

collectgarbage("collect")
local t1 = os.clock()
local s1 = 0
for i = 1, N do s1 = s1 + dati.eta end
local d1 = os.clock() - t1

ctrl.disattiva()
collectgarbage("collect")
local t2 = os.clock()
local s2 = 0
for i = 1, N do s2 = s2 + t.eta end
local d2 = os.clock() - t2

print(string.format(
  "diretto: %.4f s   con proxy: %.4f s   %.1fx",
  d1, d2, d2 / d1))
```

Il rapporto elenca `et` due volte e `cognome` e `indirizo` una: sono
esattamente gli errori di battitura che in Lua non producono alcun
segnale.

Il costo è quello annunciato nel paragrafo 13.9: ogni accesso passa da
una chiamata di funzione invece che da una lettura diretta, e il
rallentamento su un milione di accessi è di un fattore fra cinque e
dieci. È accettabile in fase di sviluppo, non in produzione.

Il tracciamento è **disattivabile** senza rimuovere il proxy: utile per
escludere dal rapporto le fasi in cui gli accessi mancanti sono
legittimi, per esempio la lettura di una configurazione opzionale.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
