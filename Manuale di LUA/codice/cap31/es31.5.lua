-- ES 31.5 — Gestore di risorse con cache
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local Risorse = {}
Risorse.__index = Risorse

function Risorse.nuovo(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    debole = opzioni.debole or false,
    cache = opzioni.debole
      and setmetatable({}, {__mode = "v"})
      or {},
    caricamenti = 0,
    colpi = 0,
    byteStimati = 0,
    caricatori = {},
  }, Risorse)
end

function Risorse:registra(tipo, caricatore, stima)
  self.caricatori[tipo] = {
    carica = caricatore,
    stima = stima,
  }
  return self
end

function Risorse:ottieni(tipo, percorso, ...)
  local chiave = tipo .. ":" .. percorso
  local v = self.cache[chiave]
  if v ~= nil then
    self.colpi = self.colpi + 1
    return v
  end

  local c = self.caricatori[tipo]
  if c == nil then
    return nil, "tipo sconosciuto: " .. tostring(tipo)
  end

  local ok, risorsa = pcall(c.carica, percorso, ...)
  if not ok then
    return nil, "caricamento fallito: "
      .. tostring(risorsa)
  end

  self.cache[chiave] = risorsa
  self.caricamenti = self.caricamenti + 1
  if c.stima then
    self.byteStimati = self.byteStimati
      + c.stima(risorsa)
  end

  return risorsa
end

function Risorse:stato()
  local quante = 0
  for _ in pairs(self.cache) do quante = quante + 1 end
  return {
    inCache = quante,
    caricamenti = self.caricamenti,
    colpi = self.colpi,
    byteStimati = self.byteStimati,
    debole = self.debole,
  }
end

function Risorse:rapporto()
  local s = self:stato()
  local totale = s.caricamenti + s.colpi
  return string.format(
    "risorse: %d in cache, %d caricamenti, %d colpi "
    .. "(%.1f%%), circa %.1f MB, modalita' %s",
    s.inCache, s.caricamenti, s.colpi,
    totale > 0 and (s.colpi / totale * 100) or 0,
    s.byteStimati / 1048576,
    s.debole and "debole" or "forte")
end

-- Registrazione dei tipi in un gioco LOVE
local function configura(r)
  r:registra("immagine", function(percorso)
    return love.graphics.newImage(percorso)
  end, function(img)
    local w, h = img:getDimensions()
    return w * h * 4
  end)

  r:registra("suono", function(percorso, modalita)
    return love.audio.newSource(percorso,
      modalita or "static")
  end, function() return 0 end)

  r:registra("font", function(percorso, dimensione)
    return love.graphics.newFont(percorso,
      dimensione or 12)
  end, function() return 0 end)

  return r
end

return {nuovo = Risorse.nuovo, configura = configura}
