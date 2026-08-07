-- ES 5.6 — Concatenazione contro table.concat
-- Manuale completo di Lua

local function conConcatenazione(n)
  local s = ""
  for i = 1, n do
    s = s .. i .. ","
  end
  return #s
end

local function conTabella(n)
  local pezzi = {}
  for i = 1, n do
    pezzi[#pezzi + 1] = i
  end
  return #table.concat(pezzi, ",") + n
end

local function misura(f, n)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f(n)
  return os.clock() - inizio, r
end

print(string.format("%9s %12s %12s %10s",
  "N", "CONCAT", "TABLE", "RAPPORTO"))

for _, n in ipairs({1000, 10000, 100000}) do
  local t1 = misura(conConcatenazione, n)
  local t2 = misura(conTabella, n)
  print(string.format("%9d %12.4f %12.4f %9.1fx",
    n, t1, t2, t2 > 0 and t1 / t2 or 0))
end
