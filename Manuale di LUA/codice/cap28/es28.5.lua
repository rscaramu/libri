-- ES 28.5 — Verifica dell’ambiente
-- Manuale completo di Lua

local function esegui(comando)
  local f = io.popen(comando .. " 2>&1")
  if f == nil then return nil end
  local uscita = f:read("a")
  f:close()
  return (uscita:gsub("%s+$", ""))
end

local function analizzaRockspec(percorso)
  local f = io.open(percorso, "r")
  if f == nil then
    return nil, "rockspec non leggibile: " .. percorso
  end
  local testo = f:read("a")
  f:close()

  local ambiente = {}
  local chunk, errore = load(testo, "rockspec", "t",
    ambiente)
  if chunk == nil then
    return nil, "rockspec malformato: " .. errore
  end
  local ok, err = pcall(chunk)
  if not ok then
    return nil, "rockspec non eseguibile: "
      .. tostring(err)
  end

  return ambiente
end

local function confrontaVersioni(a, b)
  local ma, na = a:match("(%d+)%.(%d+)")
  local mb, nb = b:match("(%d+)%.(%d+)")
  if ma == nil or mb == nil then return nil end
  ma, na = tonumber(ma), tonumber(na)
  mb, nb = tonumber(mb), tonumber(nb)
  if ma ~= mb then return ma < mb and -1 or 1 end
  if na ~= nb then return na < nb and -1 or 1 end
  return 0
end

local problemi = {}
local avvisi = {}

print("=== ambiente Lua ===")
print("  _VERSION:        " .. _VERSION)
local versioneLua = _VERSION:match("(%d+%.%d+)")

local percorsi = 0
for _ in package.path:gmatch("[^;]+") do
  percorsi = percorsi + 1
end
print("  voci in package.path:  " .. percorsi)

local cpercorsi = 0
for _ in package.cpath:gmatch("[^;]+") do
  cpercorsi = cpercorsi + 1
end
print("  voci in package.cpath: " .. cpercorsi)

print()
print("=== LuaRocks ===")
local versioneRocks = esegui("luarocks --version")
if versioneRocks == nil
   or versioneRocks:find("not found") then
  problemi[#problemi + 1] = "luarocks non trovato "
    .. "nel PATH"
  print("  NON TROVATO")
else
  print("  " .. (versioneRocks:match("^[^\n]+") or "?"))

  local versioneConfigurata = esegui(
    "luarocks config lua_version")
  print("  configurato per Lua: "
    .. tostring(versioneConfigurata))

  if versioneConfigurata
     and versioneConfigurata ~= versioneLua then
    problemi[#problemi + 1] = string.format(
      "DISCORDANZA: luarocks e' configurato per Lua "
      .. "%s ma l'interprete e' %s",
      versioneConfigurata, versioneLua)
  end
end

print()
print("=== dipendenze dichiarate ===")

local ROCKSPEC = "/tmp/verifica_ambiente.rockspec"
local f = assert(io.open(ROCKSPEC, "w"))
f:write([[
package = "esempio"
version = "1.0.0-1"
source = {url = "git+https://example.com/x.git"}
dependencies = {
  "lua >= 5.3",
  "luafilesystem >= 1.8",
  "dkjson >= 2.5",
  "inspect",
}
build = {type = "builtin", modules = {}}
]])
f:close()

local spec, errore = analizzaRockspec(ROCKSPEC)
if spec == nil then
  problemi[#problemi + 1] = errore
else
  for _, dichiarata in ipairs(spec.dependencies or {}) do
    local nome, vincolo =
      dichiarata:match("^(%S+)%s*(.*)$")

    if nome == "lua" then
      local minimo = vincolo:match("(%d+%.%d+)")
      local esito = "?"
      if minimo then
        local c = confrontaVersioni(versioneLua, minimo)
        if c == nil then
          esito = "vincolo non interpretabile"
        elseif c < 0 then
          esito = "NON SODDISFATTO"
          problemi[#problemi + 1] = string.format(
            "serve Lua %s, presente %s",
            minimo, versioneLua)
        else
          esito = "ok"
        end
      end
      print(string.format("  %-18s %-14s %s",
        nome, vincolo, esito))
    else
      local ok = pcall(require, nome)
      if not ok then
        avvisi[#avvisi + 1] = "modulo non caricabile: "
          .. nome
      end
      print(string.format("  %-18s %-14s %s",
        nome, vincolo,
        ok and "presente" or "ASSENTE"))
    end
  end
end

os.remove(ROCKSPEC)

print()
print("=== esito ===")
if #problemi == 0 then
  print("  nessun problema bloccante")
else
  for _, p in ipairs(problemi) do
    print("  PROBLEMA: " .. p)
  end
end
for _, a in ipairs(avvisi) do
  print("  avviso:   " .. a)
end
