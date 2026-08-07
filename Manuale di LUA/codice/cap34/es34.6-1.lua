-- ES 34.6 — Cronologia delle modifiche
-- Manuale completo di Lua

-- Nel modello: registrazione dentro aggiorna
function Attivita:aggiorna(modifiche, opzioni)
  opzioni = opzioni or {}

  local unione = {}
  for k, v in pairs(self) do unione[k] = v end
  for k, v in pairs(modifiche) do unione[k] = v end

  local ok, errore = M.valida(unione)
  if not ok then return nil, errore end

  local voci = {}
  local istante = opzioni.istante or os.time()

  for k, v in pairs(modifiche) do
    if k ~= "id" and k ~= "creata" and k ~= "storia" then
      local precedente = self[k]

      local diverso
      if type(precedente) == "table"
         or type(v) == "table" then
        diverso = table.concat(
          type(precedente) == "table" and precedente
            or {tostring(precedente)}, ",")
          ~= table.concat(
            type(v) == "table" and v
              or {tostring(v)}, ",")
      else
        diverso = precedente ~= v
      end

      if diverso then
        voci[#voci + 1] = {
          istante = istante,
          campo = k,
          prima = type(precedente) == "table"
            and table.concat(precedente, ",")
            or precedente,
          dopo = type(v) == "table"
            and table.concat(v, ",") or v,
        }
      end
    end
  end

  -- applicazione, come prima
  for k, v in pairs(modifiche) do
    if k == "etichette" then
      local e, err = normalizzaEtichette(v)
      if e == nil then return nil, err end
      self.etichette = e
    elseif k ~= "id" and k ~= "creata" then
      self[k] = v
    end
  end

  if modifiche.stato == "fatta"
     and self.chiusa == nil then
    self.chiusa = istante
  elseif modifiche.stato ~= nil
     and modifiche.stato ~= "fatta" then
    self.chiusa = nil
  end

  if #voci > 0 and not opzioni.senzaStoria then
    self.storia = self.storia or {}
    for _, v in ipairs(voci) do
      self.storia[#self.storia + 1] = v
    end
    -- limite: si conservano le ultime N voci
    local massimo = opzioni.massimoStoria or 50
    while #self.storia > massimo do
      table.remove(self.storia, 1)
    end
  end

  return self, voci
end
