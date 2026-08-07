-- ES 7.6 — Figure di testo
-- Manuale completo di Lua

local function triangolo(altezza)
  local righe = {}
  for i = 1, altezza do
    righe[#righe + 1] = string.rep(" ", altezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

local function rombo(mezzaAltezza)
  local righe = {}
  for i = 1, mezzaAltezza do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  for i = mezzaAltezza - 1, 1, -1 do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

local function clessidra(mezzaAltezza)
  local righe = {}
  for i = mezzaAltezza, 1, -1 do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  for i = 2, mezzaAltezza do
    righe[#righe + 1] = string.rep(" ", mezzaAltezza - i)
      .. string.rep("*", 2 * i - 1)
  end
  return table.concat(righe, "\n")
end

print(triangolo(4)) print()
print(rombo(4))     print()
print(clessidra(4))
