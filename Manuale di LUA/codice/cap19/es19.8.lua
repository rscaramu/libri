-- ES 19.8 — Validare UTF-8
-- Manuale completo di Lua

local function analizzaUtf8(s)
  if type(s) ~= "string" then
    return nil, "atteso una stringa"
  end

  local n, posizione = utf8.len(s)
  if n ~= nil then
    return true, n
  end

  local b = s:byte(posizione)
  local descrizione

  if b >= 0x80 and b <= 0xBF then
    descrizione = "byte di continuazione isolato"
  elseif b >= 0xC0 and b <= 0xC1 then
    descrizione = "sequenza sovralunga (C0 o C1)"
  elseif b >= 0xF5 then
    descrizione = "byte oltre l'intervallo valido"
  elseif b >= 0xC2 and b <= 0xDF then
    descrizione = "sequenza a 2 byte troncata o "
      .. "malformata"
  elseif b >= 0xE0 and b <= 0xEF then
    descrizione = "sequenza a 3 byte troncata o "
      .. "malformata"
  elseif b >= 0xF0 and b <= 0xF4 then
    descrizione = "sequenza a 4 byte troncata o "
      .. "malformata"
  else
    descrizione = "byte inatteso"
  end

  return false, posizione, string.format(
    "byte 0x%02X alla posizione %d: %s",
    b, posizione, descrizione)
end

local casi = {
  {"testo ASCII", "abc"},
  {"UTF-8 valido", "citt" .. utf8.char(0xE0)},
  {"stringa vuota", ""},
  {"continuazione isolata", "abc\x80def"},
  {"sequenza troncata", "abc\xC3"},
  {"tre byte troncata", "abc\xE2\x82"},
  {"sovralunga C0", "abc\xC0\x80"},
  {"oltre F4", "abc\xF8\x88\x80\x80"},
  {"quattro byte valida", utf8.char(0x1F600)},
}

for _, c in ipairs(casi) do
  local ok, a, b = analizzaUtf8(c[2])
  if ok then
    print(string.format("%-24s VALIDA, %d caratteri",
      c[1], a))
  else
    print(string.format("%-24s NON VALIDA: %s",
      c[1], b))
  end
end
