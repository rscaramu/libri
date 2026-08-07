-- ES 18.6 — La corrispondenza vuota, tre casi
-- Manuale completo di Lua

print("=== Caso 1: gsub con pattern che accetta il "
  .. "vuoto ===")
print("(\"abc\"):gsub(\"%d*\", \"-\")")
local r1, n1 = ("abc"):gsub("%d*", "-")
print("  risultato: [" .. r1 .. "] sostituzioni: " .. n1)
print("  atteso: solo le cifre sostituite, ma non ce "
  .. "ne sono")
local r1c, n1c = ("abc"):gsub("%d+", "-")
print("  corretto con +: [" .. r1c .. "] " .. n1c)

print()
print("=== Caso 2: gmatch che produce corrispondenze "
  .. "vuote ===")
print("for w in (\"abc\"):gmatch(\"%d*\") do ...")
local quante = 0
for w in ("abc"):gmatch("%d*") do
  quante = quante + 1
  io.write("[", w, "]")
end
print("  iterazioni: " .. quante
  .. " (attese 0: non ci sono cifre)")
local quante2 = 0
for w in ("abc"):gmatch("%d+") do
  quante2 = quante2 + 1
end
print("  corretto con +: " .. quante2)

print()
print("=== Caso 3: divisione che produce campi "
  .. "fantasma ===")
local pezzi = {}
for pezzo in ("a,b"):gmatch("[^,]*") do
  pezzi[#pezzi + 1] = "[" .. pezzo .. "]"
end
print("  con *: " .. table.concat(pezzi, " ")
  .. "  (" .. #pezzi .. " pezzi)")

local pezzi2 = {}
for pezzo in ("a,,b"):gmatch("[^,]*") do
  pezzi2[#pezzi2 + 1] = "[" .. pezzo .. "]"
end
print("  con campo vuoto: " .. table.concat(pezzi2, " ")
  .. "  (" .. #pezzi2 .. " pezzi)")

local pezzi3 = {}
for pezzo in ("a,,b"):gmatch("[^,]+") do
  pezzi3[#pezzi3 + 1] = "[" .. pezzo .. "]"
end
print("  con +: " .. table.concat(pezzi3, " ")
  .. "  (perde il campo vuoto!)")
print("  la soluzione corretta e' find in un ciclo,")
print("  come nell'ES 18.4")
