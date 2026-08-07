-- ES 19.5 — Uniformità del generatore casuale
-- Manuale completo di Lua

local N = 1000000
local FACCE = 6

local function misura(nome, generatore)
  local conteggi = {}
  for i = 1, FACCE do conteggi[i] = 0 end

  math.randomseed(42)
  local inizio = os.clock()
  for _ = 1, N do
    local v = generatore()
    conteggi[v] = (conteggi[v] or 0) + 1
  end
  local durata = os.clock() - inizio

  local atteso = N / FACCE
  local chiQuadro = 0
  local massimoScarto = 0

  print("=== " .. nome .. " ===")
  for i = 1, FACCE do
    local scarto = conteggi[i] - atteso
    local percentuale = scarto / atteso * 100
    chiQuadro = chiQuadro + scarto * scarto / atteso
    if math.abs(percentuale) > massimoScarto then
      massimoScarto = math.abs(percentuale)
    end
    print(string.format("  %d: %8d  scarto %+7.0f "
      .. "(%+.3f%%)", i, conteggi[i], scarto,
      percentuale))
  end

  local fuoriIntervallo = 0
  for chiave in pairs(conteggi) do
    if chiave < 1 or chiave > FACCE then
      fuoriIntervallo = fuoriIntervallo + 1
    end
  end

  print(string.format("  chi quadro: %.3f "
    .. "(soglia 5%% con 5 gradi: 11.07)", chiQuadro))
  print(string.format("  scarto massimo: %.3f%%",
    massimoScarto))
  print(string.format("  valori fuori intervallo: %d",
    fuoriIntervallo))
  print(string.format("  tempo: %.3f s", durata))
  print()
end

misura("math.random(1, 6)", function()
  return math.random(1, FACCE)
end)

misura("floor(random() * 6) + 1", function()
  return math.floor(math.random() * FACCE) + 1
end)

misura("floor(random() * 6 + 1) SBAGLIATO", function()
  return math.floor(math.random() * FACCE + 1)
end)
