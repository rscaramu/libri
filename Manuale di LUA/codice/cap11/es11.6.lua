-- ES 11.6 — Iteratore a passo k senza stato
-- Manuale completo di Lua

local function passoAvanti(stato, i)
  i = i + stato.passo
  if i > stato.fine then return nil end
  return i, stato.sequenza[i]
end

local function aPasso(sequenza, k, da)
  if math.type(k) ~= "integer" or k < 1 then
    error("il passo deve essere un intero >= 1", 2)
  end
  da = da or 1
  local stato = {
    sequenza = sequenza,
    passo = k,
    fine = #sequenza,
  }
  return passoAvanti, stato, da - k
end

local numeri = {}
for i = 1, 20 do numeri[i] = i * i end

io.write("passo 1: ")
for _, v in aPasso(numeri, 1) do io.write(v, " ") end
io.write("\n")

io.write("passo 3: ")
for i, v in aPasso(numeri, 3) do
  io.write("[", i, "]=", v, " ")
end
io.write("\n")

io.write("passo 5 da 2: ")
for i, v in aPasso(numeri, 5, 2) do
  io.write("[", i, "]=", v, " ")
end
io.write("\n")

-- Due iterazioni concorrenti sulla stessa sequenza
local a = aPasso(numeri, 2)
local statoA = select(2, aPasso(numeri, 2))
local ia = 1 - 2

local iteraB, statoB, ib = aPasso(numeri, 7)

io.write("concorrenti: ")
for _ = 1, 4 do
  local ka, va = a(statoA, ia)
  ia = ka
  local kb, vb = iteraB(statoB, ib)
  ib = kb
  io.write("(", tostring(va), "/", tostring(vb), ") ")
end
io.write("\n")
