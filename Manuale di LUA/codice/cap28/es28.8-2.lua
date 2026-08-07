-- ES 28.8 — Progetto con busted, luacheck e luacov
-- Manuale completo di Lua

local M = {}

function M.somma(a, b)
  return a + b
end

function M.media(elenco)
  if #elenco == 0 then return nil, "elenco vuoto" end
  local totale = 0
  for i = 1, #elenco do
    totale = totale + elenco[i]
  end
  return totale / #elenco
end

function M.calcolaSbagliata(x)
  -- ERRORE DI PROPOSITO: manca 'local'
  risultato = x * 2
  return risultato
end

function M.conVariabileInutile(x)
  local mai_usata = x * 100
  return x + 1
end

return M
