-- ES 9.8 — Memoizzazione a due argomenti
-- Manuale completo di Lua

local function memoizzaConcatenazione(f)
  local cache = {}
  local calcoli = 0
  local funzione = function(a, b)
    local chiave = tostring(a) .. "\0" .. tostring(b)
    local v = cache[chiave]
    if v == nil then
      calcoli = calcoli + 1
      v = f(a, b)
      cache[chiave] = v
    end
    return v
  end
  return funzione, function() return calcoli end
end

local function memoizzaAnnidata(f)
  local cache = {}
  local calcoli = 0
  local funzione = function(a, b)
    local livello = cache[a]
    if livello == nil then
      livello = {}
      cache[a] = livello
    end
    local v = livello[b]
    if v == nil then
      calcoli = calcoli + 1
      v = f(a, b)
      livello[b] = v
    end
    return v
  end
  return funzione, function() return calcoli end
end

local function lenta(a, b)
  local s = 0
  for i = 1, 100 do s = s + a * b end
  return s
end

local f1, c1 = memoizzaConcatenazione(lenta)
local f2, c2 = memoizzaAnnidata(lenta)

for _ = 1, 3 do
  for a = 1, 5 do
    for b = 1, 5 do
      f1(a, b)
      f2(a, b)
    end
  end
end

print("concatenazione: " .. c1() .. " calcoli reali")
print("annidata:       " .. c2() .. " calcoli reali")

-- Il difetto della concatenazione
print()
print("Collisione con la concatenazione:")
local function etichetta(a, b)
  return type(a) .. "/" .. tostring(a)
    .. "|" .. tostring(b)
end

local g1 = memoizzaConcatenazione(etichetta)
print("concatenazione, argomento numero: " .. g1(1, 2))
print("concatenazione, argomento stringa: " .. g1("1", 2))

local g2 = memoizzaAnnidata(etichetta)
print("annidata, argomento numero:  " .. g2(1, 2))
print("annidata, argomento stringa: " .. g2("1", 2))
