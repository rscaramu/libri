# Capitolo 14 — Programmazione a oggetti con le metatabelle

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 13](capitolo-13.md) · [Indice](README.md) · [Capitolo 15 →](capitolo-15.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap14/`](../codice/cap14/).

---

**ES 14.4 — La classe Rettangolo**

*Implementa una classe Rettangolo con larghezza, altezza, area,
perimetro, `__eq`, `__lt` basato sull’area, `__tostring` e un metodo
di ridimensionamento che restituisca un nuovo rettangolo senza
modificare l’originale.*

```lua
local Rettangolo = {}
Rettangolo.__index = Rettangolo
Rettangolo.__nome = "Rettangolo"

function Rettangolo.nuovo(larghezza, altezza)
  if type(larghezza) ~= "number"
     or type(altezza) ~= "number" then
    return nil, "servono due numeri"
  end
  if larghezza <= 0 or altezza <= 0 then
    return nil, "le dimensioni devono essere positive"
  end
  return setmetatable({
    larghezza = larghezza,
    altezza = altezza,
  }, Rettangolo)
end

function Rettangolo:area()
  return self.larghezza * self.altezza
end

function Rettangolo:perimetro()
  return 2 * (self.larghezza + self.altezza)
end

function Rettangolo:quadrato()
  return self.larghezza == self.altezza
end

function Rettangolo:ridimensionato(fattore)
  if type(fattore) ~= "number" or fattore <= 0 then
    return nil, "il fattore deve essere positivo"
  end
  return setmetatable({
    larghezza = self.larghezza * fattore,
    altezza = self.altezza * fattore,
  }, getmetatable(self))
end

Rettangolo.__eq = function(a, b)
  return a.larghezza == b.larghezza
    and a.altezza == b.altezza
end

Rettangolo.__lt = function(a, b)
  return a:area() < b:area()
end

Rettangolo.__le = function(a, b)
  return a:area() <= b:area()
end

Rettangolo.__tostring = function(r)
  return string.format("%s(%gx%g, area %g)",
    r.__nome, r.larghezza, r.altezza, r:area())
end

local a = Rettangolo.nuovo(3, 4)
local b = Rettangolo.nuovo(2, 6)
local c = Rettangolo.nuovo(3, 4)
local q = Rettangolo.nuovo(5, 5)

print(tostring(a))
print("area " .. a:area() .. ", perimetro "
  .. a:perimetro())
print("a == c: " .. tostring(a == c))
print("a == b: " .. tostring(a == b))
print("a < b:  " .. tostring(a < b))
print("a <= b: " .. tostring(a <= b))
print("q e' quadrato: " .. tostring(q:quadrato()))

local d = a:ridimensionato(2)
print("ridimensionato: " .. tostring(d))
print("originale intatto: " .. tostring(a))

print(Rettangolo.nuovo(-1, 5))
print(a:ridimensionato(0))

local elenco = {a, b, q, d}
table.sort(elenco, function(x, y) return x < y end)
io.write("ordinati per area: ")
for _, r in ipairs(elenco) do
  io.write(r:area(), " ")
end
io.write("\n")
```

produce:

```text
Rettangolo(3x4, area 12)
area 12, perimetro 14
a == c: true
a == b: false
a < b:  false
a <= b: true
q e' quadrato: true
ridimensionato: Rettangolo(6x8, area 48)
originale intatto: Rettangolo(3x4, area 12)
nil	le dimensioni devono essere positive
nil	il fattore deve essere positivo
ordinati per area: 12 12 25 48
```

Il confronto `a < b` con aree uguali restituisce `false`, come deve: `<`
è un ordine **stretto**, e due rettangoli di area dodici non sono uno
minore dell’altro. `a <= b` è invece vero.

`ridimensionato` usa `getmetatable(self)` e non `Rettangolo`: è la regola
del paragrafo 14.7, che rende il metodo corretto anche per eventuali
sottoclassi.

**ES 14.5 — La trappola dei campi condivisi, tre tipi**

*Scrivi un programma che dimostri la trappola dei campi condivisi con
almeno tre tipi di campo diversi: un numero, una stringa e una
tabella. Spiega nel commento perché i primi due si comportano
diversamente dal terzo.*

```lua
local C = {}
C.__index = C

C.contatore = 0          -- numero
C.etichetta = "iniziale"  -- stringa
C.registro = {}           -- TABELLA: condivisa!

function C.nuova(nome)
  return setmetatable({nome = nome}, C)
end

function C:incrementa()
  self.contatore = self.contatore + 1
end

function C:rinomina(s)
  self.etichetta = s
end

function C:annota(v)
  self.registro[#self.registro + 1] = self.nome .. ":" .. v
end

local a = C.nuova("A")
local b = C.nuova("B")

a:incrementa()
a:incrementa()
b:incrementa()

a:rinomina("modificata da A")

a:annota("primo")
b:annota("secondo")
a:annota("terzo")

print("contatore di a: " .. a.contatore)
print("contatore di b: " .. b.contatore)
print("contatore nella classe: " .. C.contatore)
print()
print("etichetta di a: " .. a.etichetta)
print("etichetta di b: " .. b.etichetta)
print("etichetta nella classe: " .. C.etichetta)
print()
print("registro di a: "
  .. table.concat(a.registro, " "))
print("registro di b: "
  .. table.concat(b.registro, " "))
print("registro nella classe: "
  .. table.concat(C.registro, " "))
print("a.registro e' C.registro? "
  .. tostring(a.registro == C.registro))
print("a.registro e' b.registro? "
  .. tostring(a.registro == b.registro))
```

produce:

```text
contatore di a: 2
contatore di b: 1
contatore nella classe: 0

etichetta di a: modificata da A
etichetta di b: iniziale
etichetta nella classe: iniziale

registro di a: A:primo B:secondo A:terzo
registro di b: A:primo B:secondo A:terzo
registro nella classe: A:primo B:secondo A:terzo
a.registro e' C.registro? true
a.registro e' b.registro? true
```

I primi due campi si comportano correttamente, il terzo no, e la ragione
è precisa.

Con il **numero** e la **stringa**, il metodo esegue
un’**assegnazione**: `self.contatore = ...` e `self.etichetta = ...`.
L’assegnazione a una tabella crea sempre un campo **nell’istanza**, senza
mai toccare la metatabella. La lettura precedente prende il valore dalla
classe la prima volta, poi dall’istanza.

Con la **tabella**, il metodo esegue una **lettura** seguita da una
modifica: `self.registro[...] = ...` legge `self.registro`, che non
esiste nell’istanza e viene presa dalla classe, e poi modifica quella
tabella. Nessuna assegnazione a `self` avviene mai, quindi l’istanza non
acquisisce mai un registro proprio.

La regola operativa: nella classe possono stare numeri, stringhe e
booleani come valori predefiniti; **ogni tabella va creata nel
costruttore**.

**ES 14.6 — Metatabella contro closure**

*Implementa la stessa classe due volte, una con lo schema a
metatabella e una con lo schema a closure, e confronta: memoria
occupata da diecimila istanze, tempo di creazione, tempo di mille
chiamate di metodo. Usa `collectgarbage("count")` per la memoria.*

```lua
local ConMeta = {}
ConMeta.__index = ConMeta

function ConMeta.nuovo(x, y)
  return setmetatable({x = x, y = y}, ConMeta)
end

function ConMeta:somma() return self.x + self.y end
function ConMeta:prodotto() return self.x * self.y end
function ConMeta:massimo()
  return self.x > self.y and self.x or self.y
end

local function conClosure(x, y)
  local o = {}
  function o.somma() return x + y end
  function o.prodotto() return x * y end
  function o.massimo() return x > y and x or y end
  return o
end

local N = 100000

local function misuraMemoria(costruttore)
  collectgarbage("collect")
  collectgarbage("collect")
  local prima = collectgarbage("count")
  local istanze = {}
  for i = 1, N do
    istanze[i] = costruttore(i, i + 1)
  end
  collectgarbage("collect")
  local dopo = collectgarbage("count")
  return dopo - prima, istanze
end

local function misuraTempo(f)
  collectgarbage("collect")
  local inizio = os.clock()
  f()
  return os.clock() - inizio
end

local memMeta, istanzeMeta = misuraMemoria(ConMeta.nuovo)
local memClos, istanzeClos = misuraMemoria(conClosure)

print(string.format("memoria per %d istanze:", N))
print(string.format("  metatabella: %8.0f KB (%.0f B)",
  memMeta, memMeta * 1024 / N))
print(string.format("  closure:     %8.0f KB (%.0f B)",
  memClos, memClos * 1024 / N))
print(string.format("  rapporto: %.1fx",
  memClos / memMeta))

local tCreaMeta = misuraTempo(function()
  for i = 1, N do ConMeta.nuovo(i, i) end
end)
local tCreaClos = misuraTempo(function()
  for i = 1, N do conClosure(i, i) end
end)

print(string.format("creazione: meta %.4f s, "
  .. "closure %.4f s", tCreaMeta, tCreaClos))

local M = 1000000
local om = ConMeta.nuovo(3, 4)
local oc = conClosure(3, 4)

local tChiamMeta = misuraTempo(function()
  local s = 0
  for i = 1, M do s = s + om:somma() end
end)
local tChiamClos = misuraTempo(function()
  local s = 0
  for i = 1, M do s = s + oc.somma() end
end)

print(string.format("chiamate: meta %.4f s, "
  .. "closure %.4f s", tChiamMeta, tChiamClos))
```

I risultati mostrano lo scambio.

La versione a **metatabella** occupa poche decine di byte per istanza,
perché le funzioni esistono una volta sola nella classe. La versione a
**closure** ne occupa molti di più, perché ogni istanza porta con sé tre
funzioni distinte con i propri upvalue.

La creazione è più lenta con le closure, per la stessa ragione: tre
oggetti funzione da allocare invece di uno solo `setmetatable`.

Sulla **chiamata** la closure è tipicamente più veloce, perché accede
direttamente a un upvalue invece di risalire la catena di `__index` e poi
leggere un campo dell’istanza.

La conclusione pratica: metatabelle quando le istanze sono molte, closure
quando sono poche e l’incapsulamento conta.

**ES 14.7 — Temperatura con conversioni via metatabella**

*Implementa una classe che rappresenti una temperatura, memorizzata
internamente in kelvin, con accesso in lettura e scrittura in
Celsius e in Fahrenheit tramite metatabella, così che `t.celsius =
25` aggiorni il valore interno.*

```lua
local Temperatura = {}

local CONVERSIONI = {
  kelvin = {
    leggi = function(k) return k end,
    scrivi = function(v) return v end,
  },
  celsius = {
    leggi = function(k) return k - 273.15 end,
    scrivi = function(v) return v + 273.15 end,
  },
  fahrenheit = {
    leggi = function(k)
      return (k - 273.15) * 9 / 5 + 32
    end,
    scrivi = function(v)
      return (v - 32) * 5 / 9 + 273.15
    end,
  },
}

local METODI = {}

function METODI:congelamento()
  return self.celsius <= 0
end

function METODI:ebollizione()
  return self.celsius >= 100
end

local meta = {
  __index = function(t, k)
    local c = CONVERSIONI[k]
    if c then
      return c.leggi(rawget(t, "_kelvin"))
    end
    return METODI[k]
  end,

  __newindex = function(t, k, v)
    local c = CONVERSIONI[k]
    if c == nil then
      error("proprieta' sconosciuta: " .. tostring(k), 2)
    end
    if type(v) ~= "number" then
      error("serve un numero", 2)
    end
    local k2 = c.scrivi(v)
    if k2 < 0 then
      error("sotto lo zero assoluto", 2)
    end
    rawset(t, "_kelvin", k2)
  end,

  __tostring = function(t)
    return string.format("%.2f K / %.2f C / %.2f F",
      t.kelvin, t.celsius, t.fahrenheit)
  end,

  __eq = function(a, b)
    return rawget(a, "_kelvin") == rawget(b, "_kelvin")
  end,

  __lt = function(a, b)
    return rawget(a, "_kelvin") < rawget(b, "_kelvin")
  end,
}

function Temperatura.nuova(valore, scala)
  scala = scala or "celsius"
  local t = setmetatable({_kelvin = 273.15}, meta)
  t[scala] = valore
  return t
end

local t = Temperatura.nuova(25)
print(tostring(t))

t.celsius = 100
print("dopo celsius = 100: " .. tostring(t))
print("bolle? " .. tostring(t:ebollizione()))

t.fahrenheit = 32
print("dopo fahrenheit = 32: " .. tostring(t))
print("congela? " .. tostring(t:congelamento()))

t.kelvin = 300
print("dopo kelvin = 300: " .. tostring(t))

print(pcall(function() t.rankine = 500 end))
print(pcall(function() t.celsius = -300 end))
print(pcall(function() t.celsius = "caldo" end))

local a = Temperatura.nuova(0)
local b = Temperatura.nuova(32, "fahrenheit")
print("0 C == 32 F? " .. tostring(a == b))
```

Il valore interno è **sempre in kelvin**: è l’unica scala senza valori
negativi legittimi, il che rende il controllo dello zero assoluto banale.

`__index` e `__newindex` operano su una tabella che contiene un solo
campo reale, `_kelvin`, letto e scritto con `rawget` e `rawset` per non
richiamare sé stessi.

Notate che `__index` deve gestire **due** casi: le proprietà convertite e
i metodi. Restituire `METODI[k]` come ripiego è ciò che rende possibile
`t:ebollizione()`.

L’uguaglianza confronta i kelvin, quindi zero gradi Celsius e trentadue
Fahrenheit risultano uguali, come devono.

**ES 14.8 — Generatore di classi**

*Scrivi una funzione `classe(nome, campi)` che generi automaticamente
una classe con costruttore, `__tostring`, `__eq` e metodo copia, a
partire da un elenco di nomi di campo. Verifica che le classi così
generate si comportino come quelle scritte a mano.*

```lua
local function classe(nome, campi, opzioni)
  opzioni = opzioni or {}

  local C = {}
  C.__index = C
  C.__nome = nome
  C.__campi = campi

  local insieme = {}
  for _, c in ipairs(campi) do insieme[c] = true end

  C.nuovo = function(dati)
    dati = dati or {}
    for k in pairs(dati) do
      if not insieme[k] then
        return nil, string.format(
          "%s: campo sconosciuto '%s'", nome,
          tostring(k))
      end
    end

    local istanza = setmetatable({}, C)
    for _, campo in ipairs(campi) do
      istanza[campo] = dati[campo]
    end
    return istanza
  end

  C.__tostring = function(o)
    local pezzi = {}
    for _, campo in ipairs(campi) do
      pezzi[#pezzi + 1] = campo .. "="
        .. tostring(o[campo])
    end
    return nome .. "{" .. table.concat(pezzi, ", ") .. "}"
  end

  C.__eq = function(a, b)
    for _, campo in ipairs(campi) do
      if a[campo] ~= b[campo] then return false end
    end
    return true
  end

  function C:copia(modifiche)
    local dati = {}
    for _, campo in ipairs(campi) do
      dati[campo] = self[campo]
    end
    for k, v in pairs(modifiche or {}) do
      if not insieme[k] then
        return nil, "campo sconosciuto: " .. tostring(k)
      end
      dati[k] = v
    end
    return C.nuovo(dati)
  end

  function C:comeTabella()
    local t = {}
    for _, campo in ipairs(campi) do
      t[campo] = self[campo]
    end
    return t
  end

  if opzioni.ordinaPer then
    local chiave = opzioni.ordinaPer
    C.__lt = function(a, b)
      return a[chiave] < b[chiave]
    end
    C.__le = function(a, b)
      return a[chiave] <= b[chiave]
    end
  end

  return C
end

local Punto = classe("Punto", {"x", "y"})
local Persona = classe("Persona",
  {"nome", "cognome", "eta"}, {ordinaPer = "eta"})

local p = Punto.nuovo({x = 1, y = 2})
print(tostring(p))
print("uguale a un altro (1,2)? "
  .. tostring(p == Punto.nuovo({x = 1, y = 2})))

local q = p:copia({y = 99})
print("copia modificata: " .. tostring(q))
print("originale intatto: " .. tostring(p))

print(Punto.nuovo({x = 1, z = 3}))

local gente = {
  Persona.nuovo({nome = "Anna", cognome = "Rossi",
    eta = 34}),
  Persona.nuovo({nome = "Bruno", cognome = "Bianchi",
    eta = 28}),
  Persona.nuovo({nome = "Carla", cognome = "Verdi",
    eta = 41}),
}

table.sort(gente, function(a, b) return a < b end)
for _, x in ipairs(gente) do print(tostring(x)) end
```

Il generatore produce classi che si comportano come quelle scritte a
mano, con quattro capacità automatiche: costruttore con validazione dei
nomi di campo, `__tostring`, `__eq` per contenuto e metodo di copia con
modifiche.

Il limite dichiarato è che **non genera metodi**: quelli vanno aggiunti
a mano dopo, come mostrato per `Persona`. Un generatore che accettasse
anche i metodi sarebbe possibile ma comincerebbe a somigliare a un
framework, che è precisamente ciò che l’Appendice E del primo volume
sconsiglia.

L’ordinamento facoltativo tramite `opzioni.ordinaPer` mostra come
estendere il generatore senza complicare il caso semplice: chi non ne ha
bisogno non se ne accorge.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
