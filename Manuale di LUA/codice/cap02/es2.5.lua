-- ES 2.5 — Tutti gli indici di `arg`
-- Manuale completo di Lua

local minimo, massimo = 0, 0
for k in pairs(arg) do
  if k < minimo then minimo = k end
  if k > massimo then massimo = k end
end

for i = minimo, massimo do
  print(string.format("arg[%2d] = %s", i,
    tostring(arg[i])))
end
