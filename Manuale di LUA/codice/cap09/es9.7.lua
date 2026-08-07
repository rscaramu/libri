-- ES 9.7 — Profondità massima di ricorsione
-- Manuale completo di Lua

local function ordinaria(n)
  if n == 0 then return 0 end
  return 1 + ordinaria(n - 1)
end

local function inCoda(n, acc)
  acc = acc or 0
  if n == 0 then return acc end
  return inCoda(n - 1, acc + 1)
end

local function trovaLimite(f, tetto)
  local basso, alto = 1, tetto
  -- Cerchiamo il primo valore che fallisce,
  -- raddoppiando
  while alto <= tetto and pcall(f, alto) do
    basso = alto
    alto = alto * 2
  end

  -- Poi affiniamo per bisezione
  while alto - basso > 1 do
    local medio = (basso + alto) // 2
    if pcall(f, medio) then
      basso = medio
    else
      alto = medio
    end
  end
  return basso
end

local limite = trovaLimite(ordinaria, 100000000)
print("ricorsione ordinaria: circa " .. limite
  .. " livelli")

local prove = {1000000, 10000000, 50000000}
for _, n in ipairs(prove) do
  local ok, r = pcall(inCoda, n)
  print(string.format("ricorsione in coda a %10d: %s",
    n, ok and ("ok, risultato " .. r) or "fallita"))
end

local ok, messaggio = pcall(ordinaria, 10000000)
print("messaggio d'errore: " .. tostring(messaggio))
