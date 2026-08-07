-- ES 17.4 — Validazione ancorata di un indirizzo
-- Manuale completo di Lua

local function valida(indirizzo)
  if type(indirizzo) ~= "string" then
    return false, "non e' una stringa"
  end
  if #indirizzo > 254 then
    return false, "troppo lungo"
  end

  local locale, dominio =
    indirizzo:match("^([^@]+)@([^@]+)$")
  if locale == nil then
    return false, "serve esattamente una chiocciola"
  end

  if #locale > 64 then
    return false, "parte locale troppo lunga"
  end
  if not locale:match("^[%w%.%-_%+]+$") then
    return false, "caratteri non ammessi prima della @"
  end
  if locale:match("^%.") or locale:match("%.$")
     or locale:match("%.%.") then
    return false, "punti mal posizionati nella parte "
      .. "locale"
  end

  if not dominio:match("^[%w%.%-]+$") then
    return false, "caratteri non ammessi nel dominio"
  end
  if dominio:match("^[%.%-]") or dominio:match("[%.%-]$")
     or dominio:match("%.%.") then
    return false, "punti o trattini mal posizionati"
  end

  local etichetta, tld = dominio:match("^(.+)%.(%a+)$")
  if tld == nil then
    return false, "manca il dominio di primo livello"
  end
  if #tld < 2 then
    return false, "dominio di primo livello troppo corto"
  end
  if etichetta == "" then
    return false, "dominio incompleto"
  end

  return true
end

local casi = {
  {"anna.rossi@example.com", true},
  {"a@b.co", true},
  {"nome+tag@example.co.uk", true},
  {"nome_cognome@sotto.dominio.it", true},
  {"dario@example..com", false},
  {"dario@@example.com", false},
  {"@example.com", false},
  {"dario@", false},
  {"dario@example", false},
  {".dario@example.com", false},
  {"dario.@example.com", false},
  {"da..rio@example.com", false},
  {"dario@-example.com", false},
  {"dario@example.c", false},
  {"dario spazio@example.com", false},
}

for _, c in ipairs(casi) do
  local ok, motivo = valida(c[1])
  print(string.format("%-30s %-5s %-5s %s",
    c[1], tostring(ok), tostring(c[2]),
    ok == c[2] and "ok" or ("ERRORE: "
      .. tostring(motivo))))
end
