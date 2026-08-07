-- ES 27.8 — Strato di compatibilità per `<close>`
-- Manuale completo di Lua

local haClose = load("local x <close> = nil") ~= nil

local function verificaChiudibile(risorsa)
  if type(risorsa) == "table" then
    local m = getmetatable(risorsa)
    if m and type(m.__close) == "function" then
      return true
    end
    if type(risorsa.chiudi) == "function" then
      return true
    end
  end
  return false, "la risorsa deve avere __close "
    .. "o un metodo chiudi"
end

local function chiudi(risorsa, errore)
  local m = getmetatable(risorsa)
  if m and type(m.__close) == "function" then
    return m.__close(risorsa, errore)
  end
  return risorsa:chiudi(errore)
end

local conRisorsa

if haClose then
  conRisorsa = load([[
    local verifica, chiudi = ...
    return function(costruttore, azione)
      local risorsa, errore = costruttore()
      if risorsa == nil then
        return nil, errore or "costruzione fallita"
      end
      local ok, motivo = verifica(risorsa)
      if not ok then
        -- non si chiude cio' che non e' chiudibile
        return nil, motivo
      end
      local guardia <close> = risorsa
      return azione(risorsa)
    end
  ]])(verificaChiudibile, chiudi)
else
  conRisorsa = function(costruttore, azione)
    local risorsa, errore = costruttore()
    if risorsa == nil then
      return nil, errore or "costruzione fallita"
    end
    local ok, motivo = verificaChiudibile(risorsa)
    if not ok then
      return nil, motivo
    end

    local risultati = table.pack(pcall(azione, risorsa))

    local okChiusura, erroreChiusura = pcall(chiudi,
      risorsa, risultati[1] and nil or risultati[2])

    if not risultati[1] then
      error(risultati[2], 0)
    end
    if not okChiusura then
      error(erroreChiusura, 0)
    end
    return table.unpack(risultati, 2, risultati.n)
  end
end

-- Prove
local eventi = {}

local function creaRisorsa(nome)
  return setmetatable({nome = nome}, {
    __close = function(r, errore)
      eventi[#eventi + 1] = string.format(
        "chiusa %s (errore: %s)", r.nome,
        tostring(errore))
    end,
    __index = {
      usa = function(r) return "uso di " .. r.nome end,
    },
  })
end

print("implementazione: "
  .. (haClose and "nativa con <close>"
    or "simulata con pcall"))
print()

eventi = {}
local r = conRisorsa(
  function() return creaRisorsa("A") end,
  function(risorsa) return risorsa:usa(), "secondo" end)
print("uso normale: " .. tostring(r))
for _, e in ipairs(eventi) do print("  " .. e) end

print()
eventi = {}
local ok, errore = pcall(conRisorsa,
  function() return creaRisorsa("B") end,
  function() error("guasto nell'azione", 0) end)
print("con errore: ok=" .. tostring(ok)
  .. " errore=" .. tostring(errore))
for _, e in ipairs(eventi) do print("  " .. e) end

print()
eventi = {}
print("costruzione fallita: "
  .. tostring(select(2, conRisorsa(
    function() return nil, "risorsa non disponibile" end,
    function() return "mai" end))))

print()
eventi = {}
print("risorsa non chiudibile: "
  .. tostring(select(2, conRisorsa(
    function() return {} end,
    function() return "mai" end))))
