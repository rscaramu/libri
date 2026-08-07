-- ES 13.5 — Ordine di inserimento preservato
-- Manuale completo di Lua

local function tabellaOrdinata()
  local dati = {}
  local ordine = {}
  local posizione = {}

  local proxy = setmetatable({}, {
    __index = function(_, k)
      return dati[k]
    end,

    __newindex = function(_, k, v)
      if v == nil then
        if dati[k] ~= nil then
          dati[k] = nil
          local i = posizione[k]
          table.remove(ordine, i)
          posizione[k] = nil
          for j = i, #ordine do
            posizione[ordine[j]] = j
          end
        end
        return
      end

      if dati[k] == nil then
        ordine[#ordine + 1] = k
        posizione[k] = #ordine
      end
      dati[k] = v
    end,

    __len = function() return #ordine end,
  })

  local function coppie()
    local i = 0
    return function()
      i = i + 1
      local k = ordine[i]
      if k == nil then return nil end
      return k, dati[k]
    end
  end

  return proxy, coppie
end

local t, coppie = tabellaOrdinata()

t.zeta = 1
t.alfa = 2
t.mu = 3
t.beta = 4

io.write("ordine di inserimento: ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.alfa = 99
io.write("dopo aggiornamento:    ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.mu = nil
io.write("dopo rimozione di mu:  ")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

t.omega = 5
io.write("dopo nuovo inserimento:")
for k, v in coppie() do io.write(k, "=", v, " ") end
io.write("\n")

print("lunghezza: " .. #t)
print("lettura diretta: " .. t.alfa)
