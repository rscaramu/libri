-- ES 22.4 — Permutazioni come iteratore
-- Manuale completo di Lua

local function permutazioni(sequenza)
  local n = #sequenza

  return coroutine.wrap(function()
    local corrente = {}
    local usati = {}

    local function passo(profondita)
      if profondita > n then
        local copia = {}
        table.move(corrente, 1, n, 1, copia)
        coroutine.yield(copia)
        return
      end
      for i = 1, n do
        if not usati[i] then
          usati[i] = true
          corrente[profondita] = sequenza[i]
          passo(profondita + 1)
          usati[i] = false
        end
      end
    end

    passo(1)
  end)
end

local function testo(t)
  return table.concat(t, "")
end

io.write("tutte le permutazioni di abc: ")
for p in permutazioni({"a", "b", "c"}) do
  io.write(testo(p), " ")
end
io.write("\n")

-- Ricerca con interruzione
local numeri = {1, 2, 3, 4, 5, 6, 7}
local esaminate = 0
local trovata = nil

for p in permutazioni(numeri) do
  esaminate = esaminate + 1
  -- Cerchiamo la prima permutazione in cui
  -- ogni elemento e' diverso dalla sua posizione
  local ok = true
  for i = 1, #p do
    if p[i] == i then ok = false break end
  end
  if ok then
    trovata = p
    break
  end
end

print("permutazioni esaminate: " .. esaminate)
print("trovata: " .. table.concat(trovata, " "))

local totali = 1
for i = 2, #numeri do totali = totali * i end
print("permutazioni totali possibili: " .. totali)
print(string.format("risparmio: %.2f%%",
  (1 - esaminate / totali) * 100))
