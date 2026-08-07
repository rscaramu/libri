-- ES 17.6 — Estrarre chiamate con `%b`
-- Manuale completo di Lua

local CODICE = [[
print(a, f(b, c), d)
risultato = calcola(x + g(y), z)
vuota()
annidata(f(g(h(1))))
]]

local function conBilanciate(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)(%b())") do
    r[#r + 1] = nome .. " -> "
      .. dentro:sub(2, -2)
  end
  return r
end

local function conNonAvido(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)%((.-)%)") do
    r[#r + 1] = nome .. " -> " .. dentro
  end
  return r
end

local function conAvido(testo)
  local r = {}
  for nome, dentro in testo:gmatch("(%a[%w_]*)%((.*)%)") do
    r[#r + 1] = nome .. " -> " .. dentro
  end
  return r
end

local function mostra(etichetta, elenco)
  print("=== " .. etichetta .. " ===")
  for _, v in ipairs(elenco) do print("  " .. v) end
end

mostra("con %b()", conBilanciate(CODICE))
mostra("con %((.-)%) non avido", conNonAvido(CODICE))
mostra("con %((.*)%) avido", conAvido(CODICE))
