-- ES 7.7 — Le espressioni del `for` valutate una volta
-- Manuale completo di Lua

local chiamate = 0

local function limite()
  chiamate = chiamate + 1
  print("  limite() chiamata (" .. chiamate .. ")")
  return 3
end

print("for con chiamata come valore finale:")
for i = 1, limite() do
  print("  iterazione " .. i)
end
print("chiamate totali: " .. chiamate)

chiamate = 0
print()
print("while con la stessa chiamata:")
local i = 1
while i <= limite() do
  print("  iterazione " .. i)
  i = i + 1
end
print("chiamate totali: " .. chiamate)
