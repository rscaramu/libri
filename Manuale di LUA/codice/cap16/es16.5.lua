-- ES 16.5 — Ispezionare l’ambiente dei moduli
-- Manuale completo di Lua

local function elencaCaricati()
  local nomi = {}
  for nome in pairs(package.loaded) do
    nomi[#nomi + 1] = nome
  end
  table.sort(nomi)
  return nomi
end

local function insieme(elenco)
  local s = {}
  for _, v in ipairs(elenco) do s[v] = true end
  return s
end

print("=== package.path ===")
for percorso in package.path:gmatch("[^;]+") do
  print("  " .. percorso)
end

print()
print("=== package.cpath ===")
for percorso in package.cpath:gmatch("[^;]+") do
  print("  " .. percorso)
end

print()
print("=== moduli caricati all'avvio ===")
local prima = elencaCaricati()
for _, n in ipairs(prima) do print("  " .. n) end
print("  totale: " .. #prima)

package.preload["mio.modulo"] = function()
  return {versione = "1.0"}
end
package.preload["mio.altro"] = function()
  return {}
end

local m = require("mio.modulo")

print()
print("=== dopo require('mio.modulo') ===")
local dopo = elencaCaricati()
local eraPresente = insieme(prima)
for _, n in ipairs(dopo) do
  if not eraPresente[n] then
    print("  NUOVO: " .. n)
  end
end
print("  totale: " .. #dopo)

print()
print("mio.altro registrato in preload ma non caricato: "
  .. tostring(package.loaded["mio.altro"]))
print("package.preload ha mio.altro: "
  .. tostring(package.preload["mio.altro"] ~= nil))
print("cercatori registrati: " .. #package.searchers)
print("separatori (package.config, prima riga): "
  .. package.config:match("^[^\n]+"))
