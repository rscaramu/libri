-- ES 8.7 — Rifiutare le opzioni sconosciute
-- Manuale completo di Lua

local PREDEFINITI = {
  titolo = "Senza titolo",
  larghezza = 640,
  altezza = 480,
  visibile = true,
  ridimensionabile = false,
}

local function creaFinestra(opzioni)
  opzioni = opzioni or {}

  local ignote = {}
  for chiave in pairs(opzioni) do
    if PREDEFINITI[chiave] == nil then
      ignote[#ignote + 1] = tostring(chiave)
    end
  end

  if #ignote > 0 then
    table.sort(ignote)
    return nil, "opzioni sconosciute: "
      .. table.concat(ignote, ", ")
  end

  local c = {}
  for chiave, predefinito in pairs(PREDEFINITI) do
    if opzioni[chiave] == nil then
      c[chiave] = predefinito
    else
      c[chiave] = opzioni[chiave]
    end
  end

  return string.format("%s: %dx%d visibile=%s "
    .. "ridim=%s", c.titolo, c.larghezza, c.altezza,
    tostring(c.visibile), tostring(c.ridimensionabile))
end

print(creaFinestra())
print(creaFinestra({titolo = "Editor", altezza = 900}))
print(creaFinestra({visibile = false}))
print(creaFinestra({larghezz = 800}))
print(creaFinestra({titolo = "x", colore = "rosso",
  bordo = 1}))
