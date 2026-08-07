-- ES 13.4 — Insieme con metametodi aritmetici
-- Manuale completo di Lua

local Insieme = {}
Insieme.__index = Insieme
Insieme.__nome = "Insieme"

local function nuovo(da)
  local i = setmetatable({elementi = {}, n = 0}, Insieme)
  if da then
    for _, v in ipairs(da) do
      if i.elementi[v] == nil then
        i.elementi[v] = true
        i.n = i.n + 1
      end
    end
  end
  return i
end

function Insieme:contiene(v)
  return self.elementi[v] == true
end

function Insieme:aggiungi(v)
  if self.elementi[v] == nil then
    self.elementi[v] = true
    self.n = self.n + 1
  end
  return self
end

Insieme.__add = function(a, b)
  local r = nuovo()
  for v in pairs(a.elementi) do r:aggiungi(v) end
  for v in pairs(b.elementi) do r:aggiungi(v) end
  return r
end

Insieme.__mul = function(a, b)
  local piccolo, grande = a, b
  if b.n < a.n then piccolo, grande = b, a end
  local r = nuovo()
  for v in pairs(piccolo.elementi) do
    if grande.elementi[v] then r:aggiungi(v) end
  end
  return r
end

Insieme.__sub = function(a, b)
  local r = nuovo()
  for v in pairs(a.elementi) do
    if not b.elementi[v] then r:aggiungi(v) end
  end
  return r
end

Insieme.__le = function(a, b)
  if a.n > b.n then return false end
  for v in pairs(a.elementi) do
    if not b.elementi[v] then return false end
  end
  return true
end

Insieme.__lt = function(a, b)
  return a.n < b.n and Insieme.__le(a, b)
end

Insieme.__eq = function(a, b)
  if a.n ~= b.n then return false end
  for v in pairs(a.elementi) do
    if not b.elementi[v] then return false end
  end
  return true
end

Insieme.__len = function(a) return a.n end

Insieme.__tostring = function(a)
  local v = {}
  for e in pairs(a.elementi) do v[#v + 1] = tostring(e) end
  table.sort(v)
  return "{" .. table.concat(v, ",") .. "}"
end

local A = nuovo({1, 2, 3, 4})
local B = nuovo({3, 4, 5})
local C = nuovo({3, 4})

print("A       = " .. tostring(A))
print("B       = " .. tostring(B))
print("A + B   = " .. tostring(A + B))
print("A * B   = " .. tostring(A * B))
print("A - B   = " .. tostring(A - B))
print("#A      = " .. #A)
print("C <= A  = " .. tostring(C <= A))
print("A <= C  = " .. tostring(A <= C))
print("C <  A  = " .. tostring(C < A))
print("A <  A  = " .. tostring(A < A))
print("A == A  = " .. tostring(A == nuovo({4,3,2,1})))
