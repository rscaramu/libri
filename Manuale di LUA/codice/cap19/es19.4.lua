-- ES 19.4 — Numero di settimana ISO 8601
-- Manuale completo di Lua

local function aTempo(anno, mese, giorno)
  return os.time({year = anno, month = mese,
    day = giorno, hour = 12})
end

local function giornoSettimanaIso(t)
  -- os.date restituisce 1 per domenica; ISO vuole
  -- 1 per lunedi' e 7 per domenica
  local w = tonumber(os.date("%w", t))
  if w == 0 then return 7 end
  return w
end

local function settimanaIso(anno, mese, giorno)
  local t = aTempo(anno, mese, giorno)
  local giornoIso = giornoSettimanaIso(t)

  -- Il giovedi' della stessa settimana determina
  -- l'anno ISO
  local giovedi = t + (4 - giornoIso) * 86400
  local annoIso = tonumber(os.date("%Y", giovedi))

  -- Il 4 gennaio appartiene sempre alla settimana 1
  local quattro = aTempo(annoIso, 1, 4)
  local giornoIsoQuattro = giornoSettimanaIso(quattro)
  local lunediSettimana1 =
    quattro - (giornoIsoQuattro - 1) * 86400

  local lunediCorrente = t - (giornoIso - 1) * 86400
  local settimane = math.floor(
    (lunediCorrente - lunediSettimana1) / (7 * 86400))

  return settimane + 1, annoIso, giornoIso
end

local casi = {
  {2026, 1, 1},   {2026, 1, 4},   {2026, 1, 5},
  {2026, 8, 7},   {2026, 12, 31},
  {2025, 12, 29}, {2025, 1, 1},
  {2024, 12, 30}, {2027, 1, 3},
  {2021, 1, 1},   {2020, 12, 31},
}

for _, c in ipairs(casi) do
  local settimana, annoIso, giorno =
    settimanaIso(c[1], c[2], c[3])
  print(string.format("%04d-%02d-%02d -> %04d-W%02d-%d",
    c[1], c[2], c[3], annoIso, settimana, giorno))
end
