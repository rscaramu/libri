-- ES 29.8 — Profilatore a campionamento
-- Manuale completo di Lua

local Campionatore = {}
Campionatore.__index = Campionatore

function Campionatore.nuovo(intervallo)
  return setmetatable({
    intervallo = intervallo or 10000,
    campioni = {},
    totale = 0,
    attivo = false,
  }, Campionatore)
end

function Campionatore:avvia()
  if self.attivo then return self end
  self.attivo = true
  local campioni = self.campioni

  debug.sethook(function()
    local info = debug.getinfo(2, "Sn")
    if info == nil then return end

    local nome = info.name
    if nome == nil then
      nome = string.format("%s:%d",
        info.short_src, info.linedefined)
    else
      nome = string.format("%s (%s:%d)", nome,
        info.short_src, info.linedefined)
    end

    campioni[nome] = (campioni[nome] or 0) + 1
    self.totale = self.totale + 1
  end, "", self.intervallo)

  return self
end

function Campionatore:ferma()
  debug.sethook()
  self.attivo = false
  return self
end

function Campionatore:rapporto(quanti)
  quanti = quanti or 10
  local elenco = {}
  for nome, n in pairs(self.campioni) do
    elenco[#elenco + 1] = {nome = nome, campioni = n}
  end
  table.sort(elenco, function(a, b)
    if a.campioni ~= b.campioni then
      return a.campioni > b.campioni
    end
    return a.nome < b.nome
  end)

  local righe = {string.format("%-40s %8s %8s",
    "FUNZIONE", "CAMPIONI", "QUOTA")}
  for i = 1, math.min(quanti, #elenco) do
    local v = elenco[i]
    righe[#righe + 1] = string.format(
      "%-40s %8d %7.1f%%",
      v.nome:sub(1, 40), v.campioni,
      v.campioni / self.totale * 100)
  end
  righe[#righe + 1] = string.format(
    "totale campioni: %d", self.totale)
  return table.concat(righe, "\n")
end

-- Carico di prova: tre funzioni con costi molto diversi
local function moltoLenta(n)
  local s = 0
  for i = 1, n do
    s = s + math.sqrt(i) * math.sin(i)
  end
  return s
end

local function media(n)
  local s = 0
  for i = 1, n do s = s + i end
  return s
end

local function veloce(n)
  return n * 2
end

local function carico()
  local s = 0
  for _ = 1, 20 do
    s = s + moltoLenta(200000)
    s = s + media(50000)
    s = s + veloce(1)
  end
  return s
end

-- Confronto con la strumentazione
local Strumentato = {tempi = {}}

local function misuraStrumentata(nome, f, ...)
  local inizio = os.clock()
  local r = f(...)
  local d = os.clock() - inizio
  Strumentato.tempi[nome] =
    (Strumentato.tempi[nome] or 0) + d
  return r
end

print("=== profilatore a campionamento ===")
local c = Campionatore.nuovo(10000)
collectgarbage("collect")
local t1 = os.clock()
c:avvia()
carico()
c:ferma()
local durataConHook = os.clock() - t1
print(c:rapporto(6))

print()
print("=== strumentazione esplicita ===")
collectgarbage("collect")
local t2 = os.clock()
local s = 0
for _ = 1, 20 do
  s = s + misuraStrumentata("moltoLenta",
    moltoLenta, 200000)
  s = s + misuraStrumentata("media", media, 50000)
  s = s + misuraStrumentata("veloce", veloce, 1)
end
local durataStrumentata = os.clock() - t2

local nomi = {}
for n in pairs(Strumentato.tempi) do
  nomi[#nomi + 1] = n
end
table.sort(nomi, function(a, b)
  return Strumentato.tempi[a] > Strumentato.tempi[b]
end)
local totale = 0
for _, n in ipairs(nomi) do
  totale = totale + Strumentato.tempi[n]
end
for _, n in ipairs(nomi) do
  print(string.format("%-24s %8.4f s %7.1f%%", n,
    Strumentato.tempi[n],
    Strumentato.tempi[n] / totale * 100))
end

print()
collectgarbage("collect")
local t3 = os.clock()
carico()
local durataPulita = os.clock() - t3

print(string.format("senza profilatura:   %.4f s",
  durataPulita))
print(string.format("con campionamento:   %.4f s "
  .. "(%.1f%% in piu')", durataConHook,
  (durataConHook / durataPulita - 1) * 100))
print(string.format("con strumentazione:  %.4f s "
  .. "(%.1f%% in piu')", durataStrumentata,
  (durataStrumentata / durataPulita - 1) * 100))
