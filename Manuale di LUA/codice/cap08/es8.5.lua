-- ES 8.5 — Composizione di funzioni
-- Manuale completo di Lua

local function componiDue(f, g)
  return function(...)
    return f(g(...))
  end
end

local function componi(...)
  local funzioni = table.pack(...)
  if funzioni.n == 0 then
    return function(...) return ... end
  end
  for i = 1, funzioni.n do
    if type(funzioni[i]) ~= "function" then
      return nil, "argomento " .. i .. " non e' "
        .. "una funzione"
    end
  end

  return function(...)
    local risultati = table.pack(...)
    -- Applicazione da DESTRA a SINISTRA:
    -- componi(f, g, h)(x) == f(g(h(x)))
    for i = funzioni.n, 1, -1 do
      risultati = table.pack(
        funzioni[i](table.unpack(risultati, 1,
          risultati.n)))
    end
    return table.unpack(risultati, 1, risultati.n)
  end
end

local raddoppia = function(x) return x * 2 end
local incrementa = function(x) return x + 1 end
local quadrato = function(x) return x * x end

local a = componiDue(raddoppia, incrementa)
print("componiDue(raddoppia, incrementa)(3) = " .. a(3))

local b = componi(raddoppia, incrementa, quadrato)
print("componi(raddoppia, incrementa, quadrato)(3) = "
  .. b(3))

local identita = componi()
print("componi()(7) = " .. identita(7))

print(componi(raddoppia, "non una funzione"))
