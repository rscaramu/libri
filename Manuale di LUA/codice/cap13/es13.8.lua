-- ES 13.8 — Registrare le letture di chiavi assenti
-- Manuale completo di Lua

local function conTracciamento(reale)
  local mancanti = {}
  local attivo = true
  local letture = 0

  local proxy = setmetatable({}, {
    __index = function(_, k)
      letture = letture + 1
      local v = reale[k]
      if v == nil and attivo then
        mancanti[k] = (mancanti[k] or 0) + 1
      end
      return v
    end,
    __newindex = function(_, k, v)
      reale[k] = v
    end,
    __len = function() return #reale end,
  })

  local controllo = {
    attiva = function() attivo = true end,
    disattiva = function() attivo = false end,
    rapporto = function()
      local elenco = {}
      for k, n in pairs(mancanti) do
        elenco[#elenco + 1] = {chiave = k, quante = n}
      end
      table.sort(elenco, function(a, b)
        if a.quante ~= b.quante then
          return a.quante > b.quante
        end
        return tostring(a.chiave) < tostring(b.chiave)
      end)
      return elenco, letture
    end,
    azzera = function()
      mancanti = {}
      letture = 0
    end,
  }

  return proxy, controllo
end

local dati = {nome = "Anna", eta = 34, citta = "Roma"}
local t, ctrl = conTracciamento(dati)

print(t.nome)
print(tostring(t.cognome))
print(tostring(t.et))
print(tostring(t.et))
print(tostring(t.indirizo))

local elenco, letture = ctrl.rapporto()
print("letture totali: " .. letture)
print("chiavi assenti richieste:")
for _, v in ipairs(elenco) do
  print(string.format("  %-12s %d volte",
    tostring(v.chiave), v.quante))
end

-- Costo del tracciamento
local N = 1000000

collectgarbage("collect")
local t1 = os.clock()
local s1 = 0
for i = 1, N do s1 = s1 + dati.eta end
local d1 = os.clock() - t1

ctrl.disattiva()
collectgarbage("collect")
local t2 = os.clock()
local s2 = 0
for i = 1, N do s2 = s2 + t.eta end
local d2 = os.clock() - t2

print(string.format(
  "diretto: %.4f s   con proxy: %.4f s   %.1fx",
  d1, d2, d2 / d1))
