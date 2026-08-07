-- ES 34.2 — Sottoattività
-- Manuale completo di Lua

function M.elencoAlbero(attivita, figlie, oggi)
  local perGenitore = {}
  local radici = {}
  local presenti = {}

  for _, a in ipairs(attivita) do presenti[a.id] = a end

  for _, a in ipairs(attivita) do
    if a.genitore and presenti[a.genitore] then
      local g = perGenitore[a.genitore]
      if g == nil then
        g = {}
        perGenitore[a.genitore] = g
      end
      g[#g + 1] = a
    else
      radici[#radici + 1] = a
    end
  end

  local righe = {}

  local function scendi(elenco, profondita)
    if profondita > 6 then return end
    for _, a in ipairs(elenco) do
      righe[#righe + 1] = string.rep("  ", profondita)
        .. M.riga(a, oggi)
      local sotto = perGenitore[a.id]
      if sotto then scendi(sotto, profondita + 1) end
    end
  end

  scendi(radici, 0)

  if #righe == 0 then
    return "Nessuna attivita' corrisponde ai criteri."
  end
  righe[#righe + 1] = ""
  righe[#righe + 1] = string.format("%d attivita'",
    #attivita)
  return table.concat(righe, "\n")
end
