-- ES 29.6 — Un bug sottile e il test che lo intercetta
-- Manuale completo di Lua

-- VERSIONE CORRETTA
local function partizionaCorretta(sequenza, predicato)
  local si, no = {}, {}
  for i = 1, #sequenza do
    local v = sequenza[i]
    if predicato(v, i) then
      si[#si + 1] = v
    else
      no[#no + 1] = v
    end
  end
  return si, no
end

-- VERSIONE CON IL BUG: il ciclo parte da 2
local function partizionaConBug(sequenza, predicato)
  local si, no = {}, {}
  for i = 2, #sequenza do
    local v = sequenza[i]
    if predicato(v, i) then
      si[#si + 1] = v
    else
      no[#no + 1] = v
    end
  end
  return si, no
end

local function elencoUguale(a, b)
  if #a ~= #b then return false end
  for i = 1, #a do
    if a[i] ~= b[i] then return false end
  end
  return true
end

local CASI = {
  {nome = "caso normale", dati = {1, 2, 3, 4, 5, 6}},
  {nome = "sequenza vuota", dati = {}},
  {nome = "un solo elemento pari", dati = {2}},
  {nome = "un solo elemento dispari", dati = {1}},
  {nome = "primo elemento soddisfa", dati = {2, 1, 3}},
  {nome = "primo non soddisfa", dati = {1, 2, 4}},
  {nome = "tutti soddisfano", dati = {2, 4, 6}},
  {nome = "nessuno soddisfa", dati = {1, 3, 5}},
}

local pari = function(n) return n % 2 == 0 end

print(string.format("%-24s %-10s %-10s %s",
  "CASO", "CORRETTA", "CON BUG", "ESITO"))

local intercettato = 0

for _, c in ipairs(CASI) do
  local siA, noA = partizionaCorretta(c.dati, pari)
  local siB, noB = partizionaConBug(c.dati, pari)

  -- ATTENZIONE: verifichiamo SOLO la partizione "si",
  -- come farebbe un test scritto in fretta
  local ok = elencoUguale(siA, siB)
  if not ok then intercettato = intercettato + 1 end

  print(string.format("%-24s %-10s %-10s %s",
    c.nome,
    "[" .. table.concat(siA, ",") .. "]",
    "[" .. table.concat(siB, ",") .. "]",
    ok and "identici" or "DIFFERENZA"))
end

print()
print("casi che intercettano il bug: " .. intercettato
  .. " su " .. #CASI)
