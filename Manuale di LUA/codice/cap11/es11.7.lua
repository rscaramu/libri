-- ES 11.7 — Partizione in due versioni
-- Manuale completo di Lua

local function partizionaNuove(sequenza, predicato)
  local si, no = {}, {}
  for i = 1, #sequenza do
    local v = sequenza[i]
    if predicato(v, i) then
      si[#si + 1] = v
    else
      no[#no + 1] = v
    end
  end
  return si, no
end

local function partizionaSulPosto(sequenza, predicato)
  local scrittura = 1
  local n = #sequenza

  for lettura = 1, n do
    local v = sequenza[lettura]
    if predicato(v, lettura) then
      sequenza[lettura] = sequenza[scrittura]
      sequenza[scrittura] = v
      scrittura = scrittura + 1
    end
  end

  return scrittura - 1
end

local pari = function(n) return n % 2 == 0 end

local origine = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local si, no = partizionaNuove(origine, pari)
print("nuove  si: " .. table.concat(si, " "))
print("nuove  no: " .. table.concat(no, " "))
print("originale: " .. table.concat(origine, " "))

local separazione = partizionaSulPosto(origine, pari)
print("sul posto: " .. table.concat(origine, " "))
print("separazione all'indice " .. separazione)
print("  soddisfano: " .. table.concat(origine, " ",
  1, separazione))
print("  gli altri:  " .. table.concat(origine, " ",
  separazione + 1, #origine))

-- Casi limite
local vuota = {}
print("vuota -> " .. partizionaSulPosto(vuota, pari))

local tuttiSi = {2, 4, 6}
print("tutti si -> " .. partizionaSulPosto(tuttiSi, pari))

local tuttiNo = {1, 3, 5}
print("tutti no -> " .. partizionaSulPosto(tuttiNo, pari))
