-- ES 19.6 — Formattare una durata
-- Manuale completo di Lua

local UNITA = {
  {nome = "giorno", plurale = "giorni",
   secondi = 86400},
  {nome = "ora", plurale = "ore", secondi = 3600},
  {nome = "minuto", plurale = "minuti", secondi = 60},
  {nome = "secondo", plurale = "secondi", secondi = 1},
}

local function formattaDurata(secondi, opzioni)
  opzioni = opzioni or {}
  if type(secondi) ~= "number" then
    return nil, "atteso un numero"
  end

  local negativa = secondi < 0
  secondi = math.floor(math.abs(secondi))

  if secondi == 0 then
    return "0 secondi"
  end

  local massimo = opzioni.massimoUnita or #UNITA
  local pezzi = {}
  local resto = secondi

  for _, u in ipairs(UNITA) do
    if #pezzi >= massimo then break end
    local quante = resto // u.secondi
    if quante > 0 then
      resto = resto % u.secondi
      pezzi[#pezzi + 1] = quante .. " "
        .. (quante == 1 and u.nome or u.plurale)
    end
  end

  local testo
  if #pezzi == 1 then
    testo = pezzi[1]
  else
    local ultimo = table.remove(pezzi)
    testo = table.concat(pezzi, ", ") .. " e " .. ultimo
  end

  if negativa then testo = testo .. " fa" end
  return testo
end

local casi = {0, 1, 2, 59, 60, 61, 90, 3600, 3601,
  3660, 86400, 90061, 172800, 200000, -3661}

for _, s in ipairs(casi) do
  print(string.format("%8d -> %s", s,
    formattaDurata(s)))
end

print()
print("con al massimo due unita':")
for _, s in ipairs({90061, 200000, 3661}) do
  print(string.format("%8d -> %s", s,
    formattaDurata(s, {massimoUnita = 2})))
end
