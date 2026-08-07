-- ES 34.4 — Esportazione JSON
-- Manuale completo di Lua

-- src/json.lua
local M = {}

local FUGHE = {
  ['"'] = '\\"', ["\\"] = "\\\\", ["\b"] = "\\b",
  ["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r",
  ["\t"] = "\\t",
}

local function stringa(s)
  local fuggito = s:gsub('[%c"\\]', function(c)
    local f = FUGHE[c]
    if f then return f end
    return string.format("\\u%04X", c:byte())
  end)
  return '"' .. fuggito .. '"'
end

local function numero(n)
  if n ~= n then return "null" end
  if n == math.huge or n == -math.huge then
    return "null"
  end
  if math.type(n) == "integer" then
    return string.format("%d", n)
  end
  -- %.17g garantisce la rilettura senza perdita
  local s = string.format("%.14g", n)
  if tonumber(s) ~= n then
    s = string.format("%.17g", n)
  end
  return s
end

local function eSequenza(t)
  local n = #t
  local quante = 0
  for k in pairs(t) do
    if math.type(k) ~= "integer" or k < 1 or k > n then
      return false
    end
    quante = quante + 1
  end
  return quante == n, n
end

local function codifica(v, indentazione, livello, viste)
  livello = livello or 0
  viste = viste or {}

  local t = type(v)

  if v == nil then return "null" end
  if t == "boolean" then return tostring(v) end
  if t == "number" then return numero(v) end
  if t == "string" then return stringa(v) end
  if t ~= "table" then
    return nil, "tipo non serializzabile: " .. t
  end

  if viste[v] then
    return nil, "riferimento circolare"
  end
  viste[v] = true

  local aCapo, dentro, fuori = "", "", ""
  if indentazione then
    aCapo = "\n"
    dentro = string.rep(indentazione, livello + 1)
    fuori = string.rep(indentazione, livello)
  end
  local dopoDuePunti = indentazione and " " or ""

  local sequenza, n = eSequenza(v)
  local pezzi = {}

  if sequenza then
    if n == 0 then
      viste[v] = nil
      return "[]"
    end
    for i = 1, n do
      local s, e = codifica(v[i], indentazione,
        livello + 1, viste)
      if s == nil then return nil, e end
      pezzi[i] = dentro .. s
    end
    viste[v] = nil
    return "[" .. aCapo .. table.concat(pezzi,
      "," .. aCapo) .. aCapo .. fuori .. "]"
  end

  local chiavi = {}
  for k in pairs(v) do
    if type(k) ~= "string" and type(k) ~= "number" then
      return nil, "chiave non serializzabile: "
        .. type(k)
    end
    chiavi[#chiavi + 1] = k
  end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  if #chiavi == 0 then
    viste[v] = nil
    return "{}"
  end

  for i, k in ipairs(chiavi) do
    local s, e = codifica(v[k], indentazione,
      livello + 1, viste)
    if s == nil then return nil, e end
    pezzi[i] = dentro .. stringa(tostring(k)) .. ":"
      .. dopoDuePunti .. s
  end

  viste[v] = nil
  return "{" .. aCapo .. table.concat(pezzi,
    "," .. aCapo) .. aCapo .. fuori .. "}"
end

function M.codifica(v, opzioni)
  opzioni = opzioni or {}
  local indentazione = nil
  if opzioni.leggibile then
    indentazione = opzioni.indentazione or "  "
  end
  return codifica(v, indentazione, 0, {})
end

return M
