-- ES 26.6 — Contatore ad alta risoluzione
-- Manuale completo di Lua

local cronometro = require("cronometro")

print(string.format("risoluzione dell'orologio: %.0f ns",
  cronometro.risoluzione()))

local function lavoro(n)
  local s = 0
  for i = 1, n do s = s + math.sqrt(i) end
  return s
end

print()
print("misura di operazioni molto brevi:")
for _, n in ipairs({10, 100, 1000, 10000}) do
  local t = cronometro.nuovo()
  local c1 = os.clock()
  t:avvia()
  lavoro(n)
  local us = t:ferma()
  local osclock = (os.clock() - c1) * 1e6
  print(string.format("  n=%6d  cronometro %9.2f us"
    .. "   os.clock %9.2f us", n, us, osclock))
end

print()
print("accumulo su piu' intervalli:")
local t = cronometro.nuovo()
for i = 1, 5 do
  t:avvia()
  lavoro(10000)
  t:ferma()
end
print("  totale di 5 misure: "
  .. string.format("%.2f us", t:microsecondi()))
print("  " .. tostring(t))

print()
print(pcall(function() t:ferma() end))
t:azzera()
print("dopo azzera: " .. t:microsecondi())
