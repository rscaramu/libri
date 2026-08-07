-- ES 23.8 — Cache a due livelli
-- Manuale completo di Lua

local Cache = {}
Cache.__index = Cache

function Cache.nuova(capacitaForte)
  return setmetatable({
    capacita = capacitaForte or 10,
    forte = {},
    ordine = {},
    debole = setmetatable({}, {__mode = "v"}),
    letture = 0,
    colpiForte = 0,
    colpiDebole = 0,
    mancati = 0,
  }, Cache)
end

function Cache:promuovi(chiave, valore)
  if self.forte[chiave] == nil then
    self.ordine[#self.ordine + 1] = chiave
    if #self.ordine > self.capacita then
      local vecchia = table.remove(self.ordine, 1)
      -- Retrocede al livello debole
      self.debole[vecchia] = self.forte[vecchia]
      self.forte[vecchia] = nil
    end
  end
  self.forte[chiave] = valore
end

function Cache:imposta(chiave, valore)
  self:promuovi(chiave, valore)
  return valore
end

function Cache:leggi(chiave)
  self.letture = self.letture + 1

  local v = self.forte[chiave]
  if v ~= nil then
    self.colpiForte = self.colpiForte + 1
    return v, "forte"
  end

  v = self.debole[chiave]
  if v ~= nil then
    self.colpiDebole = self.colpiDebole + 1
    self:promuovi(chiave, v)
    self.debole[chiave] = nil
    return v, "debole"
  end

  self.mancati = self.mancati + 1
  return nil, "assente"
end

function Cache:stato()
  local nForte, nDebole = 0, 0
  for _ in pairs(self.forte) do nForte = nForte + 1 end
  for _ in pairs(self.debole) do nDebole = nDebole + 1 end
  return {
    forte = nForte, debole = nDebole,
    letture = self.letture,
    colpiForte = self.colpiForte,
    colpiDebole = self.colpiDebole,
    mancati = self.mancati,
  }
end

local c = Cache.nuova(5)

for i = 1, 20 do
  c:imposta("k" .. i, {indice = i,
    riempimento = string.rep("x", 500)})
end

local s1 = c:stato()
print(string.format("dopo 20 inserimenti: forte=%d "
  .. "debole=%d", s1.forte, s1.debole))

collectgarbage("collect")
collectgarbage("collect")

local s2 = c:stato()
print(string.format("dopo la raccolta:    forte=%d "
  .. "debole=%d", s2.forte, s2.debole))

print()
print("verifica delle voci recenti:")
for i = 16, 20 do
  local v, dove = c:leggi("k" .. i)
  print(string.format("  k%-3d %s", i, dove))
end

print("verifica delle voci vecchie:")
for i = 6, 10 do
  local v, dove = c:leggi("k" .. i)
  print(string.format("  k%-3d %s", i, dove))
end

local s3 = c:stato()
print()
print(string.format(
  "letture=%d forte=%d debole=%d mancati=%d",
  s3.letture, s3.colpiForte, s3.colpiDebole,
  s3.mancati))
