-- ES 7.4 — Fattoriale e traboccamento
-- Manuale completo di Lua

local function fattoriale(n)
  if math.type(n) ~= "integer" or n < 0 then
    return nil, "serve un intero non negativo"
  end
  local r = 1
  for i = 2, n do
    r = r * i
  end
  return r
end

local function fattorialeSicuro(n)
  if math.type(n) ~= "integer" or n < 0 then
    return nil, "serve un intero non negativo"
  end
  local r = 1
  for i = 2, n do
    if r > math.maxinteger // i then
      return nil, "traboccamento a n = " .. i
    end
    r = r * i
  end
  return r
end

for n = 18, 22 do
  local grezzo = fattoriale(n)
  local sicuro, errore = fattorialeSicuro(n)
  print(string.format("%2d!  %22d  %s", n, grezzo,
    sicuro and "ok" or errore))
end
