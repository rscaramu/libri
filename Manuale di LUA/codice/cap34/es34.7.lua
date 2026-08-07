-- ES 34.7 — Persistenza a righe indipendenti
-- Manuale completo di Lua

local Righe = {}
Righe.__index = Righe

local modello = require("src.modello")

local function fuggi(s)
  return (s:gsub("[\\\t\n]", {
    ["\\"] = "\\\\", ["\t"] = "\\t", ["\n"] = "\\n",
  }))
end

local function ripristina(s)
  return (s:gsub("\\(.)", function(c)
    if c == "t" then return "\t" end
    if c == "n" then return "\n" end
    if c == "\\" then return "\\" end
    return c
  end))
end

local CAMPI = {"id", "stato", "priorita", "scadenza",
  "creata", "chiusa", "etichette", "titolo", "note"}

local function serializzaRiga(a)
  local t = a:comeTabella()
  local pezzi = {}
  for _, campo in ipairs(CAMPI) do
    local v = t[campo]
    if campo == "etichette" then
      v = table.concat(v or {}, " ")
    end
    if v == nil then v = "" end
    pezzi[#pezzi + 1] = fuggi(tostring(v))
  end
  return table.concat(pezzi, "\t")
end

local function analizzaRiga(riga)
  local valori = {}
  local posizione = 1
  while true do
    local i = riga:find("\t", posizione, true)
    if i == nil then
      valori[#valori + 1] = riga:sub(posizione)
      break
    end
    valori[#valori + 1] = riga:sub(posizione, i - 1)
    posizione = i + 1
  end

  if #valori ~= #CAMPI then
    return nil, string.format(
      "%d campi invece di %d", #valori, #CAMPI)
  end

  local dati = {}
  for i, campo in ipairs(CAMPI) do
    local v = ripristina(valori[i])
    if v == "" then
      v = nil
    elseif campo == "id" or campo == "creata"
        or campo == "chiusa" then
      v = tonumber(v)
    elseif campo == "etichette" then
      local e = {}
      for pezzo in v:gmatch("%S+") do
        e[#e + 1] = pezzo
      end
      v = e
    end
    dati[campo] = v
  end

  return dati
end

function Righe.nuovo(percorso)
  return setmetatable({
    percorso = percorso,
    attivita = {},
    prossimoId = 1,
    modificato = false,
    scartate = {},
  }, Righe)
end

function Righe:carica()
  local f = io.open(self.percorso, "r")
  if f == nil then return self, {} end

  local numero = 0
  for riga in f:lines() do
    numero = numero + 1
    if riga:match("^%s*$") == nil
       and riga:sub(1, 1) ~= "#" then
      local dati, errore = analizzaRiga(riga)
      if dati == nil then
        self.scartate[#self.scartate + 1] = {
          riga = numero, motivo = errore}
      else
        local a, err = modello.nuova(dati)
        if a == nil then
          self.scartate[#self.scartate + 1] = {
            riga = numero, motivo = err}
        else
          self.attivita[#self.attivita + 1] = a
          if a.id >= self.prossimoId then
            self.prossimoId = a.id + 1
          end
        end
      end
    end
  end
  f:close()

  return self, self.scartate
end

function Righe:salva()
  local f, errore = io.open(self.percorso, "w")
  if f == nil then return nil, errore end
  local chiudi <close> = f

  f:write("# ", table.concat(CAMPI, "\t"), "\n")
  for _, a in ipairs(self.attivita) do
    f:write(serializzaRiga(a), "\n")
  end
  f:flush()

  self.modificato = false
  return self, #self.attivita
end

return Righe
