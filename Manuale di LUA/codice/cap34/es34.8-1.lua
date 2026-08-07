-- ES 34.8 — Compatibilità con LuaJIT
-- Manuale completo di Lua

-- PRIMA (Lua 5.4)
local chiudi <close> = f
f:write(testo, "\n")

-- DOPO (portabile)
local ok, errore = pcall(function()
  f:write(testo, "\n")
  f:flush()
end)
f:close()
if not ok then return nil, errore end
