-- ES 34.8 — Compatibilità con LuaJIT
-- Manuale completo di Lua

-- src/compat.lua
local M = {}

M.jit = rawget(_G, "jit") ~= nil
M.interi = math.type ~= nil

M.unpack = table.unpack or rawget(_G, "unpack")

M.pack = table.pack or function(...)
  return {n = select("#", ...), ...}
end

if table.move then
  M.copia = function(origine, da, a, dove, destinazione)
    return table.move(origine, da, a, dove,
      destinazione)
  end
else
  M.copia = function(origine, da, a, dove, destinazione)
    destinazione = destinazione or origine
    dove = dove or 1
    if dove > da then
      for i = a - da, 0, -1 do
        destinazione[dove + i] = origine[da + i]
      end
    else
      for i = 0, a - da do
        destinazione[dove + i] = origine[da + i]
      end
    end
    return destinazione
  end
end

function M.eIntero(v)
  if M.interi then return math.type(v) == "integer" end
  return type(v) == "number" and v == math.floor(v)
end

function M.conFile(percorso, modo, azione)
  local f, errore = io.open(percorso, modo)
  if f == nil then return nil, errore end
  local risultati = M.pack(pcall(azione, f))
  f:close()
  if not risultati[1] then
    return nil, risultati[2]
  end
  return M.unpack(risultati, 2, risultati.n)
end

return M
