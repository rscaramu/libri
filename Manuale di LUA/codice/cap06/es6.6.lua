-- ES 6.6 — Configurazione con tabella di opzioni
-- Manuale completo di Lua

local PREDEFINITI = {
  nome = "senza nome",
  dimensione = 10,
  visibile = true,
  colore = "nero",
  bordo = false,
}

local function configura(opzioni)
  opzioni = opzioni or {}

  for chiave in pairs(opzioni) do
    if PREDEFINITI[chiave] == nil then
      return nil, "opzione sconosciuta: "
        .. tostring(chiave)
    end
  end

  local finale = {}
  for chiave, predefinito in pairs(PREDEFINITI) do
    local fornito = opzioni[chiave]
    -- Il confronto con nil e' l'unico modo di
    -- distinguere "assente" da "impostato a false"
    if fornito == nil then
      finale[chiave] = predefinito
    else
      finale[chiave] = fornito
    end
  end

  return finale
end

local function mostra(etichetta, c)
  if c == nil then
    print(etichetta .. ": " .. "errore")
    return
  end
  local chiavi = {}
  for k in pairs(c) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi)
  local pezzi = {}
  for _, k in ipairs(chiavi) do
    pezzi[#pezzi + 1] = k .. "=" .. tostring(c[k])
  end
  print(etichetta .. ": " .. table.concat(pezzi, " "))
end

mostra("vuota   ", configura())
mostra("parziale", configura({nome = "box"}))
mostra("false   ", configura({visibile = false,
  bordo = true}))
mostra("tutti   ", configura({
  nome = "x", dimensione = 1, visibile = false,
  colore = "rosso", bordo = true}))

local r, e = configura({dimensioe = 5})
print("errore di battitura: " .. tostring(e))
