-- ES 22.6 — Costo dello scambio di controllo
-- Manuale completo di Lua

local N = 1000000

local function misura(nome, f)
  collectgarbage("collect")
  local inizio = os.clock()
  local r = f()
  local durata = os.clock() - inizio
  return {nome = nome, durata = durata, risultato = r}
end

local prove = {}

prove[#prove + 1] = misura("ciclo for puro", function()
  local s = 0
  for i = 1, N do s = s + 1 end
  return s
end)

local function unaFunzione() return 1 end
prove[#prove + 1] = misura("chiamata di funzione",
  function()
    local s = 0
    for i = 1, N do s = s + unaFunzione() end
    return s
  end)

prove[#prove + 1] = misura("coroutine.wrap", function()
  local co = coroutine.wrap(function()
    while true do coroutine.yield(1) end
  end)
  local s = 0
  for i = 1, N do s = s + co() end
  return s
end)

prove[#prove + 1] = misura("resume esplicito", function()
  local co = coroutine.create(function()
    while true do coroutine.yield(1) end
  end)
  local s = 0
  for i = 1, N do
    local ok, v = coroutine.resume(co)
    s = s + v
  end
  return s
end)

local riferimento = prove[1].durata
for _, p in ipairs(prove) do
  print(string.format("%-24s %.4f s  %6.2fx  (%d)",
    p.nome, p.durata, p.durata / riferimento,
    p.risultato))
end

collectgarbage("collect")
local prima = collectgarbage("count")
local coroutines = {}
for i = 1, 10000 do
  coroutines[i] = coroutine.create(function()
    coroutine.yield()
  end)
  coroutine.resume(coroutines[i])
end
collectgarbage("collect")
local dopo = collectgarbage("count")
print(string.format(
  "10000 coroutine sospese: %.0f KB (%.0f byte "
  .. "ciascuna)", dopo - prima,
  (dopo - prima) * 1024 / 10000))
