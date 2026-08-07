-- ES 19.7 — Allineamento in caratteri e non in byte
-- Manuale completo di Lua

local function larghezza(s)
  local n = utf8.len(s)
  if n == nil then return #s end
  return n
end

local function riempi(s, colonne, aSinistra)
  local mancanti = colonne - larghezza(s)
  if mancanti <= 0 then return s end
  local spazi = string.rep(" ", mancanti)
  if aSinistra then return spazi .. s end
  return s .. spazi
end

local A = utf8.char(0xE0)
local E = utf8.char(0xE9)
local EU = utf8.char(0x20AC)

local RIGHE = {
  {"citta", 100},
  {"citt" .. A, 200},
  {"perche", 300},
  {"perch" .. E, 400},
  {"euro " .. EU, 500},
  {"normale", 600},
}

print("=== con string.format (conta i byte) ===")
print(string.format("%-14s %8s", "NOME", "VALORE"))
for _, r in ipairs(RIGHE) do
  print(string.format("%-14s %8d", r[1], r[2]))
end

print()
print("=== con riempimento in caratteri ===")
print(riempi("NOME", 14) .. riempi("VALORE", 8, true))
for _, r in ipairs(RIGHE) do
  print(riempi(r[1], 14)
    .. riempi(tostring(r[2]), 8, true))
end

print()
print("=== larghezze a confronto ===")
for _, r in ipairs(RIGHE) do
  print(string.format("  %-16s byte=%d caratteri=%d",
    "[" .. r[1] .. "]", #r[1], larghezza(r[1])))
end
