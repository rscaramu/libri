-- ES 27.6 — table.insert contro assegnazione diretta
-- Manuale completo di Lua

local N = 3000000

local prove = {
  {"t[#t + 1] = v", function()
    local t = {}
    for i = 1, N do t[#t + 1] = i end
    return #t
  end},
  {"table.insert(t, v)", function()
    local t = {}
    for i = 1, N do table.insert(t, i) end
    return #t
  end},
  {"table.insert localizzata", function()
    local inserisci = table.insert
    local t = {}
    for i = 1, N do inserisci(t, i) end
    return #t
  end},
  {"indice esplicito", function()
    local t = {}
    local n = 0
    for i = 1, N do
      n = n + 1
      t[n] = i
    end
    return n
  end},
}

local riferimento
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or durata
  print(string.format("%-28s %.4f s  %5.2fx  (%d)",
    p[1], durata, durata / riferimento, r))
end
