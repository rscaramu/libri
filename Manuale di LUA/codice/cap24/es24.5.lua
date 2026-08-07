-- ES 24.5 — Motore di modelli compilato una volta
-- Manuale completo di Lua

local function compila(modello)
  local pezzi = {"local _r = {}\n"}
  local posizione = 1

  while true do
    local inizio, fine, espressione =
      modello:find("{{(.-)}}", posizione)
    if inizio == nil then break end

    local testo = modello:sub(posizione, inizio - 1)
    if #testo > 0 then
      pezzi[#pezzi + 1] = string.format(
        "_r[#_r+1] = %q\n", testo)
    end
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = tostring(%s)\n", espressione)
    posizione = fine + 1
  end

  local coda = modello:sub(posizione)
  if #coda > 0 then
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = %q\n", coda)
  end
  pezzi[#pezzi + 1] = "return table.concat(_r)\n"

  local sorgente = table.concat(pezzi)

  -- COMPILAZIONE UNA VOLTA SOLA
  local ambiente = {tostring = tostring, table = table}
  local funzione, errore = load(sorgente, "modello",
    "t", ambiente)
  if funzione == nil then
    return nil, errore
  end

  -- Trova l'indice dell'upvalue _ENV
  local indiceEnv
  for i = 1, math.huge do
    local nome = debug.getupvalue(funzione, i)
    if nome == nil then break end
    if nome == "_ENV" then indiceEnv = i break end
  end

  return function(dati)
    local suo = setmetatable(
      {tostring = tostring, table = table},
      {__index = dati})
    debug.setupvalue(funzione, indiceEnv, suo)
    return funzione()
  end
end

local function compilaOgniVolta(modello)
  -- Versione dell'ES precedente: ricompila a ogni resa
  local pezzi = {"local _r = {}\n"}
  local posizione = 1
  while true do
    local inizio, fine, espressione =
      modello:find("{{(.-)}}", posizione)
    if inizio == nil then break end
    local testo = modello:sub(posizione, inizio - 1)
    if #testo > 0 then
      pezzi[#pezzi + 1] = string.format(
        "_r[#_r+1] = %q\n", testo)
    end
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = tostring(%s)\n", espressione)
    posizione = fine + 1
  end
  local coda = modello:sub(posizione)
  if #coda > 0 then
    pezzi[#pezzi + 1] = string.format(
      "_r[#_r+1] = %q\n", coda)
  end
  pezzi[#pezzi + 1] = "return table.concat(_r)\n"
  local sorgente = table.concat(pezzi)

  return function(dati)
    local ambiente = setmetatable(
      {tostring = tostring, table = table},
      {__index = dati})
    local f = load(sorgente, "modello", "t", ambiente)
    return f()
  end
end

local MODELLO = "Gentile {{nome}}, il totale e' "
  .. "{{totale}} euro, con sconto {{totale * 0.1}}."

local veloce = compila(MODELLO)
local lenta = compilaOgniVolta(MODELLO)

local DATI = {nome = "Anna", totale = 250}

print(veloce(DATI))
print(lenta(DATI))
print("stesso risultato: "
  .. tostring(veloce(DATI) == lenta(DATI)))

local N = 10000

for _, p in ipairs({{"compilata una volta", veloce},
    {"ricompilata ogni volta", lenta}}) do
  collectgarbage("collect")
  local inizio = os.clock()
  local ultimo
  for i = 1, N do
    ultimo = p[2](DATI)
  end
  local durata = os.clock() - inizio
  print(string.format("%-26s %.4f s  (%d rese)",
    p[1], durata, N))
end
