-- ES 12.5 — Appiattire e ricostruire
-- Manuale completo di Lua

local function appiattisci(t, prefisso, fuori)
  fuori = fuori or {}
  prefisso = prefisso or ""

  local chiavi = {}
  for k in pairs(t) do chiavi[#chiavi + 1] = k end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  for _, k in ipairs(chiavi) do
    local v = t[k]
    local percorso = prefisso
    if percorso == "" then
      percorso = tostring(k)
    else
      percorso = percorso .. "." .. tostring(k)
    end

    if type(v) == "table" and next(v) ~= nil then
      appiattisci(v, percorso, fuori)
    else
      fuori[percorso] = v
    end
  end

  return fuori
end

local function annida(piatto)
  local r = {}
  local percorsi = {}
  for p in pairs(piatto) do percorsi[#percorsi + 1] = p end
  table.sort(percorsi)

  for _, percorso in ipairs(percorsi) do
    local corrente = r
    local pezzi = {}
    for pezzo in percorso:gmatch("[^%.]+") do
      pezzi[#pezzi + 1] = pezzo
    end

    for i = 1, #pezzi - 1 do
      local chiave = tonumber(pezzi[i]) or pezzi[i]
      if type(corrente[chiave]) ~= "table" then
        corrente[chiave] = {}
      end
      corrente = corrente[chiave]
    end

    local ultima = pezzi[#pezzi]
    corrente[tonumber(ultima) or ultima] =
      piatto[percorso]
  end

  return r
end

local originale = {
  nome = "app",
  server = {
    host = "localhost",
    porta = 8080,
    tls = {attivo = true, cert = "/x.pem"},
  },
  moduli = {"a", "b", "c"},
  vuota = {},
}

local piatto = appiattisci(originale)

local percorsi = {}
for p in pairs(piatto) do percorsi[#percorsi + 1] = p end
table.sort(percorsi)
for _, p in ipairs(percorsi) do
  print(string.format("  %-24s %s", p,
    tostring(piatto[p])))
end

print()
local ricostruito = annida(piatto)
print("host: " .. ricostruito.server.host)
print("cert: " .. ricostruito.server.tls.cert)
print("moduli: " .. table.concat(ricostruito.moduli, " "))
print("vuota ricostruita? "
  .. tostring(ricostruito.vuota))
