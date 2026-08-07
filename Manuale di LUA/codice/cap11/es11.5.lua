-- ES 11.5 — Pila e coda
-- Manuale completo di Lua

local Pila = {}
Pila.__index = Pila

function Pila.nuova()
  return setmetatable({n = 0}, Pila)
end

function Pila:impila(v)
  self.n = self.n + 1
  self[self.n] = v
end

function Pila:sfila()
  if self.n == 0 then return nil end
  local v = self[self.n]
  self[self.n] = nil
  self.n = self.n - 1
  return v
end

function Pila:guarda()
  if self.n == 0 then return nil end
  return self[self.n]
end

local Coda = {}
Coda.__index = Coda

function Coda.nuova()
  return setmetatable({primo = 1, ultimo = 0}, Coda)
end

function Coda:accoda(v)
  self.ultimo = self.ultimo + 1
  self[self.ultimo] = v
end

function Coda:togli()
  if self.primo > self.ultimo then return nil end
  local v = self[self.primo]
  self[self.primo] = nil
  self.primo = self.primo + 1
  return v
end

function Coda:quanti()
  return self.ultimo - self.primo + 1
end

local N = 100000

local function misura(nome, f)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f()
  print(string.format("%-30s %8.4f s  (%s)",
    nome, os.clock() - inizio, tostring(r)))
end

misura("pila: " .. N .. " op.", function()
  local p = Pila.nuova()
  for i = 1, N do p:impila(i) end
  local somma = 0
  while p.n > 0 do somma = somma + p:sfila() end
  return somma
end)

misura("coda a due indici", function()
  local c = Coda.nuova()
  for i = 1, N do c:accoda(i) end
  local somma = 0
  while c:quanti() > 0 do somma = somma + c:togli() end
  return somma
end)

misura("table.insert/remove in coda", function()
  local t = {}
  for i = 1, N do table.insert(t, i) end
  local somma = 0
  while #t > 0 do somma = somma + table.remove(t) end
  return somma
end)

misura("table.remove(t, 1) INGENUO", function()
  local t = {}
  for i = 1, N // 10 do table.insert(t, i) end
  local somma = 0
  while #t > 0 do somma = somma + table.remove(t, 1) end
  return somma
end)
