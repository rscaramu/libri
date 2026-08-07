# Capitolo 12 — Tabelle come dizionari e come record

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 11](capitolo-11.md) · [Indice](README.md) · [Capitolo 13 →](capitolo-13.md)

I 5 sorgenti eseguibili di questo capitolo sono in
[`codice/cap12/`](../codice/cap12/).

---

**ES 12.4 — Il multinsieme**

*Scrivi le funzioni per un multinsieme, cioè un insieme che tiene il
conto delle occorrenze, con le operazioni aggiungi, rimuovi, conta,
unione e intersezione, dove l’intersezione prende il minimo delle
molteplicità.*

```lua
local M = {}

function M.nuovo(da)
  local m = {}
  if da then
    for _, v in ipairs(da) do
      m[v] = (m[v] or 0) + 1
    end
  end
  return m
end

function M.aggiungi(m, v, quante)
  quante = quante or 1
  if quante <= 0 then return m end
  m[v] = (m[v] or 0) + quante
  return m
end

function M.rimuovi(m, v, quante)
  quante = quante or 1
  local attuale = m[v]
  if attuale == nil then return m end
  if attuale <= quante then
    m[v] = nil
  else
    m[v] = attuale - quante
  end
  return m
end

function M.conta(m, v)
  return m[v] or 0
end

function M.cardinalita(m)
  local totale, distinti = 0, 0
  for _, n in pairs(m) do
    totale = totale + n
    distinti = distinti + 1
  end
  return totale, distinti
end

function M.unione(a, b)
  local r = {}
  for v, n in pairs(a) do r[v] = n end
  for v, n in pairs(b) do
    r[v] = math.max(r[v] or 0, n)
  end
  return r
end

function M.somma(a, b)
  local r = {}
  for v, n in pairs(a) do r[v] = n end
  for v, n in pairs(b) do r[v] = (r[v] or 0) + n end
  return r
end

function M.intersezione(a, b)
  local r = {}
  for v, n in pairs(a) do
    local m = b[v]
    if m then r[v] = math.min(n, m) end
  end
  return r
end

function M.testo(m)
  local chiavi = {}
  for v in pairs(m) do chiavi[#chiavi + 1] = v end
  table.sort(chiavi, function(x, y)
    return tostring(x) < tostring(y)
  end)
  local pezzi = {}
  for _, v in ipairs(chiavi) do
    pezzi[#pezzi + 1] = tostring(v) .. "x" .. m[v]
  end
  return "{" .. table.concat(pezzi, " ") .. "}"
end

local a = M.nuovo({"a", "b", "a", "c", "a"})
local b = M.nuovo({"a", "b", "b", "d"})

print("a        = " .. M.testo(a))
print("b        = " .. M.testo(b))
print("unione   = " .. M.testo(M.unione(a, b)))
print("somma    = " .. M.testo(M.somma(a, b)))
print("interse. = " .. M.testo(M.intersezione(a, b)))

M.aggiungi(a, "z", 3)
M.rimuovi(a, "a", 2)
print("dopo mod = " .. M.testo(a))
print("conta a  = " .. M.conta(a, "a"))
print("conta x  = " .. M.conta(a, "x"))

local totale, distinti = M.cardinalita(a)
print(string.format("cardinalita: %d totali, %d distinti",
  totale, distinti))
```

produce:

```text
a        = {ax3 bx1 cx1}
b        = {ax1 bx2 dx1}
unione   = {ax3 bx2 cx1 dx1}
somma    = {ax4 bx3 cx1 dx1}
interse. = {ax1 bx1}
dopo mod = {ax1 bx1 cx1 zx3}
conta a  = 1
conta x  = 0
```

La distinzione fra **unione** e **somma** è quella che va decisa
esplicitamente: l’unione prende il massimo delle molteplicità,
la somma le addiziona. Entrambe sono definizioni legittime e servono a
scopi diversi; chiamarle con lo stesso nome sarebbe fonte di confusione.

La rimozione elimina la chiave quando la molteplicità scende a zero,
invece di lasciarla con valore zero: mantiene la struttura pulita e fa sì
che `pairs` non restituisca voci vuote.

**ES 12.5 — Appiattire e ricostruire**

*Scrivi una funzione che appiattisca una struttura annidata di
tabelle in un dizionario a un livello solo, con chiavi che siano il
percorso completo separato da punti. Poi scrivi la funzione inversa
che ricostruisce l’annidamento.*

```lua
local function appiattisci(t, prefisso, fuori)
  fuori = fuori or {}
  prefisso = prefisso or ""

  local chiavi = {}
  for k in pairs(t) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  for _, k in ipairs(chiavi) do
    local v = t[k]
    local percorso = prefisso
    if percorso == "" then
      percorso = tostring(k)
    else
      percorso = percorso .. "." .. tostring(k)
    end

    if type(v) == "table" and next(v) ~= nil then
      appiattisci(v, percorso, fuori)
    else
      fuori[percorso] = v
    end
  end

  return fuori
end

local function annida(piatto)
  local r = {}
  local percorsi = {}
  for p in pairs(piatto) do percorsi[#percorsi + 1] = p end
  table.sort(percorsi)

  for _, percorso in ipairs(percorsi) do
    local corrente = r
    local pezzi = {}
    for pezzo in percorso:gmatch("[^%.]+") do
      pezzi[#pezzi + 1] = pezzo
    end

    for i = 1, #pezzi - 1 do
      local chiave = tonumber(pezzi[i]) or pezzi[i]
      if type(corrente[chiave]) ~= "table" then
        corrente[chiave] = {}
      end
      corrente = corrente[chiave]
    end

    local ultima = pezzi[#pezzi]
    corrente[tonumber(ultima) or ultima] =
      piatto[percorso]
  end

  return r
end

local originale = {
  nome = "app",
  server = {
    host = "localhost",
    porta = 8080,
    tls = {attivo = true, cert = "/x.pem"},
  },
  moduli = {"a", "b", "c"},
  vuota = {},
}

local piatto = appiattisci(originale)

local percorsi = {}
for p in pairs(piatto) do percorsi[#percorsi + 1] = p end
table.sort(percorsi)
for _, p in ipairs(percorsi) do
  print(string.format("  %-24s %s", p,
    tostring(piatto[p])))
end

print()
local ricostruito = annida(piatto)
print("host: " .. ricostruito.server.host)
print("cert: " .. ricostruito.server.tls.cert)
print("moduli: " .. table.concat(ricostruito.moduli, " "))
print("vuota ricostruita? "
  .. tostring(ricostruito.vuota))
```

produce:

```text
  moduli.1                 a
  moduli.2                 b
  moduli.3                 c
  nome                     app
  server.host              localhost
  server.porta             8080
  server.tls.attivo        true
  server.tls.cert          /x.pem
  vuota                    table: 0x...

host: localhost
cert: /x.pem
moduli: a b c
vuota ricostruita? table: 0x...
```

L’operazione **non è perfettamente reversibile**, e i due punti dolenti
vanno dichiarati.

**La tabella vuota** non ha percorsi da appiattire, quindi viene trattata
come una foglia e conservata per riferimento. È una scelta: l’alternativa
sarebbe perderla del tutto.

**La distinzione fra chiave numerica e stringa numerica** si perde: il
percorso `moduli.1` non dice se la chiave originale era il numero uno o
la stringa `"1"`. La ricostruzione tenta `tonumber` e sceglie il numero,
il che è corretto per le sequenze e sbagliato per un dizionario con
chiavi stringa numeriche.

Un percorso che contenga un punto nel nome della chiave rompe tutto: è il
terzo limite, e va documentato o gestito con un separatore diverso.

**ES 12.6 — Cache con scadenza**

*Implementa una cache con scadenza: ogni voce memorizza il valore e
l’istante di inserimento, e viene considerata assente dopo un numero
di secondi dato. Usa `os.time` e gestisci la pulizia delle voci
scadute senza scorrere l’intera cache a ogni accesso.*

```lua
local Cache = {}
Cache.__index = Cache

function Cache.nuova(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    durata = opzioni.durata or 60,
    orologio = opzioni.orologio or os.time,
    ogniQuante = opzioni.ogniQuante or 50,
    dati = {},
    quante = 0,
    accessi = 0,
    scaduteRimosse = 0,
  }, Cache)
end

function Cache:pulisci()
  local adesso = self.orologio()
  local daRimuovere = {}
  for k, voce in pairs(self.dati) do
    if adesso - voce.istante >= self.durata then
      daRimuovere[#daRimuovere + 1] = k
    end
  end
  for _, k in ipairs(daRimuovere) do
    self.dati[k] = nil
    self.quante = self.quante - 1
    self.scaduteRimosse = self.scaduteRimosse + 1
  end
  return #daRimuovere
end

function Cache:imposta(chiave, valore)
  self.accessi = self.accessi + 1
  if self.accessi % self.ogniQuante == 0 then
    self:pulisci()
  end
  if self.dati[chiave] == nil then
    self.quante = self.quante + 1
  end
  self.dati[chiave] = {
    valore = valore,
    istante = self.orologio(),
  }
  return valore
end

function Cache:leggi(chiave)
  self.accessi = self.accessi + 1
  local voce = self.dati[chiave]
  if voce == nil then return nil, "assente" end

  if self.orologio() - voce.istante >= self.durata then
    self.dati[chiave] = nil
    self.quante = self.quante - 1
    self.scaduteRimosse = self.scaduteRimosse + 1
    return nil, "scaduta"
  end

  return voce.valore
end

function Cache:stato()
  return {
    voci = self.quante,
    accessi = self.accessi,
    scadute = self.scaduteRimosse,
  }
end

local adesso = 1000
local c = Cache.nuova({
  durata = 10,
  ogniQuante = 5,
  orologio = function() return adesso end,
})

c:imposta("a", "valore a")
c:imposta("b", "valore b")
print("t=1000 a: " .. tostring(c:leggi("a")))

adesso = 1005
c:imposta("c", "valore c")
print("t=1005 a: " .. tostring(c:leggi("a")))

adesso = 1011
print("t=1011 a: " .. tostring(select(2, c:leggi("a"))))
print("t=1011 c: " .. tostring(c:leggi("c")))

for i = 1, 10 do c:imposta("riempi" .. i, i) end

local s = c:stato()
print(string.format(
  "voci=%d accessi=%d scadute rimosse=%d",
  s.voci, s.accessi, s.scadute))
```

La strategia di pulizia è **pigra su due livelli**. Alla lettura, una
voce scaduta viene rimossa individualmente: costa nulla e mantiene
corretto il risultato. Ogni `ogniQuante` accessi si esegue una scansione
completa, che rimuove le voci scadute che nessuno ha più letto.

L’alternativa — scansione a ogni accesso — sarebbe corretta e
proporzionalmente costosa al numero di voci. L’alternativa opposta —
nessuna scansione — lascerebbe crescere la cache indefinitamente con le
voci mai più richieste.

L’orologio iniettabile rende il test istantaneo e riproducibile, secondo
la tecnica dell’ES 14.2.

**ES 12.7 — Indice su un campo qualunque**

*Data una sequenza di record con più campi, scrivi una funzione che
costruisca un indice su un campo qualunque, passato come nome,
restituendo un dizionario da valore del campo a sequenza di record.
Verificane il comportamento quando il campo è assente in qualche
record.*

```lua
local function indicizza(elenco, campo, opzioni)
  opzioni = opzioni or {}
  local indice = {}
  local senzaCampo = {}

  for i, record in ipairs(elenco) do
    if type(record) ~= "table" then
      return nil, "elemento " .. i .. " non e' un record"
    end

    local valore = record[campo]

    if valore == nil then
      senzaCampo[#senzaCampo + 1] = i
      if opzioni.chiaveMancante ~= nil then
        valore = opzioni.chiaveMancante
      end
    end

    if valore ~= nil then
      local gruppo = indice[valore]
      if gruppo == nil then
        gruppo = {}
        indice[valore] = gruppo
      end
      gruppo[#gruppo + 1] = record
    end
  end

  return indice, senzaCampo
end

local PERSONE = {
  {nome = "Anna", citta = "Roma", ruolo = "admin"},
  {nome = "Bruno", citta = "Milano", ruolo = "utente"},
  {nome = "Carla", citta = "Roma", ruolo = "utente"},
  {nome = "Dario", ruolo = "utente"},
  {nome = "Elena", citta = "Milano"},
}

local perCitta, mancanti = indicizza(PERSONE, "citta")

local chiavi = {}
for k in pairs(perCitta) do chiavi[#chiavi + 1] = k end
table.sort(chiavi)

for _, c in ipairs(chiavi) do
  local nomi = {}
  for _, p in ipairs(perCitta[c]) do
    nomi[#nomi + 1] = p.nome
  end
  print(string.format("%-10s %s", c,
    table.concat(nomi, ", ")))
end
print("record senza il campo: "
  .. table.concat(mancanti, ", "))

print()
local conRiserva = indicizza(PERSONE, "citta",
  {chiaveMancante = "(sconosciuta)"})
local nomi = {}
for _, p in ipairs(conRiserva["(sconosciuta)"]) do
  nomi[#nomi + 1] = p.nome
end
print("con chiave di riserva: " .. table.concat(nomi, ", "))
```

produce:

```text
Milano     Bruno, Elena
Roma       Anna, Carla
record senza il campo: 4

con chiave di riserva: Dario
```

Il comportamento sui record che non hanno il campo va **deciso e
dichiarato**, e le due opzioni sono entrambe legittime: escluderli
dall’indice, segnalandone le posizioni, oppure raggrupparli sotto una
chiave di riserva.

Scartarli in silenzio sarebbe la terza opzione, ed è quella da evitare:
chi usa l’indice non saprebbe che alcuni record non ci sono.

I record nell’indice sono **riferimenti** agli originali, non copie:
modificarli attraverso l’indice modifica l’elenco. È coerente con la
semantica delle tabelle ma va documentato.

**ES 12.8 — Confronto fra due dizionari**

*Scrivi una funzione che confronti due dizionari e restituisca tre
insiemi: le chiavi presenti solo nel primo, quelle presenti solo nel
secondo, e quelle presenti in entrambi con valori diversi. Usala per
confrontare due configurazioni e stampare un rapporto leggibile.*

```lua
local function confronta(a, b)
  local soloA, soloB, diversi, uguali = {}, {}, {}, {}

  for k, va in pairs(a) do
    local vb = b[k]
    if vb == nil then
      soloA[#soloA + 1] = k
    elseif va ~= vb then
      diversi[#diversi + 1] = {chiave = k,
        primo = va, secondo = vb}
    else
      uguali[#uguali + 1] = k
    end
  end

  for k in pairs(b) do
    if a[k] == nil then
      soloB[#soloB + 1] = k
    end
  end

  local function ordinaChiavi(t)
    table.sort(t, function(x, y)
      return tostring(x) < tostring(y)
    end)
    return t
  end

  ordinaChiavi(soloA)
  ordinaChiavi(soloB)
  ordinaChiavi(uguali)
  table.sort(diversi, function(x, y)
    return tostring(x.chiave) < tostring(y.chiave)
  end)

  return {
    soloPrimo = soloA,
    soloSecondo = soloB,
    diversi = diversi,
    uguali = uguali,
  }
end

local function rapporto(differenze, nomeA, nomeB)
  local righe = {}

  righe[#righe + 1] = string.format(
    "Confronto fra %s e %s", nomeA, nomeB)
  righe[#righe + 1] = string.rep("-", 46)

  if #differenze.soloPrimo > 0 then
    righe[#righe + 1] = "Solo in " .. nomeA .. ":"
    for _, k in ipairs(differenze.soloPrimo) do
      righe[#righe + 1] = "  - " .. tostring(k)
    end
  end

  if #differenze.soloSecondo > 0 then
    righe[#righe + 1] = "Solo in " .. nomeB .. ":"
    for _, k in ipairs(differenze.soloSecondo) do
      righe[#righe + 1] = "  + " .. tostring(k)
    end
  end

  if #differenze.diversi > 0 then
    righe[#righe + 1] = "Valori diversi:"
    for _, d in ipairs(differenze.diversi) do
      righe[#righe + 1] = string.format(
        "  ~ %s: %s -> %s", tostring(d.chiave),
        tostring(d.primo), tostring(d.secondo))
    end
  end

  righe[#righe + 1] = string.format(
    "Identiche: %d chiavi", #differenze.uguali)

  return table.concat(righe, "\n")
end

local PRODUZIONE = {
  host = "prod.example.com",
  porta = 443,
  timeout = 30,
  debug = false,
  cache = true,
}

local SVILUPPO = {
  host = "localhost",
  porta = 8080,
  timeout = 30,
  debug = true,
  verboso = 3,
}

print(rapporto(confronta(PRODUZIONE, SVILUPPO),
  "produzione", "sviluppo"))
```

produce:

```text
Confronto fra produzione e sviluppo
----------------------------------------------
Solo in produzione:
  - cache
Solo in sviluppo:
  + verboso
Valori diversi:
  ~ debug: false -> true
  ~ host: prod.example.com -> localhost
  ~ porta: 443 -> 8080
Identiche: 1 chiavi
```

Il confronto richiede **due cicli**: uno su ciascun dizionario. Con un
solo ciclo si perderebbero le chiavi presenti solo nel secondo.

Il confronto `va ~= vb` funziona per scalari; su valori che sono tabelle
confronterebbe l’identità, segnalando come diverse due tabelle con lo
stesso contenuto. Per un confronto profondo servirebbe la funzione
dell’ES 10.2.

Notate il caso `debug`: `false` è un valore legittimo e viene
correttamente confrontato. Un’implementazione che usasse `if not vb then`
per verificare l’assenza lo avrebbe scambiato per una chiave mancante.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
