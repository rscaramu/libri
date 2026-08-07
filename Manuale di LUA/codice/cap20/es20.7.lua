-- ES 20.7 — Tre modi di leggere un file
-- Manuale completo di Lua

local NOME = "/tmp/prova_lettura.txt"
local RIGHE = 100000

local f = assert(io.open(NOME, "w"))
for i = 1, RIGHE do
  f:write("riga numero ", i,
    " con del testo di riempimento\n")
end
f:close()

local function misura(nome, funzione)
  collectgarbage("collect")
  collectgarbage("collect")
  local memPrima = collectgarbage("count")
  local inizio = os.clock()
  local quante = funzione()
  local durata = os.clock() - inizio
  local memDopo = collectgarbage("count")
  print(string.format(
    "%-24s %.4f s  %8.0f KB  righe=%d",
    nome, durata, memDopo - memPrima, quante))
end

misura("read('a') + gmatch", function()
  local file = assert(io.open(NOME, "r"))
  local tutto = file:read("a")
  file:close()
  local n = 0
  for _ in tutto:gmatch("[^\n]+") do n = n + 1 end
  return n
end)

misura("lines() in un ciclo", function()
  local n = 0
  for _ in io.lines(NOME) do n = n + 1 end
  return n
end)

misura("read(N) a blocchi", function()
  local file = assert(io.open(NOME, "rb"))
  local n = 0
  local resto = ""
  while true do
    local pezzo = file:read(65536)
    if pezzo == nil then break end
    local dati = resto .. pezzo
    local ultimo = 1
    while true do
      local i = dati:find("\n", ultimo, true)
      if i == nil then break end
      n = n + 1
      ultimo = i + 1
    end
    resto = dati:sub(ultimo)
  end
  if #resto > 0 then n = n + 1 end
  file:close()
  return n
end)

os.remove(NOME)
