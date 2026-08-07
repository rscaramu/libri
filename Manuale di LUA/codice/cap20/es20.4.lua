-- ES 20.4 — Copia a blocchi
-- Manuale completo di Lua

local function copia(origine, destinazione, opzioni)
  opzioni = opzioni or {}
  local blocco = opzioni.blocco or 65536

  local ingresso, err1 = io.open(origine, "rb")
  if ingresso == nil then
    return nil, "lettura: " .. err1
  end
  local chiudiIngresso <close> = ingresso

  local uscita, err2 = io.open(destinazione, "wb")
  if uscita == nil then
    return nil, "scrittura: " .. err2
  end
  local chiudiUscita <close> = uscita

  local totale = 0
  while true do
    local pezzo = ingresso:read(blocco)
    if pezzo == nil or #pezzo == 0 then break end
    local ok, err3 = uscita:write(pezzo)
    if ok == nil then
      return nil, "scrittura interrotta: "
        .. tostring(err3)
    end
    totale = totale + #pezzo
  end

  uscita:flush()
  return totale
end

-- Prepariamo un file di prova di 5 MB
local NOME = "/tmp/prova_copia.bin"
local COPIA = "/tmp/prova_copia_2.bin"

local f = assert(io.open(NOME, "wb"))
local riempimento = string.rep("0123456789", 1024)
for _ = 1, 512 do f:write(riempimento) end
f:close()

for _, blocco in ipairs({1024, 65536, 1048576}) do
  collectgarbage("collect")
  local prima = collectgarbage("count")
  local inizio = os.clock()
  local byte, errore = copia(NOME, COPIA,
    {blocco = blocco})
  local durata = os.clock() - inizio
  local dopo = collectgarbage("count")

  if byte then
    print(string.format(
      "blocco %8d: %d byte, %.4f s, %+.0f KB",
      blocco, byte, durata, dopo - prima))
  else
    print("errore: " .. errore)
  end
end

print(copia("/non/esiste", COPIA))
print(copia(NOME, "/percorso/inesistente/x"))

os.remove(NOME)
os.remove(COPIA)
