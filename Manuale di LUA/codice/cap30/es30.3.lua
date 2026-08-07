-- ES 30.3 — Migrazione di un programma da 5.1 a 5.4
-- Manuale completo di Lua

local M = {}

function M.areaCerchio(r)
  -- math.pow rimossa in 5.3: si usa l'operatore ^
  return math.pi * r ^ 2
end

function M.normalizza(v)
  -- table.maxn rimossa in 5.2. La sostituzione NON e'
  -- banale: maxn restituiva il massimo indice
  -- numerico, anche con buchi, mentre # restituisce
  -- un bordo qualunque.
  local massimo = 0
  for k in pairs(v) do
    if type(k) == "number" and k > massimo then
      massimo = k
    end
  end

  local somma = 0
  for i = 1, massimo do
    somma = somma + (v[i] or 0)
  end
  if somma == 0 then
    return nil, "somma nulla"
  end

  local r = {}
  for i = 1, massimo do
    r[i] = (v[i] or 0) / somma
  end
  return table.unpack(r, 1, massimo)
end

function M.conAmbiente(codice, dati)
  -- loadstring rimossa in 5.2: load accetta stringhe.
  -- setfenv rimossa: l'ambiente si passa a load.
  local f, errore = load(codice, "codice", "t", dati)
  if f == nil then return nil, errore end
  return f()
end

function M.impacchetta(...)
  -- table.pack fa esattamente questo dalla 5.2
  return table.pack(...)
end

return M
