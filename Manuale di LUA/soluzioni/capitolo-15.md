# Capitolo 15 — Ereditarietà, composizione e polimorfismo

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 14](capitolo-14.md) · [Indice](README.md) · [Capitolo 16 →](capitolo-16.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap15/`](../codice/cap15/).

---

**ES 15.4 — Perché `self.super` fallisce a tre livelli**

*Costruisci una gerarchia a tre livelli e dimostra che
`self.super.metodo(self)` produce un ciclo infinito quando il metodo
è definito al livello intermedio, mentre `Base.metodo(self)`
funziona. Spiega nel commento il perché esatto.*

```lua
local function creaClasse(nome, base)
  local c = {}
  c.__index = c
  c.__nome = nome
  c.super = base
  if base then setmetatable(c, {__index = base}) end
  c.nuova = function()
    return setmetatable({}, c)
  end
  return c
end

local A = creaClasse("A")
function A:saluta()
  return "A"
end

local B = creaClasse("B", A)
function B:saluta()
  -- CON self.super: self e' un'istanza di C,
  -- e self.super risale a... B, non ad A!
  return "B <- " .. self.super.saluta(self)
end

local C = creaClasse("C", B)
-- C NON ridefinisce saluta

local istanza = C.nuova()

print("Chiamata su un'istanza di C:")
local ok, risultato = pcall(function()
  return istanza:saluta()
end)
print("  " .. tostring(ok) .. "  "
  .. tostring(risultato))

-- Versione corretta: si nomina la classe base
local A2 = creaClasse("A2")
function A2:saluta() return "A2" end

local B2 = creaClasse("B2", A2)
function B2:saluta()
  return "B2 <- " .. A2.saluta(self)
end

local C2 = creaClasse("C2", B2)

print("Con la classe nominata esplicitamente:")
print("  " .. C2.nuova():saluta())
```

Il meccanismo del guasto.

L’istanza è di tipo `C`. Chiamando `istanza:saluta()`, la ricerca non
trova il metodo in `C`, risale a `B` e lo trova lì.

Dentro `B:saluta`, il valore di `self` è l’**istanza**, non `B`. Quindi
`self.super` cerca il campo `super` partendo dall’istanza: non lo trova,
risale a `C`, e lo trova: `C.super` vale `B`.

Il metodo chiama quindi `B.saluta(self)`, cioè **sé stesso**, e la
ricorsione non termina mai.

Con `A2.saluta(self)` il problema non si pone: il nome della classe base
è fissato nel codice del metodo, e non dipende dal tipo dell’istanza.

La lezione generale: `self` è sempre l’istanza, mai la classe in cui il
metodo è definito. Qualunque tentativo di risalire la gerarchia partendo
da `self` risale dal **tipo dinamico**, non dal punto in cui il codice si
trova.

**ES 15.5 — Metodi astratti verificati alla creazione**

*Implementa una funzione `creaClasse` che supporti anche i metodi
astratti dichiarati esplicitamente, in modo che tentare di creare
un’istanza di una classe con metodi astratti non implementati
produca un errore alla creazione e non alla prima chiamata.*

```lua
local function creaClasse(nome, opzioni)
  opzioni = opzioni or {}
  local base = opzioni.base
  local astratti = opzioni.astratti or {}

  local C = {}
  C.__index = C
  C.__nome = nome
  C.super = base
  C.__astratti = astratti

  if base then setmetatable(C, {__index = base}) end

  local function mancanti(classe)
    local elenco = {}
    local visti = {}
    local corrente = classe
    while corrente do
      for _, m in ipairs(corrente.__astratti or {}) do
        if not visti[m] then
          visti[m] = true
          if type(classe[m]) ~= "function" then
            elenco[#elenco + 1] = m
          end
        end
      end
      corrente = corrente.super
    end
    table.sort(elenco)
    return elenco
  end

  C.mancanti = function() return mancanti(C) end

  C.nuova = function(...)
    local assenti = mancanti(C)
    if #assenti > 0 then
      return nil, string.format(
        "%s non implementa: %s", nome,
        table.concat(assenti, ", "))
    end
    local istanza = setmetatable({}, C)
    if istanza.inizializza then
      istanza:inizializza(...)
    end
    return istanza
  end

  return C
end

local Figura = creaClasse("Figura", {
  astratti = {"area", "perimetro"},
})

function Figura:descrivi()
  return string.format("%s: area %.2f, perimetro %.2f",
    self.__nome, self:area(), self:perimetro())
end

local Cerchio = creaClasse("Cerchio", {base = Figura})
function Cerchio:inizializza(r) self.r = r end
function Cerchio:area() return math.pi * self.r ^ 2 end
function Cerchio:perimetro() return 2 * math.pi * self.r end

local Incompleta = creaClasse("Incompleta",
  {base = Figura})
function Incompleta:area() return 1 end

local Vuota = creaClasse("Vuota", {base = Figura})

print(Cerchio.nuova(2):descrivi())
print(Incompleta.nuova())
print(Vuota.nuova())

print("mancanti in Incompleta: "
  .. table.concat(Incompleta.mancanti(), ", "))
print("mancanti in Cerchio: "
  .. (#Cerchio.mancanti() == 0 and "nessuno" or "?"))
```

produce:

```text
Cerchio: area 12.57, perimetro 12.57
nil	Incompleta non implementa: perimetro
nil	Vuota non implementa: area, perimetro
mancanti in Incompleta: perimetro
mancanti in Cerchio: nessuno
```

La verifica avviene **alla creazione dell’istanza** e non alla prima
chiamata: l’errore arriva nel punto in cui il programmatore ha
sbagliato, non molto più tardi in un punto lontano.

La ricerca risale tutta la gerarchia raccogliendo gli astratti dichiarati
a ogni livello, così una classe può aggiungere requisiti a quelli della
base.

Il controllo `type(classe[m]) ~= "function"` sfrutta la catena di
`__index`: se il metodo è implementato a qualunque livello, viene
trovato.

Il costo è una verifica a ogni creazione: su classi con molte istanze
converrebbe calcolarla una volta e memorizzarla, invalidandola se la
classe viene modificata.

**ES 15.6 — Costo di una chiamata di metodo**

*Confronta sperimentalmente il costo di una chiamata di metodo in tre
configurazioni: metodo definito nella classe dell’oggetto, metodo
ereditato a un livello, metodo trovato tramite `__index` funzione
con tre basi. Usa un milione di chiamate e `os.clock`.*

```lua
local N = 5000000

-- Livello 0: metodo nella classe dell'oggetto
local Diretta = {}
Diretta.__index = Diretta
function Diretta:valore() return 1 end

-- Livello 1: metodo ereditato
local Base1 = {}
Base1.__index = Base1
function Base1:valore() return 1 end

local Derivata1 = setmetatable({}, {__index = Base1})
Derivata1.__index = Derivata1

-- Ereditarieta' multipla con __index funzione
local M1 = {}
local M2 = {}
local M3 = {}
function M3:valore() return 1 end

local Multipla = setmetatable({}, {
  __index = function(_, k)
    for _, b in ipairs({M1, M2, M3}) do
      local v = b[k]
      if v ~= nil then return v end
    end
    return nil
  end,
})
Multipla.__index = Multipla

-- Funzione locale, come riferimento
local function libera() return 1 end

local prove = {
  {"funzione locale", function()
    local s = 0
    for i = 1, N do s = s + libera() end
    return s
  end},
  {"metodo diretto", function()
    local o = setmetatable({}, Diretta)
    local s = 0
    for i = 1, N do s = s + o:valore() end
    return s
  end},
  {"metodo ereditato (1)", function()
    local o = setmetatable({}, Derivata1)
    local s = 0
    for i = 1, N do s = s + o:valore() end
    return s
  end},
  {"__index funzione (3 basi)", function()
    local o = setmetatable({}, Multipla)
    local s = 0
    for i = 1, N do s = s + o:valore() end
    return s
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

L’ordine dei risultati è sempre lo stesso, anche se i valori assoluti
variano.

La **funzione locale** è la più veloce: un accesso a registro e una
chiamata.

Il **metodo diretto** costa poco di più: una ricerca fallita
nell’istanza, una nella metatabella tramite `__index` tabella, che
avviene dentro l’interprete.

Il **metodo ereditato a un livello** aggiunge una seconda ricerca nella
catena. La differenza è misurabile ma modesta.

L’**`__index` come funzione** è nettamente il più costoso: ogni accesso
comporta una chiamata di funzione Lua che scorre tre tabelle. Il
rallentamento è tipicamente di parecchie volte rispetto al metodo
diretto.

È il motivo dell’avvertenza del paragrafo 15.5: l’ereditarietà multipla
con `__index` funzione va bene per le classi con pochi accessi, e va
sostituita con la copia dei metodi quando è nei percorsi caldi.

**ES 15.7 — Composizione al posto della gerarchia**

*Riprogetta la gerarchia dell’ES 15.1 usando la composizione al posto
dell’ereditarietà, con oggetti che possiedono una strategia di
calcolo. Confronta le due soluzioni su leggibilità, estendibilità e
numero di righe.*

```lua
local Forma = {}
Forma.__index = Forma
Forma.__tostring = function(f)
  return string.format("%s(area %.2f, perim %.2f)",
    f.nome, f:area(), f:perimetro())
end

function Forma.nuova(nome, strategia, dati)
  if type(strategia) ~= "table"
     or type(strategia.area) ~= "function"
     or type(strategia.perimetro) ~= "function" then
    return nil, "la strategia deve avere area e "
      .. "perimetro"
  end
  local f = setmetatable({
    nome = nome,
    strategia = strategia,
    dati = dati,
  }, Forma)
  return f
end

function Forma:area()
  return self.strategia.area(self.dati)
end

function Forma:perimetro()
  return self.strategia.perimetro(self.dati)
end

function Forma:piuGrandeDi(altra)
  return self:area() > altra:area()
end

local RETTANGOLO = {
  area = function(d) return d.base * d.altezza end,
  perimetro = function(d)
    return 2 * (d.base + d.altezza)
  end,
}

local CERCHIO = {
  area = function(d) return math.pi * d.raggio ^ 2 end,
  perimetro = function(d)
    return 2 * math.pi * d.raggio
  end,
}

local TRIANGOLO = {
  perimetro = function(d) return d.a + d.b + d.c end,
  area = function(d)
    local s = (d.a + d.b + d.c) / 2
    return math.sqrt(s * (s - d.a) * (s - d.b)
      * (s - d.c))
  end,
}

local forme = {
  Forma.nuova("rettangolo", RETTANGOLO,
    {base = 3, altezza = 4}),
  Forma.nuova("quadrato", RETTANGOLO,
    {base = 3, altezza = 3}),
  Forma.nuova("cerchio", CERCHIO, {raggio = 2}),
  Forma.nuova("triangolo", TRIANGOLO,
    {a = 3, b = 4, c = 5}),
}

table.sort(forme, function(a, b)
  return a:area() < b:area()
end)

for _, f in ipairs(forme) do print(tostring(f)) end

print(Forma.nuova("rotta", {area = function() end}))
```

Il confronto fra le due soluzioni.

**Righe di codice**: la versione a composizione è più breve, perché non
ripete la struttura di classe per ogni forma. Una strategia è una tabella
con due funzioni.

**Leggibilità**: la gerarchia esprime meglio la relazione «un quadrato è
un rettangolo»; la composizione la perde. D’altra parte, la composizione
rende immediato che quadrato e rettangolo **condividono le stesse
formule**, cosa che nella gerarchia richiedeva un livello di
ereditarietà.

**Estendibilità**: aggiungere una forma alla versione a composizione
significa aggiungere una tabella con due funzioni, senza toccare nulla.
Nella gerarchia significa creare una classe e collegarla.

**Flessibilità**: con la composizione la strategia si può **cambiare a
runtime**, cosa impossibile con l’ereditarietà. E si può verificare che
la strategia abbia i metodi richiesti al momento della costruzione, che è
la verifica dell’ES 15.5 ottenuta gratis.

La composizione ha un limite: la strategia non può chiamare metodi
ridefiniti dell’oggetto, perché non lo conosce. Se il polimorfismo deve
funzionare in entrambe le direzioni, l’ereditarietà resta necessaria.

**ES 15.8 — Interfacce come contratti**

*Scrivi una funzione che, dato un oggetto e un elenco di nomi di
metodi, verifichi che li implementi tutti, e usala per definire tre
«interfacce» applicate a classi non imparentate. Fai in modo che il
messaggio di errore indichi quali metodi mancano e da quale classe.*

```lua
local function verificaInterfaccia(oggetto, contratto,
                                   nome)
  if type(oggetto) ~= "table" then
    return false, {"non e' una tabella"}
  end

  local mancanti = {}
  for _, metodo in ipairs(contratto) do
    if type(oggetto[metodo]) ~= "function" then
      mancanti[#mancanti + 1] = metodo
    end
  end

  if #mancanti > 0 then
    table.sort(mancanti)
    return false, mancanti
  end
  return true
end

local function richiedi(oggetto, contratto, nomeContratto)
  local ok, mancanti = verificaInterfaccia(oggetto,
    contratto)
  if not ok then
    local classe = "sconosciuta"
    local m = getmetatable(oggetto)
    if m and m.__nome then classe = m.__nome end
    error(string.format(
      "%s non soddisfa %s: mancano %s",
      classe, nomeContratto,
      table.concat(mancanti, ", ")), 3)
  end
  return oggetto
end

local SERIALIZZABILE = {"serializza", "deserializza"}
local CONFRONTABILE = {"confronta"}
local ITERABILE = {"iteratore", "quanti"}

-- Tre classi non imparentate
local Punto = {}
Punto.__index = Punto
Punto.__nome = "Punto"
function Punto.nuovo(x, y)
  return setmetatable({x = x, y = y}, Punto)
end
function Punto:serializza()
  return self.x .. "," .. self.y
end
function Punto.deserializza(s)
  local x, y = s:match("(%-?%d+),(%-?%d+)")
  return Punto.nuovo(tonumber(x), tonumber(y))
end
function Punto:confronta(altro)
  local a = self.x * self.x + self.y * self.y
  local b = altro.x * altro.x + altro.y * altro.y
  if a < b then return -1 end
  if a > b then return 1 end
  return 0
end

local Elenco = {}
Elenco.__index = Elenco
Elenco.__nome = "Elenco"
function Elenco.nuovo(v)
  return setmetatable({v = v or {}}, Elenco)
end
function Elenco:iteratore()
  local i = 0
  return function()
    i = i + 1
    return self.v[i]
  end
end
function Elenco:quanti() return #self.v end
function Elenco:serializza()
  return table.concat(self.v, "|")
end

local Nudo = {}
Nudo.__index = Nudo
Nudo.__nome = "Nudo"
function Nudo.nuovo() return setmetatable({}, Nudo) end

local prove = {
  {Punto.nuovo(1, 2), SERIALIZZABILE, "Serializzabile"},
  {Punto.nuovo(1, 2), CONFRONTABILE, "Confrontabile"},
  {Punto.nuovo(1, 2), ITERABILE, "Iterabile"},
  {Elenco.nuovo({1, 2}), ITERABILE, "Iterabile"},
  {Elenco.nuovo({1, 2}), SERIALIZZABILE,
    "Serializzabile"},
  {Nudo.nuovo(), CONFRONTABILE, "Confrontabile"},
}

for _, p in ipairs(prove) do
  local ok, messaggio = pcall(richiedi, p[1], p[2], p[3])
  local nome = getmetatable(p[1]).__nome
  if ok then
    print(string.format("%-8s soddisfa %-16s OK",
      nome, p[3]))
  else
    print(string.format("%-8s %s", nome,
      tostring(messaggio)))
  end
end
```

produce:

```text
Punto    soddisfa Serializzabile   OK
Punto    soddisfa Confrontabile    OK
Punto    ...:96: Punto non soddisfa Iterabile:
         mancano iteratore, quanti
Elenco   soddisfa Iterabile        OK
Elenco   ...:96: Elenco non soddisfa Serializzabile:
         mancano deserializza
Nudo     ...:96: Nudo non soddisfa Confrontabile:
         mancano confronta
```

Le tre classi non hanno **alcuna** relazione di ereditarietà, eppure
`Punto` ed `Elenco` soddisfano contratti che condividono in parte. È il
duck typing del paragrafo 15.7, reso esplicito e verificabile.

Il messaggio d’errore nomina la classe e **tutti** i metodi mancanti, non
solo il primo: è la differenza fra un messaggio che risolve il problema e
uno che ne rivela un pezzo alla volta.

Il livello tre in `error` fa sì che la posizione riportata sia quella di
chi ha chiamato `richiedi`, non quella interna alla funzione di verifica.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
