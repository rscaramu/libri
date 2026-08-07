-- ES 12.7 — Indice su un campo qualunque
-- Manuale completo di Lua

local function indicizza(elenco, campo, opzioni)
  opzioni = opzioni or {}
  local indice = {}
  local senzaCampo = {}

  for i, record in ipairs(elenco) do
    if type(record) ~= "table" then
      return nil, "elemento " .. i .. " non e' un record"
    end

    local valore = record[campo]

    if valore == nil then
      senzaCampo[#senzaCampo + 1] = i
      if opzioni.chiaveMancante ~= nil then
        valore = opzioni.chiaveMancante
      end
    end

    if valore ~= nil then
      local gruppo = indice[valore]
      if gruppo == nil then
        gruppo = {}
        indice[valore] = gruppo
      end
      gruppo[#gruppo + 1] = record
    end
  end

  return indice, senzaCampo
end

local PERSONE = {
  {nome = "Anna", citta = "Roma", ruolo = "admin"},
  {nome = "Bruno", citta = "Milano", ruolo = "utente"},
  {nome = "Carla", citta = "Roma", ruolo = "utente"},
  {nome = "Dario", ruolo = "utente"},
  {nome = "Elena", citta = "Milano"},
}

local perCitta, mancanti = indicizza(PERSONE, "citta")

local chiavi = {}
for k in pairs(perCitta) do chiavi[#chiavi + 1] = k end
table.sort(chiavi)

for _, c in ipairs(chiavi) do
  local nomi = {}
  for _, p in ipairs(perCitta[c]) do
    nomi[#nomi + 1] = p.nome
  end
  print(string.format("%-10s %s", c,
    table.concat(nomi, ", ")))
end
print("record senza il campo: "
  .. table.concat(mancanti, ", "))

print()
local conRiserva = indicizza(PERSONE, "citta",
  {chiaveMancante = "(sconosciuta)"})
local nomi = {}
for _, p in ipairs(conRiserva["(sconosciuta)"]) do
  nomi[#nomi + 1] = p.nome
end
print("con chiave di riserva: " .. table.concat(nomi, ", "))
