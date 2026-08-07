-- ES 9.5 — Variabile dentro e fuori dal ciclo
-- Manuale completo di Lua

local dentro = {}
for i = 1, 3 do
  local valore = i * 10
  dentro[i] = function() return valore end
end

local fuori = {}
local valoreEsterno
for i = 1, 3 do
  valoreEsterno = i * 10
  fuori[i] = function() return valoreEsterno end
end

print("dentro il ciclo: " .. dentro[1]() .. " "
  .. dentro[2]() .. " " .. dentro[3]())
print("fuori dal ciclo: " .. fuori[1]() .. " "
  .. fuori[2]() .. " " .. fuori[3]())
