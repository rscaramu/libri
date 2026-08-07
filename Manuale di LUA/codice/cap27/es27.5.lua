-- ES 27.5 — Riscrittura portabile
-- Manuale completo di Lua

local function operazioniBit()
  local bit = rawget(_G, "bit") or rawget(_G, "bit32")
  if bit then
    return bit.band, bit.bor, bit.bxor,
           bit.lshift, bit.rshift
  end
  if math.type then
    local f = load([[
      return function(a,b) return a & b end,
             function(a,b) return a | b end,
             function(a,b) return a ~ b end,
             function(a,n) return a << n end,
             function(a,n) return a >> n end
    ]])
    return f()
  end
  local function bin(a, b, op)
    local r, p = 0, 1
    while a > 0 or b > 0 do
      if op(a % 2, b % 2) == 1 then r = r + p end
      a = math.floor(a / 2)
      b = math.floor(b / 2)
      p = p * 2
    end
    return r
  end
  return
    function(a, b) return bin(a, b, function(x, y)
      return (x == 1 and y == 1) and 1 or 0 end) end,
    function(a, b) return bin(a, b, function(x, y)
      return (x == 1 or y == 1) and 1 or 0 end) end,
    function(a, b) return bin(a, b, function(x, y)
      return x ~= y and 1 or 0 end) end,
    function(a, n) return math.floor(a * 2 ^ n) end,
    function(a, n) return math.floor(a / 2 ^ n) end
end

local band, bor, bxor, lshift, rshift = operazioniBit()

local function divInt(a, b)
  return math.floor(a / b)
end

-- Versione ORIGINALE, solo Lua 5.3+
local function coloreOriginale(r, g, b)
  return (r << 16) | (g << 8) | b
end

local function componentiOriginale(colore)
  return (colore >> 16) & 255,
         (colore >> 8) & 255,
         colore & 255
end

-- Versione PORTABILE
local function colorePortabile(r, g, b)
  return bor(bor(lshift(r, 16), lshift(g, 8)), b)
end

local function componentiPortabile(colore)
  return band(rshift(colore, 16), 255),
         band(rshift(colore, 8), 255),
         band(colore, 255)
end

local function checksumOriginale(s)
  local h = 5381
  for i = 1, #s do
    h = ((h << 5) + h + s:byte(i)) & 0xFFFFFFFF
  end
  return h
end

local function checksumPortabile(s)
  local h = 5381
  for i = 1, #s do
    h = band(lshift(h, 5) + h + s:byte(i), 0xFFFFFFFF)
  end
  return h
end

print(string.format("%-8s %-8s %-8s %-12s %-12s %s",
  "R", "G", "B", "ORIGINALE", "PORTABILE", "ESITO"))

math.randomseed(7)
local errori = 0

for prova = 1, 20 do
  local r, g, b
  if prova <= 6 then
    local fissi = {
      {0, 0, 0}, {255, 255, 255}, {255, 0, 0},
      {0, 255, 0}, {0, 0, 255}, {128, 64, 32},
    }
    r, g, b = table.unpack(fissi[prova])
  else
    r = math.random(0, 255)
    g = math.random(0, 255)
    b = math.random(0, 255)
  end

  local o = coloreOriginale(r, g, b)
  local p = colorePortabile(r, g, b)

  local ro, go, bo = componentiOriginale(o)
  local rp, gp, bp = componentiPortabile(p)

  local ok = o == p and ro == rp and go == gp
    and bo == bp and ro == r and go == g and bo == b
  if not ok then errori = errori + 1 end

  print(string.format("%-8d %-8d %-8d %-12d %-12d %s",
    r, g, b, o, p, ok and "ok" or "DIVERSI"))
end

print()
local testi = {"", "a", "Lua", "programmazione",
  string.rep("x", 100)}
for _, t in ipairs(testi) do
  local a = checksumOriginale(t)
  local b = checksumPortabile(t)
  print(string.format("checksum %-18s %12d %12d %s",
    "[" .. t:sub(1, 14) .. "]", a, b,
    a == b and "ok" or "DIVERSI"))
end

print()
print("divisione intera:")
for _, coppia in ipairs({{17, 5}, {-7, 2}, {7, -2},
    {-7, -2}, {0, 3}}) do
  local a, b = coppia[1], coppia[2]
  local originale = load("return " .. a .. " // " .. b)
  local o = originale and originale() or "n/d"
  local p = divInt(a, b)
  print(string.format("  %3d // %3d = %-6s %-6s %s",
    a, b, tostring(o), tostring(p),
    tostring(o) == tostring(p) and "ok" or "DIVERSI"))
end
print()
print("errori totali: " .. errori)
