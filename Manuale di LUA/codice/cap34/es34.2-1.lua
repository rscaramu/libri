-- ES 34.2 — Sottoattività
-- Manuale completo di Lua

-- in M.valida
if dati.genitore ~= nil then
  if math.type(dati.genitore) ~= "integer"
     or dati.genitore < 1 then
    errori[#errori + 1] =
      "genitore deve essere un id valido"
  elseif dati.id ~= nil and dati.genitore == dati.id then
    errori[#errori + 1] =
      "un'attivita' non puo' essere figlia di se stessa"
  end
end
