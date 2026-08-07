-- ES 10.4 — Riconoscere una sequenza
-- Manuale completo di Lua

local function eSequenza(t)
  if type(t) ~= "table" then return false end

  local massimo = 0
  local quante = 0

  for k in pairs(t) do
    if math.type(k) ~= "integer" then
      return false
    end
    if k < 1 then return false end
    if k > massimo then massimo = k end
    quante = quante + 1
  end

  return massimo == quante, quante
end

local prove = {
  {{}, true, "vuota"},
  {{1, 2, 3}, true, "sequenza normale"},
  {{"a", nil, "c"}, false, "con buco"},
  {{a = 1}, false, "chiave stringa"},
  {{[1] = "x", [3] = "y"}, false, "indici non contigui"},
  {{[0] = "zero", "uno"}, false, "indice zero"},
  {{[1.5] = "x"}, false, "chiave float"},
  {{[2.0] = "x", [1] = "y"}, true, "float intero"},
  {{1, 2, nome = "x"}, false, "mista"},
  {{[-1] = "x"}, false, "indice negativo"},
}

for _, p in ipairs(prove) do
  local r = eSequenza(p[1])
  print(string.format("%-22s atteso=%-5s ottenuto=%-5s %s",
    p[3], tostring(p[2]), tostring(r),
    r == p[2] and "ok" or "ERRORE"))
end
