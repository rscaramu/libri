-- ES 6.4 — Il mediano di tre numeri
-- Manuale completo di Lua

local function medianoAlternativo(a, b, c)
  if (a <= b and b <= c) or (c <= b and b <= a) then
    return b
  elseif (b <= a and a <= c) or (c <= a and a <= b) then
    return a
  end
  return c
end
