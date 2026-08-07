-- ES 14.5 — La trappola dei campi condivisi, tre tipi
-- Manuale completo di Lua

local C = {}
C.__index = C

C.contatore = 0          -- numero
C.etichetta = "iniziale"  -- stringa
C.registro = {}           -- TABELLA: condivisa!

function C.nuova(nome)
  return setmetatable({nome = nome}, C)
end

function C:incrementa()
  self.contatore = self.contatore + 1
end

function C:rinomina(s)
  self.etichetta = s
end

function C:annota(v)
  self.registro[#self.registro + 1] = self.nome .. ":" .. v
end

local a = C.nuova("A")
local b = C.nuova("B")

a:incrementa()
a:incrementa()
b:incrementa()

a:rinomina("modificata da A")

a:annota("primo")
b:annota("secondo")
a:annota("terzo")

print("contatore di a: " .. a.contatore)
print("contatore di b: " .. b.contatore)
print("contatore nella classe: " .. C.contatore)
print()
print("etichetta di a: " .. a.etichetta)
print("etichetta di b: " .. b.etichetta)
print("etichetta nella classe: " .. C.etichetta)
print()
print("registro di a: "
  .. table.concat(a.registro, " "))
print("registro di b: "
  .. table.concat(b.registro, " "))
print("registro nella classe: "
  .. table.concat(C.registro, " "))
print("a.registro e' C.registro? "
  .. tostring(a.registro == C.registro))
print("a.registro e' b.registro? "
  .. tostring(a.registro == b.registro))
