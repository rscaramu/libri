-- ES 23.5 — Chiavi deboli: stringhe contro tabelle
-- Manuale completo di Lua

local conStringhe = setmetatable({}, {__mode = "k"})
local conTabelle = setmetatable({}, {__mode = "k"})
local conValoriDeboli = setmetatable({}, {__mode = "v"})

local function quante(t)
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

do
  for i = 1, 100 do
    conStringhe["chiave" .. i] = i
    conTabelle[{indice = i}] = i
    conValoriDeboli[i] = {indice = i}
  end
end

print("prima della raccolta:")
print("  chiavi stringa:  " .. quante(conStringhe))
print("  chiavi tabella:  " .. quante(conTabelle))
print("  valori tabella:  " .. quante(conValoriDeboli))

collectgarbage("collect")
collectgarbage("collect")

print("dopo la raccolta:")
print("  chiavi stringa:  " .. quante(conStringhe))
print("  chiavi tabella:  " .. quante(conTabelle))
print("  valori tabella:  " .. quante(conValoriDeboli))

print()
print("con un riferimento trattenuto:")
local trattenuta = {marcata = true}
conTabelle[trattenuta] = "sopravvive"
for i = 1, 50 do conTabelle[{}] = i end

collectgarbage("collect")
collectgarbage("collect")
print("  voci rimaste: " .. quante(conTabelle))
print("  la trattenuta c'e' ancora: "
  .. tostring(conTabelle[trattenuta]))

print()
print("chiavi numeriche:")
local conNumeri = setmetatable({}, {__mode = "k"})
for i = 1, 100 do conNumeri[i] = "x" end
collectgarbage("collect")
print("  voci rimaste: " .. quante(conNumeri))
