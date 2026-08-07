-- ES 30.5 — Rapporto delle differenze semantiche
-- Manuale completo di Lua

local righe = {}

local function segnala(nome, valore)
  righe[#righe + 1] = string.format("%-34s %s",
    nome, tostring(valore))
end

segnala("_VERSION", _VERSION)

-- 1. Tipo del risultato della divisione
segnala("tipo di 6/3", math.type and math.type(6/3)
  or "senza math.type")
segnala("6/3 == 2", 6/3 == 2)
segnala("tostring(6/3)", tostring(6/3))
segnala("tipo di 6//3", math.type and math.type(6//3)
  or "n/d")

-- 2. Comportamento di # su tabelle con buchi
local conBuchi = {}
conBuchi[1] = "a"
conBuchi[2] = "b"
conBuchi[4] = "d"
segnala("# su {1,2,_,4}", #conBuchi)

local conBuchi2 = {"a", nil, "c"}
segnala("# su {'a', nil, 'c'}", #conBuchi2)

local grande = {}
for i = 1, 100 do grande[i] = i end
grande[50] = nil
segnala("# su 1..100 senza il 50", #grande)

-- 3. Ordine di pairs su una tabella data
local ordinata = {}
for _, k in ipairs({"alfa", "beta", "gamma", "delta",
    "epsilon"}) do
  ordinata[k] = true
end
local visto = {}
for k in pairs(ordinata) do visto[#visto + 1] = k end
segnala("ordine di pairs", table.concat(visto, " "))

-- 4. Sequenza di math.random con seme fisso
math.randomseed(42)
local casuali = {}
for i = 1, 5 do
  casuali[i] = math.random(1, 1000)
end
segnala("random con seme 42",
  table.concat(casuali, " "))

math.randomseed(42)
local ripetuti = {}
for i = 1, 5 do
  ripetuti[i] = math.random(1, 1000)
end
segnala("stessa sequenza ripetendo il seme",
  table.concat(casuali, " ")
    == table.concat(ripetuti, " "))

-- 5. Rappresentazione dei float
segnala("tostring(0.1)", tostring(0.1))
segnala("tostring(1/3)", tostring(1/3))
segnala("tostring(2^63)", tostring(2^63))
segnala("0.1 + 0.2 == 0.3", 0.1 + 0.2 == 0.3)
segnala("tostring(0.1 + 0.2)", tostring(0.1 + 0.2))

-- 6. Coercizione stringa-numero
segnala("'10' + 5", pcall(function()
  return "10" + 5 end) and ("10" + 5) or "errore")
segnala("tipo di '10' + 5",
  math.type and math.type("10" + 5) or "n/d")

-- 7. Confronto fra interi e float
segnala("1 == 1.0", 1 == 1.0)
segnala("chiave 1 e chiave 1.0",
  (function()
    local t = {}
    t[1] = "intero"
    t[1.0] = "float"
    return t[1]
  end)())

-- 8. Concatenazione di numeri
segnala("1 .. ''", 1 .. "")
segnala("1.0 .. ''", 1.0 .. "")

print(table.concat(righe, "\n"))
