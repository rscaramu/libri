-- ES 4.5 — Da euro a centesimi
-- Manuale completo di Lua

local function aCentesimi(euro)
  if type(euro) ~= "number" then
    return nil, "atteso un numero"
  end
  -- Arrotondamento simmetrico, non troncamento
  if euro >= 0 then
    return math.floor(euro * 100 + 0.5)
  end
  return math.ceil(euro * 100 - 0.5)
end

local prove = {0.1, 0.29, 1.15, 8.35, 19.99,
               -2.675, 0.005}

for _, e in ipairs(prove) do
  local ingenuo = math.floor(e * 100)
  local corretto = aCentesimi(e)
  print(string.format(
    "%8.3f  ingenuo=%5d  corretto=%5d  %s",
    e, ingenuo, corretto,
    ingenuo == corretto and "" or "<-- DIVERSI"))
end

print(string.format("%.20f", 0.29 * 100))
print(string.format("%.20f", 1.15 * 100))
print(string.format("%.20f", 8.35 * 100))
