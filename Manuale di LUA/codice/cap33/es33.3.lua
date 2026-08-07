-- ES 33.3 — Validazione dei parametri nel gateway
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

local M = {}

local function confrontabile(v, soglia)
  local tv, ts = type(v), type(soglia)
  return (tv == "number" and ts == "number")
      or (tv == "string" and ts == "string")
end

local CONVERSIONI = {
  numero = function(v)
    local n = tonumber(v)
    if n == nil then return nil, "non numerico" end
    return n
  end,
  intero = function(v)
    local n = tonumber(v)
    if n == nil then return nil, "non numerico" end
    if n ~= math.floor(n) then
      return nil, "non intero"
    end
    return math.tointeger(n) or n
  end,
  booleano = function(v)
    if v == "true" or v == "1" or v == "si" then
      return true
    end
    if v == "false" or v == "0" or v == "no" then
      return false
    end
    return nil, "non booleano"
  end,
  testo = function(v) return tostring(v) end,
}

function M.valida(parametri, schema)
  local puliti = {}
  local errori = {}

  for nome, regola in pairs(schema) do
    local grezzo = parametri[nome]

    -- I parametri di query multipli arrivano come
    -- tabella: prendiamo l'ultimo, come fanno i
    -- server web piu' diffusi.
    if type(grezzo) == "table" then
      grezzo = grezzo[#grezzo]
    end

    if grezzo == nil or grezzo == "" then
      if regola.obbligatorio then
        errori[#errori + 1] = {campo = nome,
          motivo = "parametro obbligatorio mancante"}
      elseif regola.predefinito ~= nil then
        puliti[nome] = regola.predefinito
      end

    else
      local converti = CONVERSIONI[regola.tipo or "testo"]
      if converti == nil then
        errori[#errori + 1] = {campo = nome,
          motivo = "tipo di schema sconosciuto: "
            .. tostring(regola.tipo)}
      else
        local valore, motivo = converti(grezzo)
        if valore == nil then
          errori[#errori + 1] = {campo = nome,
            motivo = motivo, ricevuto = grezzo}
        else
          local ok = true

          if regola.minimo ~= nil then
            if not confrontabile(valore,
                regola.minimo) then
              errori[#errori + 1] = {campo = nome,
                motivo = "non confrontabile con il "
                  .. "minimo"}
              ok = false
            elseif valore < regola.minimo then
              errori[#errori + 1] = {campo = nome,
                motivo = "minore del minimo "
                  .. tostring(regola.minimo),
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.massimo ~= nil then
            if not confrontabile(valore,
                regola.massimo) then
              errori[#errori + 1] = {campo = nome,
                motivo = "non confrontabile con il "
                  .. "massimo"}
              ok = false
            elseif valore > regola.massimo then
              errori[#errori + 1] = {campo = nome,
                motivo = "maggiore del massimo "
                  .. tostring(regola.massimo),
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.ammessi then
            local trovato = false
            for _, a in ipairs(regola.ammessi) do
              if valore == a then trovato = true break end
            end
            if not trovato then
              errori[#errori + 1] = {campo = nome,
                motivo = "valore non ammesso",
                ricevuto = tostring(valore)}
              ok = false
            end
          end

          if ok and regola.pattern
             and type(valore) == "string" then
            if not valore:match(regola.pattern) then
              errori[#errori + 1] = {campo = nome,
                motivo = "formato non valido"}
              ok = false
            end
          end

          if ok then puliti[nome] = valore end
        end
      end
    end
  end

  for nome in pairs(parametri) do
    if schema[nome] == nil then
      errori[#errori + 1] = {campo = nome,
        motivo = "parametro non previsto"}
    end
  end

  table.sort(errori, function(a, b)
    if a.campo ~= b.campo then
      return a.campo < b.campo
    end
    return a.motivo < b.motivo
  end)

  if #errori > 0 then return nil, errori end
  return puliti
end

-- Uso nel gestore OpenResty
local SCHEMA = {
  n = {tipo = "intero", obbligatorio = true,
       minimo = 1, massimo = 1000},
  formato = {tipo = "testo", predefinito = "json",
             ammessi = {"json", "csv", "testo"}},
  dettaglio = {tipo = "booleano",
               predefinito = false},
  etichetta = {tipo = "testo",
               pattern = "^[%w%-_]+$"},
}

function M.gestisci(parametri, rispondi)
  local puliti, errori = M.valida(parametri, SCHEMA)

  if puliti == nil then
    return rispondi(400, {
      errore = "parametri non validi",
      dettagli = errori,
    })
  end

  local somma = 0
  for i = 1, puliti.n do somma = somma + i end

  return rispondi(200, {
    n = puliti.n,
    somma = somma,
    formato = puliti.formato,
    dettaglio = puliti.dettaglio,
  })
end

-- Prova fuori da nginx
local function rispondiFinta(stato, corpo)
  local pezzi = {}
  local chiavi = {}
  for k in pairs(corpo) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  for _, k in ipairs(chiavi) do
    local v = corpo[k]
    if type(v) == "table" then
      local sotto = {}
      for _, e in ipairs(v) do
        sotto[#sotto + 1] = e.campo .. "="
          .. e.motivo
      end
      pezzi[#pezzi + 1] = k .. ":["
        .. table.concat(sotto, "; ") .. "]"
    else
      pezzi[#pezzi + 1] = k .. "=" .. tostring(v)
    end
  end
  return stato, table.concat(pezzi, " ")
end

local CASI = {
  {nome = "tutto valido",
   p = {n = "10", formato = "csv"}},
  {nome = "solo obbligatorio", p = {n = "5"}},
  {nome = "n mancante", p = {formato = "json"}},
  {nome = "n non numerico", p = {n = "molti"}},
  {nome = "n non intero", p = {n = "3.5"}},
  {nome = "n fuori intervallo", p = {n = "5000"}},
  {nome = "formato non ammesso",
   p = {n = "1", formato = "xml"}},
  {nome = "etichetta con spazi",
   p = {n = "1", etichetta = "con spazio"}},
  {nome = "parametro ignoto",
   p = {n = "1", sconosciuto = "x"}},
  {nome = "errori multipli",
   p = {n = "abc", formato = "xml", extra = "1"}},
  {nome = "valore multiplo",
   p = {n = {"1", "7"}}},
}

for _, c in ipairs(CASI) do
  local stato, testo = M.gestisci(c.p, rispondiFinta)
  print(string.format("%-22s %d  %s", c.nome, stato,
    testo))
end

return M
