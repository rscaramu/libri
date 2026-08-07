-- ES 33.5 — Coda con priorità in Redis
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

-- Script Redis: estrazione atomica del massimo
-- KEYS[1] = chiave dell'insieme ordinato
-- ARGV[1] = quanti elementi estrarre (opzionale)
local chiaveCoda = KEYS[1]
local quanti = tonumber(ARGV[1]) or 1

if quanti < 1 then
  return redis.error_reply("quantita' non valida")
end

-- ZPOPMAX e' gia' atomico, ma lo avvolgiamo per
-- poter aggiungere logica senza perdere l'atomicita'
local estratti = redis.call("ZPOPMAX", chiaveCoda,
  quanti)

if #estratti == 0 then
  return {}
end

local risultato = {}
for i = 1, #estratti, 2 do
  local payload = estratti[i]
  local punteggio = tonumber(estratti[i + 1])
  local priorita = math.floor(punteggio / 1000000000)

  risultato[#risultato + 1] = payload
  risultato[#risultato + 1] = tostring(priorita)

  -- Registrazione dell'estrazione, nello stesso
  -- script: nessun'altra connessione puo' intervenire
  redis.call("HINCRBY", chiaveCoda .. ":stat",
    "estratti", 1)
  redis.call("HSET", chiaveCoda .. ":stat",
    "ultimo", payload)
end

return risultato
