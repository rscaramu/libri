-- ES 4.7 — La tabella dei segni del modulo
-- Manuale completo di Lua

local valori = {7, -7}
local divisori = {3, -3}

print(string.format("%5s %5s %8s %8s %10s",
  "a", "b", "a % b", "a // b", "verifica"))

for _, a in ipairs(valori) do
  for _, b in ipairs(divisori) do
    local resto = a % b
    local quoziente = a // b
    -- La definizione: a == (a // b) * b + (a % b)
    local ricostruito = quoziente * b + resto
    print(string.format("%5d %5d %8d %8d %10s",
      a, b, resto, quoziente,
      ricostruito == a and "ok" or "ERRORE"))
  end
end
