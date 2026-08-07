-- ES 24.4 — Vie di fuga dalla sandbox
-- Manuale completo di Lua

local AMBIENTE_INGENUO = {
  print = print,
  string = string,
  math = math,
  table = table,
  pairs = pairs,
  ipairs = ipairs,
  tostring = tostring,
  type = type,
  getmetatable = getmetatable,
  setmetatable = setmetatable,
}

local function eseguiIngenua(codice)
  local f, err = load(codice, "sandbox", "t",
    AMBIENTE_INGENUO)
  if f == nil then return nil, err end
  local ok, r = pcall(f)
  return ok and r or ("errore: " .. tostring(r))
end

print("=== fuga 1: la metatabella delle stringhe ===")
print(eseguiIngenua([[
  local m = getmetatable("")
  local nomi = {}
  for k in pairs(m.__index) do nomi[#nomi + 1] = k end
  table.sort(nomi)
  return "raggiunta la libreria string vera, "
    .. #nomi .. " funzioni"
]]))

print(eseguiIngenua([[
  -- Peggio: si puo' MODIFICARE per tutto il programma
  local m = getmetatable("")
  local originale = m.__index.upper
  m.__index.upper = function(s) return "SABOTATO" end
  local r = ("prova"):upper()
  m.__index.upper = originale
  return r
]]))

print()
print("=== fuga 2: inquinamento dell'ambiente ===")
print(eseguiIngenua([[
  string.nuovaFunzione = "lasciata qui"
  return "scritto in string, condivisa"
]]))
print(eseguiIngenua([[
  return "la esecuzione successiva la vede: "
    .. tostring(string.nuovaFunzione)
]]))

print()
print("=== la versione corretta ===")

local function soloLettura(tabella, nomi)
  local copia = {}
  for _, n in ipairs(nomi) do copia[n] = tabella[n] end
  return setmetatable({}, {
    __index = copia,
    __newindex = function()
      error("libreria in sola lettura", 2)
    end,
    __metatable = false,
  })
end

local function eseguiSicura(codice)
  local ambiente = {
    print = print,
    pairs = pairs,
    ipairs = ipairs,
    tostring = tostring,
    type = type,
    -- getmetatable e setmetatable NON esposti
    string = soloLettura(string, {"format", "rep",
      "sub", "upper", "lower", "len", "byte", "char"}),
    math = soloLettura(math, {"floor", "ceil", "abs",
      "max", "min", "sqrt", "pi"}),
    table = soloLettura(table, {"concat", "insert",
      "remove", "sort"}),
  }

  local f, err = load(codice, "sandbox", "t", ambiente)
  if f == nil then return nil, err end
  local ok, r = pcall(f)
  return ok and r or ("errore: " .. tostring(r))
end

print(eseguiSicura([[
  return getmetatable("") and "raggiunta" or "bloccata"
]]))
print(eseguiSicura([[
  string.sabotaggio = 1
  return "scritto"
]]))
print(eseguiSicura([[
  return "uso legittimo: " .. string.format("%d", 42)
]]))
print(eseguiSicura([[
  return "anche questo: " .. table.concat({1,2,3}, "-")
]]))
