-- ES 14.8 — Generatore di classi
-- Manuale completo di Lua

local function classe(nome, campi, opzioni)
  opzioni = opzioni or {}

  local C = {}
  C.__index = C
  C.__nome = nome
  C.__campi = campi

  local insieme = {}
  for _, c in ipairs(campi) do insieme[c] = true end

  C.nuovo = function(dati)
    dati = dati or {}
    for k in pairs(dati) do
      if not insieme[k] then
        return nil, string.format(
          "%s: campo sconosciuto '%s'", nome,
          tostring(k))
      end
    end

    local istanza = setmetatable({}, C)
    for _, campo in ipairs(campi) do
      istanza[campo] = dati[campo]
    end
    return istanza
  end

  C.__tostring = function(o)
    local pezzi = {}
    for _, campo in ipairs(campi) do
      pezzi[#pezzi + 1] = campo .. "="
        .. tostring(o[campo])
    end
    return nome .. "{" .. table.concat(pezzi, ", ") .. "}"
  end

  C.__eq = function(a, b)
    for _, campo in ipairs(campi) do
      if a[campo] ~= b[campo] then return false end
    end
    return true
  end

  function C:copia(modifiche)
    local dati = {}
    for _, campo in ipairs(campi) do
      dati[campo] = self[campo]
    end
    for k, v in pairs(modifiche or {}) do
      if not insieme[k] then
        return nil, "campo sconosciuto: " .. tostring(k)
      end
      dati[k] = v
    end
    return C.nuovo(dati)
  end

  function C:comeTabella()
    local t = {}
    for _, campo in ipairs(campi) do
      t[campo] = self[campo]
    end
    return t
  end

  if opzioni.ordinaPer then
    local chiave = opzioni.ordinaPer
    C.__lt = function(a, b)
      return a[chiave] < b[chiave]
    end
    C.__le = function(a, b)
      return a[chiave] <= b[chiave]
    end
  end

  return C
end

local Punto = classe("Punto", {"x", "y"})
local Persona = classe("Persona",
  {"nome", "cognome", "eta"}, {ordinaPer = "eta"})

local p = Punto.nuovo({x = 1, y = 2})
print(tostring(p))
print("uguale a un altro (1,2)? "
  .. tostring(p == Punto.nuovo({x = 1, y = 2})))

local q = p:copia({y = 99})
print("copia modificata: " .. tostring(q))
print("originale intatto: " .. tostring(p))

print(Punto.nuovo({x = 1, z = 3}))

local gente = {
  Persona.nuovo({nome = "Anna", cognome = "Rossi",
    eta = 34}),
  Persona.nuovo({nome = "Bruno", cognome = "Bianchi",
    eta = 28}),
  Persona.nuovo({nome = "Carla", cognome = "Verdi",
    eta = 41}),
}

table.sort(gente, function(a, b) return a < b end)
for _, x in ipairs(gente) do print(tostring(x)) end
