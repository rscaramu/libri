-- ES 10.8 — Chiavi numeriche e chiavi stringa
-- Manuale completo di Lua

local t = {}

t[1] = "intero uno"
t["1"] = "stringa uno"
t[2] = "intero due"
t[2.0] = "float due"
t[2.5] = "float due e mezzo"
t[0] = "zero"
t[-1] = "meno uno"

print("--- accessi diretti ---")
print("t[1]     = " .. tostring(t[1]))
print("t['1']   = " .. tostring(t["1"]))
print("t[2]     = " .. tostring(t[2]))
print("t[2.0]   = " .. tostring(t[2.0]))
print("t[2.5]   = " .. tostring(t[2.5]))

print()
print("--- tutte le chiavi presenti ---")
local chiavi = {}
for k in pairs(t) do
  chiavi[#chiavi + 1] = {chiave = k, tipo = type(k),
    sottotipo = math.type(k)}
end
table.sort(chiavi, function(a, b)
  if a.tipo ~= b.tipo then return a.tipo < b.tipo end
  return tostring(a.chiave) < tostring(b.chiave)
end)

for _, c in ipairs(chiavi) do
  print(string.format("  %-4s tipo=%-8s sottotipo=%-9s "
    .. "val=%s",
    tostring(c.chiave), c.tipo,
    tostring(c.sottotipo), tostring(t[c.chiave])))
end

print()
print("chiavi totali: " .. #chiavi)
print("t[2] e t[2.0] sono la stessa chiave? "
  .. tostring(t[2] == t[2.0]))
print("t[1] e t['1'] sono la stessa chiave? "
  .. tostring(t[1] == t["1"]))
