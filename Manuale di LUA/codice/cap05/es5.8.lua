-- ES 5.8 — ASCII contro UTF-8
-- Manuale completo di Lua

local A = utf8.char(0xE0)      -- a con accento grave
local E = utf8.char(0xE8)      -- e con accento grave
local EU = utf8.char(0x20AC)   -- simbolo dell'euro

local ASCII = "citta e perche"
local UTF8 = "citt" .. A .. " e perch" .. E

print("=== 1. Lunghezza ===")
print(string.format("ASCII: #=%d  utf8.len=%d",
  #ASCII, utf8.len(ASCII)))
print(string.format("UTF-8: #=%d  utf8.len=%d",
  #UTF8, utf8.len(UTF8)))
print("Corretto: usare utf8.len per i caratteri.")
print()

print("=== 2. Sottostringa ===")
print("ASCII sub(1,5):  [" .. ASCII:sub(1, 5) .. "]")
local grezzo = UTF8:sub(1, 5)
print("UTF-8 sub(1,5) e' valido? "
  .. tostring(utf8.len(grezzo) ~= nil))
local fine = utf8.offset(UTF8, 6) - 1
print("UTF-8 corretto:  [" .. UTF8:sub(1, fine) .. "]")
print()

print("=== 3. Inversione ===")
print("ASCII reverse valido? "
  .. tostring(utf8.len(ASCII:reverse()) ~= nil))
print("UTF-8 reverse valido? "
  .. tostring(utf8.len(UTF8:reverse()) ~= nil))
local caratteri = {}
for _, codice in utf8.codes(UTF8) do
  table.insert(caratteri, 1, utf8.char(codice))
end
print("UTF-8 corretto:  [" .. table.concat(caratteri)
  .. "]")
print()

print("=== 4. Maiuscolo ===")
print("ASCII upper: [" .. ASCII:upper() .. "]")
print("UTF-8 upper: le lettere accentate NON cambiano,")
print("perche' string.upper opera su singoli byte")
print("usando le funzioni del C.")
print()

print("=== 5. Allineamento in colonna ===")
local nomi = {"citta", "citt" .. A, "euro " .. EU}
print("Con %-12s (byte):")
for _, n in ipairs(nomi) do
  print(string.format("  [%-12s]", n))
end
print("Con riempimento in caratteri:")
for _, n in ipairs(nomi) do
  local mancanti = 12 - utf8.len(n)
  print("  [" .. n .. string.rep(" ", mancanti) .. "]")
end
