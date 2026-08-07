-- ES 9.6 — Fibonacci come iteratore
-- Manuale completo di Lua

local function fibonacci(limite)
  local a, b = 0, 1
  return function()
    if limite and a > limite then
      return nil
    end
    local corrente = a
    a, b = b, a + b
    return corrente
  end
end

io.write("fino a 100: ")
for v in fibonacci(100) do
  io.write(v, " ")
end
io.write("\n")

io.write("primi 10 senza limite: ")
local quanti = 0
for v in fibonacci() do
  io.write(v, " ")
  quanti = quanti + 1
  if quanti >= 10 then break end
end
io.write("\n")

local somma = 0
for v in fibonacci(4000000) do
  if v % 2 == 0 then somma = somma + v end
end
print("somma dei pari fino a 4 milioni: " .. somma)
