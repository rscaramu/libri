-- ES 20.6 — Configurazione con ambiente ristretto
-- Manuale completo di Lua

local AMBIENTE_SICURO = {
  math = {
    floor = math.floor, ceil = math.ceil,
    abs = math.abs, max = math.max, min = math.min,
    pi = math.pi,
  },
  string = {
    format = string.format, rep = string.rep,
    upper = string.upper, lower = string.lower,
  },
  os = {
    date = os.date,   -- solo la formattazione
  },
  tostring = tostring,
  tonumber = tonumber,
  ipairs = ipairs,
  pairs = pairs,
  type = type,
}

local function caricaConfigurazione(testo, extra)
  local ambiente = {}
  for k, v in pairs(AMBIENTE_SICURO) do
    if type(v) == "table" then
      local copia = {}
      for kk, vv in pairs(v) do copia[kk] = vv end
      ambiente[k] = copia
    else
      ambiente[k] = v
    end
  end
  for k, v in pairs(extra or {}) do
    ambiente[k] = v
  end

  local chunk, errore = load(testo, "configurazione",
    "t", ambiente)
  if chunk == nil then
    return nil, "sintassi: " .. errore
  end

  local ok, risultato = pcall(chunk)
  if not ok then
    return nil, "esecuzione: " .. tostring(risultato)
  end
  if type(risultato) ~= "table" then
    return nil, "la configurazione deve restituire "
      .. "una tabella"
  end

  return risultato
end

local BUONA = [[
local base = 8000
return {
  host = "example.com",
  porta = base + 80,
  soglia = math.floor(3.7),
  etichetta = string.format("v%d.%d", 2, 1),
  generata = os.date("!%Y", 0),
}
]]

local c, e = caricaConfigurazione(BUONA)
if c then
  print("host:      " .. c.host)
  print("porta:     " .. c.porta)
  print("soglia:    " .. c.soglia)
  print("etichetta: " .. c.etichetta)
  print("generata:  " .. c.generata)
end

local CATTIVE = {
  {"os.execute", "os.execute('echo COMPROMESSO')\n"
    .. "return {}"},
  {"io.open", "return {x = io.open('/etc/passwd')}"},
  {"require", "require('os')\nreturn {}"},
  {"load", "return {f = load('return 1')}"},
  {"_G", "return {g = _G}"},
  {"getmetatable", "return {m = getmetatable('')}"},
  {"os.remove", "os.remove('/tmp/x')\nreturn {}"},
  {"sintassi", "return {porta = }"},
}

print()
for _, p in ipairs(CATTIVE) do
  local r, err = caricaConfigurazione(p[2])
  print(string.format("%-14s -> %s", p[1],
    r and "PASSATA (male!)" or err))
end
