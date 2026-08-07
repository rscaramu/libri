-- ES 28.6 — Usare una libreria dell’ecosistema
-- Manuale completo di Lua

local lfs = require("lfs")

-- 1. Elencare una cartella
print("=== contenuto della cartella corrente ===")
for voce in lfs.dir(".") do
  if voce ~= "." and voce ~= ".." then
    local attributi = lfs.attributes(voce)
    if attributi then
      print(string.format("  %-30s %-10s %10d",
        voce, attributi.mode, attributi.size))
    end
  end
end

-- 2. Attributi completi di un file
print()
print("=== attributi ===")
local a = lfs.attributes("/etc/hosts")
if a then
  print("  modo:       " .. a.mode)
  print("  dimensione: " .. a.size)
  print("  modificato: "
    .. os.date("%Y-%m-%d %H:%M", a.modification))
  print("  permessi:   " .. tostring(a.permissions))
end

-- 3. Creare e rimuovere cartelle
print()
print("=== creazione ===")
local percorso = "/tmp/prova_lfs/annidata"
print("  mkdir ricorsivo a mano:")
local parziale = ""
for pezzo in percorso:gmatch("[^/]+") do
  parziale = parziale .. "/" .. pezzo
  local esiste = lfs.attributes(parziale, "mode")
  if esiste == nil then
    local ok, errore = lfs.mkdir(parziale)
    print("    creata " .. parziale .. ": "
      .. tostring(ok))
  end
end

-- 4. Cartella corrente
print()
print("=== cartella corrente ===")
local prima = lfs.currentdir()
print("  prima: " .. prima)
lfs.chdir("/tmp")
print("  dopo:  " .. lfs.currentdir())
lfs.chdir(prima)

-- 5. Ricorsione su un albero
print()
print("=== scansione ricorsiva ===")
local function scandisci(radice, profondita, fuori)
  fuori = fuori or {}
  profondita = profondita or 0
  if profondita > 5 then return fuori end

  for voce in lfs.dir(radice) do
    if voce ~= "." and voce ~= ".." then
      local completo = radice .. "/" .. voce
      local modo = lfs.attributes(completo, "mode")
      if modo == "directory" then
        fuori[#fuori + 1] = {tipo = "d",
          percorso = completo}
        scandisci(completo, profondita + 1, fuori)
      elseif modo == "file" then
        fuori[#fuori + 1] = {tipo = "f",
          percorso = completo}
      end
    end
  end
  return fuori
end

local voci = scandisci("/tmp/prova_lfs")
for _, v in ipairs(voci) do
  print("  " .. v.tipo .. " " .. v.percorso)
end

lfs.rmdir("/tmp/prova_lfs/annidata")
lfs.rmdir("/tmp/prova_lfs")
