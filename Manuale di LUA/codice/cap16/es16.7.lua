-- ES 16.7 — Ricaricare un modulo
-- Manuale completo di Lua

local versione = 1

package.preload["contatore"] = function()
  local n = 0
  local v = versione
  return {
    incrementa = function()
      n = n + 1
      return n
    end,
    versione = function() return v end,
  }
end

local function ricarica(nome)
  package.loaded[nome] = nil
  return require(nome)
end

local vecchio = require("contatore")
vecchio.incrementa()
vecchio.incrementa()

print("vecchio: versione " .. vecchio.versione()
  .. ", contatore " .. vecchio.incrementa())

versione = 2
local nuovo = ricarica("contatore")

print("nuovo:   versione " .. nuovo.versione()
  .. ", contatore " .. nuovo.incrementa())

print("vecchio dopo il ricarico: versione "
  .. vecchio.versione() .. ", contatore "
  .. vecchio.incrementa())

print("sono lo stesso oggetto? "
  .. tostring(vecchio == nuovo))
print("require restituisce il nuovo? "
  .. tostring(require("contatore") == nuovo))
