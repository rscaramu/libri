-- ES 14.6 — Metatabella contro closure
-- Manuale completo di Lua

local ConMeta = {}
ConMeta.__index = ConMeta

function ConMeta.nuovo(x, y)
  return setmetatable({x = x, y = y}, ConMeta)
end

function ConMeta:somma() return self.x + self.y end
function ConMeta:prodotto() return self.x * self.y end
function ConMeta:massimo()
  return self.x > self.y and self.x or self.y
end

local function conClosure(x, y)
  local o = {}
  function o.somma() return x + y end
  function o.prodotto() return x * y end
  function o.massimo() return x > y and x or y end
  return o
end

local N = 100000

local function misuraMemoria(costruttore)
  collectgarbage("collect")
  collectgarbage("collect")
  local prima = collectgarbage("count")
  local istanze = {}
  for i = 1, N do
    istanze[i] = costruttore(i, i + 1)
  end
  collectgarbage("collect")
  local dopo = collectgarbage("count")
  return dopo - prima, istanze
end

local function misuraTempo(f)
  collectgarbage("collect")
  local inizio = os.clock()
  f()
  return os.clock() - inizio
end

local memMeta, istanzeMeta = misuraMemoria(ConMeta.nuovo)
local memClos, istanzeClos = misuraMemoria(conClosure)

print(string.format("memoria per %d istanze:", N))
print(string.format("  metatabella: %8.0f KB (%.0f B)",
  memMeta, memMeta * 1024 / N))
print(string.format("  closure:     %8.0f KB (%.0f B)",
  memClos, memClos * 1024 / N))
print(string.format("  rapporto: %.1fx",
  memClos / memMeta))

local tCreaMeta = misuraTempo(function()
  for i = 1, N do ConMeta.nuovo(i, i) end
end)
local tCreaClos = misuraTempo(function()
  for i = 1, N do conClosure(i, i) end
end)

print(string.format("creazione: meta %.4f s, "
  .. "closure %.4f s", tCreaMeta, tCreaClos))

local M = 1000000
local om = ConMeta.nuovo(3, 4)
local oc = conClosure(3, 4)

local tChiamMeta = misuraTempo(function()
  local s = 0
  for i = 1, M do s = s + om:somma() end
end)
local tChiamClos = misuraTempo(function()
  local s = 0
  for i = 1, M do s = s + oc.somma() end
end)

print(string.format("chiamate: meta %.4f s, "
  .. "closure %.4f s", tChiamMeta, tChiamClos))
