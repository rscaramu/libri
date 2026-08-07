-- ES 21.7 — Gerarchia di errori a due livelli
-- Manuale completo di Lua

local ErroreBase = {}
ErroreBase.__index = ErroreBase
ErroreBase.__nome = "Errore"
ErroreBase.__tostring = function(e)
  return string.format("[%s] %s", e.tipo, e.messaggio)
end

local function creaTipo(nome, base)
  local T = setmetatable({}, {__index = base})
  T.__index = T
  T.__nome = nome
  T.__tostring = ErroreBase.__tostring
  T.super = base

  T.nuovo = function(messaggio, dettagli)
    return setmetatable({
      tipo = nome,
      messaggio = messaggio,
      dettagli = dettagli,
    }, T)
  end

  return T
end

local ErroreApplicazione = creaTipo("Applicazione",
  ErroreBase)
local ErroreRete = creaTipo("Rete", ErroreApplicazione)
local ErroreDati = creaTipo("Dati", ErroreApplicazione)
local ErroreAutenticazione = creaTipo("Autenticazione",
  ErroreApplicazione)

local function eDiTipo(valore, tipo)
  if type(valore) ~= "table" then return false end
  local m = getmetatable(valore)
  while m do
    if m == tipo then return true end
    m = m.super
  end
  return false
end

local function operazione(quale)
  if quale == "rete" then
    error(ErroreRete.nuovo("connessione rifiutata",
      {host = "example.com"}))
  elseif quale == "dati" then
    error(ErroreDati.nuovo("record malformato",
      {riga = 42}))
  elseif quale == "auth" then
    error(ErroreAutenticazione.nuovo("token scaduto"))
  elseif quale == "generico" then
    error("errore non strutturato")
  end
  return "tutto bene"
end

for _, quale in ipairs({"ok", "rete", "dati", "auth",
    "generico"}) do
  local ok, e = pcall(operazione, quale)

  if ok then
    print(string.format("%-10s -> %s", quale, e))

  elseif eDiTipo(e, ErroreRete) then
    print(string.format("%-10s -> gestito come rete: "
      .. "%s (host %s)", quale, tostring(e),
      tostring(e.dettagli and e.dettagli.host)))

  elseif eDiTipo(e, ErroreDati) then
    print(string.format("%-10s -> gestito come dati: "
      .. "%s (riga %s)", quale, tostring(e),
      tostring(e.dettagli and e.dettagli.riga)))

  elseif eDiTipo(e, ErroreApplicazione) then
    print(string.format("%-10s -> non gestito qui, "
      .. "rilancio: %s", quale, tostring(e)))

  else
    print(string.format("%-10s -> errore esterno: %s",
      quale, tostring(e)))
  end
end

print()
print("verifiche di appartenenza:")
local e = ErroreRete.nuovo("x")
print("  Rete e' Rete:          "
  .. tostring(eDiTipo(e, ErroreRete)))
print("  Rete e' Applicazione:  "
  .. tostring(eDiTipo(e, ErroreApplicazione)))
print("  Rete e' Base:          "
  .. tostring(eDiTipo(e, ErroreBase)))
print("  Rete e' Dati:          "
  .. tostring(eDiTipo(e, ErroreDati)))
