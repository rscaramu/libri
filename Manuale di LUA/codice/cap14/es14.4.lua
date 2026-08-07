-- ES 14.4 — La classe Rettangolo
-- Manuale completo di Lua

local Rettangolo = {}
Rettangolo.__index = Rettangolo
Rettangolo.__nome = "Rettangolo"

function Rettangolo.nuovo(larghezza, altezza)
  if type(larghezza) ~= "number"
     or type(altezza) ~= "number" then
    return nil, "servono due numeri"
  end
  if larghezza <= 0 or altezza <= 0 then
    return nil, "le dimensioni devono essere positive"
  end
  return setmetatable({
    larghezza = larghezza,
    altezza = altezza,
  }, Rettangolo)
end

function Rettangolo:area()
  return self.larghezza * self.altezza
end

function Rettangolo:perimetro()
  return 2 * (self.larghezza + self.altezza)
end

function Rettangolo:quadrato()
  return self.larghezza == self.altezza
end

function Rettangolo:ridimensionato(fattore)
  if type(fattore) ~= "number" or fattore <= 0 then
    return nil, "il fattore deve essere positivo"
  end
  return setmetatable({
    larghezza = self.larghezza * fattore,
    altezza = self.altezza * fattore,
  }, getmetatable(self))
end

Rettangolo.__eq = function(a, b)
  return a.larghezza == b.larghezza
    and a.altezza == b.altezza
end

Rettangolo.__lt = function(a, b)
  return a:area() < b:area()
end

Rettangolo.__le = function(a, b)
  return a:area() <= b:area()
end

Rettangolo.__tostring = function(r)
  return string.format("%s(%gx%g, area %g)",
    r.__nome, r.larghezza, r.altezza, r:area())
end

local a = Rettangolo.nuovo(3, 4)
local b = Rettangolo.nuovo(2, 6)
local c = Rettangolo.nuovo(3, 4)
local q = Rettangolo.nuovo(5, 5)

print(tostring(a))
print("area " .. a:area() .. ", perimetro "
  .. a:perimetro())
print("a == c: " .. tostring(a == c))
print("a == b: " .. tostring(a == b))
print("a < b:  " .. tostring(a < b))
print("a <= b: " .. tostring(a <= b))
print("q e' quadrato: " .. tostring(q:quadrato()))

local d = a:ridimensionato(2)
print("ridimensionato: " .. tostring(d))
print("originale intatto: " .. tostring(a))

print(Rettangolo.nuovo(-1, 5))
print(a:ridimensionato(0))

local elenco = {a, b, q, d}
table.sort(elenco, function(x, y) return x < y end)
io.write("ordinati per area: ")
for _, r in ipairs(elenco) do
  io.write(r:area(), " ")
end
io.write("\n")
