-- ES 30.6 — `print` e `tostring` in Lua 5.4
-- Manuale completo di Lua

local originale = tostring

local chiamate = 0
local ultimoArgomento = nil

_G.tostring = function(v)
  chiamate = chiamate + 1
  ultimoArgomento = v
  return "SOSTITUITO(" .. originale(v) .. ")"
end

print("--- con tostring globale sostituito ---")
print(42)
print("una stringa")
print(nil)
print(true)

local conMeta = setmetatable({}, {
  __tostring = function() return "DA METAMETODO" end
})
print(conMeta)

print("chiamate a tostring intercettate da print: "
  .. chiamate)

print("--- concatenazione e string.format ---")
local prima = chiamate
local s = "valore: " .. 42
local f = string.format("%s", 42)
print("chiamate durante .. e format: "
  .. (chiamate - prima))

print("--- chiamata esplicita ---")
local prima2 = chiamate
local esplicita = tostring(99)
print("chiamate con tostring esplicito: "
  .. (chiamate - prima2))
print("risultato: " .. originale(esplicita))

_G.tostring = originale
print("--- ripristinato ---")
print("ora print e' normale: " .. 7)
