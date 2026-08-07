-- ES 6.4 — Il mediano di tre numeri
-- Manuale completo di Lua

local function mediano(a, b, c)
  if a > b then a, b = b, a end
  if b > c then b, c = c, b end
  if a > b then a, b = b, a end
  return b
end

local disposizioni = {
  {1, 2, 3}, {1, 3, 2}, {2, 1, 3},
  {2, 3, 1}, {3, 1, 2}, {3, 2, 1},
}

for _, d in ipairs(disposizioni) do
  local m = mediano(d[1], d[2], d[3])
  print(string.format("(%d,%d,%d) -> %d %s",
    d[1], d[2], d[3], m,
    m == 2 and "ok" or "ERRORE"))
end

local uguali = {
  {5, 5, 5, 5}, {5, 5, 9, 5}, {1, 5, 5, 5},
  {5, 1, 5, 5}, {-3, 0, 3, 0},
}

for _, u in ipairs(uguali) do
  local m = mediano(u[1], u[2], u[3])
  print(string.format("(%d,%d,%d) -> %d atteso %d %s",
    u[1], u[2], u[3], m, u[4],
    m == u[4] and "ok" or "ERRORE"))
end
