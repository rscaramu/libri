-- ES 33.6 — Interruttore automatico
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

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
