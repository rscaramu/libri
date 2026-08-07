-- ES 16.4 — Modulo di utilità per le stringhe
-- Manuale completo di Lua

local M = {}

local function eSpazio(c)
  return c == " " or c == "\t" or c == "\n"
    or c == "\r" or c == "\v" or c == "\f"
end

local function proteggi(s)
  return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
end

function M.dividi(s, separatore, massimo)
  if type(s) ~= "string" then
    return nil, "primo argomento non e' una stringa"
  end
  separatore = separatore or ","
  if separatore == "" then
    return nil, "separatore vuoto"
  end

  local pezzi = {}
  local pattern = proteggi(separatore)
  local posizione = 1

  while true do
    if massimo and #pezzi >= massimo - 1 then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    local inizio, fine = s:find(pattern, posizione)
    if inizio == nil then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    pezzi[#pezzi + 1] = s:sub(posizione, inizio - 1)
    posizione = fine + 1
  end

  return pezzi
end

function M.taglia(s, dove)
  if type(s) ~= "string" then
    return nil, "atteso una stringa"
  end
  dove = dove or "entrambi"
  local a, b = 1, #s
  if dove ~= "destra" then
    while a <= b and eSpazio(s:sub(a, a)) do
      a = a + 1
    end
  end
  if dove ~= "sinistra" then
    while b >= a and eSpazio(s:sub(b, b)) do
      b = b - 1
    end
  end
  return s:sub(a, b)
end

function M.iniziaCon(s, prefisso)
  if #prefisso > #s then return false end
  return s:sub(1, #prefisso) == prefisso
end

function M.finisceCon(s, suffisso)
  if #suffisso == 0 then return true end
  if #suffisso > #s then return false end
  return s:sub(-#suffisso) == suffisso
end

function M.capitalizza(s)
  if s == "" then return s end
  return s:sub(1, 1):upper() .. s:sub(2):lower()
end

function M.titolo(s)
  local pezzi = {}
  for parola in s:gmatch("%S+") do
    pezzi[#pezzi + 1] = M.capitalizza(parola)
  end
  return table.concat(pezzi, " ")
end

function M.riempi(s, larghezza, carattere, aSinistra)
  carattere = carattere or " "
  local mancanti = larghezza - #s
  if mancanti <= 0 then return s end
  local riempimento = carattere:rep(mancanti)
  if aSinistra then return riempimento .. s end
  return s .. riempimento
end

return M
