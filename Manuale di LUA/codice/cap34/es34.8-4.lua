-- ES 34.8 — Compatibilità con LuaJIT
-- Manuale completo di Lua

-- table.move non esiste in LuaJIT
local function copia(origine, quante)
  local r = {}
  for i = 1, quante do r[i] = origine[i] end
  return r
end
