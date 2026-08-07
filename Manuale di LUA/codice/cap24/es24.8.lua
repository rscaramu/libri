-- ES 24.8 — Generatore di costruttori compilati
-- Manuale completo di Lua

local function generaCostruttore(nome, campi)
  local righe = {
    "local setmetatable, type, error, format = ...",
    "local M = {}",
    "M.__index = M",
    "M.__nome = " .. string.format("%q", nome),
    "return M, function(dati)",
    "  dati = dati or {}",
  }

  for _, c in ipairs(campi) do
    local chiave = string.format("%q", c.nome)

    if c.obbligatorio then
      righe[#righe + 1] = string.format(
        "  if dati[%s] == nil then return nil, "
        .. "%q end", chiave,
        nome .. ": campo obbligatorio " .. c.nome)
    end

    if c.tipo then
      righe[#righe + 1] = string.format(
        "  if dati[%s] ~= nil and type(dati[%s]) "
        .. "~= %q then return nil, format(%q, "
        .. "type(dati[%s])) end",
        chiave, chiave, c.tipo,
        nome .. ": " .. c.nome .. " deve essere "
          .. c.tipo .. ", ricevuto %s", chiave)
    end
  end

  righe[#righe + 1] = "  return setmetatable({"
  for _, c in ipairs(campi) do
    local chiave = string.format("%q", c.nome)
    if c.predefinito ~= nil then
      righe[#righe + 1] = string.format(
        "    [%s] = dati[%s] ~= nil and dati[%s] "
        .. "or %s,", chiave, chiave, chiave,
        type(c.predefinito) == "string"
          and string.format("%q", c.predefinito)
          or tostring(c.predefinito))
    else
      righe[#righe + 1] = string.format(
        "    [%s] = dati[%s],", chiave, chiave)
    end
  end
  righe[#righe + 1] = "  }, M)"
  righe[#righe + 1] = "end"

  local sorgente = table.concat(righe, "\n")
  local chunk, errore = load(sorgente,
    "costruttore:" .. nome, "t")
  if chunk == nil then
    return nil, errore .. "\n--- sorgente ---\n"
      .. sorgente
  end

  return chunk(setmetatable, type, error, string.format)
end

local function costruttoreGenerico(nome, campi)
  local M = {}
  M.__index = M
  M.__nome = nome
  return M, function(dati)
    dati = dati or {}
    for _, c in ipairs(campi) do
      local v = dati[c.nome]
      if v == nil and c.obbligatorio then
        return nil, nome .. ": campo obbligatorio "
          .. c.nome
      end
      if v ~= nil and c.tipo
         and type(v) ~= c.tipo then
        return nil, string.format(
          "%s: %s deve essere %s, ricevuto %s",
          nome, c.nome, c.tipo, type(v))
      end
    end
    local istanza = {}
    for _, c in ipairs(campi) do
      local v = dati[c.nome]
      if v == nil then v = c.predefinito end
      istanza[c.nome] = v
    end
    return setmetatable(istanza, M)
  end
end

local CAMPI = {
  {nome = "nome", tipo = "string", obbligatorio = true},
  {nome = "eta", tipo = "number", predefinito = 0},
  {nome = "attivo", tipo = "boolean",
   predefinito = true},
}

local _, creaCompilato = generaCostruttore("Utente",
  CAMPI)
local _, creaGenerico = costruttoreGenerico("Utente",
  CAMPI)

local u = creaCompilato({nome = "Anna", eta = 34})
print(u.nome, u.eta, u.attivo)

print(creaCompilato({}))
print(creaCompilato({nome = "x", eta = "trenta"}))
print(creaGenerico({}))

local N = 500000
for _, p in ipairs({{"compilato", creaCompilato},
    {"generico", creaGenerico}}) do
  collectgarbage("collect")
  local inizio = os.clock()
  for i = 1, N do
    p[2]({nome = "x", eta = i})
  end
  print(string.format("%-12s %.4f s", p[1],
    os.clock() - inizio))
end
