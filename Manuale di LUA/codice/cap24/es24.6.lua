-- ES 24.6 — Upvalue per nome
-- Manuale completo di Lua

local function elencaUpvalue(f)
  if type(f) ~= "function" then
    return nil, "atteso una funzione"
  end
  local r = {}
  for i = 1, math.huge do
    local nome, valore = debug.getupvalue(f, i)
    if nome == nil then break end
    r[#r + 1] = {
      indice = i, nome = nome, valore = valore,
      tipo = type(valore),
    }
  end
  return r
end

local function impostaUpvalue(f, nome, valore)
  for i = 1, math.huge do
    local n = debug.getupvalue(f, i)
    if n == nil then break end
    if n == nome then
      debug.setupvalue(f, i, valore)
      return true, i
    end
  end
  return false, "upvalue non trovato: " .. nome
end

local function leggiUpvalue(f, nome)
  for i = 1, math.huge do
    local n, v = debug.getupvalue(f, i)
    if n == nil then break end
    if n == nome then return v, i end
  end
  return nil, "upvalue non trovato: " .. nome
end

local function creaContatore(iniziale, passo, etichetta)
  local valore = iniziale
  local incrementi = 0
  return function()
    incrementi = incrementi + 1
    valore = valore + passo
    return etichetta .. "=" .. valore
      .. " (" .. incrementi .. " incrementi)"
  end
end

local c = creaContatore(0, 5, "contatore")

print("stato iniziale:")
for _, u in ipairs(elencaUpvalue(c)) do
  print(string.format("  %d. %-12s %-8s %s",
    u.indice, u.nome, u.tipo, tostring(u.valore)))
end

print()
print(c())
print(c())

print()
print("dopo due chiamate:")
for _, u in ipairs(elencaUpvalue(c)) do
  print(string.format("  %d. %-12s %s",
    u.indice, u.nome, tostring(u.valore)))
end

print()
print("modifica per nome:")
print("  " .. tostring(impostaUpvalue(c, "passo", 100)))
print("  " .. tostring(impostaUpvalue(c, "etichetta",
  "MODIFICATO")))
print("  " .. tostring(impostaUpvalue(c, "inesistente",
  1)))

print()
print(c())
print("valore letto per nome: "
  .. tostring(leggiUpvalue(c, "valore")))

print()
print("condivisione fra due closure:")
local function creaCoppia()
  local condiviso = 0
  return function() condiviso = condiviso + 1
    return condiviso end,
    function() return condiviso end
end

local incrementa, leggi = creaCoppia()
incrementa()
incrementa()
print("  leggi(): " .. leggi())
impostaUpvalue(incrementa, "condiviso", 100)
print("  dopo aver modificato l'upvalue di incrementa,")
print("  leggi() vede: " .. leggi())
print("  perche' e' lo STESSO upvalue")
