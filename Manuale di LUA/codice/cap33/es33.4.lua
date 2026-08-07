-- ES 33.4 — Cache a due livelli per OpenResty
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

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
