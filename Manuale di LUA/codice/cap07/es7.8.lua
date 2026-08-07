-- ES 7.8 — Tre modi di saltare elementi
-- Manuale completo di Lua

local N = 1000000

local function conInversione()
  local somma = 0
  for i = 1, N do
    if i % 3 ~= 0 then
      somma = somma + i
    end
  end
  return somma
end

local function conGoto()
  local somma = 0
  for i = 1, N do
    if i % 3 == 0 then goto continua end
    somma = somma + i
    ::continua::
  end
  return somma
end

local function elabora(i, accumulatore)
  if i % 3 == 0 then return accumulatore end
  return accumulatore + i
end

local function conFunzione()
  local somma = 0
  for i = 1, N do
    somma = elabora(i, somma)
  end
  return somma
end

local prove = {
  {"condizione invertita", conInversione},
  {"goto", conGoto},
  {"funzione estratta", conFunzione},
}

local riferimento = nil
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or r
  print(string.format("%-24s %.4f s  %s", p[1], durata,
    r == riferimento and "ok" or "RISULTATO DIVERSO"))
end
