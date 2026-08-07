-- ES 6.8 — Quando `cond and a or b` fallisce
-- Manuale completo di Lua

-- Caso 1: il valore vero e' false
local function haPermesso(utente)
  -- SBAGLIATO: restituisce sempre true
  return utente.attivo and utente.permessoScrittura
    or true
end

local function haPermessoCorretto(utente)
  if utente.attivo then
    return utente.permessoScrittura
  end
  return true
end

local u = {attivo = true, permessoScrittura = false}
print("1 sbagliato:", haPermesso(u))
print("1 corretto: ", haPermessoCorretto(u))

-- Caso 2: il valore memorizzato e' false
local CONFIGURAZIONE = {
  timeout = 30,
  verbose = false,
}

local function leggi(chiave)
  -- SBAGLIATO: il valore false viene scartato
  return CONFIGURAZIONE[chiave] ~= nil
    and CONFIGURAZIONE[chiave] or "NON IMPOSTATO"
end

local function leggiCorretto(chiave)
  local v = CONFIGURAZIONE[chiave]
  if v == nil then return "NON IMPOSTATO" end
  return v
end

for _, k in ipairs({"timeout", "verbose", "proxy"}) do
  print(string.format("2 %-8s sbagliato=%-14s "
    .. "corretto=%s", k,
    tostring(leggi(k)), tostring(leggiCorretto(k))))
end

-- Caso 3: il valore vero e' il risultato di un
-- confronto che puo' essere false
local function segno(n)
  -- SBAGLIATO su n == 0
  return n ~= 0 and (n > 0) or "zero"
end

local function segnoCorretto(n)
  if n == 0 then return "zero" end
  return n > 0
end

for _, n in ipairs({5, -5, 0}) do
  print(string.format("3 n=%2d sbagliato=%-6s "
    .. "corretto=%s", n,
    tostring(segno(n)), tostring(segnoCorretto(n))))
end
