-- ES 26.7 — Il longjmp che perde memoria
-- Manuale completo di Lua

local p = require("perdita")

local function mostra(etichetta)
  local a, l, differenza = p.statistiche()
  print(string.format("%-28s alloc=%d free=%d "
    .. "perse=%d", etichetta, a, l, differenza))
end

mostra("stato iniziale")

for i = 1, 100 do
  p.perde("prova", 3)
end
mostra("100 chiamate corrette")

for i = 1, 100 do
  pcall(p.perde, 42, "non un numero")
end
mostra("100 chiamate con errore")

for i = 1, 100 do
  pcall(p.validaPrima, 42, "non un numero")
end
mostra("100 con validaPrima")

for i = 1, 100 do
  pcall(p.conUserdata, 42, "non un numero")
end
collectgarbage("collect")
mostra("100 con userdata")

print()
print("le tre versioni sono equivalenti in uso normale:")
print("  " .. p.perde("x", 1))
print("  " .. p.validaPrima("x", 1))
print("  " .. p.conUserdata("x", 1))
