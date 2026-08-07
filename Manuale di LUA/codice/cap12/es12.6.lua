-- ES 12.6 — Cache con scadenza
-- Manuale completo di Lua

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
