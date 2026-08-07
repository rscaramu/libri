-- ES 18.8 — Ancorato contro non ancorato
-- Manuale completo di Lua

local N = 100000
local RIPETIZIONI = 200

local conCorrispondenza = string.rep("a", N)
local senzaCorrispondenza = string.rep("b", N)

local prove = {
  {"ancorato, corrisponde", "^aaa", conCorrispondenza},
  {"non ancorato, corrisponde", "aaa",
    conCorrispondenza},
  {"ancorato, non corrisponde", "^aaa",
    senzaCorrispondenza},
  {"non ancorato, non corrisponde", "aaa",
    senzaCorrispondenza},
}

for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local trovato = false
  for _ = 1, RIPETIZIONI do
    trovato = p[3]:match(p[2]) ~= nil
  end
  local durata = os.clock() - inizio
  print(string.format("%-32s %.4f s  trovato=%s",
    p[1], durata, tostring(trovato)))
end
