-- ES 5.5 — Importo all’italiana
-- Manuale completo di Lua

local function formattaEuro(centesimi)
  if math.type(centesimi) ~= "integer" then
    return nil, "servono centesimi come intero"
  end

  local negativo = centesimi < 0
  local assoluto = math.abs(centesimi)

  local euro = assoluto // 100
  local resto = assoluto % 100

  -- Separatore delle migliaia, dal fondo
  local cifre = tostring(euro)
  local gruppi = {}
  local fine = #cifre

  while fine > 3 do
    table.insert(gruppi, 1, cifre:sub(fine - 2, fine))
    fine = fine - 3
  end
  table.insert(gruppi, 1, cifre:sub(1, fine))

  local intero = table.concat(gruppi, ".")

  local risultato = string.format("%s,%02d", intero, resto)
  if negativo then risultato = "-" .. risultato end

  return risultato .. " EUR"
end

local prove = {0, 1, 99, 100, 150, 1000, 99999,
               100000000, -250, -1, 123456789}

for _, c in ipairs(prove) do
  print(string.format("%12d  %s", c, formattaEuro(c)))
end
