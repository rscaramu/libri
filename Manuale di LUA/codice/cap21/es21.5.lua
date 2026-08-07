-- ES 21.5 — Acquisizione e rilascio di più risorse
-- Manuale completo di Lua

local function conRisorse(specifiche, azione)
  local acquisite = {}
  local eventi = {}

  local function rilasciaTutte()
    for i = #acquisite, 1, -1 do
      local voce = acquisite[i]
      local ok, err = pcall(voce.rilascia, voce.valore)
      eventi[#eventi + 1] = string.format(
        "rilascio %s: %s", voce.nome,
        ok and "ok" or ("ERRORE " .. tostring(err)))
      acquisite[i] = nil
    end
  end

  for _, spec in ipairs(specifiche) do
    local ok, valore = pcall(spec.acquisisci)
    if not ok then
      eventi[#eventi + 1] = "acquisizione " .. spec.nome
        .. " FALLITA: " .. tostring(valore)
      rilasciaTutte()
      return nil, "acquisizione fallita: " .. spec.nome,
        eventi
    end
    eventi[#eventi + 1] = "acquisito " .. spec.nome
    acquisite[#acquisite + 1] = {
      nome = spec.nome,
      valore = valore,
      rilascia = spec.rilascia,
    }
  end

  local valori = {}
  for i, v in ipairs(acquisite) do
    valori[i] = v.valore
  end

  local risultati = table.pack(
    pcall(azione, table.unpack(valori, 1, #valori)))
  rilasciaTutte()

  if not risultati[1] then
    return nil, risultati[2], eventi
  end
  return table.unpack(risultati, 2, risultati.n)
end

local function spec(nome, fallisce)
  return {
    nome = nome,
    acquisisci = function()
      if fallisce then
        error("guasto nell'acquisizione di " .. nome, 0)
      end
      return "risorsa-" .. nome
    end,
    rilascia = function(v)
      -- niente da fare, il rilascio e' registrato
      -- dal chiamante
    end,
  }
end

print("=== tutto riesce ===")
local r, e, eventi = conRisorse(
  {spec("A"), spec("B"), spec("C")},
  function(a, b, c)
    return a .. "+" .. b .. "+" .. c
  end)
print("risultato: " .. tostring(r))
for _, ev in ipairs(eventi or {}) do print("  " .. ev) end

print()
print("=== la terza acquisizione fallisce ===")
local r2, e2, eventi2 = conRisorse(
  {spec("A"), spec("B"), spec("C", true), spec("D")},
  function() return "mai eseguita" end)
print("risultato: " .. tostring(r2) .. "  " .. tostring(e2))
for _, ev in ipairs(eventi2 or {}) do print("  " .. ev) end

print()
print("=== l'azione fallisce ===")
local r3, e3, eventi3 = conRisorse(
  {spec("A"), spec("B")},
  function() error("guasto nell'azione", 0) end)
print("risultato: " .. tostring(r3) .. "  " .. tostring(e3))
for _, ev in ipairs(eventi3 or {}) do print("  " .. ev) end
