-- ES 21.8 — Convertire fra le due convenzioni
-- Manuale completo di Lua

local function aRisultato(f)
  return function(...)
    local r = table.pack(pcall(f, ...))
    if not r[1] then
      return nil, r[2]
    end
    return table.unpack(r, 2, r.n)
  end
end

local function aErrore(f, messaggioPredefinito)
  return function(...)
    local r = table.pack(f(...))
    if r.n >= 1 and r[1] == nil then
      local messaggio = r[2]
        or messaggioPredefinito
        or "operazione fallita"
      error(messaggio, 2)
    end
    return table.unpack(r, 1, r.n)
  end
end

-- Funzioni di prova
local function conError(a, b)
  if type(a) ~= "number" then
    error("primo argomento non numerico", 2)
  end
  return a + b, a - b, a * b
end

local function conNil(a, b)
  if type(a) ~= "number" then
    return nil, "primo argomento non numerico"
  end
  return a + b, a - b, a * b
end

local function conNilIntermedi()
  return 1, nil, 3, nil
end

print("=== aRisultato su una funzione con error ===")
local sicura = aRisultato(conError)
print(sicura(10, 3))
print(sicura("x", 3))

print()
print("=== aErrore su una funzione con nil ===")
local esplosiva = aErrore(conNil)
print(esplosiva(10, 3))
print(pcall(esplosiva, "x", 3))

print()
print("=== conservazione dei nil intermedi ===")
local a = table.pack(conNilIntermedi())
print("originale: n=" .. a.n)

local b = table.pack(aRisultato(conNilIntermedi)())
print("aRisultato: n=" .. b.n)
for i = 1, b.n do
  io.write("[", tostring(b[i]), "]")
end
print()

local c = table.pack(aErrore(function()
  return 1, nil, 3, nil
end)())
print("aErrore: n=" .. c.n)
for i = 1, c.n do
  io.write("[", tostring(c[i]), "]")
end
print()

print()
print("=== composizione: andata e ritorno ===")
local andata = aRisultato(conError)
local ritorno = aErrore(andata)
print(ritorno(10, 3))
print(pcall(ritorno, "x", 3))
