-- ES 20.5 — Unire più file
-- Manuale completo di Lua

local function unisci(elenco, destinazione)
  local uscita, err = io.open(destinazione, "w")
  if uscita == nil then
    return nil, "impossibile scrivere: " .. err
  end
  local chiudi <close> = uscita

  local uniti, saltati = 0, 0
  local righeTotali = 0

  for _, nome in ipairs(elenco) do
    local ingresso, errAperto = io.open(nome, "r")
    if ingresso == nil then
      io.stderr:write("avviso: salto '", nome,
        "': ", tostring(errAperto), "\n")
      saltati = saltati + 1
    else
      local righe = {}
      for riga in ingresso:lines() do
        righe[#righe + 1] = riga
      end
      ingresso:close()

      uscita:write(string.rep("=", 60), "\n")
      uscita:write("FILE:  ", nome, "\n")
      uscita:write("RIGHE: ", #righe, "\n")
      uscita:write(string.rep("=", 60), "\n")
      for _, riga in ipairs(righe) do
        uscita:write(riga, "\n")
      end
      uscita:write("\n")

      uniti = uniti + 1
      righeTotali = righeTotali + #righe
    end
  end

  return {
    uniti = uniti,
    saltati = saltati,
    righe = righeTotali,
  }
end

local BASE = "/tmp/unione_"
for i = 1, 3 do
  local f = assert(io.open(BASE .. i .. ".txt", "w"))
  for j = 1, i * 2 do
    f:write("file ", i, " riga ", j, "\n")
  end
  f:close()
end

local risultato, errore = unisci({
  BASE .. "1.txt",
  BASE .. "mancante.txt",
  BASE .. "2.txt",
  BASE .. "3.txt",
}, "/tmp/unione_totale.txt")

if risultato then
  print(string.format(
    "uniti=%d saltati=%d righe=%d",
    risultato.uniti, risultato.saltati,
    risultato.righe))
end

local n = 0
for riga in io.lines("/tmp/unione_totale.txt") do
  n = n + 1
  if n <= 6 then print("  " .. riga) end
end
print("  ... totale " .. n .. " righe nel risultato")

for i = 1, 3 do os.remove(BASE .. i .. ".txt") end
os.remove("/tmp/unione_totale.txt")
