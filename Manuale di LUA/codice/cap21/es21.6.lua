-- ES 21.6 — Costo di pcall e xpcall
-- Manuale completo di Lua

local N = 5000000

local function bersaglio(a, b)
  return a + b
end

local function gestore(m) return m end

local prove = {
  {"chiamata diretta", function()
    local s = 0
    for i = 1, N do s = s + bersaglio(i, 1) end
    return s
  end},
  {"pcall", function()
    local s = 0
    for i = 1, N do
      local ok, r = pcall(bersaglio, i, 1)
      s = s + r
    end
    return s
  end},
  {"pcall con closure", function()
    local s = 0
    for i = 1, N do
      local ok, r = pcall(function()
        return bersaglio(i, 1)
      end)
      s = s + r
    end
    return s
  end},
  {"xpcall con gestore", function()
    local s = 0
    for i = 1, N do
      local ok, r = xpcall(bersaglio, gestore, i, 1)
      s = s + r
    end
    return s
  end},
}

local riferimento
for _, p in ipairs(prove) do
  collectgarbage("collect")
  local inizio = os.clock()
  local r = p[2]()
  local durata = os.clock() - inizio
  riferimento = riferimento or durata
  print(string.format("%-24s %.4f s  %5.2fx",
    p[1], durata, durata / riferimento))
end
