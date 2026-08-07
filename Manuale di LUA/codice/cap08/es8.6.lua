-- ES 8.6 — Massimo comun divisore in tre forme
-- Manuale completo di Lua

local function mcdCiclo(a, b)
  a, b = math.abs(a), math.abs(b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end

local function mcdRicorsivo(a, b)
  a, b = math.abs(a), math.abs(b)
  if b == 0 then return a end
  -- NON in coda: c'e' una moltiplicazione per 1
  -- che impedisce l'ottimizzazione
  return 1 * mcdRicorsivo(b, a % b)
end

local function mcdCoda(a, b)
  a, b = math.abs(a), math.abs(b)
  if b == 0 then return a end
  return mcdCoda(b, a % b)
end

local prove = {
  {48, 18, 6}, {17, 5, 1}, {0, 5, 5},
  {5, 0, 5}, {-48, 18, 6}, {100, 100, 100},
}

for _, p in ipairs(prove) do
  local r1 = mcdCiclo(p[1], p[2])
  local r2 = mcdRicorsivo(p[1], p[2])
  local r3 = mcdCoda(p[1], p[2])
  print(string.format("mcd(%4d,%4d) = %d %d %d  %s",
    p[1], p[2], r1, r2, r3,
    (r1 == p[3] and r2 == p[3] and r3 == p[3])
      and "ok" or "ERRORE"))
end

-- Profondita' massima
local function profonditaMassima(f)
  local n = 0
  local function prova(k)
    local ok = pcall(f, k)
    return ok
  end
  -- L'algoritmo di Euclide converge in fretta:
  -- per forzare la profondita' usiamo una ricorsione
  -- artificiale.
  local function ricorsivaNonCoda(k)
    if k == 0 then return 0 end
    return 1 + ricorsivaNonCoda(k - 1)
  end
  local function ricorsivaCoda(k, acc)
    acc = acc or 0
    if k == 0 then return acc end
    return ricorsivaCoda(k - 1, acc + 1)
  end

  local limite = 1
  while pcall(ricorsivaNonCoda, limite) do
    limite = limite * 2
    if limite > 100000000 then break end
  end
  print("ricorsione ordinaria: fallisce oltre circa "
    .. limite // 2)

  local ok = pcall(ricorsivaCoda, 10000000)
  print("ricorsione in coda a 10 milioni: "
    .. tostring(ok))
  return n
end

profonditaMassima()
