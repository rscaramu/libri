-- ES 13.6 — Matrice con `__index` a due livelli
-- Manuale completo di Lua

local Matrice = {}
Matrice.__index = Matrice

local Riga = {}
Riga.__index = function(riga, colonna)
  if type(colonna) ~= "number" then return nil end
  local m = rawget(riga, "matrice")
  local r = rawget(riga, "indice")
  if colonna < 1 or colonna > m.colonne then
    error("colonna fuori intervallo: " .. colonna, 2)
  end
  return m.dati[(r - 1) * m.colonne + colonna]
end
Riga.__newindex = function(riga, colonna, valore)
  local m = rawget(riga, "matrice")
  local r = rawget(riga, "indice")
  if type(colonna) ~= "number"
     or colonna < 1 or colonna > m.colonne then
    error("colonna fuori intervallo: "
      .. tostring(colonna), 2)
  end
  m.dati[(r - 1) * m.colonne + colonna] = valore
end
Riga.__len = function(riga)
  return rawget(riga, "matrice").colonne
end

local function nuova(righe, colonne, riempimento)
  local m = setmetatable({
    righe = righe,
    colonne = colonne,
    dati = {},
    righeCache = {},
  }, Matrice)

  for i = 1, righe * colonne do
    m.dati[i] = riempimento or 0
  end

  for i = 1, righe do
    m.righeCache[i] = setmetatable(
      {matrice = m, indice = i}, Riga)
  end

  return m
end

Matrice.__index = function(m, k)
  if type(k) == "number" then
    local cache = rawget(m, "righeCache")
    local riga = cache and cache[k]
    if riga == nil then
      error("riga fuori intervallo: " .. k, 2)
    end
    return riga
  end
  return Matrice[k]
end

Matrice.__add = function(a, b)
  if a.righe ~= b.righe or a.colonne ~= b.colonne then
    error("dimensioni incompatibili", 2)
  end
  local r = nuova(a.righe, a.colonne)
  for i = 1, #a.dati do
    r.dati[i] = a.dati[i] + b.dati[i]
  end
  return r
end

Matrice.__mul = function(a, b)
  if type(b) == "number" then a, b = b, a end
  if type(a) == "number" then
    local r = nuova(b.righe, b.colonne)
    for i = 1, #b.dati do r.dati[i] = b.dati[i] * a end
    return r
  end

  if a.colonne ~= b.righe then
    error(string.format(
      "dimensioni incompatibili: %dx%d per %dx%d",
      a.righe, a.colonne, b.righe, b.colonne), 2)
  end

  local r = nuova(a.righe, b.colonne)
  for i = 1, a.righe do
    for j = 1, b.colonne do
      local s = 0
      for k = 1, a.colonne do
        s = s + a.dati[(i - 1) * a.colonne + k]
          * b.dati[(k - 1) * b.colonne + j]
      end
      r.dati[(i - 1) * r.colonne + j] = s
    end
  end
  return r
end

Matrice.__tostring = function(m)
  local righe = {}
  for i = 1, m.righe do
    local pezzi = {}
    for j = 1, m.colonne do
      pezzi[j] = string.format("%7.2f",
        m.dati[(i - 1) * m.colonne + j])
    end
    righe[i] = table.concat(pezzi)
  end
  return table.concat(righe, "\n")
end

local a = nuova(2, 3)
a[1][1] = 1  a[1][2] = 2  a[1][3] = 3
a[2][1] = 4  a[2][2] = 5  a[2][3] = 6

local b = nuova(3, 2)
b[1][1] = 7   b[1][2] = 8
b[2][1] = 9   b[2][2] = 10
b[3][1] = 11  b[3][2] = 12

print("a =") print(tostring(a))
print("a[2][3] = " .. a[2][3])
print("a * b =") print(tostring(a * b))
print("a * 2 =") print(tostring(2 * a))
print("righe di a: " .. #a[1] .. " colonne")

print(pcall(function() return a[5] end))
print(pcall(function() return a[1][9] end))
print(pcall(function() return a * a end))
