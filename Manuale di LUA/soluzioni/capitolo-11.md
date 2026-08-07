# Capitolo 11 — Tabelle come array: sequenze, iterazione, la libreria table

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 10](capitolo-10.md) · [Indice](README.md) · [Capitolo 12 →](capitolo-12.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap11/`](../codice/cap11/).

---

**ES 11.4 — Inversione sul posto e con copia**

*Scrivi una funzione che inverta una sequenza sul posto, senza
costruirne una nuova, e una che ne restituisca una nuova invertita.
Confronta le due su una sequenza di un milione di elementi.*

```lua
local function inverteSulPosto(t)
  local n = #t
  for i = 1, n // 2 do
    t[i], t[n - i + 1] = t[n - i + 1], t[i]
  end
  return t
end

local function invertita(t)
  local n = #t
  local r = {}
  for i = 1, n do
    r[i] = t[n - i + 1]
  end
  return r
end

local piccola = {1, 2, 3, 4, 5}
print("originale: " .. table.concat(piccola, " "))
print("copia:     "
  .. table.concat(invertita(piccola), " "))
print("originale intatta: "
  .. table.concat(piccola, " "))
inverteSulPosto(piccola)
print("dopo sul posto: " .. table.concat(piccola, " "))

local N = 1000000
local grande = {}
for i = 1, N do grande[i] = i end

collectgarbage("collect")
local m1 = collectgarbage("count")
local t1 = os.clock()
inverteSulPosto(grande)
local d1 = os.clock() - t1
local m2 = collectgarbage("count")

collectgarbage("collect")
local m3 = collectgarbage("count")
local t2 = os.clock()
local copia = invertita(grande)
local d2 = os.clock() - t2
local m4 = collectgarbage("count")

print(string.format("sul posto: %.4f s, %+.0f KB",
  d1, m2 - m1))
print(string.format("con copia: %.4f s, %+.0f KB",
  d2, m4 - m3))
print("copia lunga " .. #copia)
```

La versione sul posto scambia gli elementi a coppie e non alloca nulla;
quella con copia costruisce una tabella nuova della stessa dimensione.

Su un milione di elementi la differenza di memoria è di alcune decine di
megabyte, mentre i tempi sono confrontabili: entrambe fanno un numero di
operazioni proporzionale a `n`, ma la copia paga anche l’allocazione e
la crescita progressiva della tabella.

Notate `n // 2` come limite: scambiare fino a `n` invertirebbe due volte
riportando la sequenza all’ordine iniziale. Con `n` dispari l’elemento
centrale resta al suo posto, il che è corretto.

**ES 11.5 — Pila e coda**

*Implementa una pila con le operazioni impila, sfila e guarda, e una
coda a due indici come nel paragrafo 11.7. Misura il costo di
centomila operazioni su ciascuna e confrontalo con l’uso ingenuo di
`table.insert` e `table.remove` in prima posizione.*

```lua
local Pila = {}
Pila.__index = Pila

function Pila.nuova()
  return setmetatable({n = 0}, Pila)
end

function Pila:impila(v)
  self.n = self.n + 1
  self[self.n] = v
end

function Pila:sfila()
  if self.n == 0 then return nil end
  local v = self[self.n]
  self[self.n] = nil
  self.n = self.n - 1
  return v
end

function Pila:guarda()
  if self.n == 0 then return nil end
  return self[self.n]
end

local Coda = {}
Coda.__index = Coda

function Coda.nuova()
  return setmetatable({primo = 1, ultimo = 0}, Coda)
end

function Coda:accoda(v)
  self.ultimo = self.ultimo + 1
  self[self.ultimo] = v
end

function Coda:togli()
  if self.primo > self.ultimo then return nil end
  local v = self[self.primo]
  self[self.primo] = nil
  self.primo = self.primo + 1
  return v
end

function Coda:quanti()
  return self.ultimo - self.primo + 1
end

local N = 100000

local function misura(nome, f)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f()
  print(string.format("%-30s %8.4f s  (%s)",
    nome, os.clock() - inizio, tostring(r)))
end

misura("pila: " .. N .. " op.", function()
  local p = Pila.nuova()
  for i = 1, N do p:impila(i) end
  local somma = 0
  while p.n > 0 do somma = somma + p:sfila() end
  return somma
end)

misura("coda a due indici", function()
  local c = Coda.nuova()
  for i = 1, N do c:accoda(i) end
  local somma = 0
  while c:quanti() > 0 do somma = somma + c:togli() end
  return somma
end)

misura("table.insert/remove in coda", function()
  local t = {}
  for i = 1, N do table.insert(t, i) end
  local somma = 0
  while #t > 0 do somma = somma + table.remove(t) end
  return somma
end)

misura("table.remove(t, 1) INGENUO", function()
  local t = {}
  for i = 1, N // 10 do table.insert(t, i) end
  local somma = 0
  while #t > 0 do somma = somma + table.remove(t, 1) end
  return somma
end)
```

I primi tre casi hanno tempi confrontabili, perché tutte le operazioni
sono a costo costante: la pila e la coda a due indici non spostano mai
nulla, e `table.insert` e `table.remove` **in coda** nemmeno.

Il quarto caso è quello che dimostra il punto: `table.remove(t, 1)`
sposta tutti gli elementi rimanenti a ogni chiamata, quindi il costo
totale è proporzionale al **quadrato** del numero di elementi. Notate che
usa un decimo degli elementi degli altri e impiega comunque più tempo.

**ES 11.6 — Iteratore a passo k senza stato**

*Scrivi un iteratore senza stato che scorra una sequenza a passo `k`,
restituendo un elemento ogni `k`. Verifica che due cicli concorrenti
sulla stessa sequenza non interferiscano.*

```lua
local function passoAvanti(stato, i)
  i = i + stato.passo
  if i > stato.fine then return nil end
  return i, stato.sequenza[i]
end

local function aPasso(sequenza, k, da)
  if math.type(k) ~= "integer" or k < 1 then
    error("il passo deve essere un intero >= 1", 2)
  end
  da = da or 1
  local stato = {
    sequenza = sequenza,
    passo = k,
    fine = #sequenza,
  }
  return passoAvanti, stato, da - k
end

local numeri = {}
for i = 1, 20 do numeri[i] = i * i end

io.write("passo 1: ")
for _, v in aPasso(numeri, 1) do io.write(v, " ") end
io.write("\n")

io.write("passo 3: ")
for i, v in aPasso(numeri, 3) do
  io.write("[", i, "]=", v, " ")
end
io.write("\n")

io.write("passo 5 da 2: ")
for i, v in aPasso(numeri, 5, 2) do
  io.write("[", i, "]=", v, " ")
end
io.write("\n")

-- Due iterazioni concorrenti sulla stessa sequenza
local a = aPasso(numeri, 2)
local statoA = select(2, aPasso(numeri, 2))
local ia = 1 - 2

local iteraB, statoB, ib = aPasso(numeri, 7)

io.write("concorrenti: ")
for _ = 1, 4 do
  local ka, va = a(statoA, ia)
  ia = ka
  local kb, vb = iteraB(statoB, ib)
  ib = kb
  io.write("(", tostring(va), "/", tostring(vb), ") ")
end
io.write("\n")
```

L’iteratore è **senza stato** nel senso tecnico: la funzione
`passoAvanti` non conserva nulla fra le chiamate, e riceve tutto dal
`for` sotto forma di stato invariante e valore di controllo.

La tabella `stato` non contraddice la definizione: è creata una volta e
non cambia durante l’iterazione. Ciò che cambia — l’indice corrente — è
il valore di controllo, che viaggia negli argomenti.

Il vantaggio è che due cicli sulla stessa sequenza non interferiscono,
come dimostra la parte finale: ciascuno ha il proprio valore di
controllo. Con una closure che conserva l’indice, i due cicli si
disturberebbero se condividessero l’iteratore.

**ES 11.7 — Partizione in due versioni**

*Scrivi una funzione che, data una sequenza e un predicato, la
partizioni in due nuove sequenze: gli elementi che soddisfano il
predicato e gli altri. Poi scrivi la versione sul posto, che
riordina la sequenza originale e restituisce l’indice di
separazione.*

```lua
local function partizionaNuove(sequenza, predicato)
  local si, no = {}, {}
  for i = 1, #sequenza do
    local v = sequenza[i]
    if predicato(v, i) then
      si[#si + 1] = v
    else
      no[#no + 1] = v
    end
  end
  return si, no
end

local function partizionaSulPosto(sequenza, predicato)
  local scrittura = 1
  local n = #sequenza

  for lettura = 1, n do
    local v = sequenza[lettura]
    if predicato(v, lettura) then
      sequenza[lettura] = sequenza[scrittura]
      sequenza[scrittura] = v
      scrittura = scrittura + 1
    end
  end

  return scrittura - 1
end

local pari = function(n) return n % 2 == 0 end

local origine = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local si, no = partizionaNuove(origine, pari)
print("nuove  si: " .. table.concat(si, " "))
print("nuove  no: " .. table.concat(no, " "))
print("originale: " .. table.concat(origine, " "))

local separazione = partizionaSulPosto(origine, pari)
print("sul posto: " .. table.concat(origine, " "))
print("separazione all'indice " .. separazione)
print("  soddisfano: " .. table.concat(origine, " ",
  1, separazione))
print("  gli altri:  " .. table.concat(origine, " ",
  separazione + 1, #origine))

-- Casi limite
local vuota = {}
print("vuota -> " .. partizionaSulPosto(vuota, pari))

local tuttiSi = {2, 4, 6}
print("tutti si -> " .. partizionaSulPosto(tuttiSi, pari))

local tuttiNo = {1, 3, 5}
print("tutti no -> " .. partizionaSulPosto(tuttiNo, pari))
```

produce:

```text
nuove  si: 2 4 6 8 10
nuove  no: 1 3 5 7 9
originale: 1 2 3 4 5 6 7 8 9 10
sul posto: 2 4 6 8 10 3 7 1 9 5
separazione all'indice 5
  soddisfano: 2 4 6 8 10
  gli altri:  3 7 1 9 5
vuota -> 0
tutti si -> 3
tutti no -> 0
```

La versione con tabelle nuove **conserva l’ordine relativo** in entrambe
le partizioni ed è più semplice da leggere. Costa una tabella
aggiuntiva.

La versione sul posto non alloca nulla e fa un solo passaggio, ma **non
conserva l’ordine**: lo scambio porta in avanti gli elementi che
soddisfano il predicato e sparpaglia gli altri. È l’algoritmo alla base
del quicksort, e la perdita dell’ordine è il prezzo dell’assenza di
memoria aggiuntiva.

Se serve l’ordine **e** l’assenza di allocazioni, non c’è soluzione
semplice: si può fare in tempo proporzionale a `n` solo con memoria
aggiuntiva, oppure senza memoria con un algoritmo più lento.

**ES 11.8 — Decora, ordina, spoglia**

*Implementa la tecnica *decora, ordina, spoglia* per ordinare mille
stringhe con una funzione di normalizzazione costosa. Misura la
differenza rispetto all’ordinamento diretto e verifica quante volte
viene invocata la normalizzazione nei due casi.*

```lua
local ACCENTI = {
  ["\195\160"] = "a", ["\195\161"] = "a",
  ["\195\168"] = "e", ["\195\169"] = "e",
  ["\195\172"] = "i", ["\195\173"] = "i",
  ["\195\178"] = "o", ["\195\179"] = "o",
  ["\195\185"] = "u", ["\195\186"] = "u",
}

local chiamate = 0

local function normalizza(s)
  chiamate = chiamate + 1
  s = s:lower()
  for a, b in pairs(ACCENTI) do
    s = s:gsub(a, b)
  end
  return s
end

local function generaNomi(quanti)
  local base = {"citta", "citt\195\160", "perche",
    "perch\195\169", "cosi", "cos\195\172", "Zoe",
    "anna", "Elena", "carlo", "\195\188ber", "bosco"}
  local r = {}
  math.randomseed(12345)
  for i = 1, quanti do
    r[i] = base[math.random(#base)] .. i
  end
  return r
end

local nomi = generaNomi(1000)

-- Versione diretta
local copia1 = {}
table.move(nomi, 1, #nomi, 1, copia1)
chiamate = 0
local t1 = os.clock()
table.sort(copia1, function(a, b)
  return normalizza(a) < normalizza(b)
end)
local d1 = os.clock() - t1
local c1 = chiamate

-- Versione decora, ordina, spoglia
local copia2 = {}
table.move(nomi, 1, #nomi, 1, copia2)
chiamate = 0
local t2 = os.clock()

local decorati = {}
for i = 1, #copia2 do
  decorati[i] = {chiave = normalizza(copia2[i]),
    valore = copia2[i]}
end
table.sort(decorati, function(a, b)
  if a.chiave ~= b.chiave then
    return a.chiave < b.chiave
  end
  return a.valore < b.valore
end)
for i = 1, #decorati do
  copia2[i] = decorati[i].valore
end

local d2 = os.clock() - t2
local c2 = chiamate

print(string.format("diretta: %.4f s, %d chiamate",
  d1, c1))
print(string.format("decorata: %.4f s, %d chiamate",
  d2, c2))
print(string.format("rapporto chiamate: %.1fx",
  c1 / c2))

local uguali = true
for i = 1, #copia1 do
  if copia1[i] ~= copia2[i] then uguali = false end
end
print("stesso risultato: " .. tostring(uguali))
```

Su mille elementi, `table.sort` esegue circa diecimila confronti, e la
versione diretta chiama la normalizzazione **due volte per confronto**,
cioè circa ventimila volte. La versione decorata la chiama esattamente
mille volte, una per elemento.

Il rapporto è quindi di circa venti a uno sulle chiamate, e il guadagno
in tempo è proporzionale al costo della normalizzazione: con una funzione
banale la differenza è modesta, con una costosa è decisiva.

Notate che la versione decorata aggiunge un criterio secondario sul
valore originale: due nomi che si normalizzano allo stesso modo devono
avere un ordine deterministico, e la chiave da sola non lo garantisce.

Il costo è la memoria: una tabella di mille record intermedi. È lo
scambio classico fra tempo e spazio.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
