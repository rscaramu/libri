-- ES 4.6 — Numeri primi
-- Manuale completo di Lua

local function ePrimo(n)
  if type(n) ~= "number" or n ~= math.floor(n) then
    return false
  end
  if n < 2 then return false end
  if n < 4 then return true end
  if n % 2 == 0 then return false end

  local limite = math.floor(math.sqrt(n))
  local i = 3
  while i <= limite do
    if n % i == 0 then return false end
    i = i + 2
  end
  return true
end

io.write("Primi fino a 30: ")
for n = 1, 30 do
  if ePrimo(n) then io.write(n, " ") end
end
io.write("\n")

local grandi = {97, 100, 7919, 7920,
                104729, 1000003, 1000005}
for _, n in ipairs(grandi) do
  print(string.format("%8d  %s", n,
    ePrimo(n) and "primo" or "composto"))
end
