# Capitolo 34 — Progetto finale: un’applicazione completa in Lua

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 33](capitolo-33.md) · [Indice](README.md)

---

Le soluzioni si innestano sul progetto del Capitolo 34 e ne rispettano
la direzione delle dipendenze: il modello non conosce nessuno, il
deposito conosce il modello, i comandi conoscono tutto.

**ES 34.1 — Il comando `rinvia`**

*Aggiungi il comando `rinvia <id> --giorni N` che sposti in avanti la
scadenza di un’attività, gestendo il caso di attività senza scadenza
e quello di attività già chiuse.*

Nel modello, un metodo che sposta la scadenza:

```lua
function Attivita:rinvia(giorni)
  if type(giorni) ~= "number"
     or giorni ~= math.floor(giorni) then
    return nil, "i giorni devono essere un intero"
  end
  if giorni == 0 then
    return nil, "rinvio nullo"
  end
  if not self:aperta() then
    return nil, "l'attivita' e' gia' chiusa"
  end

  local function aTempo(testo)
    local a, m, g = testo:match(
      "(%d%d%d%d)%-(%d%d)%-(%d%d)")
    return os.time({
      year = tonumber(a), month = tonumber(m),
      day = tonumber(g), hour = 12,
    })
  end

  local base
  if self.scadenza == nil then
    -- senza scadenza, si parte da oggi
    base = os.time({
      year = tonumber(os.date("%Y")),
      month = tonumber(os.date("%m")),
      day = tonumber(os.date("%d")),
      hour = 12,
    })
  else
    base = aTempo(self.scadenza)
  end

  local nuova = os.date("%Y-%m-%d",
    base + giorni * 86400)

  local precedente = self.scadenza
  self.scadenza = nuova
  return nuova, precedente
end
```

E il comando corrispondente:

```lua
comandi.rinvia = {
  aiuto = "rinvia <id> [<id> ...] --giorni N",
  opzioni = {"giorni", "archivio"},
  esegui = function(contesto)
    local ids = contesto.analisi.posizionali
    if #ids == 0 then return nil, "serve almeno un id" end

    local giorni, errore = cli.numero(contesto.opzioni,
      "giorni")
    if giorni == nil then
      return nil, errore or "serve --giorni N"
    end

    local righe = {}
    for _, id in ipairs(ids) do
      local a, err = contesto.deposito:trova(id)
      if a == nil then return nil, err end

      local nuova, precedente = a:rinvia(giorni)
      if nuova == nil then
        return nil, string.format("#%s: %s", id,
          precedente)
      end

      righe[#righe + 1] = string.format(
        "#%d %s: %s -> %s", a.id, a.titolo,
        precedente or "(nessuna scadenza)", nuova)
    end

    contesto.deposito.modificato = true
    contesto.deposito:salva()
    return "Rinviate:\n  " .. table.concat(righe,
      "\n  ")
  end,
}
```

Le due situazioni richieste sono gestite esplicitamente.

Un’attività **senza scadenza** riceve una scadenza calcolata a partire da
oggi, non un errore. È la scelta più utile: chi scrive `rinvia 3
--giorni 7` su un’attività senza scadenza intende quasi certamente
«fissala fra una settimana».

Un’attività **già chiusa** produce un errore, perché rinviare qualcosa
di completato non ha significato. La segnalazione nomina
l’identificatore, così che con più attività si sappia quale.

Il rinvio con giorni negativi è ammesso e anticipa la scadenza: è una
conseguenza gratuita dell’implementazione, e conviene documentarla invece
di vietarla.

**ES 34.2 — Sottoattività**

*Aggiungi le sottoattività: ogni attività può avere un identificatore
di attività genitrice, l’elenco le mostra annidate, e completare una
genitrice richiede che tutte le figlie siano completate.*

Nel modello si aggiunge il campo `genitore` e la sua validazione:

```lua
-- in M.valida
if dati.genitore ~= nil then
  if math.type(dati.genitore) ~= "integer"
     or dati.genitore < 1 then
    errori[#errori + 1] =
      "genitore deve essere un id valido"
  elseif dati.id ~= nil and dati.genitore == dati.id then
    errori[#errori + 1] =
      "un'attivita' non puo' essere figlia di se stessa"
  end
end
```

Nel deposito, le operazioni sull’albero:

```lua
function Deposito:figlie(id)
  id = tonumber(id)
  local r = {}
  for _, a in ipairs(self.attivita) do
    if a.genitore == id then r[#r + 1] = a end
  end
  table.sort(r, function(x, y) return x.id < y.id end)
  return r
end

function Deposito:antenati(id)
  local r = {}
  local visti = {}
  local corrente = self:trova(id)
  while corrente and corrente.genitore do
    if visti[corrente.genitore] then
      return nil, "ciclo nella gerarchia"
    end
    visti[corrente.genitore] = true
    corrente = self:trova(corrente.genitore)
    if corrente then r[#r + 1] = corrente end
  end
  return r
end

function Deposito:impostaGenitore(id, genitore)
  local a, errore = self:trova(id)
  if a == nil then return nil, errore end

  if genitore == nil then
    a.genitore = nil
    self.modificato = true
    return a
  end

  local g, err2 = self:trova(genitore)
  if g == nil then return nil, err2 end

  -- verifica di aciclicita': il genitore proposto
  -- non deve essere un discendente
  local corrente = g
  local visti = {}
  while corrente do
    if corrente.id == a.id then
      return nil, "creerebbe un ciclo nella gerarchia"
    end
    if visti[corrente.id] then break end
    visti[corrente.id] = true
    corrente = corrente.genitore
      and self:trova(corrente.genitore) or nil
  end

  a.genitore = g.id
  self.modificato = true
  return a
end

function Deposito:puoChiudere(id)
  local aperte = {}
  for _, f in ipairs(self:figlie(id)) do
    if f:aperta() then
      aperte[#aperte + 1] = f.id
    end
  end
  if #aperte > 0 then
    return false, aperte
  end
  return true
end
```

Nella presentazione, l’elenco annidato:

```lua
function M.elencoAlbero(attivita, figlie, oggi)
  local perGenitore = {}
  local radici = {}
  local presenti = {}

  for _, a in ipairs(attivita) do presenti[a.id] = a end

  for _, a in ipairs(attivita) do
    if a.genitore and presenti[a.genitore] then
      local g = perGenitore[a.genitore]
      if g == nil then
        g = {}
        perGenitore[a.genitore] = g
      end
      g[#g + 1] = a
    else
      radici[#radici + 1] = a
    end
  end

  local righe = {}

  local function scendi(elenco, profondita)
    if profondita > 6 then return end
    for _, a in ipairs(elenco) do
      righe[#righe + 1] = string.rep("  ", profondita)
        .. M.riga(a, oggi)
      local sotto = perGenitore[a.id]
      if sotto then scendi(sotto, profondita + 1) end
    end
  end

  scendi(radici, 0)

  if #righe == 0 then
    return "Nessuna attivita' corrisponde ai criteri."
  end
  righe[#righe + 1] = ""
  righe[#righe + 1] = string.format("%d attivita'",
    #attivita)
  return table.concat(righe, "\n")
end
```

E il comando `fatta` che verifica le figlie:

```lua
comandi.fatta = {
  aiuto = "fatta <id> [<id> ...] [--forza]",
  opzioni = {"archivio", "forza"},
  esegui = function(contesto)
    local ids = contesto.analisi.posizionali
    if #ids == 0 then return nil, "serve almeno un id" end
    local forza = cli.booleana(contesto.opzioni, "forza")

    local fatte = {}
    for _, id in ipairs(ids) do
      if not forza then
        local ok, aperte =
          contesto.deposito:puoChiudere(id)
        if not ok then
          local elenco = {}
          for _, n in ipairs(aperte) do
            elenco[#elenco + 1] = "#" .. n
          end
          return nil, string.format(
            "#%s ha sottoattivita' aperte: %s "
            .. "(usa --forza per chiudere comunque)",
            id, table.concat(elenco, ", "))
        end
      end

      local a, errore = contesto.deposito:modifica(id,
        {stato = "fatta"})
      if a == nil then return nil, errore end
      fatte[#fatte + 1] = tostring(a)
    end

    contesto.deposito:salva()
    return "Completate:\n  "
      .. table.concat(fatte, "\n  ")
  end,
}
```

Tre punti.

La **verifica di aciclicità** è indispensabile: senza, impostare A come
figlia di B e B come figlia di A produrrebbe una ricorsione infinita
nell’elenco annidato. La verifica risale la catena dei genitori
cercando l’attività stessa.

Il **genitore inesistente** è tollerato nell’elenco: l’attività compare
come radice invece di sparire. Un archivio in cui una genitrice è stata
rimossa resta utilizzabile.

L’opzione `--forza` è la valvola di sfogo: la regola sulle figlie aperte
è una salvaguardia, non una prigione, e un utente che sa quel che fa deve
poterla scavalcare esplicitamente.

**ES 34.3 — Suite di test per modello e filtri**

*Scrivi la suite di test completa per `src/modello.lua` e
`src/filtri.lua`, con almeno trenta casi che coprano tutti i limiti
discussi nel capitolo.*

```lua
local T = require("test")
local gruppo, prova, a = T.gruppo, T.prova, T.assert

local modello = require("src.modello")
local filtri = require("src.filtri")

local OGGI = "2026-08-07"

local function att(dati)
  local x = modello.nuova(dati)
  return x
end

gruppo("modello", function()

  gruppo("validazione del titolo", function()
    prova("titolo obbligatorio", function()
      a.uguale(nil, modello.nuova({}))
    end)
    prova("titolo vuoto rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = ""}))
    end)
    prova("titolo di soli spazi rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "   "}))
    end)
    prova("titolo non stringa rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = 42}))
    end)
    prova("titolo troppo lungo rifiutato", function()
      a.uguale(nil, modello.nuova({
        titolo = string.rep("x", 201)}))
    end)
    prova("titolo al limite accettato", function()
      a.vero(modello.nuova({
        titolo = string.rep("x", 200)}) ~= nil)
    end)
    prova("spazi ai margini rimossi", function()
      a.uguale("prova",
        att({titolo = "  prova  "}).titolo)
    end)
  end)

  gruppo("priorita' e stato", function()
    prova("priorita' predefinita", function()
      a.uguale("media", att({titolo = "x"}).priorita)
    end)
    prova("stato predefinito", function()
      a.uguale("aperta", att({titolo = "x"}).stato)
    end)
    prova("priorita' non valida rifiutata", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        priorita = "altissima"}))
    end)
    prova("stato non valido rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        stato = "quasi"}))
    end)
    prova("tutte le priorita' ammesse", function()
      for _, p in ipairs(modello.PRIORITA) do
        a.vero(modello.nuova({titolo = "x",
          priorita = p}) ~= nil, p)
      end
    end)
  end)

  gruppo("etichette", function()
    prova("da stringa separata da virgole", function()
      a.uguale({"a", "b"},
        att({titolo = "x", etichette = "a,b"}).etichette)
    end)
    prova("normalizzate in minuscolo", function()
      a.uguale({"casa"},
        att({titolo = "x", etichette = "CASA"}).etichette)
    end)
    prova("ordinate", function()
      a.uguale({"a", "m", "z"},
        att({titolo = "x",
          etichette = "z,a,m"}).etichette)
    end)
    prova("spazi rimossi", function()
      a.uguale({"a", "b"},
        att({titolo = "x",
          etichette = " a , b "}).etichette)
    end)
    prova("vuote scartate", function()
      a.uguale({"a"},
        att({titolo = "x",
          etichette = "a,,"}).etichette)
    end)
    prova("assenti danno tabella vuota", function()
      a.uguale({}, att({titolo = "x"}).etichette)
    end)
    prova("haEtichetta e' insensibile al caso",
      function()
        local x = att({titolo = "x",
          etichette = "casa"})
        a.vero(x:haEtichetta("CASA"))
        a.vero(not x:haEtichetta("lavoro"))
      end)
  end)

  gruppo("scadenza", function()
    prova("formato valido accettato", function()
      a.vero(modello.nuova({titolo = "x",
        scadenza = "2026-01-01"}) ~= nil)
    end)
    prova("formato non valido rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = "01/01/2026"}))
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = "2026-1-1"}))
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = 20260101}))
    end)
    prova("scaduta se precedente a oggi", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-01"})
      a.vero(x:scaduta(OGGI))
    end)
    prova("non scaduta se oggi", function()
      local x = att({titolo = "x", scadenza = OGGI})
      a.vero(not x:scaduta(OGGI))
    end)
    prova("chiusa non e' mai scaduta", function()
      local x = att({titolo = "x",
        scadenza = "2020-01-01", stato = "fatta"})
      a.vero(not x:scaduta(OGGI))
    end)
    prova("senza scadenza non e' scaduta", function()
      a.vero(not att({titolo = "x"}):scaduta(OGGI))
    end)
    prova("giorni alla scadenza", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-10"})
      a.uguale(3, x:giorniAllaScadenza(OGGI))
    end)
    prova("giorni negativi se scaduta", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-01"})
      a.uguale(-6, x:giorniAllaScadenza(OGGI))
    end)
  end)

  gruppo("aggiornamento", function()
    prova("modifica valida applicata", function()
      local x = att({titolo = "x"})
      x:aggiorna({priorita = "alta"})
      a.uguale("alta", x.priorita)
    end)
    prova("modifica non valida NON applicata",
      function()
        local x = att({titolo = "x",
          priorita = "bassa"})
        local ok = x:aggiorna({priorita = "assurda"})
        a.uguale(nil, ok)
        a.uguale("bassa", x.priorita)
      end)
    prova("id non modificabile", function()
      local x = att({titolo = "x", id = 7})
      x:aggiorna({id = 99})
      a.uguale(7, x.id)
    end)
    prova("chiusura registra l'istante", function()
      local x = att({titolo = "x"})
      x:aggiorna({stato = "fatta"})
      a.vero(x.chiusa ~= nil)
    end)
    prova("riapertura azzera l'istante", function()
      local x = att({titolo = "x"})
      x:aggiorna({stato = "fatta"})
      x:aggiorna({stato = "aperta"})
      a.uguale(nil, x.chiusa)
    end)
  end)

  gruppo("metametodi", function()
    prova("uguaglianza per id", function()
      local x = att({titolo = "a", id = 1})
      local y = att({titolo = "b", id = 1})
      a.vero(x == y)
    end)
    prova("ordine per id", function()
      local x = att({titolo = "a", id = 1})
      local y = att({titolo = "b", id = 2})
      a.vero(x < y)
    end)
    prova("tostring contiene id e titolo", function()
      local s = tostring(att({titolo = "prova",
        id = 3}))
      a.vero(s:find("3", 1, true) ~= nil)
      a.vero(s:find("prova", 1, true) ~= nil)
    end)
  end)

end)

gruppo("filtri", function()

  local function insieme()
    return {
      att({titolo = "urgente scaduta", id = 1,
        priorita = "urgente", scadenza = "2026-08-01",
        etichette = "lavoro"}),
      att({titolo = "alta aperta", id = 2,
        priorita = "alta", etichette = "casa"}),
      att({titolo = "media fatta", id = 3,
        priorita = "media", stato = "fatta",
        etichette = "casa,spesa"}),
      att({titolo = "bassa futura", id = 4,
        priorita = "bassa", scadenza = "2026-08-10",
        etichette = "lavoro"}),
      att({titolo = "in corso", id = 5,
        priorita = "alta", stato = "in corso"}),
    }
  end

  gruppo("ordinamento", function()
    prova("per id", function()
      local r = filtri.ordina(insieme(), "id")
      a.uguale({1, 2, 3, 4, 5},
        {r[1].id, r[2].id, r[3].id, r[4].id, r[5].id})
    end)
    prova("per priorita' decrescente", function()
      local r = filtri.ordina(insieme(), "priorita")
      a.uguale("urgente", r[1].priorita)
      a.uguale("bassa", r[5].priorita)
    end)
    prova("parita' risolta per id", function()
      local r = filtri.ordina(insieme(), "priorita")
      a.uguale(2, r[2].id)
      a.uguale(5, r[3].id)
    end)
    prova("senza scadenza in fondo", function()
      local r = filtri.ordina(insieme(), "scadenza")
      a.uguale(1, r[1].id)
      a.uguale(4, r[2].id)
    end)
    prova("criterio sconosciuto rifiutato", function()
      a.uguale(nil, filtri.ordina(insieme(), "colore"))
    end)
    prova("non modifica l'ingresso", function()
      local o = insieme()
      filtri.ordina(o, "priorita")
      a.uguale(1, o[1].id)
    end)
  end)

  gruppo("filtro", function()
    prova("per stato", function()
      local r = filtri.filtra(insieme(),
        {stato = "fatta"})
      a.uguale(1, #r)
      a.uguale(3, r[1].id)
    end)
    prova("aperte comprende 'in corso'", function()
      local r = filtri.filtra(insieme(),
        {aperte = true})
      a.uguale(4, #r)
    end)
    prova("per etichetta", function()
      local r = filtri.filtra(insieme(),
        {etichetta = "casa"})
      a.uguale(2, #r)
    end)
    prova("etichetta insensibile al caso", function()
      local r = filtri.filtra(insieme(),
        {etichetta = "CASA"})
      a.uguale(2, #r)
    end)
    prova("scadute", function()
      local r = filtri.filtra(insieme(),
        {scadute = true, oggi = OGGI})
      a.uguale(1, #r)
      a.uguale(1, r[1].id)
    end)
    prova("entro N giorni", function()
      local r = filtri.filtra(insieme(),
        {entro = 5, oggi = OGGI})
      a.uguale(2, #r)
    end)
    prova("criteri combinati", function()
      local r = filtri.filtra(insieme(), {
        etichetta = "lavoro", aperte = true,
        oggi = OGGI})
      a.uguale(2, #r)
    end)
    prova("nessun criterio restituisce tutto",
      function()
        a.uguale(5, #filtri.filtra(insieme(), {}))
      end)
    prova("criterio impossibile da' vuoto", function()
      a.uguale(0, #filtri.filtra(insieme(),
        {etichetta = "inesistente"}))
    end)
  end)

  gruppo("ricerca", function()
    prova("termine nel titolo", function()
      local r = filtri.cerca(insieme(), "urgente")
      a.vero(#r >= 1)
      a.uguale(1, r[1].id)
    end)
    prova("insensibile al caso", function()
      a.uguale(#filtri.cerca(insieme(), "URGENTE"),
        #filtri.cerca(insieme(), "urgente"))
    end)
    prova("termini multipli in AND", function()
      a.uguale(1, #filtri.cerca(insieme(),
        "urgente scaduta"))
      a.uguale(0, #filtri.cerca(insieme(),
        "urgente inesistente"))
    end)
    prova("cerca anche nelle etichette", function()
      a.vero(#filtri.cerca(insieme(), "spesa") >= 1)
    end)
    prova("testo vuoto rifiutato", function()
      local r, e = filtri.cerca(insieme(), "")
      a.uguale(0, #r)
      a.vero(e ~= nil)
    end)
    prova("il titolo pesa piu' delle etichette",
      function()
        local r = filtri.cerca(insieme(), "casa")
        a.vero(#r >= 1)
      end)
  end)

  gruppo("riepilogo", function()
    prova("totale corretto", function()
      a.uguale(5, filtri.riepiloga(insieme()).totale)
    end)
    prova("conteggio per stato", function()
      local r = filtri.riepiloga(insieme())
      a.uguale(3, r.perStato["aperta"])
      a.uguale(1, r.perStato["fatta"])
      a.uguale(1, r.perStato["in corso"])
    end)
    prova("conteggio per etichetta", function()
      local r = filtri.riepiloga(insieme())
      a.uguale(2, r.perEtichetta["casa"])
      a.uguale(2, r.perEtichetta["lavoro"])
    end)
    prova("scadute contate", function()
      local r = filtri.riepiloga(insieme(), OGGI)
      a.uguale(1, r.scadute)
      a.uguale(2, r.conScadenza)
    end)
    prova("insieme vuoto", function()
      local r = filtri.riepiloga({})
      a.uguale(0, r.totale)
      a.uguale(0, r.scadute)
    end)
  end)

end)

os.exit(T.esegui() and 0 or 1)
```

Sessantuno test, ben oltre i trenta richiesti, con la distribuzione che
il Capitolo 29 raccomanda. Eseguiti contro i moduli reali del Capitolo
34, passano tutti.

I test che valgono di più sono quelli che verificano proprietà **non
ovvie** del progetto: che un aggiornamento non valido non modifichi
l’oggetto, che l’ordinamento non tocchi l’ingresso, che la riapertura
azzeri l’istante di chiusura, che un’attività chiusa non risulti mai
scaduta.

La data di riferimento è **iniettata** in ogni test che dipende dal
tempo: senza, la suite passerebbe oggi e fallirebbe fra un mese.

**ES 34.4 — Esportazione JSON**

*Aggiungi il formato di esportazione JSON, scrivendo il codificatore
in Lua puro, e verifica che il risultato sia rileggibile da uno
strumento esterno.*

```lua
-- src/json.lua
local M = {}

local FUGHE = {
  ['"'] = '\\"', ["\\"] = "\\\\", ["\b"] = "\\b",
  ["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r",
  ["\t"] = "\\t",
}

local function stringa(s)
  local fuggito = s:gsub('[%c"\\]', function(c)
    local f = FUGHE[c]
    if f then return f end
    return string.format("\\u%04X", c:byte())
  end)
  return '"' .. fuggito .. '"'
end

local function numero(n)
  if n ~= n then return "null" end
  if n == math.huge or n == -math.huge then
    return "null"
  end
  if math.type(n) == "integer" then
    return string.format("%d", n)
  end
  -- %.17g garantisce la rilettura senza perdita
  local s = string.format("%.14g", n)
  if tonumber(s) ~= n then
    s = string.format("%.17g", n)
  end
  return s
end

local function eSequenza(t)
  local n = #t
  local quante = 0
  for k in pairs(t) do
    if math.type(k) ~= "integer" or k < 1 or k > n then
      return false
    end
    quante = quante + 1
  end
  return quante == n, n
end

local function codifica(v, indentazione, livello, viste)
  livello = livello or 0
  viste = viste or {}

  local t = type(v)

  if v == nil then return "null" end
  if t == "boolean" then return tostring(v) end
  if t == "number" then return numero(v) end
  if t == "string" then return stringa(v) end
  if t ~= "table" then
    return nil, "tipo non serializzabile: " .. t
  end

  if viste[v] then
    return nil, "riferimento circolare"
  end
  viste[v] = true

  local aCapo, dentro, fuori = "", "", ""
  if indentazione then
    aCapo = "\n"
    dentro = string.rep(indentazione, livello + 1)
    fuori = string.rep(indentazione, livello)
  end
  local dopoDuePunti = indentazione and " " or ""

  local sequenza, n = eSequenza(v)
  local pezzi = {}

  if sequenza then
    if n == 0 then
      viste[v] = nil
      return "[]"
    end
    for i = 1, n do
      local s, e = codifica(v[i], indentazione,
        livello + 1, viste)
      if s == nil then return nil, e end
      pezzi[i] = dentro .. s
    end
    viste[v] = nil
    return "[" .. aCapo .. table.concat(pezzi,
      "," .. aCapo) .. aCapo .. fuori .. "]"
  end

  local chiavi = {}
  for k in pairs(v) do
    if type(k) ~= "string" and type(k) ~= "number" then
      return nil, "chiave non serializzabile: "
        .. type(k)
    end
    chiavi[#chiavi + 1] = k
  end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  if #chiavi == 0 then
    viste[v] = nil
    return "{}"
  end

  for i, k in ipairs(chiavi) do
    local s, e = codifica(v[k], indentazione,
      livello + 1, viste)
    if s == nil then return nil, e end
    pezzi[i] = dentro .. stringa(tostring(k)) .. ":"
      .. dopoDuePunti .. s
  end

  viste[v] = nil
  return "{" .. aCapo .. table.concat(pezzi,
    "," .. aCapo) .. aCapo .. fuori .. "}"
end

function M.codifica(v, opzioni)
  opzioni = opzioni or {}
  local indentazione = nil
  if opzioni.leggibile then
    indentazione = opzioni.indentazione or "  "
  end
  return codifica(v, indentazione, 0, {})
end

return M
```

Il comando di esportazione diventa:

```lua
comandi.esporta = {
  aiuto = "esporta [--formato csv|json] [--leggibile]",
  opzioni = {"formato", "leggibile", "archivio"},
  esegui = function(contesto)
    local f = cli.stringa(contesto.opzioni, "formato",
      "csv")
    local ordinate = filtri.ordina(
      contesto.deposito:tutte(), "id")

    if f == "csv" then
      return formato.csv(ordinate)
    end

    if f == "json" then
      local grezze = {}
      for i, a in ipairs(ordinate) do
        grezze[i] = a:comeTabella()
      end
      local testo, errore = json.codifica({
        generato = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        quante = #grezze,
        attivita = grezze,
      }, {leggibile = cli.booleana(contesto.opzioni,
        "leggibile")})
      if testo == nil then
        return nil, "esportazione fallita: " .. errore
      end
      return testo
    end

    return nil, "formato non supportato: " .. f
  end,
}
```

Tre scelte progettuali.

Le **chiavi sono ordinate**, il che rende l’output deterministico: due
esportazioni degli stessi dati producono byte identici, e la differenza
fra due versioni è leggibile con un confronto testuale.

I **numeri usano `%.14g` con verifica di rilettura**: se la
rappresentazione a quattordici cifre non rilegge esattamente lo stesso
valore, si passa a diciassette, che è il minimo che garantisce la
rilettura esatta di un float a doppia precisione. È il compromesso fra
leggibilità e fedeltà.

Le **tabelle vuote diventano `[]`**, non `{}`. È l’ambiguità dell’ES 25.7
e dell’ES 28.4, risolta a favore dell’array perché nel progetto tutte le
tabelle vuote sono elenchi di etichette. La scelta va dichiarata, ed è
il motivo per cui questo commento esiste.

**ES 34.5 — Archivi grandi con indice separato**

*Rendi il deposito capace di gestire archivi di centomila attività
senza caricarli interamente in memoria, usando un indice su file
separato. Misura la differenza nei tempi di avvio.*

```lua
local Grande = {}
Grande.__index = Grande

local modello = require("src.modello")

-- Formato: un record per riga, serializzato,
-- preceduto dalla sua lunghezza in byte.
-- L'indice mappa id -> posizione nel file.

local function serializzaRiga(t)
  local pezzi = {}
  local chiavi = {}
  for k in pairs(t) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)
  for _, k in ipairs(chiavi) do
    local v = t[k]
    local sv
    if type(v) == "table" then
      local sotto = {}
      for i, e in ipairs(v) do
        sotto[i] = string.format("%q", tostring(e))
      end
      sv = "{" .. table.concat(sotto, ",") .. "}"
    elseif type(v) == "string" then
      sv = string.format("%q", v)
    else
      sv = tostring(v)
    end
    pezzi[#pezzi + 1] = k .. "=" .. sv
  end
  return "{" .. table.concat(pezzi, ",") .. "}"
end

function Grande.nuovo(percorso)
  return setmetatable({
    percorso = percorso,
    percorsoIndice = percorso .. ".idx",
    indice = {},
    prossimoId = 1,
    file = nil,
    letture = 0,
  }, Grande)
end

function Grande:apri()
  local f = io.open(self.percorso, "a+b")
  if f == nil then
    return nil, "impossibile aprire l'archivio"
  end
  self.file = f
  return self
end

function Grande:caricaIndice()
  local f = io.open(self.percorsoIndice, "r")
  if f then
    local testo = f:read("a")
    f:close()
    local chunk = load("return " .. testo, "indice",
      "t", {})
    if chunk then
      local ok, dati = pcall(chunk)
      if ok and type(dati) == "table" then
        self.indice = dati.indice or {}
        self.prossimoId = dati.prossimoId or 1
        return self, "indice caricato"
      end
    end
  end
  return self:ricostruisciIndice()
end

function Grande:ricostruisciIndice()
  self.indice = {}
  self.prossimoId = 1

  local f = io.open(self.percorso, "rb")
  if f == nil then return self, "archivio assente" end

  local posizione = 0
  for riga in f:lines("L") do
    local id = riga:match("id=(%d+)")
    if id then
      id = tonumber(id)
      self.indice[id] = posizione
      if id >= self.prossimoId then
        self.prossimoId = id + 1
      end
    end
    posizione = posizione + #riga
  end
  f:close()

  self:salvaIndice()
  return self, "indice ricostruito"
end

function Grande:salvaIndice()
  local pezzi = {"{indice={"}
  local ids = {}
  for id in pairs(self.indice) do ids[#ids + 1] = id end
  table.sort(ids)
  for _, id in ipairs(ids) do
    pezzi[#pezzi + 1] = string.format("[%d]=%d,", id,
      self.indice[id])
  end
  pezzi[#pezzi + 1] = "},prossimoId="
    .. self.prossimoId .. "}"

  local f = io.open(self.percorsoIndice, "w")
  if f == nil then return nil, "indice non scrivibile" end
  f:write(table.concat(pezzi))
  f:close()
  return self
end

function Grande:aggiungi(dati)
  local a, errore = modello.nuova(dati)
  if a == nil then return nil, errore end

  a.id = self.prossimoId
  self.prossimoId = self.prossimoId + 1

  self.file:seek("end")
  local posizione = self.file:seek()
  self.file:write(serializzaRiga(a:comeTabella()), "\n")
  self.indice[a.id] = posizione

  return a
end

function Grande:trova(id)
  id = tonumber(id)
  local posizione = self.indice[id]
  if posizione == nil then
    return nil, "attivita' #" .. tostring(id)
      .. " non trovata"
  end

  self.letture = self.letture + 1
  self.file:seek("set", posizione)
  local riga = self.file:read("l")
  if riga == nil then
    return nil, "indice non allineato all'archivio"
  end

  local chunk = load("return " .. riga, "record", "t",
    {})
  if chunk == nil then
    return nil, "record illeggibile"
  end
  local ok, grezzo = pcall(chunk)
  if not ok then return nil, "record illeggibile" end

  return modello.nuova(grezzo)
end

function Grande:quante()
  local n = 0
  for _ in pairs(self.indice) do n = n + 1 end
  return n
end

function Grande:chiudi()
  if self.file then
    self.file:close()
    self.file = nil
  end
  self:salvaIndice()
end

return Grande
```

Il confronto con il deposito del Capitolo 34.

Il deposito originale carica **l’intero archivio in memoria** all’avvio:
con centomila attività significa costruire centomila tabelle con
metatabella, il che richiede secondi e decine di megabyte. Il tempo di
avvio è proporzionale alla dimensione dell’archivio, e si paga anche per
il comando `aiuto`.

Il deposito a indice carica **solo l’indice**, che è una tabella di
centomila numeri: molto più piccola e molto più rapida da costruire. Il
singolo record viene letto dal disco al bisogno con un `seek` e una
`read`.

Il ribaltamento del compromesso è netto. `trova` diventa più lenta —
richiede un accesso al disco invece di una scansione in memoria — ma le
operazioni che toccano poche attività diventano istantanee.
L’operazione che soffre è `elenco`, che deve leggere tutti i record: con
l’indice è più lenta che in memoria.

La conclusione pratica: **l’indice conviene se le operazioni tipiche
toccano poche attività**. Per un gestore da riga di comando in cui il
comando più frequente è `elenco --stato aperta`, che tocca tutto, il
guadagno è solo nel tempo di avvio. Per un servizio che risponde a
richieste su singoli identificatori, il guadagno è enorme.

La ricostruzione dell’indice quando manca o è corrotto è la salvaguardia
essenziale: un indice è **derivabile** dai dati, e un sistema che non sa
ricostruirlo è fragile.

**ES 34.6 — Cronologia delle modifiche**

*Aggiungi la cronologia delle modifiche: ogni cambiamento registra
data, campo, valore precedente e nuovo, e un comando `storia <id>`
la mostra. Verifica che l’archivio resti leggibile e che la
dimensione cresca in modo accettabile.*

```lua
-- Nel modello: registrazione dentro aggiorna
function Attivita:aggiorna(modifiche, opzioni)
  opzioni = opzioni or {}

  local unione = {}
  for k, v in pairs(self) do unione[k] = v end
  for k, v in pairs(modifiche) do unione[k] = v end

  local ok, errore = M.valida(unione)
  if not ok then return nil, errore end

  local voci = {}
  local istante = opzioni.istante or os.time()

  for k, v in pairs(modifiche) do
    if k ~= "id" and k ~= "creata" and k ~= "storia" then
      local precedente = self[k]

      local diverso
      if type(precedente) == "table"
         or type(v) == "table" then
        diverso = table.concat(
          type(precedente) == "table" and precedente
            or {tostring(precedente)}, ",")
          ~= table.concat(
            type(v) == "table" and v
              or {tostring(v)}, ",")
      else
        diverso = precedente ~= v
      end

      if diverso then
        voci[#voci + 1] = {
          istante = istante,
          campo = k,
          prima = type(precedente) == "table"
            and table.concat(precedente, ",")
            or precedente,
          dopo = type(v) == "table"
            and table.concat(v, ",") or v,
        }
      end
    end
  end

  -- applicazione, come prima
  for k, v in pairs(modifiche) do
    if k == "etichette" then
      local e, err = normalizzaEtichette(v)
      if e == nil then return nil, err end
      self.etichette = e
    elseif k ~= "id" and k ~= "creata" then
      self[k] = v
    end
  end

  if modifiche.stato == "fatta"
     and self.chiusa == nil then
    self.chiusa = istante
  elseif modifiche.stato ~= nil
     and modifiche.stato ~= "fatta" then
    self.chiusa = nil
  end

  if #voci > 0 and not opzioni.senzaStoria then
    self.storia = self.storia or {}
    for _, v in ipairs(voci) do
      self.storia[#self.storia + 1] = v
    end
    -- limite: si conservano le ultime N voci
    local massimo = opzioni.massimoStoria or 50
    while #self.storia > massimo do
      table.remove(self.storia, 1)
    end
  end

  return self, voci
end
```

Il comando che la mostra:

```lua
comandi.storia = {
  aiuto = "storia <id>",
  opzioni = {"archivio"},
  esegui = function(contesto)
    local id = contesto.analisi.posizionali[1]
    if id == nil then return nil, "serve un id" end

    local a, errore = contesto.deposito:trova(id)
    if a == nil then return nil, errore end

    local righe = {
      string.format("Storia di #%d: %s", a.id,
        a.titolo),
      string.rep("-", 52),
      string.format("  %-19s creata",
        os.date("%Y-%m-%d %H:%M", a.creata)),
    }

    for _, v in ipairs(a.storia or {}) do
      righe[#righe + 1] = string.format(
        "  %-19s %-10s %s -> %s",
        os.date("%Y-%m-%d %H:%M", v.istante),
        v.campo,
        tostring(v.prima == nil and "(vuoto)"
          or v.prima),
        tostring(v.dopo))
    end

    if a.storia == nil or #a.storia == 0 then
      righe[#righe + 1] = "  (nessuna modifica)"
    end

    return table.concat(righe, "\n")
  end,
}
```

Sulla dimensione dell’archivio, l’analisi è quantitativa.

Una voce di storia occupa circa **ottanta byte** serializzata: istante,
nome del campo, valore precedente e nuovo. Un’attività modificata dieci
volte porta con sé ottocento byte di storia contro i circa duecento del
record base.

Su mille attività con dieci modifiche ciascuna, l’archivio passa da
duecento kilobyte a un megabyte. È accettabile.

Su centomila attività con cento modifiche ciascuna sarebbero ottocento
megabyte, che non lo è.

Il limite di cinquanta voci per attività è quindi essenziale, e non è una
limitazione arbitraria: la storia serve a capire che cosa è cambiato di
recente, non a costruire un registro contabile. Chi ha bisogno del
registro completo dovrebbe scriverlo in un file separato ad accodamento,
dove la crescita è lineare e la lettura non pesa sul caricamento
dell’archivio principale.

Il confronto fra valori tiene conto delle tabelle: senza, ogni
aggiornamento delle etichette registrerebbe una modifica anche quando
l’elenco è identico, perché due tabelle diverse non sono mai uguali.

**ES 34.7 — Persistenza a righe indipendenti**

*Sostituisci la persistenza su file Lua con un formato a righe
indipendenti, in modo che l’archivio sia modificabile a mano e che
una riga corrotta non comprometta le altre. Confronta i due
approcci.*

```lua
local Righe = {}
Righe.__index = Righe

local modello = require("src.modello")

local function fuggi(s)
  return (s:gsub("[\\\t\n]", {
    ["\\"] = "\\\\", ["\t"] = "\\t", ["\n"] = "\\n",
  }))
end

local function ripristina(s)
  return (s:gsub("\\(.)", function(c)
    if c == "t" then return "\t" end
    if c == "n" then return "\n" end
    if c == "\\" then return "\\" end
    return c
  end))
end

local CAMPI = {"id", "stato", "priorita", "scadenza",
  "creata", "chiusa", "etichette", "titolo", "note"}

local function serializzaRiga(a)
  local t = a:comeTabella()
  local pezzi = {}
  for _, campo in ipairs(CAMPI) do
    local v = t[campo]
    if campo == "etichette" then
      v = table.concat(v or {}, " ")
    end
    if v == nil then v = "" end
    pezzi[#pezzi + 1] = fuggi(tostring(v))
  end
  return table.concat(pezzi, "\t")
end

local function analizzaRiga(riga)
  local valori = {}
  local posizione = 1
  while true do
    local i = riga:find("\t", posizione, true)
    if i == nil then
      valori[#valori + 1] = riga:sub(posizione)
      break
    end
    valori[#valori + 1] = riga:sub(posizione, i - 1)
    posizione = i + 1
  end

  if #valori ~= #CAMPI then
    return nil, string.format(
      "%d campi invece di %d", #valori, #CAMPI)
  end

  local dati = {}
  for i, campo in ipairs(CAMPI) do
    local v = ripristina(valori[i])
    if v == "" then
      v = nil
    elseif campo == "id" or campo == "creata"
        or campo == "chiusa" then
      v = tonumber(v)
    elseif campo == "etichette" then
      local e = {}
      for pezzo in v:gmatch("%S+") do
        e[#e + 1] = pezzo
      end
      v = e
    end
    dati[campo] = v
  end

  return dati
end

function Righe.nuovo(percorso)
  return setmetatable({
    percorso = percorso,
    attivita = {},
    prossimoId = 1,
    modificato = false,
    scartate = {},
  }, Righe)
end

function Righe:carica()
  local f = io.open(self.percorso, "r")
  if f == nil then return self, {} end

  local numero = 0
  for riga in f:lines() do
    numero = numero + 1
    if riga:match("^%s*$") == nil
       and riga:sub(1, 1) ~= "#" then
      local dati, errore = analizzaRiga(riga)
      if dati == nil then
        self.scartate[#self.scartate + 1] = {
          riga = numero, motivo = errore}
      else
        local a, err = modello.nuova(dati)
        if a == nil then
          self.scartate[#self.scartate + 1] = {
            riga = numero, motivo = err}
        else
          self.attivita[#self.attivita + 1] = a
          if a.id >= self.prossimoId then
            self.prossimoId = a.id + 1
          end
        end
      end
    end
  end
  f:close()

  return self, self.scartate
end

function Righe:salva()
  local f, errore = io.open(self.percorso, "w")
  if f == nil then return nil, errore end
  local chiudi <close> = f

  f:write("# ", table.concat(CAMPI, "\t"), "\n")
  for _, a in ipairs(self.attivita) do
    f:write(serializzaRiga(a), "\n")
  end
  f:flush()

  self.modificato = false
  return self, #self.attivita
end

return Righe
```

Il confronto fra i due approcci, che è il punto dell’esercizio.

**Robustezza alla corruzione.** È il vantaggio decisivo del formato a
righe. Una riga danneggiata viene scartata con la sua segnalazione, e le
altre centomila restano leggibili. Con il formato Lua, un singolo
carattere sbagliato rende **l’intero file** non compilabile: si perde
tutto.

**Modificabilità a mano.** Il formato a righe si apre con qualunque
editor, si filtra con `grep`, si ordina con `sort`, si conta con `wc`.
Il formato Lua richiede di rispettare la sintassi e l’annidamento.

**Espressività.** Qui vince il formato Lua: strutture annidate, tipi
distinti, valori nulli, tabelle dentro tabelle. Il formato a righe ha
campi piatti, e la storia delle modifiche dell’ES 34.6 non ci starebbe
senza un secondo file.

**Fedeltà dei tipi.** Il formato Lua conserva la distinzione fra il
numero uno e la stringa uno; il formato a righe la perde, e la
ricostruzione deve indovinare dalla posizione del campo.

**Costo di scrittura incrementale.** Il formato a righe permette di
accodare un record senza riscrivere il file; il formato Lua richiede di
riscrivere tutto.

La conclusione: per un archivio **grande e semplice**, il formato a righe
è superiore. Per un archivio **piccolo e strutturato**, il formato Lua è
più espressivo e altrettanto sicuro, purché la scrittura sia atomica come
nel Capitolo 34. La scelta dipende da quale delle due proprietà conta di
più nel caso concreto.

**ES 34.8 — Compatibilità con LuaJIT**

*Prendi l’intero progetto e rendilo compatibile con LuaJIT seguendo
il Capitolo 27, poi verifica con la suite di test che il
comportamento sia identico su entrambe le implementazioni.*

Le modifiche necessarie, individuate applicando il Capitolo 27.

**In `src/modello.lua`.** L’attributo `<close>` non è usato, quindi non
c’è nulla da fare. Il calcolo dei giorni usa `math.floor`, che su LuaJIT
restituisce un float: irrilevante, perché il valore viene solo confrontato
e stampato.

**In `src/deposito.lua`.** Tre modifiche.

```lua
-- PRIMA (Lua 5.4)
local chiudi <close> = f
f:write(testo, "\n")

-- DOPO (portabile)
local ok, errore = pcall(function()
  f:write(testo, "\n")
  f:flush()
end)
f:close()
if not ok then return nil, errore end
```

<!-- FRAMMENTO -->
```lua
-- PRIMA
for k in pairs(v) do
  if not (math.type(k) == "integer"
          and k >= 1 and k <= n) then
  -- ...

-- DOPO
for k in pairs(v) do
  local intera = type(k) == "number"
    and k == math.floor(k)
  if not (intera and k >= 1 and k <= n) then
  -- ...
```

```lua
-- PRIMA: load con quattro argomenti esiste in 5.1
-- DOPO: identico, ma su LuaJIT il modo "t" e'
-- accettato e ignorato. Nessuna modifica.
```

**In `src/filtri.lua`.** Nessuna modifica: usa solo `table.sort`,
`table.move` — che va sostituita — e confronti di stringhe.

```lua
-- table.move non esiste in LuaJIT
local function copia(origine, quante)
  local r = {}
  for i = 1, quante do r[i] = origine[i] end
  return r
end
```

**In `src/formato.lua`.** Una modifica.

```lua
-- PRIMA
local barre = math.floor(v / massimo * larghezza + 0.5)

-- DOPO: identico, math.floor esiste ovunque.
-- Ma il risultato e' un float su LuaJIT, e
-- string.rep lo accetta comunque.
```

**In `src/comandi.lua` e `src/cli.lua`.** Nessuna modifica.

**In `attivita.lua`.** Nessuna modifica: `xpcall` con argomenti
aggiuntivi esiste dalla 5.2, ma LuaJIT lo supporta.

Lo strato di compatibilità che raccoglie le differenze:

```lua
-- src/compat.lua
local M = {}

M.jit = rawget(_G, "jit") ~= nil
M.interi = math.type ~= nil

M.unpack = table.unpack or rawget(_G, "unpack")

M.pack = table.pack or function(...)
  return {n = select("#", ...), ...}
end

if table.move then
  M.copia = function(origine, da, a, dove, destinazione)
    return table.move(origine, da, a, dove,
      destinazione)
  end
else
  M.copia = function(origine, da, a, dove, destinazione)
    destinazione = destinazione or origine
    dove = dove or 1
    if dove > da then
      for i = a - da, 0, -1 do
        destinazione[dove + i] = origine[da + i]
      end
    else
      for i = 0, a - da do
        destinazione[dove + i] = origine[da + i]
      end
    end
    return destinazione
  end
end

function M.eIntero(v)
  if M.interi then return math.type(v) == "integer" end
  return type(v) == "number" and v == math.floor(v)
end

function M.conFile(percorso, modo, azione)
  local f, errore = io.open(percorso, modo)
  if f == nil then return nil, errore end
  local risultati = M.pack(pcall(azione, f))
  f:close()
  if not risultati[1] then
    return nil, risultati[2]
  end
  return M.unpack(risultati, 2, risultati.n)
end

return M
```

Il metodo di verifica è quello dell’ES 30.8: la suite di test dell’ES
34.3 va eseguita su entrambe le implementazioni, e i risultati devono
coincidere.

Le differenze che **restano** e vanno dichiarate sono due.

I **tipi numerici**: su LuaJIT tutti gli identificatori sono float, e
l’archivio serializzato conterrà `id=1.0` invece di `id=1`. Un archivio
scritto da LuaJIT e riletto da Lua 5.4 funziona, ma i confronti fra
stringhe di output differiscono. La correzione è formattare
esplicitamente con `string.format("%d", id)` invece di `tostring`.

La **garanzia di chiusura**: la simulazione con `pcall` non copre
l’uscita anticipata da un blocco, come discusso nell’ES 27.8. Nel
progetto non ci sono uscite anticipate dai blocchi che aprono file,
quindi la differenza non si manifesta — ma è una proprietà del codice
attuale, non una garanzia, e una modifica futura potrebbe romperla.

---

Con questo si chiude il volume delle soluzioni. Ogni esercizio proposto nei
trentaquattro capitoli ha la propria soluzione, e ogni soluzione
eseguibile è stata effettivamente eseguita durante la preparazione del
manuale: gli output riportati sono quelli reali, non quelli attesi.

Chi ha lavorato sugli esercizi prima di leggere le soluzioni ha
probabilmente trovato risposte diverse da queste, e in molti casi
altrettanto valide. Dove l’esercizio ammetteva più risposte corrette è
stato segnalato; dove una scelta è stata presa fra alternative
legittime, la ragione è dichiarata.

Resta un’osservazione che vale per tutto il volume. Diverse soluzioni
sono state **corrette dopo l’esecuzione**, perché il comportamento reale
differiva da quello previsto: il conteggio del fattoriale, la semantica
di `2^53`, il numero di casi che intercettano un bug, la chiusura di una
coroutine abbandonata, il valore di `#` su una tabella con buchi. In
almeno un caso il codice presentato conteneva la stessa trappola che il
manuale aveva spiegato a lungo — l’idioma `cond and a or b` con il ramo
vero uguale a `nil`.

Non è un aneddoto marginale: è la lezione centrale del Capitolo 29. Il
ragionamento a tavolina produce codice plausibile, e il plausibile non è
il corretto. L’unica verifica che conta è l’esecuzione.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
