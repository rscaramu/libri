-- ES 12.8 — Confronto fra due dizionari
-- Manuale completo di Lua

local function confronta(a, b)
  local soloA, soloB, diversi, uguali = {}, {}, {}, {}

  for k, va in pairs(a) do
    local vb = b[k]
    if vb == nil then
      soloA[#soloA + 1] = k
    elseif va ~= vb then
      diversi[#diversi + 1] = {chiave = k,
        primo = va, secondo = vb}
    else
      uguali[#uguali + 1] = k
    end
  end

  for k in pairs(b) do
    if a[k] == nil then
      soloB[#soloB + 1] = k
    end
  end

  local function ordinaChiavi(t)
    table.sort(t, function(x, y)
      return tostring(x) < tostring(y)
    end)
    return t
  end

  ordinaChiavi(soloA)
  ordinaChiavi(soloB)
  ordinaChiavi(uguali)
  table.sort(diversi, function(x, y)
    return tostring(x.chiave) < tostring(y.chiave)
  end)

  return {
    soloPrimo = soloA,
    soloSecondo = soloB,
    diversi = diversi,
    uguali = uguali,
  }
end

local function rapporto(differenze, nomeA, nomeB)
  local righe = {}

  righe[#righe + 1] = string.format(
    "Confronto fra %s e %s", nomeA, nomeB)
  righe[#righe + 1] = string.rep("-", 46)

  if #differenze.soloPrimo > 0 then
    righe[#righe + 1] = "Solo in " .. nomeA .. ":"
    for _, k in ipairs(differenze.soloPrimo) do
      righe[#righe + 1] = "  - " .. tostring(k)
    end
  end

  if #differenze.soloSecondo > 0 then
    righe[#righe + 1] = "Solo in " .. nomeB .. ":"
    for _, k in ipairs(differenze.soloSecondo) do
      righe[#righe + 1] = "  + " .. tostring(k)
    end
  end

  if #differenze.diversi > 0 then
    righe[#righe + 1] = "Valori diversi:"
    for _, d in ipairs(differenze.diversi) do
      righe[#righe + 1] = string.format(
        "  ~ %s: %s -> %s", tostring(d.chiave),
        tostring(d.primo), tostring(d.secondo))
    end
  end

  righe[#righe + 1] = string.format(
    "Identiche: %d chiavi", #differenze.uguali)

  return table.concat(righe, "\n")
end

local PRODUZIONE = {
  host = "prod.example.com",
  porta = 443,
  timeout = 30,
  debug = false,
  cache = true,
}

local SVILUPPO = {
  host = "localhost",
  porta = 8080,
  timeout = 30,
  debug = true,
  verboso = 3,
}

print(rapporto(confronta(PRODUZIONE, SVILUPPO),
  "produzione", "sviluppo"))
