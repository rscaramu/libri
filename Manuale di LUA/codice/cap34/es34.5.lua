-- ES 34.5 — Archivi grandi con indice separato
-- Manuale completo di Lua

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
