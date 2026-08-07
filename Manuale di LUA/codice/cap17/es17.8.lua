-- ES 17.8 — Parola intera con `%f`
-- Manuale completo di Lua

local function contaParolaIntera(testo, parola)
  local pattern = "%f[%w]" .. parola:gsub(
    "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1") .. "%f[%W]"
  local _, quante = testo:gsub(pattern, "")
  return quante
end

local function contaIngenuo(testo, parola)
  local _, quante = testo:gsub(parola, "")
  return quante
end

local TESTO = [[
Il gatto e il gattone giocano. Il gattino dorme.
Un gatto, due gatti, mille gattoni.
gatto
(gatto) [gatto] "gatto"
grattacielo non contiene la parola.
]]

for _, parola in ipairs({"gatto", "il", "gatti"}) do
  print(string.format("%-8s intera=%d  ingenuo=%d",
    parola,
    contaParolaIntera(TESTO, parola),
    contaIngenuo(TESTO, parola)))
end
