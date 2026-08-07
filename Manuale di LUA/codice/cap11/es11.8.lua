-- ES 11.8 — Decora, ordina, spoglia
-- Manuale completo di Lua

local ACCENTI = {
  ["\195\160"] = "a", ["\195\161"] = "a",
  ["\195\168"] = "e", ["\195\169"] = "e",
  ["\195\172"] = "i", ["\195\173"] = "i",
  ["\195\178"] = "o", ["\195\179"] = "o",
  ["\195\185"] = "u", ["\195\186"] = "u",
}

local chiamate = 0

local function normalizza(s)
  chiamate = chiamate + 1
  s = s:lower()
  for a, b in pairs(ACCENTI) do
    s = s:gsub(a, b)
  end
  return s
end

local function generaNomi(quanti)
  local base = {"citta", "citt\195\160", "perche",
    "perch\195\169", "cosi", "cos\195\172", "Zoe",
    "anna", "Elena", "carlo", "\195\188ber", "bosco"}
  local r = {}
  math.randomseed(12345)
  for i = 1, quanti do
    r[i] = base[math.random(#base)] .. i
  end
  return r
end

local nomi = generaNomi(1000)

-- Versione diretta
local copia1 = {}
table.move(nomi, 1, #nomi, 1, copia1)
chiamate = 0
local t1 = os.clock()
table.sort(copia1, function(a, b)
  return normalizza(a) < normalizza(b)
end)
local d1 = os.clock() - t1
local c1 = chiamate

-- Versione decora, ordina, spoglia
local copia2 = {}
table.move(nomi, 1, #nomi, 1, copia2)
chiamate = 0
local t2 = os.clock()

local decorati = {}
for i = 1, #copia2 do
  decorati[i] = {chiave = normalizza(copia2[i]),
    valore = copia2[i]}
end
table.sort(decorati, function(a, b)
  if a.chiave ~= b.chiave then
    return a.chiave < b.chiave
  end
  return a.valore < b.valore
end)
for i = 1, #decorati do
  copia2[i] = decorati[i].valore
end

local d2 = os.clock() - t2
local c2 = chiamate

print(string.format("diretta: %.4f s, %d chiamate",
  d1, c1))
print(string.format("decorata: %.4f s, %d chiamate",
  d2, c2))
print(string.format("rapporto chiamate: %.1fx",
  c1 / c2))

local uguali = true
for i = 1, #copia1 do
  if copia1[i] ~= copia2[i] then uguali = false end
end
print("stesso risultato: " .. tostring(uguali))
