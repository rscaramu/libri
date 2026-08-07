-- ES 33.5 — Coda con priorità in Redis
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

-- Script Redis: inserimento atomico con priorita'
-- KEYS[1] = chiave dell'insieme ordinato
-- KEYS[2] = chiave del contatore di sequenza
-- ARGV[1] = priorita' (numero, piu' alto = prima)
-- ARGV[2] = payload
local chiaveCoda = KEYS[1]
local chiaveSequenza = KEYS[2]
local priorita = tonumber(ARGV[1])
local payload = ARGV[2]

if priorita == nil then
  return redis.error_reply("priorita' non numerica")
end

-- La sequenza garantisce l'ordine FIFO a parita'
-- di priorita'. Il punteggio combina i due valori:
-- priorita' nella parte alta, sequenza (negata,
-- per avere il piu' vecchio prima) nella bassa.
local sequenza = redis.call("INCR", chiaveSequenza)

local punteggio = priorita * 1000000000
  - (sequenza % 1000000000)

redis.call("ZADD", chiaveCoda, punteggio, payload)

return {sequenza, punteggio}
