-- ES 11.4 — Inversione sul posto e con copia
-- Manuale completo di Lua

local function inverteSulPosto(t)
  local n = #t
  for i = 1, n // 2 do
    t[i], t[n - i + 1] = t[n - i + 1], t[i]
  end
  return t
end

local function invertita(t)
  local n = #t
  local r = {}
  for i = 1, n do
    r[i] = t[n - i + 1]
  end
  return r
end

local piccola = {1, 2, 3, 4, 5}
print("originale: " .. table.concat(piccola, " "))
print("copia:     "
  .. table.concat(invertita(piccola), " "))
print("originale intatta: "
  .. table.concat(piccola, " "))
inverteSulPosto(piccola)
print("dopo sul posto: " .. table.concat(piccola, " "))

local N = 1000000
local grande = {}
for i = 1, N do grande[i] = i end

collectgarbage("collect")
local m1 = collectgarbage("count")
local t1 = os.clock()
inverteSulPosto(grande)
local d1 = os.clock() - t1
local m2 = collectgarbage("count")

collectgarbage("collect")
local m3 = collectgarbage("count")
local t2 = os.clock()
local copia = invertita(grande)
local d2 = os.clock() - t2
local m4 = collectgarbage("count")

print(string.format("sul posto: %.4f s, %+.0f KB",
  d1, m2 - m1))
print(string.format("con copia: %.4f s, %+.0f KB",
  d2, m4 - m3))
print("copia lunga " .. #copia)
