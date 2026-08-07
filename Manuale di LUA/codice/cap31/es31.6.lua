-- ES 31.6 — Salvataggio e caricamento
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local Salvataggio = {}

local VERSIONE = 3
local NOME = "salvataggio.lua"

local function serializza(v, livello)
  livello = livello or 0
  local t = type(v)

  if t == "nil" or t == "boolean" or t == "number" then
    return tostring(v)
  end
  if t == "string" then
    return string.format("%q", v)
  end
  if t ~= "table" then
    return nil, "tipo non serializzabile: " .. t
  end

  local dentro = string.rep("  ", livello + 1)
  local pezzi = {}
  local n = #v

  for i = 1, n do
    local s, e = serializza(v[i], livello + 1)
    if s == nil then return nil, e end
    pezzi[#pezzi + 1] = dentro .. s
  end

  local chiavi = {}
  for k in pairs(v) do
    local numerica = type(k) == "number"
      and k == math.floor(k) and k >= 1 and k <= n
    if not numerica then chiavi[#chiavi + 1] = k end
  end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)

  for _, k in ipairs(chiavi) do
    local sv, e = serializza(v[k], livello + 1)
    if sv == nil then return nil, e end
    local sk
    if type(k) == "string"
       and k:match("^[%a_][%w_]*$") then
      sk = k
    else
      sk = "[" .. serializza(k) .. "]"
    end
    pezzi[#pezzi + 1] = dentro .. sk .. " = " .. sv
  end

  if #pezzi == 0 then return "{}" end
  return "{\n" .. table.concat(pezzi, ",\n") .. "\n"
    .. string.rep("  ", livello) .. "}"
end

local MIGRAZIONI = {
  [1] = function(dati)
    -- v1 -> v2: il punteggio era una stringa
    dati.punteggio = tonumber(dati.punteggio) or 0
    dati.versione = 2
    return dati
  end,
  [2] = function(dati)
    -- v2 -> v3: introdotte le statistiche
    dati.statistiche = dati.statistiche or {
      partite = 0, tempoTotale = 0,
    }
    dati.versione = 3
    return dati
  end,
}

function Salvataggio.scrivi(stato)
  local dati = {
    versione = VERSIONE,
    salvatoIl = os.time(),
    punteggio = stato.punteggio or 0,
    livello = stato.livello or 1,
    vite = stato.vite or 3,
    sbloccati = stato.sbloccati or {},
    statistiche = stato.statistiche or {
      partite = 0, tempoTotale = 0,
    },
  }

  local testo, errore = serializza(dati)
  if testo == nil then
    return nil, "serializzazione: " .. errore
  end

  local temporaneo = NOME .. ".tmp"
  local ok, err = love.filesystem.write(temporaneo,
    "return " .. testo .. "\n")
  if not ok then
    return nil, "scrittura fallita: " .. tostring(err)
  end

  -- LOVE non ha rename: si rimuove e si riscrive.
  -- Non e' atomico, ma il file temporaneo permette
  -- di accorgersi di un salvataggio interrotto.
  love.filesystem.remove(NOME)
  local contenuto = love.filesystem.read(temporaneo)
  love.filesystem.write(NOME, contenuto)
  love.filesystem.remove(temporaneo)

  return true
end

function Salvataggio.leggi()
  if not love.filesystem.getInfo(NOME) then
    return nil, "nessun salvataggio"
  end

  local testo = love.filesystem.read(NOME)
  if testo == nil then
    return nil, "file illeggibile"
  end

  local chunk, errore = load(testo, "salvataggio",
    "t", {})
  if chunk == nil then
    return nil, "salvataggio corrotto: " .. errore
  end

  local ok, dati = pcall(chunk)
  if not ok then
    return nil, "salvataggio corrotto: "
      .. tostring(dati)
  end
  if type(dati) ~= "table" then
    return nil, "salvataggio malformato"
  end

  local versione = tonumber(dati.versione) or 1
  if versione > VERSIONE then
    return nil, string.format(
      "salvataggio di versione %d, questo gioco "
      .. "arriva alla %d", versione, VERSIONE)
  end

  while versione < VERSIONE do
    local migrazione = MIGRAZIONI[versione]
    if migrazione == nil then
      return nil, "nessuna migrazione da " .. versione
    end
    dati = migrazione(dati)
    versione = dati.versione
  end

  if type(dati.punteggio) ~= "number" then
    dati.punteggio = 0
  end
  if type(dati.vite) ~= "number" or dati.vite < 0 then
    dati.vite = 3
  end
  if type(dati.sbloccati) ~= "table" then
    dati.sbloccati = {}
  end

  return dati
end

return Salvataggio
