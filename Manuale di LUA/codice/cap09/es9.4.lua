-- ES 9.4 — Lista privata con copia
-- Manuale completo di Lua

local function creaLista()
  local elementi = {}

  local function aggiungi(v)
    if v == nil then
      return nil, "non si puo' aggiungere nil"
    end
    elementi[#elementi + 1] = v
    return #elementi
  end

  local function copia()
    local c = {}
    table.move(elementi, 1, #elementi, 1, c)
    return c
  end

  local function quanti()
    return #elementi
  end

  return aggiungi, copia, quanti
end

local aggiungi, copia, quanti = creaLista()

aggiungi("a")
aggiungi("b")
aggiungi("c")

local istantanea = copia()
print("copia: " .. table.concat(istantanea, " "))

-- Modifichiamo la copia
istantanea[1] = "MODIFICATO"
istantanea[#istantanea + 1] = "AGGIUNTO"

print("copia modificata: "
  .. table.concat(istantanea, " "))
print("originale:        "
  .. table.concat(copia(), " "))
print("elementi: " .. quanti())

-- Non c'e' alcun modo di raggiungere `elementi`
print(aggiungi("d"))
print("dopo: " .. table.concat(copia(), " "))
