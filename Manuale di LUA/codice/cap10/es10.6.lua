-- ES 10.6 — Unione con strategia di conflitto
-- Manuale completo di Lua

local STRATEGIE = {}

STRATEGIE.prima = function(a, b) return a end
STRATEGIE.seconda = function(a, b) return b end

STRATEGIE.unisci = function(a, b, ricorsiva)
  if type(a) == "table" and type(b) == "table" then
    return ricorsiva(a, b)
  end
  return b
end

STRATEGIE.errore = function(a, b, _, chiave)
  error("conflitto sulla chiave " .. tostring(chiave), 0)
end

local function unione(a, b, strategia)
  strategia = strategia or "seconda"
  local risolvi = STRATEGIE[strategia]
  if risolvi == nil then
    local nomi = {}
    for k in pairs(STRATEGIE) do nomi[#nomi + 1] = k end
    table.sort(nomi)
    return nil, "strategia sconosciuta: " .. strategia
      .. " (disponibili: " .. table.concat(nomi, ", ")
      .. ")"
  end

  local function fondi(x, y)
    local r = {}
    for k, v in pairs(x) do r[k] = v end
    for k, v in pairs(y) do
      if r[k] == nil then
        r[k] = v
      else
        r[k] = risolvi(r[k], v, fondi, k)
      end
    end
    return r
  end

  local ok, risultato = pcall(fondi, a, b)
  if not ok then return nil, risultato end
  return risultato
end

local function mostra(etichetta, t)
  if t == nil then
    print(etichetta .. ": errore")
    return
  end
  local chiavi = {}
  for k in pairs(t) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  local pezzi = {}
  for _, k in ipairs(chiavi) do
    local v = t[k]
    if type(v) == "table" then
      local sotto = {}
      local sk = {}
      for kk in pairs(v) do sk[#sk + 1] = kk end
      table.sort(sk)
      for _, kk in ipairs(sk) do
        sotto[#sotto + 1] = kk .. "=" .. tostring(v[kk])
      end
      pezzi[#pezzi + 1] = k .. "={"
        .. table.concat(sotto, ",") .. "}"
    else
      pezzi[#pezzi + 1] = k .. "=" .. tostring(v)
    end
  end
  print(etichetta .. ": " .. table.concat(pezzi, " "))
end

local A = {x = 1, y = 2, dentro = {p = 1, q = 2}}
local B = {y = 99, z = 3, dentro = {q = 88, r = 3}}

mostra("prima  ", unione(A, B, "prima"))
mostra("seconda", unione(A, B, "seconda"))
mostra("unisci ", unione(A, B, "unisci"))

local r, e = unione(A, B, "errore")
print("errore : " .. tostring(e))

print(unione(A, B, "inesistente"))
