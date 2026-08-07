-- ES 22.5 — Coda di lavoro con priorità
-- Manuale completo di Lua

local Schedulatore = {}
Schedulatore.__index = Schedulatore

function Schedulatore.nuovo()
  return setmetatable({
    compiti = {},
    prossimoId = 0,
    passi = 0,
  }, Schedulatore)
end

function Schedulatore:aggiungi(nome, priorita, funzione)
  self.prossimoId = self.prossimoId + 1
  self.compiti[#self.compiti + 1] = {
    id = self.prossimoId,
    nome = nome,
    priorita = priorita,
    co = coroutine.create(funzione),
    pronto = true,
  }
  return self.prossimoId
end

function Schedulatore:prossimo()
  local migliore = nil
  for _, c in ipairs(self.compiti) do
    if c.pronto
       and coroutine.status(c.co) == "suspended" then
      if migliore == nil
         or c.priorita > migliore.priorita
         or (c.priorita == migliore.priorita
             and c.id < migliore.id) then
        migliore = c
      end
    end
  end
  return migliore
end

function Schedulatore:esegui(massimo)
  massimo = massimo or 1000
  local traccia = {}

  while self.passi < massimo do
    local c = self:prossimo()
    if c == nil then break end

    self.passi = self.passi + 1
    local ok, nuovaPriorita = coroutine.resume(c.co,
      c.priorita)

    if not ok then
      traccia[#traccia + 1] = string.format(
        "%s ERRORE: %s", c.nome, tostring(nuovaPriorita))
      c.pronto = false
    elseif coroutine.status(c.co) == "dead" then
      traccia[#traccia + 1] = c.nome .. " terminato"
      c.pronto = false
    else
      traccia[#traccia + 1] = string.format(
        "%s (p=%d)", c.nome, c.priorita)
      if type(nuovaPriorita) == "number" then
        c.priorita = nuovaPriorita
      end
    end
  end

  return traccia
end

local s = Schedulatore.nuovo()

s:aggiungi("urgente", 10, function()
  for i = 1, 3 do
    coroutine.yield(10)
  end
end)

s:aggiungi("normale", 5, function()
  for i = 1, 3 do
    coroutine.yield(5)
  end
end)

s:aggiungi("crescente", 1, function(p)
  for i = 1, 4 do
    p = coroutine.yield(p + 4)
  end
end)

s:aggiungi("rotto", 8, function()
  coroutine.yield(8)
  error("compito difettoso")
end)

for i, riga in ipairs(s:esegui(30)) do
  print(string.format("%2d. %s", i, riga))
end
