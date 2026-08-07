-- ES 30.8 — Strato di compatibilità per `<close>`, verificato
-- Manuale completo di Lua

local function costruisciStrato(forzaSimulato)
  local haClose = not forzaSimulato
    and load("local x <close> = nil") ~= nil

  local function chiudi(risorsa, errore)
    local m = getmetatable(risorsa)
    if m and type(m.__close) == "function" then
      return m.__close(risorsa, errore)
    end
    return risorsa:chiudi(errore)
  end

  if haClose then
    return load([[
      local chiudi = ...
      return function(costruttore, azione)
        local risorsa, errore = costruttore()
        if risorsa == nil then
          return nil, errore or "costruzione fallita"
        end
        local guardia <close> = risorsa
        return azione(risorsa)
      end
    ]])(chiudi), "nativa"
  end

  return function(costruttore, azione)
    local risorsa, errore = costruttore()
    if risorsa == nil then
      return nil, errore or "costruzione fallita"
    end
    local risultati = table.pack(pcall(azione, risorsa))

    -- ATTENZIONE: qui NON si puo' scrivere
    --   risultati[1] and nil or risultati[2]
    -- perche' con il ramo vero uguale a nil l'idioma
    -- restituisce sempre il ramo falso. E' la trappola
    -- del Capitolo 6.
    local motivo
    if not risultati[1] then motivo = risultati[2] end

    local okChiusura, erroreChiusura = pcall(chiudi,
      risorsa, motivo)
    if not risultati[1] then error(risultati[2], 0) end
    if not okChiusura then error(erroreChiusura, 0) end
    return table.unpack(risultati, 2, risultati.n)
  end, "simulata"
end

local function creaRisorsa(nome, registro)
  return setmetatable({nome = nome}, {
    __close = function(r, errore)
      registro[#registro + 1] = string.format(
        "chiusa %s (errore: %s)", r.nome,
        tostring(errore))
    end,
    __index = {
      usa = function(r) return "uso di " .. r.nome end,
    },
  })
end

local SCENARI = {
  {
    nome = "successo",
    azione = function(r) return r:usa() end,
    atteso = "uso di X",
  },
  {
    nome = "errore nell'azione",
    azione = function() error("guasto", 0) end,
    atteso = nil,
  },
  {
    nome = "valori multipli",
    azione = function(r) return 1, 2, 3 end,
    atteso = 1,
  },
  {
    nome = "nil come risultato",
    azione = function(r) return nil, "motivo" end,
    atteso = nil,
  },
}

for _, forzaSimulato in ipairs({false, true}) do
  local conRisorsa, quale =
    costruisciStrato(forzaSimulato)
  print("=== implementazione " .. quale .. " ===")

  for _, sc in ipairs(SCENARI) do
    local registro = {}
    local risultati = table.pack(pcall(conRisorsa,
      function() return creaRisorsa("X", registro) end,
      sc.azione))

    local esito
    if risultati[1] then
      esito = "ok: " .. tostring(risultati[2])
    else
      esito = "errore: " .. tostring(risultati[2])
    end

    print(string.format("  %-22s %-22s chiusure: %d",
      sc.nome, esito, #registro))
    for _, r in ipairs(registro) do
      print("      " .. r)
    end
  end
  print()
end
