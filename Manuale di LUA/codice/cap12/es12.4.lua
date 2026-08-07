-- ES 12.4 — Il multinsieme
-- Manuale completo di Lua

local M = {}

function M.nuovo(da)
  local m = {}
  if da then
    for _, v in ipairs(da) do
      m[v] = (m[v] or 0) + 1
    end
  end
  return m
end

function M.aggiungi(m, v, quante)
  quante = quante or 1
  if quante <= 0 then return m end
  m[v] = (m[v] or 0) + quante
  return m
end

function M.rimuovi(m, v, quante)
  quante = quante or 1
  local attuale = m[v]
  if attuale == nil then return m end
  if attuale <= quante then
    m[v] = nil
  else
    m[v] = attuale - quante
  end
  return m
end

function M.conta(m, v)
  return m[v] or 0
end

function M.cardinalita(m)
  local totale, distinti = 0, 0
  for _, n in pairs(m) do
    totale = totale + n
    distinti = distinti + 1
  end
  return totale, distinti
end

function M.unione(a, b)
  local r = {}
  for v, n in pairs(a) do r[v] = n end
  for v, n in pairs(b) do
    r[v] = math.max(r[v] or 0, n)
  end
  return r
end

function M.somma(a, b)
  local r = {}
  for v, n in pairs(a) do r[v] = n end
  for v, n in pairs(b) do r[v] = (r[v] or 0) + n end
  return r
end

function M.intersezione(a, b)
  local r = {}
  for v, n in pairs(a) do
    local m = b[v]
    if m then r[v] = math.min(n, m) end
  end
  return r
end

function M.testo(m)
  local chiavi = {}
  for v in pairs(m) do chiavi[#chiavi + 1] = v end
  table.sort(chiavi, function(x, y)
    return tostring(x) < tostring(y)
  end)
  local pezzi = {}
  for _, v in ipairs(chiavi) do
    pezzi[#pezzi + 1] = tostring(v) .. "x" .. m[v]
  end
  return "{" .. table.concat(pezzi, " ") .. "}"
end

local a = M.nuovo({"a", "b", "a", "c", "a"})
local b = M.nuovo({"a", "b", "b", "d"})

print("a        = " .. M.testo(a))
print("b        = " .. M.testo(b))
print("unione   = " .. M.testo(M.unione(a, b)))
print("somma    = " .. M.testo(M.somma(a, b)))
print("interse. = " .. M.testo(M.intersezione(a, b)))

M.aggiungi(a, "z", 3)
M.rimuovi(a, "a", 2)
print("dopo mod = " .. M.testo(a))
print("conta a  = " .. M.conta(a, "a"))
print("conta x  = " .. M.conta(a, "x"))

local totale, distinti = M.cardinalita(a)
print(string.format("cardinalita: %d totali, %d distinti",
  totale, distinti))
