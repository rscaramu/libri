-- ES 4.8 — Rappresentazione binaria
-- Manuale completo di Lua

local function binario(n, cifre)
  if type(n) ~= "number" or math.type(n) ~= "integer" then
    return nil, "serve un intero"
  end

  cifre = cifre or 0
  if n == 0 then
    return string.rep("0", math.max(1, cifre))
  end

  local negativo = n < 0
  local bit = {}

  if negativo then
    -- Rappresentazione in complemento a due su 64 bit:
    -- e' quella che Lua usa davvero in memoria.
    for i = 63, 0, -1 do
      bit[#bit + 1] = tostring((n >> i) & 1)
    end
    return table.concat(bit)
  end

  local v = n
  while v > 0 do
    table.insert(bit, 1, tostring(v & 1))
    v = v >> 1
  end

  while #bit < cifre do
    table.insert(bit, 1, "0")
  end

  return table.concat(bit)
end

for _, n in ipairs({0, 1, 2, 5, 10, 255, 256, 1023}) do
  print(string.format("%6d  %s", n, binario(n, 8)))
end

print()
print("  -1  " .. binario(-1))
print("  -2  " .. binario(-2))
print(" -10  " .. binario(-10))
