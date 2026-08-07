-- ES 33.7 — Registrazione strutturata e aggregazione
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

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
