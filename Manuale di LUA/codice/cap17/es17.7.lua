-- ES 17.7 — Date in formati diversi
-- Manuale completo di Lua

local FORMATI = {
  {nome = "AAAA-MM-GG",
   pattern = "^(%d%d%d%d)([%-/%.])(%d%d?)%2(%d%d?)$",
   ordine = "amg"},
  {nome = "GG-MM-AAAA",
   pattern = "^(%d%d?)([%-/%.])(%d%d?)%2(%d%d%d%d)$",
   ordine = "gma"},
}

local GIORNI_MESE = {31, 28, 31, 30, 31, 30,
                     31, 31, 30, 31, 30, 31}

local function bisestile(anno)
  return (anno % 4 == 0 and anno % 100 ~= 0)
    or anno % 400 == 0
end

local function valida(g, m, a)
  if m < 1 or m > 12 then
    return false, "mese fuori intervallo"
  end
  local massimo = GIORNI_MESE[m]
  if m == 2 and bisestile(a) then massimo = 29 end
  if g < 1 or g > massimo then
    return false, "giorno fuori intervallo"
  end
  return true
end

local function analizza(testo)
  if type(testo) ~= "string" then
    return nil, "atteso una stringa"
  end
  testo = testo:match("^%s*(.-)%s*$")

  for _, f in ipairs(FORMATI) do
    local x, _, y, z = testo:match(f.pattern)
    if x then
      local g, m, a
      if f.ordine == "amg" then
        a, m, g = tonumber(x), tonumber(y), tonumber(z)
      else
        g, m, a = tonumber(x), tonumber(y), tonumber(z)
      end

      local ok, motivo = valida(g, m, a)
      if not ok then return nil, motivo end

      local ambigua = false
      if f.ordine == "gma" and g <= 12 and m <= 12
         and g ~= m then
        ambigua = true
      end

      return {
        giorno = g, mese = m, anno = a,
        formato = f.nome,
        ambigua = ambigua,
        iso = string.format("%04d-%02d-%02d", a, m, g),
      }
    end
  end

  return nil, "formato non riconosciuto"
end

local casi = {
  "2026-08-07", "2026/08/07", "2026.08.07",
  "07-08-2026", "07/08/2026", "7/8/2026",
  "29-02-2024", "29-02-2026",
  "31-04-2026", "13/13/2026",
  "2026-08-07 ", "07-08/2026", "ciao",
}

for _, c in ipairs(casi) do
  local r, errore = analizza(c)
  if r then
    print(string.format("%-14s -> %s  [%s]%s",
      c, r.iso, r.formato,
      r.ambigua and "  AMBIGUA" or ""))
  else
    print(string.format("%-14s -> %s", c, errore))
  end
end
