-- ES 7.5 — Fibonacci con `for` e con `while`
-- Manuale completo di Lua

local a, b = 0, 1
io.write("Primi 30: ")
for i = 1, 30 do
  io.write(a, " ")
  a, b = b, a + b
end
io.write("\n")

local x, y = 0, 1
local quanti = 0
while x <= 1000000 do
  x, y = y, x + y
  quanti = quanti + 1
end
print(string.format(
  "Primo termine oltre un milione: %d (indice %d)",
  x, quanti))
