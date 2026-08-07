-- ES 26.5 — Righe della matrice come oggetti
-- Manuale completo di Lua

local matrice = require("matrice2")

local m = matrice.nuova(3, 4)

for i = 1, 3 do
  for j = 1, 4 do
    m[i][j] = i * 10 + j
  end
end

for i = 1, 3 do
  print("riga " .. i .. ": " .. tostring(m[i]))
end

print("m[2][3] = " .. m[2][3])
print("righe: " .. #m .. ", colonne: " .. #m[1])
print("dimensioni: " .. m:dimensioni())

local riga = m[2]
riga[1] = 999
print("dopo modifica via riga: " .. m[2][1])

print(pcall(function() return m[9] end))
print(pcall(function() return m[1][9] end))
print(pcall(function() m[1][0] = 1 end))
