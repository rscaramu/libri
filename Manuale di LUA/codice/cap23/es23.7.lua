-- ES 23.7 — Ordine dei finalizzatori e resurrezione
-- Manuale completo di Lua

local eventi = {}
local resuscitato = nil

local function crea(nome)
  return setmetatable({nome = nome}, {
    __gc = function(o)
      eventi[#eventi + 1] = "finalizzo " .. o.nome
    end
  })
end

print("=== ordine di finalizzazione ===")
do
  local primo = crea("primo")
  local secondo = crea("secondo")
  local terzo = crea("terzo")
end

collectgarbage("collect")
collectgarbage("collect")

for _, e in ipairs(eventi) do print("  " .. e) end
print("  (creati nell'ordine primo, secondo, terzo)")

print()
print("=== resurrezione ===")
eventi = {}

local funzionaAncora = nil

do
  local risorsa = setmetatable({nome = "resuscitabile",
    valore = 42}, {
    __gc = function(o)
      eventi[#eventi + 1] = "gc chiamato su " .. o.nome
      -- Rendiamo l'oggetto di nuovo raggiungibile
      resuscitato = o
    end
  })
end

collectgarbage("collect")
collectgarbage("collect")

print("  eventi: " .. #eventi)
for _, e in ipairs(eventi) do print("    " .. e) end
print("  l'oggetto e' tornato raggiungibile: "
  .. tostring(resuscitato ~= nil))
if resuscitato then
  print("  e i suoi campi sono intatti: valore = "
    .. tostring(resuscitato.valore))
end

print()
print("=== il finalizzatore viene chiamato una "
  .. "seconda volta? ===")
eventi = {}
resuscitato = nil
collectgarbage("collect")
collectgarbage("collect")
print("  eventi dopo la seconda morte: " .. #eventi)
print("  (atteso 0: Lua marca l'oggetto come gia'")
print("   finalizzato e non richiama __gc)")
