-- ES 34.1 — Il comando `rinvia`
-- Manuale completo di Lua

function Attivita:rinvia(giorni)
  if type(giorni) ~= "number"
     or giorni ~= math.floor(giorni) then
    return nil, "i giorni devono essere un intero"
  end
  if giorni == 0 then
    return nil, "rinvio nullo"
  end
  if not self:aperta() then
    return nil, "l'attivita' e' gia' chiusa"
  end

  local function aTempo(testo)
    local a, m, g = testo:match(
      "(%d%d%d%d)%-(%d%d)%-(%d%d)")
    return os.time({
      year = tonumber(a), month = tonumber(m),
      day = tonumber(g), hour = 12,
    })
  end

  local base
  if self.scadenza == nil then
    -- senza scadenza, si parte da oggi
    base = os.time({
      year = tonumber(os.date("%Y")),
      month = tonumber(os.date("%m")),
      day = tonumber(os.date("%d")),
      hour = 12,
    })
  else
    base = aTempo(self.scadenza)
  end

  local nuova = os.date("%Y-%m-%d",
    base + giorni * 86400)

  local precedente = self.scadenza
  self.scadenza = nuova
  return nuova, precedente
end
