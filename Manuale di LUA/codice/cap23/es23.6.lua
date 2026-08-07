-- ES 23.6 — Memoria trattenuta e transitoria
-- Manuale completo di Lua

local function misuraMemoria(funzione)
  collectgarbage("collect")
  collectgarbage("collect")
  local base = collectgarbage("count")

  local massimo = base
  local risultato = funzione(function()
    local attuale = collectgarbage("count")
    if attuale > massimo then massimo = attuale end
  end)

  local dopoEsecuzione = collectgarbage("count")
  if dopoEsecuzione > massimo then
    massimo = dopoEsecuzione
  end

  collectgarbage("collect")
  collectgarbage("collect")
  local trattenuta = collectgarbage("count") - base

  return {
    trattenuta = trattenuta,
    picco = massimo - base,
    transitoria = massimo - base - trattenuta,
    risultato = risultato,
  }
end

local N = 100000

local strategie = {
  {"concatenazione", function(campiona)
    local s = ""
    for i = 1, N // 10 do
      s = s .. i .. ","
      if i % 1000 == 0 then campiona() end
    end
    return s
  end},

  {"table.concat", function(campiona)
    local pezzi = {}
    for i = 1, N do
      pezzi[#pezzi + 1] = i
      if i % 10000 == 0 then campiona() end
    end
    return table.concat(pezzi, ",")
  end},

  {"table.concat + pulizia", function(campiona)
    local pezzi = {}
    for i = 1, N do
      pezzi[#pezzi + 1] = i
      if i % 10000 == 0 then campiona() end
    end
    local r = table.concat(pezzi, ",")
    pezzi = nil
    collectgarbage("collect")
    return r
  end},
}

print(string.format("%-24s %11s %11s %11s",
  "STRATEGIA", "TRATTENUTA", "PICCO", "TRANSITORIA"))

for _, s in ipairs(strategie) do
  local m = misuraMemoria(s[2])
  print(string.format("%-24s %9.0f KB %9.0f KB %9.0f KB",
    s[1], m.trattenuta, m.picco, m.transitoria))
end
