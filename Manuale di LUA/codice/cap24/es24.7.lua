-- ES 24.7 — Tracciatore di copertura
-- Manuale completo di Lua

local Copertura = {}
Copertura.__index = Copertura

function Copertura.nuova(filtro)
  return setmetatable({
    filtro = filtro,
    eseguite = {},
    attiva = false,
  }, Copertura)
end

function Copertura:avvia()
  if self.attiva then return self end
  self.attiva = true
  local eseguite = self.eseguite
  local filtro = self.filtro

  debug.sethook(function(_, riga)
    local info = debug.getinfo(2, "S")
    if info == nil then return end
    local sorgente = info.short_src
    if filtro and not sorgente:find(filtro, 1, true) then
      return
    end
    local perFile = eseguite[sorgente]
    if perFile == nil then
      perFile = {}
      eseguite[sorgente] = perFile
    end
    perFile[riga] = (perFile[riga] or 0) + 1
  end, "l")

  return self
end

function Copertura:ferma()
  debug.sethook()
  self.attiva = false
  return self
end

function Copertura:rapporto(sorgente, testo)
  local perFile = self.eseguite[sorgente] or {}
  local righe = {}
  local numero = 0
  local eseguibili, coperte = 0, 0

  for riga in (testo .. "\n"):gmatch("(.-)\n") do
    numero = numero + 1
    local pulita = riga:match("^%s*(.-)%s*$")
    local eseguibile = pulita ~= ""
      and not pulita:match("^%-%-")
      and pulita ~= "end"
      and pulita ~= "else"
      and not pulita:match("^local function")
      and not pulita:match("^function")

    local quante = perFile[numero]
    local marcatore

    if quante then
      marcatore = string.format("%4dx", quante)
      coperte = coperte + 1
      eseguibili = eseguibili + 1
    elseif eseguibile then
      marcatore = "  !!!"
      eseguibili = eseguibili + 1
    else
      marcatore = "     "
    end

    righe[#righe + 1] = string.format("%s %3d| %s",
      marcatore, numero, riga)
  end

  local percentuale = 0
  if eseguibili > 0 then
    percentuale = coperte / eseguibili * 100
  end

  righe[#righe + 1] = ""
  righe[#righe + 1] = string.format(
    "copertura: %d/%d righe (%.1f%%)",
    coperte, eseguibili, percentuale)

  return table.concat(righe, "\n")
end

local SORGENTE = [[
local function classifica(n)
  if n < 0 then
    return "negativo"
  elseif n == 0 then
    return "zero"
  elseif n < 10 then
    return "piccolo"
  else
    return "grande"
  end
end

local risultati = {}
for _, v in ipairs({5, 0, 100}) do
  risultati[#risultati + 1] = classifica(v)
end
return table.concat(risultati, " ")
]]

local NOME = "/tmp/copertura_prova.lua"
local f = assert(io.open(NOME, "w"))
f:write(SORGENTE)
f:close()

local chunk = assert(loadfile(NOME))

local c = Copertura.nuova("copertura_prova")
c:avvia()
local risultato = chunk()
c:ferma()

print("risultato: " .. tostring(risultato))
print()
print(c:rapporto(NOME, SORGENTE))

os.remove(NOME)
