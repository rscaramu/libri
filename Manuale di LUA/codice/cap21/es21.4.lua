-- ES 21.4 — Validatore robusto sui confronti
-- Manuale completo di Lua

local function confrontabile(valore, soglia)
  local tv, ts = type(valore), type(soglia)
  if tv == "number" and ts == "number" then
    return true
  end
  if tv == "string" and ts == "string" then
    return true
  end
  return false
end

local function valida(dato, schema, percorso, errori)
  percorso = percorso or ""
  errori = errori or {}

  local function segnala(campo, messaggio)
    local completo = percorso
    if campo then
      completo = completo == "" and campo
        or (completo .. "." .. campo)
    end
    if completo == "" then completo = "(radice)" end
    errori[#errori + 1] = completo .. ": " .. messaggio
  end

  if type(dato) ~= "table" then
    segnala(nil, "atteso table, ricevuto " .. type(dato))
    return errori
  end

  for campo, regola in pairs(schema) do
    local valore = dato[campo]
    local sotto = percorso == "" and campo
      or (percorso .. "." .. campo)

    if valore == nil then
      if regola.obbligatorio then
        segnala(campo, "campo obbligatorio mancante")
      end

    elseif regola.tipo == "table" and regola.campi then
      valida(valore, regola.campi, sotto, errori)

    elseif regola.tipo and type(valore) ~= regola.tipo then
      segnala(campo, string.format(
        "atteso %s, ricevuto %s",
        regola.tipo, type(valore)))

    else
      if regola.minimo ~= nil then
        if not confrontabile(valore, regola.minimo) then
          segnala(campo, string.format(
            "non confrontabile con il minimo: %s "
            .. "contro %s", type(valore),
            type(regola.minimo)))
        elseif valore < regola.minimo then
          segnala(campo, string.format(
            "valore %s minore del minimo %s",
            tostring(valore), tostring(regola.minimo)))
        end
      end

      if regola.massimo ~= nil then
        if not confrontabile(valore, regola.massimo) then
          segnala(campo, string.format(
            "non confrontabile con il massimo: %s "
            .. "contro %s", type(valore),
            type(regola.massimo)))
        elseif valore > regola.massimo then
          segnala(campo, string.format(
            "valore %s maggiore del massimo %s",
            tostring(valore), tostring(regola.massimo)))
        end
      end

      if regola.ammessi then
        local trovato = false
        for _, a in ipairs(regola.ammessi) do
          if valore == a then trovato = true break end
        end
        if not trovato then
          segnala(campo, "valore non ammesso: "
            .. tostring(valore))
        end
      end
    end
  end

  for campo in pairs(dato) do
    if schema[campo] == nil then
      segnala(campo, "campo non previsto")
    end
  end

  table.sort(errori)
  return errori
end

local SCHEMA = {
  -- tipo NON dichiarato: e' il caso dell'esercizio
  quantita = {minimo = 1, massimo = 100},
  nome = {tipo = "string", obbligatorio = true},
}

local casi = {
  {nome = "ok", quantita = 50},
  {nome = "stringa", quantita = "molte"},
  {nome = "tabella", quantita = {}},
  {nome = "booleano", quantita = true},
  {nome = "fuori", quantita = 500},
}

for _, dato in ipairs(casi) do
  local errori = valida(dato, SCHEMA)
  print(string.format("%-10s -> %s", dato.nome,
    #errori == 0 and "ok"
      or table.concat(errori, "; ")))
end
