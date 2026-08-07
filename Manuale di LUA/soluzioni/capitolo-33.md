# Capitolo 33 — Web e scripting di rete: OpenResty e dintorni

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 32](capitolo-32.md) · [Indice](README.md) · [Capitolo 34 →](capitolo-34.md)

---

Le soluzioni di questo capitolo riguardano OpenResty e Redis, che non
sono disponibili nell’ambiente in cui il manuale è stato preparato. Il
codice è verificato sintatticamente; dove possibile, la logica è
riscritta in forma provabile fuori da nginx tramite l’iniezione delle
dipendenze, secondo la tecnica dell’ES 33.1.

**ES 33.3 — Validazione dei parametri nel gateway**

*Estendi il gateway del paragrafo 33.6 con la validazione dello
schema dei parametri, riusando il validatore dell’ES 21.1, e con una
risposta d’errore che elenchi tutti i problemi.*

```lua
local M = {}

local function confrontabile(v, soglia)
  local tv, ts = type(v), type(soglia)
  return (tv == "number" and ts == "number")
      or (tv == "string" and ts == "string")
end

local CONVERSIONI = {
  numero = function(v)
    local n = tonumber(v)
    if n == nil then return nil, "non numerico" end
    return n
  end,
  intero = function(v)
    local n = tonumber(v)
    if n == nil then return nil, "non numerico" end
    if n ~= math.floor(n) then
      return nil, "non intero"
    end
    return math.tointeger(n) or n
  end,
  booleano = function(v)
    if v == "true" or v == "1" or v == "si" then
      return true
    end
    if v == "false" or v == "0" or v == "no" then
      return false
    end
    return nil, "non booleano"
  end,
  testo = function(v) return tostring(v) end,
}

function M.valida(parametri, schema)
  local puliti = {}
  local errori = {}

  for nome, regola in pairs(schema) do
    local grezzo = parametri[nome]

    -- I parametri di query multipli arrivano come
    -- tabella: prendiamo l'ultimo, come fanno i
    -- server web piu' diffusi.
    if type(grezzo) == "table" then
      grezzo = grezzo[#grezzo]
    end

    if grezzo == nil or grezzo == "" then
      if regola.obbligatorio then
        errori[#errori + 1] = {campo = nome,
          motivo = "parametro obbligatorio mancante"}
      elseif regola.predefinito ~= nil then
        puliti[nome] = regola.predefinito
      end

    else
      local converti = CONVERSIONI[regola.tipo or "testo"]
      if converti == nil then
        errori[#errori + 1] = {campo = nome,
          motivo = "tipo di schema sconosciuto: "
            .. tostring(regola.tipo)}
      else
        local valore, motivo = converti(grezzo)
        if valore == nil then
          errori[#errori + 1] = {campo = nome,
            motivo = motivo, ricevuto = grezzo}
        else
          local ok = true

          if regola.minimo ~= nil then
            if not confrontabile(valore,
                regola.minimo) then
              errori[#errori + 1] = {campo = nome,
                motivo = "non confrontabile con il "
                  .. "minimo"}
              ok = false
            elseif valore < regola.minimo then
              errori[#errori + 1] = {campo = nome,
                motivo = "minore del minimo "
                  .. tostring(regola.minimo),
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.massimo ~= nil then
            if not confrontabile(valore,
                regola.massimo) then
              errori[#errori + 1] = {campo = nome,
                motivo = "non confrontabile con il "
                  .. "massimo"}
              ok = false
            elseif valore > regola.massimo then
              errori[#errori + 1] = {campo = nome,
                motivo = "maggiore del massimo "
                  .. tostring(regola.massimo),
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.ammessi then
            local trovato = false
            for _, a in ipairs(regola.ammessi) do
              if valore == a then trovato = true break end
            end
            if not trovato then
              errori[#errori + 1] = {campo = nome,
                motivo = "valore non ammesso",
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.pattern
             and type(valore) == "string" then
            if not valore:match(regola.pattern) then
              errori[#errori + 1] = {campo = nome,
                motivo = "formato non valido"}
              ok = false
            end
          end

          if ok then puliti[nome] = valore end
        end
      end
    end
  end

  for nome in pairs(parametri) do
    if schema[nome] == nil then
      errori[#errori + 1] = {campo = nome,
        motivo = "parametro non previsto"}
    end
  end

  table.sort(errori, function(a, b)
    if a.campo ~= b.campo then
      return a.campo < b.campo
    end
    return a.motivo < b.motivo
  end)

  if #errori > 0 then return nil, errori end
  return puliti
end

-- Uso nel gestore OpenResty
local SCHEMA = {
  n = {tipo = "intero", obbligatorio = true,
       minimo = 1, massimo = 1000},
  formato = {tipo = "testo", predefinito = "json",
             ammessi = {"json", "csv", "testo"}},
  dettaglio = {tipo = "booleano",
               predefinito = false},
  etichetta = {tipo = "testo",
               pattern = "^[%w%-_]+$"},
}

function M.gestisci(parametri, rispondi)
  local puliti, errori = M.valida(parametri, SCHEMA)

  if puliti == nil then
    return rispondi(400, {
      errore = "parametri non validi",
      dettagli = errori,
    })
  end

  local somma = 0
  for i = 1, puliti.n do somma = somma + i end

  return rispondi(200, {
    n = puliti.n,
    somma = somma,
    formato = puliti.formato,
    dettaglio = puliti.dettaglio,
  })
end

-- Prova fuori da nginx
local function rispondiFinta(stato, corpo)
  local pezzi = {}
  local chiavi = {}
  for k in pairs(corpo) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  for _, k in ipairs(chiavi) do
    local v = corpo[k]
    if type(v) == "table" then
      local sotto = {}
      for _, e in ipairs(v) do
        sotto[#sotto + 1] = e.campo .. "="
          .. e.motivo
      end
      pezzi[#pezzi + 1] = k .. ":["
        .. table.concat(sotto, "; ") .. "]"
    else
      pezzi[#pezzi + 1] = k .. "=" .. tostring(v)
    end
  end
  return stato, table.concat(pezzi, " ")
end

local CASI = {
  {nome = "tutto valido",
   p = {n = "10", formato = "csv"}},
  {nome = "solo obbligatorio", p = {n = "5"}},
  {nome = "n mancante", p = {formato = "json"}},
  {nome = "n non numerico", p = {n = "molti"}},
  {nome = "n non intero", p = {n = "3.5"}},
  {nome = "n fuori intervallo", p = {n = "5000"}},
  {nome = "formato non ammesso",
   p = {n = "1", formato = "xml"}},
  {nome = "etichetta con spazi",
   p = {n = "1", etichetta = "con spazio"}},
  {nome = "parametro ignoto",
   p = {n = "1", sconosciuto = "x"}},
  {nome = "errori multipli",
   p = {n = "abc", formato = "xml", extra = "1"}},
  {nome = "valore multiplo",
   p = {n = {"1", "7"}}},
}

for _, c in ipairs(CASI) do
  local stato, testo = M.gestisci(c.p, rispondiFinta)
  print(string.format("%-22s %d  %s", c.nome, stato,
    testo))
end

return M
```

produce:

```text
tutto valido           200  dettaglio=false
                            formato=csv n=10 somma=55
solo obbligatorio      200  dettaglio=false
                            formato=json n=5 somma=15
n mancante             400  dettagli:[n=parametro
                            obbligatorio mancante]
                            errore=parametri non validi
n non numerico         400  dettagli:[n=non numerico]
                            errore=parametri non validi
n non intero           400  dettagli:[n=non intero]
                            errore=parametri non validi
n fuori intervallo     400  dettagli:[n=maggiore del
                            massimo 1000]
                            errore=parametri non validi
formato non ammesso    400  dettagli:[formato=valore
                            non ammesso]
                            errore=parametri non validi
etichetta con spazi    400  dettagli:[etichetta=formato
                            non valido]
                            errore=parametri non validi
parametro ignoto       400  dettagli:[sconosciuto=
                            parametro non previsto]
                            errore=parametri non validi
errori multipli        400  dettagli:[extra=parametro
                            non previsto; formato=valore
                            non ammesso; n=non numerico]
                            errore=parametri non validi
valore multiplo        200  dettaglio=false
                            formato=json n=7 somma=28
```

Tre elementi.

La risposta d’errore elenca **tutti** i problemi, non il primo: un
client che invia tre parametri sbagliati riceve tre segnalazioni e
corregge in una volta sola. È la scelta dell’ES 21.1 applicata a un’API.

I **parametri di query ripetuti** — `?n=1&n=7` — arrivano da OpenResty
come tabella. Il codice prende l’ultimo, che è la convenzione più
diffusa, ma la scelta va dichiarata perché altri server prendono il
primo.

I **parametri non previsti** vengono rifiutati. Su un’API pubblica la
scelta è discutibile, perché impedisce l’aggiunta di parametri
sperimentali dai client; su un’API interna è preferibile, perché
intercetta gli errori di battitura invece di ignorarli.

**ES 33.4 — Cache a due livelli per OpenResty**

*Implementa una cache a due livelli per OpenResty: un livello per
processo con `lua-resty-lrucache` e uno condiviso con
`lua_shared_dict`. Verifica che il primo livello riduca gli accessi
al secondo.*

```lua
local M = {}

local Cache = {}
Cache.__index = Cache

function M.nuova(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    -- livello 1: per processo, in memoria Lua
    locale = opzioni.locale or {},
    localeChiavi = {},
    localeMassimo = opzioni.localeMassimo or 200,
    localeTtl = opzioni.localeTtl or 5,

    -- livello 2: condiviso fra processi
    condivisa = opzioni.condivisa,
    condivisaTtl = opzioni.condivisaTtl or 60,

    codifica = opzioni.codifica
      or function(v) return v end,
    decodifica = opzioni.decodifica
      or function(v) return v end,
    orologio = opzioni.orologio or os.time,

    letture = 0,
    colpiL1 = 0,
    colpiL2 = 0,
    mancati = 0,
  }, Cache)
end

function Cache:scadutaL1(voce)
  return self.orologio() - voce.istante
    >= self.localeTtl
end

function Cache:inserisciL1(chiave, valore)
  if self.locale[chiave] == nil then
    self.localeChiavi[#self.localeChiavi + 1] = chiave
    if #self.localeChiavi > self.localeMassimo then
      local vecchia = table.remove(self.localeChiavi, 1)
      self.locale[vecchia] = nil
    end
  end
  self.locale[chiave] = {
    valore = valore,
    istante = self.orologio(),
  }
end

function Cache:leggi(chiave)
  self.letture = self.letture + 1

  local voce = self.locale[chiave]
  if voce ~= nil then
    if not self:scadutaL1(voce) then
      self.colpiL1 = self.colpiL1 + 1
      return voce.valore, "L1"
    end
    self.locale[chiave] = nil
  end

  if self.condivisa then
    local grezzo = self.condivisa:get(chiave)
    if grezzo ~= nil then
      self.colpiL2 = self.colpiL2 + 1
      local valore = self.decodifica(grezzo)
      -- promozione al livello 1
      self:inserisciL1(chiave, valore)
      return valore, "L2"
    end
  end

  self.mancati = self.mancati + 1
  return nil, "assente"
end

function Cache:scrivi(chiave, valore)
  self:inserisciL1(chiave, valore)
  if self.condivisa then
    self.condivisa:set(chiave, self.codifica(valore),
      self.condivisaTtl)
  end
  return valore
end

function Cache:invalida(chiave)
  self.locale[chiave] = nil
  for i = #self.localeChiavi, 1, -1 do
    if self.localeChiavi[i] == chiave then
      table.remove(self.localeChiavi, i)
    end
  end
  if self.condivisa then
    self.condivisa:delete(chiave)
  end
end

function Cache:statistiche()
  local totale = self.letture
  return {
    letture = totale,
    colpiL1 = self.colpiL1,
    colpiL2 = self.colpiL2,
    mancati = self.mancati,
    quotaL1 = totale > 0
      and (self.colpiL1 / totale * 100) or 0,
    accessiAlLivello2 = self.colpiL2 + self.mancati,
  }
end

-- Dizionario condiviso simulato, per provare
-- fuori da nginx
local function dizionarioFinto(orologio)
  local dati = {}
  local accessi = 0
  return {
    get = function(_, k)
      accessi = accessi + 1
      local v = dati[k]
      if v == nil then return nil end
      if v.scade and orologio() >= v.scade then
        dati[k] = nil
        return nil
      end
      return v.valore
    end,
    set = function(_, k, v, ttl)
      accessi = accessi + 1
      dati[k] = {valore = v,
        scade = ttl and (orologio() + ttl)}
      return true
    end,
    delete = function(_, k) dati[k] = nil end,
    accessi = function() return accessi end,
  }
end

local adesso = 1000
local dizionario = dizionarioFinto(
  function() return adesso end)

local c = M.nuova({
  condivisa = dizionario,
  localeTtl = 5,
  condivisaTtl = 60,
  localeMassimo = 3,
  orologio = function() return adesso end,
})

c:scrivi("a", "valore-a")
c:scrivi("b", "valore-b")

local accessiPrima = dizionario.accessi()

for _ = 1, 100 do
  c:leggi("a")
  c:leggi("b")
end

local s1 = c:statistiche()
print(string.format(
  "200 letture: L1=%d L2=%d mancati=%d",
  s1.colpiL1, s1.colpiL2, s1.mancati))
print("accessi al dizionario condiviso: "
  .. (dizionario.accessi() - accessiPrima))

adesso = adesso + 6

local accessiPrima2 = dizionario.accessi()
for _ = 1, 100 do
  c:leggi("a")
end
local s2 = c:statistiche()
print()
print("dopo la scadenza di L1 (6 secondi):")
print(string.format("  L1=%d L2=%d mancati=%d",
  s2.colpiL1 - s1.colpiL1,
  s2.colpiL2 - s1.colpiL2,
  s2.mancati - s1.mancati))
print("  accessi al condiviso: "
  .. (dizionario.accessi() - accessiPrima2))

adesso = adesso + 100
local accessiPrima3 = dizionario.accessi()
local v, dove = c:leggi("a")
print()
print("dopo la scadenza anche di L2: "
  .. tostring(v) .. " (" .. dove .. ")")
print("  accessi al condiviso: "
  .. (dizionario.accessi() - accessiPrima3))

return M
```

produce:

```text
200 letture: L1=200 L2=0 mancati=0
accessi al dizionario condiviso: 0

dopo la scadenza di L1 (6 secondi):
  L1=99 L2=1 mancati=0
  accessi al condiviso: 1

dopo la scadenza anche di L2: nil (assente)
  accessi al condiviso: 1
```

La verifica richiesta è nella prima e nella seconda sezione.

Duecento letture consecutive producono **zero accessi** al dizionario
condiviso: il livello locale le serve tutte. In OpenResty questo
significa evitare duecento operazioni su una struttura protetta da un
lucchetto condiviso fra i processi, che sotto carico è il punto di
contesa principale.

Dopo la scadenza del livello uno, la prima lettura scende al livello due
— un solo accesso al condiviso — e **promuove** il valore, così che le
novantanove successive tornino a essere servite localmente.

Il rapporto fra i due livelli è il punto di progetto: un TTL locale breve
riduce l’incoerenza fra processi, uno lungo riduce la contesa. Cinque
secondi contro sessanta è un compromesso ragionevole per dati che
cambiano lentamente.

**ES 33.5 — Coda con priorità in Redis**

*Scrivi uno script Redis in Lua che implementi una coda con priorità,
garantendo che l’estrazione dell’elemento a priorità più alta e la
sua rimozione avvengano atomicamente.*

```lua
-- Script Redis: inserimento atomico con priorita'
-- KEYS[1] = chiave dell'insieme ordinato
-- KEYS[2] = chiave del contatore di sequenza
-- ARGV[1] = priorita' (numero, piu' alto = prima)
-- ARGV[2] = payload
local chiaveCoda = KEYS[1]
local chiaveSequenza = KEYS[2]
local priorita = tonumber(ARGV[1])
local payload = ARGV[2]

if priorita == nil then
  return redis.error_reply("priorita' non numerica")
end

-- La sequenza garantisce l'ordine FIFO a parita'
-- di priorita'. Il punteggio combina i due valori:
-- priorita' nella parte alta, sequenza (negata,
-- per avere il piu' vecchio prima) nella bassa.
local sequenza = redis.call("INCR", chiaveSequenza)

local punteggio = priorita * 1000000000
  - (sequenza % 1000000000)

redis.call("ZADD", chiaveCoda, punteggio, payload)

return {sequenza, punteggio}
```

```lua
-- Script Redis: estrazione atomica del massimo
-- KEYS[1] = chiave dell'insieme ordinato
-- ARGV[1] = quanti elementi estrarre (opzionale)
local chiaveCoda = KEYS[1]
local quanti = tonumber(ARGV[1]) or 1

if quanti < 1 then
  return redis.error_reply("quantita' non valida")
end

-- ZPOPMAX e' gia' atomico, ma lo avvolgiamo per
-- poter aggiungere logica senza perdere l'atomicita'
local estratti = redis.call("ZPOPMAX", chiaveCoda,
  quanti)

if #estratti == 0 then
  return {}
end

local risultato = {}
for i = 1, #estratti, 2 do
  local payload = estratti[i]
  local punteggio = tonumber(estratti[i + 1])
  local priorita = math.floor(punteggio / 1000000000)

  risultato[#risultato + 1] = payload
  risultato[#risultato + 1] = tostring(priorita)

  -- Registrazione dell'estrazione, nello stesso
  -- script: nessun'altra connessione puo' intervenire
  redis.call("HINCRBY", chiaveCoda .. ":stat",
    "estratti", 1)
  redis.call("HSET", chiaveCoda .. ":stat",
    "ultimo", payload)
end

return risultato
```

L’uso dal lato client:

```lua
local INSERISCI = [[ ... primo script ... ]]
local ESTRAI = [[ ... secondo script ... ]]

local function esempio(rossa)
  -- caricamento una volta sola
  local shaInserisci = rossa:script("LOAD", INSERISCI)
  local shaEstrai = rossa:script("LOAD", ESTRAI)

  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "1", "lavoro a bassa priorita'")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "9", "lavoro urgente")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "5", "lavoro normale")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "9", "secondo urgente")

  local r = rossa:evalsha(shaEstrai, 1, "coda", "4")
  -- ordine atteso:
  --   lavoro urgente (9, sequenza 2)
  --   secondo urgente (9, sequenza 4)
  --   lavoro normale (5)
  --   lavoro a bassa priorita' (1)
  return r
end
```

Il punto dell’esercizio è l’**atomicità**, e va spiegato con precisione.

Senza script, l’estrazione richiederebbe due comandi: `ZREVRANGE` per
trovare l’elemento con punteggio massimo e `ZREM` per rimuoverlo. Fra i
due, un’altra connessione può eseguire gli stessi comandi e ottenere lo
**stesso elemento**: due lavoratori elaborerebbero lo stesso lavoro.

Redis esegue gli script Lua **atomicamente**: durante l’esecuzione
nessun altro comando viene servito, da nessuna connessione. Il `ZPOPMAX`
e la registrazione delle statistiche avvengono senza che nulla possa
inserirsi.

La combinazione di priorità e sequenza in un punteggio unico è la
tecnica standard per ottenere un ordinamento a due criteri con un
insieme ordinato, che ne ammette uno solo. La priorità occupa la parte
alta, la sequenza negata la parte bassa: due elementi con la stessa
priorità sono ordinati per anzianità.

Il limite da dichiarare: i punteggi di Redis sono float a doppia
precisione, quindi la combinazione funziona finché priorità e sequenza
restano entro i cinquantatré bit di mantissa. Con un miliardo come
moltiplicatore, la priorità massima sicura è attorno a nove milioni.

**ES 33.6 — Interruttore automatico**

*Prendi il client dell’ES 33.2 e aggiungi un interruttore automatico:
dopo N fallimenti consecutivi verso lo stesso servizio, le richieste
vengono rifiutate immediatamente per un periodo, senza nemmeno
tentare.*

```lua
local M = {}

local Interruttore = {}
Interruttore.__index = Interruttore

local CHIUSO = "chiuso"
local APERTO = "aperto"
local SEMIAPERTO = "semiaperto"

function M.nuovo(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    soglia = opzioni.soglia or 5,
    attesa = opzioni.attesa or 30,
    prove = opzioni.prove or 1,
    orologio = opzioni.orologio or os.time,

    stato = CHIUSO,
    fallimenti = 0,
    successiSemiaperto = 0,
    apertoDa = nil,
    transizioni = {},
  }, Interruttore)
end

function Interruttore:registraTransizione(da, a, motivo)
  self.transizioni[#self.transizioni + 1] = {
    istante = self.orologio(),
    da = da, a = a, motivo = motivo,
  }
end

function Interruttore:aggiornaStato()
  if self.stato == APERTO then
    if self.orologio() - self.apertoDa >= self.attesa then
      self:registraTransizione(APERTO, SEMIAPERTO,
        "attesa trascorsa")
      self.stato = SEMIAPERTO
      self.successiSemiaperto = 0
    end
  end
end

function Interruttore:permesso()
  self:aggiornaStato()
  if self.stato == APERTO then
    local rimanente = self.attesa
      - (self.orologio() - self.apertoDa)
    return false, string.format(
      "interruttore aperto, riprova fra %d s",
      math.max(0, rimanente))
  end
  return true
end

function Interruttore:successo()
  if self.stato == SEMIAPERTO then
    self.successiSemiaperto =
      self.successiSemiaperto + 1
    if self.successiSemiaperto >= self.prove then
      self:registraTransizione(SEMIAPERTO, CHIUSO,
        "prove riuscite")
      self.stato = CHIUSO
      self.fallimenti = 0
    end
  else
    self.fallimenti = 0
  end
end

function Interruttore:fallimento()
  if self.stato == SEMIAPERTO then
    self:registraTransizione(SEMIAPERTO, APERTO,
      "prova fallita")
    self.stato = APERTO
    self.apertoDa = self.orologio()
    return
  end

  self.fallimenti = self.fallimenti + 1
  if self.fallimenti >= self.soglia then
    self:registraTransizione(CHIUSO, APERTO,
      self.fallimenti .. " fallimenti consecutivi")
    self.stato = APERTO
    self.apertoDa = self.orologio()
  end
end

function Interruttore:esegui(azione, ...)
  local ok, motivo = self:permesso()
  if not ok then
    return nil, motivo, "rifiutata"
  end

  local risultati = table.pack(pcall(azione, ...))

  if risultati[1] and risultati[2] ~= nil then
    self:successo()
    return table.unpack(risultati, 2, risultati.n)
  end

  self:fallimento()
  if not risultati[1] then
    return nil, tostring(risultati[2]), "errore"
  end
  return nil, tostring(risultati[3])
    or "fallimento", "fallita"
end

-- Prova con orologio simulato
local adesso = 0
local i = M.nuovo({
  soglia = 3,
  attesa = 10,
  prove = 2,
  orologio = function() return adesso end,
})

local serviziGuasto = true

local function servizio()
  if serviziGuasto then
    error("connessione rifiutata", 0)
  end
  return "risposta ok"
end

local function passo(etichetta)
  local r, motivo, esito = i:esegui(servizio)
  print(string.format("t=%3d %-22s stato=%-11s %s",
    adesso, etichetta, i.stato,
    r and ("ok: " .. r)
      or (tostring(esito) .. ": " .. tostring(motivo))))
end

print("--- servizio guasto ---")
for k = 1, 5 do
  passo("chiamata " .. k)
  adesso = adesso + 1
end

print()
print("--- durante l'attesa ---")
adesso = adesso + 3
passo("tentativo precoce")

print()
print("--- attesa trascorsa, servizio ancora guasto ---")
adesso = 20
passo("prima prova")
adesso = adesso + 1
passo("dopo il fallimento")

print()
print("--- servizio riparato ---")
serviziGuasto = false
adesso = 40
passo("prima prova")
passo("seconda prova")
passo("dopo la chiusura")

print()
print("transizioni registrate:")
for _, t in ipairs(i.transizioni) do
  print(string.format("  t=%3d  %s -> %-11s %s",
    t.istante, t.da, t.a, t.motivo))
end

return M
```

produce:

```text
--- servizio guasto ---
t=  0 chiamata 1             stato=chiuso      errore:
connessione rifiutata
t=  1 chiamata 2             stato=chiuso      errore:
connessione rifiutata
t=  2 chiamata 3             stato=aperto      errore:
connessione rifiutata
t=  3 chiamata 4             stato=aperto      rifiutata:
interruttore aperto, riprova fra 9 s
t=  4 chiamata 5             stato=aperto      rifiutata:
interruttore aperto, riprova fra 8 s

--- durante l'attesa ---
t=  8 tentativo precoce      stato=aperto      rifiutata:
interruttore aperto, riprova fra 4 s

--- attesa trascorsa, servizio ancora guasto ---
t= 20 prima prova            stato=aperto      errore:
connessione rifiutata
t= 21 dopo il fallimento     stato=aperto      rifiutata:
interruttore aperto, riprova fra 9 s

--- servizio riparato ---
t= 40 prima prova            stato=semiaperto  ok:
risposta ok
t= 40 seconda prova          stato=chiuso      ok:
risposta ok
t= 40 dopo la chiusura       stato=chiuso      ok:
risposta ok
```

Il comportamento è quello canonico dell’interruttore automatico, con i
tre stati.

**Chiuso**: le chiamate passano. Tre fallimenti consecutivi lo aprono.

**Aperto**: le chiamate sono **rifiutate immediatamente**, senza nemmeno
tentare. È il punto: un servizio in difficoltà non riceve altro carico, e
il chiamante non aspetta il timeout di una connessione destinata a
fallire. Le chiamate ai tempi tre, quattro e otto costano zero.

**Semiaperto**: trascorsa l’attesa, una chiamata viene lasciata passare
come sonda. Se fallisce, si torna aperti e l’attesa riparte, come ai
tempi venti e ventuno. Se riesce per il numero di prove richiesto, si
richiude.

Il numero di prove maggiore di uno protegge dal caso in cui il servizio
risponda a intermittenza: una singola risposta riuscita non basta a
dichiararlo sano.

L’orologio iniettabile è ancora una volta ciò che rende il test
istantaneo invece di richiedere minuti reali di attesa.

**ES 33.7 — Registrazione strutturata e aggregazione**

*Scrivi la fase di registrazione di un gateway che produca una riga
strutturata per richiesta con cliente, percorso, stato, durata ed
esito della cache, e un modulo che aggreghi quelle righe in
statistiche per percorso senza caricarle tutte in memoria.*

La fase di registrazione produce una riga per richiesta, in un formato
scomponibile senza ambiguità:

```lua
-- /app/lua/registro.lua
local durata = 0
if ngx.ctx.inizio then
  durata = (ngx.now() - ngx.ctx.inizio) * 1000
end

-- formato a coppie chiave=valore separate da tab:
-- niente virgole da proteggere, niente JSON da
-- analizzare, campi aggiungibili senza rompere
-- chi legge
local campi = {
  "t=" .. ngx.now(),
  "cliente=" .. (ngx.ctx.cliente or "-"),
  "metodo=" .. ngx.var.request_method,
  "percorso=" .. (ngx.var.uri or "-"),
  "stato=" .. ngx.status,
  "durata=" .. string.format("%.1f", durata),
  "cache=" .. (ngx.header["X-Cache"] or "-"),
  "byte=" .. (ngx.var.bytes_sent or "0"),
}

ngx.log(ngx.INFO, table.concat(campi, "\t"))
```

E l’aggregatore, che legge il registro **una riga alla volta** senza
caricarlo in memoria:

```lua
local Aggregatore = {}
Aggregatore.__index = Aggregatore

local function analizzaRiga(riga)
  local campi = {}
  for pezzo in riga:gmatch("[^\t]+") do
    local k, v = pezzo:match("^([%w_]+)=(.*)$")
    if k then campi[k] = v end
  end
  if campi.percorso == nil then return nil end
  return campi
end

local function normalizzaPercorso(p)
  -- /api/utenti/12345 -> /api/utenti/:id
  p = p:gsub("/%d+", "/:id")
  p = p:gsub("/%x%x%x%x%x%x%x%x[%x%-]*", "/:uuid")
  return p
end

function Aggregatore.nuovo(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    perPercorso = {},
    righe = 0,
    scartate = 0,
    normalizza = opzioni.normalizza
      or normalizzaPercorso,
    -- percentili approssimati con istogramma a
    -- intervalli: memoria costante per percorso
    intervalli = opzioni.intervalli
      or {1, 2, 5, 10, 25, 50, 100, 250, 500,
          1000, 2500, 5000},
  }, Aggregatore)
end

function Aggregatore:voce(percorso)
  local v = self.perPercorso[percorso]
  if v == nil then
    v = {
      richieste = 0,
      durataTotale = 0,
      durataMassima = 0,
      perStato = {},
      colpiCache = 0,
      byte = 0,
      istogramma = {},
    }
    for i = 1, #self.intervalli + 1 do
      v.istogramma[i] = 0
    end
    self.perPercorso[percorso] = v
  end
  return v
end

function Aggregatore:aggiungi(riga)
  self.righe = self.righe + 1
  local c = analizzaRiga(riga)
  if c == nil then
    self.scartate = self.scartate + 1
    return
  end

  local percorso = self.normalizza(c.percorso)
  local v = self:voce(percorso)
  local durata = tonumber(c.durata) or 0

  v.richieste = v.richieste + 1
  v.durataTotale = v.durataTotale + durata
  if durata > v.durataMassima then
    v.durataMassima = durata
  end
  v.perStato[c.stato] = (v.perStato[c.stato] or 0) + 1
  if c.cache == "HIT" then
    v.colpiCache = v.colpiCache + 1
  end
  v.byte = v.byte + (tonumber(c.byte) or 0)

  local slot = #self.intervalli + 1
  for i, limite in ipairs(self.intervalli) do
    if durata <= limite then slot = i break end
  end
  v.istogramma[slot] = v.istogramma[slot] + 1
end

function Aggregatore:percentile(v, p)
  local bersaglio = v.richieste * p / 100
  local cumulato = 0
  for i, quante in ipairs(v.istogramma) do
    cumulato = cumulato + quante
    if cumulato >= bersaglio then
      return self.intervalli[i] or math.huge
    end
  end
  return math.huge
end

function Aggregatore:daFile(percorso)
  local f, errore = io.open(percorso, "r")
  if f == nil then return nil, errore end
  for riga in f:lines() do
    self:aggiungi(riga)
  end
  f:close()
  return self
end

function Aggregatore:rapporto()
  local elenco = {}
  for percorso, v in pairs(self.perPercorso) do
    elenco[#elenco + 1] = {percorso = percorso, v = v}
  end
  table.sort(elenco, function(a, b)
    if a.v.richieste ~= b.v.richieste then
      return a.v.richieste > b.v.richieste
    end
    return a.percorso < b.percorso
  end)

  local righe = {string.format(
    "%-18s %6s %7s %7s %8s %6s", "PERCORSO", "RICH.",
    "MEDIA", "p95", "MAX", "CACHE")}

  for _, e in ipairs(elenco) do
    local v = e.v
    righe[#righe + 1] = string.format(
      "%-18s %6d %4.1fms %5.0fms %6.1fms %4.0f%%",
      e.percorso:sub(1, 18), v.richieste,
      v.durataTotale / v.richieste,
      self:percentile(v, 95),
      v.durataMassima,
      v.colpiCache / v.richieste * 100)
  end

  righe[#righe + 1] = string.format(
    "%d righe lette, %d scartate, %d percorsi",
    self.righe, self.scartate, #elenco)

  return table.concat(righe, "\n")
end

-- Prova con righe sintetiche
local a = Aggregatore.nuovo()
math.randomseed(7)

local PERCORSI = {
  {"/api/utenti/%d", 30, 5},
  {"/api/ordini/%d", 12, 40},
  {"/salute", 1, 1},
}

for i = 1, 5000 do
  local scelto = PERCORSI[math.random(#PERCORSI)]
  local durata = scelto[2]
    + math.random() * scelto[3]
  if math.random() < 0.02 then durata = durata * 20 end
  a:aggiungi(table.concat({
    "t=" .. i,
    "cliente=c" .. math.random(3),
    "metodo=GET",
    "percorso=" .. string.format(scelto[1],
      math.random(100000)),
    "stato=" .. (math.random() < 0.03 and "500"
      or "200"),
    "durata=" .. string.format("%.1f", durata),
    "cache=" .. (math.random() < 0.4 and "HIT"
      or "MISS"),
    "byte=" .. math.random(200, 8000),
  }, "\t"))
end

a:aggiungi("riga malformata senza campi")

print(a:rapporto())
```

produce:

```text
PERCORSO            RICH.   MEDIA     p95      MAX  CACHE
/api/utenti/:id      1696 45.4ms    50ms  692.8ms   39%
/salute              1663  2.0ms     2ms   39.8ms   38%
/api/ordini/:id      1641 42.7ms   100ms  948.6ms   40%
5001 righe lette, 1 scartate, 3 percorsi
```

Tre elementi progettuali.

Il **formato a coppie separate da tabulazione** è scelto perché si
analizza con una sola espressione, non ha caratteri da proteggere, e
permette di aggiungere campi senza rompere chi legge le righe vecchie.
JSON sarebbe più espressivo e molto più costoso da produrre a ogni
richiesta.

La **normalizzazione del percorso** è indispensabile: senza,
`/api/utenti/12345` e `/api/utenti/12346` sarebbero percorsi distinti, e
il rapporto avrebbe migliaia di righe con una richiesta ciascuna invece
di tre righe utili.

I **percentili approssimati con istogramma** sono il punto dell’esercizio
sulla memoria. Calcolare il novantacinquesimo percentile esatto richiede
di conservare tutte le durate: su dieci milioni di righe sono ottanta
megabyte. L’istogramma a dodici intervalli occupa dodici numeri per
percorso, indipendentemente da quante righe si leggono, e restituisce il
percentile con la precisione dell’intervallo. È il compromesso che
adottano tutti i sistemi di monitoraggio seri.

**ES 33.8 — Sequenziale, parallelo, con limite complessivo**

*Confronta tre modi di rispondere a una richiesta che richiede dati
da due servizi: chiamate sequenziali, chiamate parallele con
`ngx.thread`, e chiamate parallele con un limite di tempo
complessivo. Per ciascuno indica il tempo atteso, il comportamento
se un servizio è lento e quello se un servizio è irraggiungibile.*

```lua
local M = {}

-- Le tre strategie, scritte contro un'astrazione del
-- trasporto per poterle provare fuori da OpenResty.

function M.sequenziale(chiamate, ambiente)
  local risultati = {}
  local inizio = ambiente.adesso()

  for i, c in ipairs(chiamate) do
    local ok, valore = ambiente.chiama(c)
    risultati[i] = {ok = ok, valore = valore,
      nome = c.nome}
  end

  return risultati, ambiente.adesso() - inizio
end

function M.parallelo(chiamate, ambiente)
  local inizio = ambiente.adesso()
  local fili = {}

  for i, c in ipairs(chiamate) do
    fili[i] = ambiente.avvia(c)
  end

  local risultati = {}
  for i, f in ipairs(fili) do
    local ok, valore = ambiente.attendi(f)
    risultati[i] = {ok = ok, valore = valore,
      nome = chiamate[i].nome}
  end

  return risultati, ambiente.adesso() - inizio
end

function M.paralleloConLimite(chiamate, ambiente,
                              limite)
  local inizio = ambiente.adesso()
  local fili = {}

  for i, c in ipairs(chiamate) do
    fili[i] = ambiente.avvia(c)
  end

  -- un filo aggiuntivo fa da sveglia
  local sveglia = ambiente.avviaSveglia(limite)

  local risultati = {}
  local scaduto = false

  for i, f in ipairs(fili) do
    if scaduto then
      ambiente.uccidi(f)
      risultati[i] = {ok = false,
        valore = "limite complessivo superato",
        nome = chiamate[i].nome}
    else
      local rimasto = limite
        - (ambiente.adesso() - inizio)
      local ok, valore = ambiente.attendiEntro(f,
        rimasto)
      if ok == nil then
        scaduto = true
        ambiente.uccidi(f)
        risultati[i] = {ok = false,
          valore = "limite complessivo superato",
          nome = chiamate[i].nome}
      else
        risultati[i] = {ok = ok, valore = valore,
          nome = chiamate[i].nome}
      end
    end
  end

  ambiente.uccidi(sveglia)
  return risultati, ambiente.adesso() - inizio
end

-- Ambiente simulato: il tempo avanza a scatti
local function ambienteSimulato()
  local orologio = 0
  return {
    adesso = function() return orologio end,
    chiama = function(c)
      orologio = orologio + c.durata
      if c.guasto then return false, "irraggiungibile" end
      return true, c.nome .. ": ok"
    end,
    avvia = function(c)
      return {chiamata = c, avviatoA = orologio}
    end,
    attendi = function(f)
      local fine = f.avviatoA + f.chiamata.durata
      if fine > orologio then orologio = fine end
      if f.chiamata.guasto then
        return false, "irraggiungibile"
      end
      return true, f.chiamata.nome .. ": ok"
    end,
    attendiEntro = function(f, quanto)
      local fine = f.avviatoA + f.chiamata.durata
      if fine - f.avviatoA > quanto then
        orologio = f.avviatoA + quanto
        return nil
      end
      if fine > orologio then orologio = fine end
      if f.chiamata.guasto then
        return false, "irraggiungibile"
      end
      return true, f.chiamata.nome .. ": ok"
    end,
    avviaSveglia = function() return {} end,
    uccidi = function() end,
  }
end

local SCENARI = {
  {nome = "entrambi rapidi",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 60}}},
  {nome = "uno lento",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 900}}},
  {nome = "uno irraggiungibile",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 2000, guasto = true}}},
}

print(string.format("%-22s %-14s %7s  %s",
  "SCENARIO", "STRATEGIA", "TEMPO", "ESITI"))

for _, sc in ipairs(SCENARI) do
  for _, st in ipairs({
      {"sequenziale", M.sequenziale, nil},
      {"parallela", M.parallelo, nil},
      {"con limite 500", M.paralleloConLimite, 500}}) do
    local amb = ambienteSimulato()
    local r, tempo
    if st[3] then
      r, tempo = st[2](sc.chiamate, amb, st[3])
    else
      r, tempo = st[2](sc.chiamate, amb)
    end
    local esiti = {}
    for _, x in ipairs(r) do
      esiti[#esiti + 1] = x.nome .. "="
        .. (x.ok and "ok" or "KO")
    end
    print(string.format("%-22s %-14s %5dms  %s",
      sc.nome, st[1], tempo, table.concat(esiti, " ")))
  end
end

return M
```

produce:

```text
SCENARIO               STRATEGIA        TEMPO  ESITI
entrambi rapidi        sequenziale      110ms  A=ok B=ok
entrambi rapidi        parallela         60ms  A=ok B=ok
entrambi rapidi        con limite 500    60ms  A=ok B=ok
uno lento              sequenziale      950ms  A=ok B=ok
uno lento              parallela        900ms  A=ok B=ok
uno lento              con limite 500   450ms  A=ok B=KO
uno irraggiungibile    sequenziale     2050ms  A=ok B=KO
uno irraggiungibile    parallela       2000ms  A=ok B=KO
uno irraggiungibile    con limite 500   450ms  A=ok B=KO
```

Il confronto risponde alle tre domande dell’esercizio.

**Tempo atteso.** La sequenziale costa la **somma** delle durate, la
parallela il **massimo**. Con due servizi da cinquanta e sessanta
millisecondi la differenza è di cinquanta millisecondi su
centodieci — quasi la metà. Con dieci servizi il divario diventa
drammatico.

**Servizio lento.** La parallela non aiuta: il tempo totale è quello del
più lento, e novecento millisecondi restano novecento. Solo il limite
complessivo lo tronca, restituendo una risposta parziale in
quattrocentocinquanta millisecondi — il limite di cinquecento meno i
cinquanta già spesi ad attendere la prima chiamata. È la scelta giusta
per un gateway: **meglio una risposta incompleta in tempo utile che una
completa fuori tempo**.

**Servizio irraggiungibile.** Qui la differenza è enorme: senza limite si
aspetta il timeout della connessione, che può essere di secondi. Con il
limite complessivo si risponde comunque entro il mezzo secondo. È
il caso in cui il limite passa da ottimizzazione a necessità, ed è il
motivo per cui va combinato con l’interruttore automatico dell’ES 33.6:
il limite protegge la singola richiesta, l’interruttore protegge dal
ripetere l’attesa per ogni richiesta successiva.

Il limite dell’implementazione, da dichiarare: `ngx.thread.wait` non
accetta un tempo massimo. Il limite complessivo si ottiene avviando un
filo aggiuntivo che dorme con `ngx.sleep(limite)` e usando
`ngx.thread.wait` su **tutti** i fili insieme: il primo che termina
sblocca l’attesa, e se è la sveglia si uccidono gli altri con
`ngx.thread.kill`. L’ambiente simulato di questo esercizio astrae quel
meccanismo per renderlo provabile.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
