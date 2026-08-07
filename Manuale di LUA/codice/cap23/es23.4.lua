-- ES 23.4 — Incrementale contro generazionale
-- Manuale completo di Lua

local function misura(nome, modalita, carico)
  collectgarbage(modalita)
  collectgarbage("collect")
  collectgarbage("collect")

  local memPrima = collectgarbage("count")
  local inizio = os.clock()
  local pausaMassima = 0

  local risultato = carico(function()
    local t = os.clock()
    collectgarbage("step")
    local d = os.clock() - t
    if d > pausaMassima then pausaMassima = d end
  end)

  local durata = os.clock() - inizio
  local memDopo = collectgarbage("count")

  print(string.format(
    "  %-14s %.4f s  memoria finale %7.0f KB",
    modalita, durata, memDopo - memPrima))
  return risultato
end

-- Carico 1: molti oggetti di breve durata
local function caricoEffimero()
  return function()
    local somma = 0
    for i = 1, 300000 do
      local t = {a = i, b = i * 2, c = tostring(i)}
      somma = somma + t.a
    end
    return somma
  end
end

-- Carico 2: struttura grande e stabile
local function caricoStabile()
  return function()
    local vivi = {}
    for i = 1, 100000 do
      vivi[i] = {indice = i, dati = {i, i + 1}}
    end
    local somma = 0
    for _ = 1, 20 do
      for i = 1, 100000 do
        somma = somma + vivi[i].indice
      end
    end
    return somma, vivi
  end
end

print("=== carico effimero (oggetti di breve durata) ===")
misura("effimero", "incremental", caricoEffimero())
misura("effimero", "generational", caricoEffimero())

print()
print("=== carico stabile (struttura viva e grande) ===")
misura("stabile", "incremental", caricoStabile())
misura("stabile", "generational", caricoStabile())

collectgarbage("incremental")
