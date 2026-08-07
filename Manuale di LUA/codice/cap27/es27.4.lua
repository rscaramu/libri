-- ES 27.4 — Rapporto delle differenze fra implementazioni
-- Manuale completo di Lua

local function prova(nome, codice)
  local f, errore = load("return " .. codice)
  if f == nil then
    f, errore = load(codice)
  end
  if f == nil then
    return nome, "ERRORE DI SINTASSI"
  end
  local ok, r = pcall(f)
  if not ok then
    return nome, "errore: " .. tostring(r)
  end
  return nome, tostring(r)
end

local CASI = {
  {"presenza di math.type", "math.type ~= nil"},
  {"math.type(1)", "math.type and math.type(1)"},
  {"math.type(1.0)", "math.type and math.type(1.0)"},
  {"1/0", "1/0"},
  {"-1/0", "-1/0"},
  {"0/0 e' NaN", "0/0 ~= 0/0"},
  {"3/1", "3/1"},
  {"2^2", "2^2"},
  {"math.floor(2^53)", "math.floor(2^53)"},
  {"2^53 == 2^53+1", "2^53 == 2^53+1"},
  {"maxinteger", "math.maxinteger"},
  {"maxinteger + 1", "math.maxinteger and " ..
    "math.maxinteger + 1"},
  {"table.pack presente", "table.pack ~= nil"},
  {"unpack globale", "rawget(_G, 'unpack') ~= nil"},
  {"table.unpack presente", "table.unpack ~= nil"},
  {"format %q su 1/3", "string.format('%q', 1/3)"},
  {"format %q su a\\nb",
    "string.format('%q', 'a\\nb')"},
  {"tostring(0.1)", "tostring(0.1)"},
  {"tostring(1e300*1e300)", "tostring(1e300*1e300)"},
  {"utf8 presente", "utf8 ~= nil"},
  {"bit presente", "rawget(_G, 'bit') ~= nil"},
  {"jit presente", "rawget(_G, 'jit') ~= nil"},
  {"setfenv presente",
    "rawget(_G, 'setfenv') ~= nil"},
  {"divisione intera", "17 // 5"},
  {"operatore and bit a bit", "5 & 3"},
  {"attributo const", "local x <const> = 1 return x"},
  {"goto", "do goto x ::x:: end return 'ok'"},
  {"_ENV", "_ENV ~= nil"},
  {"warn presente", "rawget(_G, 'warn') ~= nil"},
  {"coroutine.close", "coroutine.close ~= nil"},
  {"table.create", "table.create ~= nil"},
  {"os.date campo isdst",
    "tostring(os.date('*t').isdst)"},
}

print("_VERSION = " .. _VERSION)
local j = rawget(_G, "jit")
if j then print("jit.version = " .. j.version) end
print(string.rep("-", 56))

for _, c in ipairs(CASI) do
  local nome, risultato = prova(c[1], c[2])
  print(string.format("%-26s %s", nome, risultato))
end
