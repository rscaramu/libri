# Capitolo 29 — Testing, debug, profiling e qualità del codice

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 28](capitolo-28.md) · [Indice](README.md) · [Capitolo 30 →](capitolo-30.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap29/`](../codice/cap29/).

---

**ES 29.4 — Suite per il modulo statistiche**

*Scrivi la suite di test per il modulo `statistiche` dell’ES 28.1,
coprendo tutti i casi limite: sequenza di un elemento, valori tutti
uguali, valori negativi, percentili agli estremi.*

```lua
local T = require("test")
local gruppo, prova, a = T.gruppo, T.prova, T.assert

-- Il modulo da testare, in versione ridotta
local st = {}

local function valida(v, nome)
  if type(v) ~= "table" then
    return nil, nome .. ": attesa una tabella"
  end
  local n = #v
  if n == 0 then return nil, nome .. ": sequenza vuota" end
  for i = 1, n do
    if type(v[i]) ~= "number" then
      return nil, nome .. ": elemento " .. i
        .. " non numerico"
    end
  end
  return n
end

function st.media(v)
  local n, e = valida(v, "media")
  if not n then return nil, e end
  local s = 0
  for i = 1, n do s = s + v[i] end
  return s / n
end

function st.mediana(v)
  local n, e = valida(v, "mediana")
  if not n then return nil, e end
  local c = {}
  table.move(v, 1, n, 1, c)
  table.sort(c)
  if n % 2 == 1 then return c[(n + 1) // 2] end
  return (c[n // 2] + c[n // 2 + 1]) / 2
end

function st.varianza(v, campionaria)
  local n, e = valida(v, "varianza")
  if not n then return nil, e end
  if campionaria and n < 2 then
    return nil, "varianza: servono almeno due valori"
  end
  local m = st.media(v)
  local s = 0
  for i = 1, n do
    local d = v[i] - m
    s = s + d * d
  end
  return s / (campionaria and (n - 1) or n)
end

function st.percentile(v, p)
  local n, e = valida(v, "percentile")
  if not n then return nil, e end
  if type(p) ~= "number" or p < 0 or p > 100 then
    return nil, "percentile: p fra 0 e 100"
  end
  local c = {}
  table.move(v, 1, n, 1, c)
  table.sort(c)
  if n == 1 then return c[1] end
  local pos = (p / 100) * (n - 1) + 1
  local basso = math.floor(pos)
  local alto = basso + 1
  if alto > n then return c[n] end
  return c[basso] + (pos - basso) * (c[alto] - c[basso])
end

local function vicino(atteso, ottenuto, tolleranza)
  tolleranza = tolleranza or 1e-9
  return math.abs(atteso - ottenuto) < tolleranza
end

gruppo("statistiche", function()

  gruppo("casi degeneri", function()
    prova("sequenza vuota rifiutata", function()
      a.uguale(nil, st.media({}))
      a.uguale(nil, st.mediana({}))
      a.uguale(nil, st.varianza({}))
    end)

    prova("non tabella rifiutata", function()
      a.uguale(nil, st.media("x"))
      a.uguale(nil, st.media(42))
      a.uguale(nil, st.media(nil))
    end)

    prova("elemento non numerico rifiutato", function()
      a.uguale(nil, st.media({1, "due", 3}))
      a.uguale(nil, st.media({1, {}, 3}))
      a.uguale(nil, st.media({1, true}))
    end)
  end)

  gruppo("un solo elemento", function()
    prova("media di un elemento", function()
      a.uguale(5, st.media({5}))
    end)
    prova("mediana di un elemento", function()
      a.uguale(5, st.mediana({5}))
    end)
    prova("varianza di popolazione e' zero", function()
      a.uguale(0, st.varianza({5}))
    end)
    prova("varianza campionaria rifiutata", function()
      a.uguale(nil, st.varianza({5}, true))
    end)
    prova("percentile di un elemento", function()
      a.uguale(5, st.percentile({5}, 0))
      a.uguale(5, st.percentile({5}, 50))
      a.uguale(5, st.percentile({5}, 100))
    end)
  end)

  gruppo("valori tutti uguali", function()
    prova("media", function()
      a.uguale(7, st.media({7, 7, 7, 7}))
    end)
    prova("mediana", function()
      a.uguale(7, st.mediana({7, 7, 7, 7}))
    end)
    prova("varianza nulla", function()
      a.uguale(0, st.varianza({7, 7, 7, 7}))
      a.uguale(0, st.varianza({7, 7, 7, 7}, true))
    end)
  end)

  gruppo("mediana", function()
    prova("numero dispari di elementi", function()
      a.uguale(3, st.mediana({1, 3, 5}))
      a.uguale(3, st.mediana({5, 1, 3}))
    end)
    prova("numero pari e' la media dei centrali",
      function()
        a.uguale(3, st.mediana({1, 2, 4, 6}))
      end)
    prova("non modifica l'ingresso", function()
      local v = {3, 1, 2}
      st.mediana(v)
      a.uguale({3, 1, 2}, v)
    end)
    prova("valori negativi", function()
      a.uguale(-2, st.mediana({-5, -2, 1}))
    end)
  end)

  gruppo("varianza", function()
    prova("popolazione", function()
      -- {2,4,4,4,5,5,7,9}: media 5, varianza 4
      a.vero(vicino(4,
        st.varianza({2,4,4,4,5,5,7,9})))
    end)
    prova("campionaria e' maggiore", function()
      local v = {2,4,4,4,5,5,7,9}
      a.vero(st.varianza(v, true) > st.varianza(v))
    end)
    prova("due valori", function()
      a.uguale(0.25, st.varianza({1, 2}))
      a.uguale(0.5, st.varianza({1, 2}, true))
    end)
  end)

  gruppo("percentile", function()
    prova("p=0 e' il minimo", function()
      a.uguale(1, st.percentile({1, 2, 3, 4}, 0))
    end)
    prova("p=100 e' il massimo", function()
      a.uguale(4, st.percentile({1, 2, 3, 4}, 100))
    end)
    prova("p=50 coincide con la mediana", function()
      local v = {1, 2, 3, 4, 5}
      a.uguale(st.mediana(v), st.percentile(v, 50))
    end)
    prova("interpolazione fra due valori", function()
      a.vero(vicino(1.5, st.percentile({1, 2}, 50)))
    end)
    prova("p fuori intervallo rifiutato", function()
      a.uguale(nil, st.percentile({1, 2}, -1))
      a.uguale(nil, st.percentile({1, 2}, 101))
      a.uguale(nil, st.percentile({1, 2}, "meta'"))
    end)
    prova("ordine dell'ingresso irrilevante",
      function()
        local ordinata = st.percentile({1,2,3,4,5}, 25)
        local mescolata =
          st.percentile({3,1,5,2,4}, 25)
        a.uguale(ordinata, mescolata)
      end)
  end)

  gruppo("valori speciali", function()
    prova("negativi", function()
      a.uguale(-2, st.media({-1, -2, -3}))
    end)
    prova("misti positivi e negativi", function()
      a.uguale(0, st.media({-5, 0, 5}))
    end)
    prova("float", function()
      a.vero(vicino(1.5, st.media({1.0, 2.0})))
    end)
    prova("zero non e' trattato come assente",
      function()
        a.uguale(0, st.media({0, 0, 0}))
      end)
  end)

end)

os.exit(T.esegui() and 0 or 1)
```

Ventotto test, con la distribuzione che il Capitolo 29 raccomanda: la
maggior parte sui casi limite, pochi sul caso normale.

Il test «non modifica l’ingresso» è quello che coglie l’errore più
comune in questa classe di funzioni: ordinare la sequenza ricevuta invece
di una copia.

Il test «zero non è trattato come assente» verifica la regola del
Capitolo 6 applicata alla validazione: un’implementazione che usasse
`if not v[i] then` per rilevare i buchi rifiuterebbe gli zeri.

La funzione `vicino` con tolleranza è obbligatoria per i confronti fra
float: `a.uguale(4, varianza)` fallirebbe su un risultato pari a
`3.9999999999999996`, che è matematicamente corretto.

**ES 29.5 — Framework con setup, teardown e salto**

*Estendi il framework di test del paragrafo 29.1 con `before_each`,
`after_each` e la possibilità di saltare un test marcandolo.
Verifica che l’ordine di esecuzione sia deterministico.*

```lua
local Test = {}

local prove = {}
local corrente = nil
local ordine = 0

local function percorsoCorrente(nome)
  local percorso = nome
  local g = corrente
  while g do
    percorso = g.nome .. " > " .. percorso
    g = g.padre
  end
  return percorso
end

local function catenaGanci(quale)
  local ganci = {}
  local g = corrente
  while g do
    if g[quale] then
      table.insert(ganci, 1, g[quale])
    end
    g = g.padre
  end
  return ganci
end

function Test.gruppo(nome, corpo)
  local precedente = corrente
  corrente = {nome = nome, padre = precedente}
  corpo()
  corrente = precedente
end

function Test.primaDiOgnuno(f)
  if corrente == nil then
    error("primaDiOgnuno fuori da un gruppo", 2)
  end
  corrente.primaDiOgnuno = f
end

function Test.dopoOgnuno(f)
  if corrente == nil then
    error("dopoOgnuno fuori da un gruppo", 2)
  end
  corrente.dopoOgnuno = f
end

local function registra(nome, corpo, saltata, motivo)
  ordine = ordine + 1
  prove[#prove + 1] = {
    ordine = ordine,
    nome = percorsoCorrente(nome),
    corpo = corpo,
    saltata = saltata,
    motivo = motivo,
    prima = catenaGanci("primaDiOgnuno"),
    dopo = catenaGanci("dopoOgnuno"),
  }
end

function Test.prova(nome, corpo)
  registra(nome, corpo, false)
end

function Test.salta(nome, corpo, motivo)
  registra(nome, corpo, true, motivo or "saltata")
end

local function confronta(a, b)
  if a == b then return true end
  if type(a) ~= "table" or type(b) ~= "table" then
    return false
  end
  for k, v in pairs(a) do
    if not confronta(v, b[k]) then return false end
  end
  for k in pairs(b) do
    if a[k] == nil then return false end
  end
  return true
end

Test.assert = {}

function Test.assert.uguale(atteso, ottenuto, nota)
  if not confronta(atteso, ottenuto) then
    error(string.format("atteso %s, ottenuto %s%s",
      tostring(atteso), tostring(ottenuto),
      nota and (" (" .. nota .. ")") or ""), 2)
  end
end

function Test.assert.vero(v, nota)
  if not v then
    error("atteso vero, ottenuto " .. tostring(v)
      .. (nota and (" (" .. nota .. ")") or ""), 2)
  end
end

function Test.esegui()
  -- ordine DETERMINISTICO: quello di registrazione
  table.sort(prove, function(a, b)
    return a.ordine < b.ordine
  end)

  local passate, fallite, saltate = 0, 0, 0
  local dettagli = {}

  for _, p in ipairs(prove) do
    if p.saltata then
      saltate = saltate + 1
      io.write("s")
    else
      local contesto = {}

      local ok, messaggio = xpcall(function()
        for _, g in ipairs(p.prima) do g(contesto) end
        p.corpo(contesto)
      end, function(m) return tostring(m) end)

      -- i ganci di pulizia girano SEMPRE, anche
      -- se il test e' fallito
      for i = #p.dopo, 1, -1 do
        pcall(p.dopo[i], contesto)
      end

      if ok then
        passate = passate + 1
        io.write(".")
      else
        fallite = fallite + 1
        io.write("F")
        dettagli[#dettagli + 1] = {nome = p.nome,
          messaggio = messaggio}
      end
    end
  end

  io.write("\n\n")
  for _, d in ipairs(dettagli) do
    print("FALLITA: " .. d.nome)
    print("   " .. d.messaggio)
  end

  for _, p in ipairs(prove) do
    if p.saltata then
      print("SALTATA: " .. p.nome .. " (" .. p.motivo
        .. ")")
    end
  end

  print(string.format(
    "%d passate, %d fallite, %d saltate, %d totali",
    passate, fallite, saltate, #prove))

  return fallite == 0
end

-- Uso
local T = Test
local eventi = {}

T.gruppo("esterno", function()
  T.primaDiOgnuno(function(c)
    eventi[#eventi + 1] = "prima esterno"
    c.risorsaEsterna = "aperta"
  end)
  T.dopoOgnuno(function(c)
    eventi[#eventi + 1] = "dopo esterno"
  end)

  T.prova("nel gruppo esterno", function(c)
    eventi[#eventi + 1] = "  corpo esterno"
    T.assert.uguale("aperta", c.risorsaEsterna)
  end)

  T.gruppo("interno", function()
    T.primaDiOgnuno(function(c)
      eventi[#eventi + 1] = "  prima interno"
      c.risorsaInterna = "aperta"
    end)
    T.dopoOgnuno(function(c)
      eventi[#eventi + 1] = "  dopo interno"
    end)

    T.prova("vede entrambe le risorse", function(c)
      eventi[#eventi + 1] = "    corpo interno"
      T.assert.uguale("aperta", c.risorsaEsterna)
      T.assert.uguale("aperta", c.risorsaInterna)
    end)

    T.prova("fallisce ma la pulizia gira", function(c)
      eventi[#eventi + 1] = "    corpo che fallisce"
      T.assert.uguale(1, 2)
    end)

    T.salta("non ancora implementata", function()
      error("questa non deve girare")
    end, "funzionalita' in sviluppo")
  end)
end)

local esito = T.esegui()

print()
print("sequenza degli eventi:")
for _, e in ipairs(eventi) do print("  " .. e) end
```

produce:

```text
..Fs

FALLITA: esterno > interno > fallisce ma la pulizia gira
   ...: atteso 1, ottenuto 2
SALTATA: esterno > interno > non ancora implementata
(funzionalita' in sviluppo)
2 passate, 1 fallite, 1 saltate, 4 totali

sequenza degli eventi:
  prima esterno
    corpo esterno
  dopo esterno
  prima esterno
    prima interno
      corpo interno
    dopo interno
  dopo esterno
  prima esterno
    prima interno
      corpo che fallisce
    dopo interno
  dopo esterno
```

Tre proprietà verificate.

I ganci di preparazione girano dall’**esterno verso l’interno**, quelli
di pulizia in ordine inverso: è la convenzione universale, e riflette il
fatto che le risorse interne possono dipendere da quelle esterne.

I ganci di pulizia girano **anche quando il test fallisce**, il che è
essenziale: un test che lascia un file aperto o una connessione appesa
compromette quelli successivi.

L’ordine di esecuzione è **quello di registrazione**, garantito
ordinando per il contatore assegnato alla registrazione. Senza,
l’ordine dipenderebbe dall’implementazione delle tabelle e potrebbe
variare fra esecuzioni, rendendo i fallimenti irriproducibili.

Il test saltato non viene eseguito affatto: il suo corpo contiene un
`error` che non scatta mai, il che lo dimostra.

**ES 29.6 — Un bug sottile e il test che lo intercetta**

*Prendi una funzione di un capitolo precedente, introduci
deliberatamente un bug sottile, e verifica se la suite di test che
scriveresti lo intercetta. Se non lo intercetta, aggiungi il test
mancante.*

Prendiamo la funzione di partizione dell’ES 11.7 e introduciamo un bug
di un solo carattere.

```lua
-- VERSIONE CORRETTA
local function partizionaCorretta(sequenza, predicato)
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

-- VERSIONE CON IL BUG: il ciclo parte da 2
local function partizionaConBug(sequenza, predicato)
  local si, no = {}, {}
  for i = 2, #sequenza do
    local v = sequenza[i]
    if predicato(v, i) then
      si[#si + 1] = v
    else
      no[#no + 1] = v
    end
  end
  return si, no
end

local function elencoUguale(a, b)
  if #a ~= #b then return false end
  for i = 1, #a do
    if a[i] ~= b[i] then return false end
  end
  return true
end

local CASI = {
  {nome = "caso normale", dati = {1, 2, 3, 4, 5, 6}},
  {nome = "sequenza vuota", dati = {}},
  {nome = "un solo elemento pari", dati = {2}},
  {nome = "un solo elemento dispari", dati = {1}},
  {nome = "primo elemento soddisfa", dati = {2, 1, 3}},
  {nome = "primo non soddisfa", dati = {1, 2, 4}},
  {nome = "tutti soddisfano", dati = {2, 4, 6}},
  {nome = "nessuno soddisfa", dati = {1, 3, 5}},
}

local pari = function(n) return n % 2 == 0 end

print(string.format("%-24s %-10s %-10s %s",
  "CASO", "CORRETTA", "CON BUG", "ESITO"))

local intercettato = 0

for _, c in ipairs(CASI) do
  local siA, noA = partizionaCorretta(c.dati, pari)
  local siB, noB = partizionaConBug(c.dati, pari)

  -- ATTENZIONE: verifichiamo SOLO la partizione "si",
  -- come farebbe un test scritto in fretta
  local ok = elencoUguale(siA, siB)
  if not ok then intercettato = intercettato + 1 end

  print(string.format("%-24s %-10s %-10s %s",
    c.nome,
    "[" .. table.concat(siA, ",") .. "]",
    "[" .. table.concat(siB, ",") .. "]",
    ok and "identici" or "DIFFERENZA"))
end

print()
print("casi che intercettano il bug: " .. intercettato
  .. " su " .. #CASI)
```

produce:

```text
CASO                     CORRETTA   CON BUG    ESITO
caso normale             [2,4,6]    [2,4,6]    identici
sequenza vuota           []         []         identici
un solo elemento pari    [2]        []         DIFFERENZA
un solo elemento dispari []         []         identici
primo elemento soddisfa  [2]        []         DIFFERENZA
primo non soddisfa       [2,4]      [2,4]      identici
tutti soddisfano         [2,4,6]    [4,6]      DIFFERENZA
nessuno soddisfa         []         []         identici

casi che intercettano il bug: 3 su 8
```

Il risultato è la lezione dell’esercizio, e ha due strati.

**Primo strato: il caso normale non basta.** Su otto casi di prova solo
tre intercettano il bug, e sono tutti casi in cui il primo elemento
soddisfa il predicato. Il caso apparentemente più completo — sei
elementi, tre che soddisfano e tre no — **non lo intercetta**, perché il
primo elemento è dispari e la sua perdita non tocca la partizione che
stiamo confrontando. Un test scritto solo su quel caso darebbe verde su
codice rotto.

**Secondo strato, più importante: l’asserzione è parziale.** Il confronto
verifica soltanto la partizione «si» e ignora la «no». Verificando
entrambe, sette casi su otto rivelerebbero il bug, perché l’elemento
perduto finisce quasi sempre in una delle due. La differenza fra tre e
sette non sta nei casi di prova ma in **quanto della risposta si
controlla**.

È l’errore più comune nei test scritti in fretta: si verifica il valore
che interessava in quel momento e si ignora il resto. Un test che
controlla metà del risultato copre metà dei bug, e la metà scoperta non è
segnalata da nulla.

La conclusione operativa è doppia: servono casi scelti per esercitare i
confini — primo elemento, ultimo, unico, collezione vuota — **e**
asserzioni che verifichino l’intero risultato, non la porzione a cui si
stava pensando.

**ES 29.7 — luacheck su un progetto reale**

*Configura `luacheck` su uno dei progetti scritti finora, correggi
tutte le segnalazioni, e documenta quali erano bug reali, quali
erano rumore e quali hai deciso di ignorare con una regola nel
`.luacheckrc`.*

Applicando `luacheck` al progetto del Capitolo 34, le segnalazioni si
dividono in tre categorie.

**Bug reali.** Sono quelli che giustificano lo strumento da soli.

```text
(W111) setting non-standard global variable 'x'
(W113) accessing undefined variable 'nomeSbagliato'
```

Il primo indica un `local` dimenticato; il secondo un errore di battitura
in un nome. Entrambi non producono alcun errore a runtime — restituiscono
`nil` o creano una globale — e possono restare nascosti per anni.

**Rumore da correggere comunque.** Non sono bug ma peggiorano la
leggibilità.

```text
(W211) unused variable 'temporaneo'
(W212) unused argument 'self'
(W311) value assigned to variable 'x' is unused
(W411) variable 'i' was previously defined
(W421) shadowing upvalue 'config'
```

L’ombreggiamento di un upvalue merita attenzione particolare: non è un
errore, ma è la premessa di uno. Una variabile locale che nasconde un
upvalue con lo stesso nome produce codice in cui la stessa parola
significa due cose diverse in punti vicini.

**Segnalazioni da ignorare con una regola.**

```lua
-- .luacheckrc
ignore = {
  "212/self",   -- self inutilizzato nei metodi
  "212/_.*",    -- argomenti con nome che inizia per _
  "542",        -- blocco if vuoto (usato come
                -- documentazione di un caso)
}
```

Il primo caso è il più frequente: un metodo dichiarato con i due punti
riceve `self` anche quando non lo usa, e segnalarlo produce decine di
avvisi inutili.

La regola generale è che ogni voce in `ignore` va **commentata con la
ragione**. Un `.luacheckrc` con dieci codici e nessuna spiegazione è
indistinguibile da uno scritto per far tacere lo strumento, e nel giro di
un anno nessuno saprà più se quelle esclusioni siano ancora giustificate.

**ES 29.8 — Profilatore a campionamento**

*Scrivi un profilatore a campionamento basato su `debug.sethook` con
evento di conteggio, confrontalo con quello per strumentazione del
paragrafo 29.7 sullo stesso carico, e commenta le differenze nei
risultati e nel costo.*

```lua
local Campionatore = {}
Campionatore.__index = Campionatore

function Campionatore.nuovo(intervallo)
  return setmetatable({
    intervallo = intervallo or 10000,
    campioni = {},
    totale = 0,
    attivo = false,
  }, Campionatore)
end

function Campionatore:avvia()
  if self.attivo then return self end
  self.attivo = true
  local campioni = self.campioni

  debug.sethook(function()
    local info = debug.getinfo(2, "Sn")
    if info == nil then return end

    local nome = info.name
    if nome == nil then
      nome = string.format("%s:%d",
        info.short_src, info.linedefined)
    else
      nome = string.format("%s (%s:%d)", nome,
        info.short_src, info.linedefined)
    end

    campioni[nome] = (campioni[nome] or 0) + 1
    self.totale = self.totale + 1
  end, "", self.intervallo)

  return self
end

function Campionatore:ferma()
  debug.sethook()
  self.attivo = false
  return self
end

function Campionatore:rapporto(quanti)
  quanti = quanti or 10
  local elenco = {}
  for nome, n in pairs(self.campioni) do
    elenco[#elenco + 1] = {nome = nome, campioni = n}
  end
  table.sort(elenco, function(a, b)
    if a.campioni ~= b.campioni then
      return a.campioni > b.campioni
    end
    return a.nome < b.nome
  end)

  local righe = {string.format("%-40s %8s %8s",
    "FUNZIONE", "CAMPIONI", "QUOTA")}
  for i = 1, math.min(quanti, #elenco) do
    local v = elenco[i]
    righe[#righe + 1] = string.format(
      "%-40s %8d %7.1f%%",
      v.nome:sub(1, 40), v.campioni,
      v.campioni / self.totale * 100)
  end
  righe[#righe + 1] = string.format(
    "totale campioni: %d", self.totale)
  return table.concat(righe, "\n")
end

-- Carico di prova: tre funzioni con costi molto diversi
local function moltoLenta(n)
  local s = 0
  for i = 1, n do
    s = s + math.sqrt(i) * math.sin(i)
  end
  return s
end

local function media(n)
  local s = 0
  for i = 1, n do s = s + i end
  return s
end

local function veloce(n)
  return n * 2
end

local function carico()
  local s = 0
  for _ = 1, 20 do
    s = s + moltoLenta(200000)
    s = s + media(50000)
    s = s + veloce(1)
  end
  return s
end

-- Confronto con la strumentazione
local Strumentato = {tempi = {}}

local function misuraStrumentata(nome, f, ...)
  local inizio = os.clock()
  local r = f(...)
  local d = os.clock() - inizio
  Strumentato.tempi[nome] =
    (Strumentato.tempi[nome] or 0) + d
  return r
end

print("=== profilatore a campionamento ===")
local c = Campionatore.nuovo(10000)
collectgarbage("collect")
local t1 = os.clock()
c:avvia()
carico()
c:ferma()
local durataConHook = os.clock() - t1
print(c:rapporto(6))

print()
print("=== strumentazione esplicita ===")
collectgarbage("collect")
local t2 = os.clock()
local s = 0
for _ = 1, 20 do
  s = s + misuraStrumentata("moltoLenta",
    moltoLenta, 200000)
  s = s + misuraStrumentata("media", media, 50000)
  s = s + misuraStrumentata("veloce", veloce, 1)
end
local durataStrumentata = os.clock() - t2

local nomi = {}
for n in pairs(Strumentato.tempi) do
  nomi[#nomi + 1] = n
end
table.sort(nomi, function(a, b)
  return Strumentato.tempi[a] > Strumentato.tempi[b]
end)
local totale = 0
for _, n in ipairs(nomi) do
  totale = totale + Strumentato.tempi[n]
end
for _, n in ipairs(nomi) do
  print(string.format("%-24s %8.4f s %7.1f%%", n,
    Strumentato.tempi[n],
    Strumentato.tempi[n] / totale * 100))
end

print()
collectgarbage("collect")
local t3 = os.clock()
carico()
local durataPulita = os.clock() - t3

print(string.format("senza profilatura:   %.4f s",
  durataPulita))
print(string.format("con campionamento:   %.4f s "
  .. "(%.1f%% in piu')", durataConHook,
  (durataConHook / durataPulita - 1) * 100))
print(string.format("con strumentazione:  %.4f s "
  .. "(%.1f%% in piu')", durataStrumentata,
  (durataStrumentata / durataPulita - 1) * 100))
```

Le differenze fra i due approcci sono quelle attese.

Il **campionamento** non richiede alcuna modifica al codice sotto esame:
si attiva, si esegue, si legge il rapporto. Vede **tutte** le funzioni,
comprese quelle di libreria e quelle che non sapevate di chiamare. Il
suo costo dipende dall’intervallo scelto: con diecimila istruzioni fra un
campione e l’altro il rallentamento è modesto.

La **strumentazione** richiede di annotare ogni punto di interesse, e
quindi vede solo ciò che avete deciso di guardare. In compenso i tempi
sono esatti e non stimati, e le funzioni non annotate non pagano nulla.

L’attribuzione del campionamento è **approssimata**: un campione viene
attribuito alla funzione in esecuzione in quel momento, e con pochi
campioni la stima è rumorosa. La proporzione converge al valore vero solo
con molti campioni, il che significa che il profilatore a campionamento
è affidabile sui carichi lunghi e inaffidabile su quelli brevi.

La regola pratica: **campionamento per scoprire dove guardare,
strumentazione per misurare ciò che si è deciso di ottimizzare**.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
