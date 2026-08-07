-- ES 34.8 — Compatibilità con LuaJIT
-- Manuale completo di Lua

-- PRIMA
local barre = math.floor(v / massimo * larghezza + 0.5)

-- DOPO: identico, math.floor esiste ovunque.
-- Ma il risultato e' un float su LuaJIT, e
-- string.rep lo accetta comunque.
