-- ES 13.7 — Le regole di `__gc`
-- Manuale completo di Lua

local eventi = {}

-- Caso 1: __gc presente al momento di setmetatable
local function conGc()
  local meta = {
    __gc = function() eventi[#eventi + 1] = "A: gc" end
  }
  local o = setmetatable({}, meta)
  return o
end

-- Caso 2: __gc aggiunto DOPO setmetatable
local function gcTardivo()
  local meta = {}
  local o = setmetatable({}, meta)
  meta.__gc = function()
    eventi[#eventi + 1] = "B: gc"
  end
  return o
end

-- Caso 3: setmetatable ripetuto dopo aver aggiunto __gc
local function gcRiassegnato()
  local meta = {}
  local o = setmetatable({}, meta)
  meta.__gc = function()
    eventi[#eventi + 1] = "C: gc"
  end
  setmetatable(o, meta)
  return o
end

-- Caso 4: __gc che solleva un errore
local function gcConErrore()
  return setmetatable({}, {
    __gc = function()
      eventi[#eventi + 1] = "D: prima dell'errore"
      error("guasto nel finalizzatore")
    end
  })
end

do
  local a = conGc()
  local b = gcTardivo()
  local c = gcRiassegnato()
  local d = gcConErrore()
end

collectgarbage("collect")
collectgarbage("collect")

table.sort(eventi)
print("eventi registrati:")
for _, e in ipairs(eventi) do print("  " .. e) end

print()
print("A presente? " .. tostring(
  eventi[1] and true or false))
