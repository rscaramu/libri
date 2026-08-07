-- ES 34.2 — Sottoattività
-- Manuale completo di Lua

function Deposito:figlie(id)
  id = tonumber(id)
  local r = {}
  for _, a in ipairs(self.attivita) do
    if a.genitore == id then r[#r + 1] = a end
  end
  table.sort(r, function(x, y) return x.id < y.id end)
  return r
end

function Deposito:antenati(id)
  local r = {}
  local visti = {}
  local corrente = self:trova(id)
  while corrente and corrente.genitore do
    if visti[corrente.genitore] then
      return nil, "ciclo nella gerarchia"
    end
    visti[corrente.genitore] = true
    corrente = self:trova(corrente.genitore)
    if corrente then r[#r + 1] = corrente end
  end
  return r
end

function Deposito:impostaGenitore(id, genitore)
  local a, errore = self:trova(id)
  if a == nil then return nil, errore end

  if genitore == nil then
    a.genitore = nil
    self.modificato = true
    return a
  end

  local g, err2 = self:trova(genitore)
  if g == nil then return nil, err2 end

  -- verifica di aciclicita': il genitore proposto
  -- non deve essere un discendente
  local corrente = g
  local visti = {}
  while corrente do
    if corrente.id == a.id then
      return nil, "creerebbe un ciclo nella gerarchia"
    end
    if visti[corrente.id] then break end
    visti[corrente.id] = true
    corrente = corrente.genitore
      and self:trova(corrente.genitore) or nil
  end

  a.genitore = g.id
  self.modificato = true
  return a
end

function Deposito:puoChiudere(id)
  local aperte = {}
  for _, f in ipairs(self:figlie(id)) do
    if f:aperta() then
      aperte[#aperte + 1] = f.id
    end
  end
  if #aperte > 0 then
    return false, aperte
  end
  return true
end
