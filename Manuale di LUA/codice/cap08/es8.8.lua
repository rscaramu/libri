-- ES 8.8 — Le quattro regole dei valori multipli
-- Manuale completo di Lua

local function cinque()
  return 1, 2, 3, 4, 5
end

print("--- 1. Ultima posizione: tutti i valori ---")
print(cinque())
local a, b, c, d, e, f = cinque()
print(a, b, c, d, e, f)

print("--- 2. Posizione intermedia: uno solo ---")
print(cinque(), "coda")
print("prima", cinque(), "dopo")
local g, h = cinque(), 99
print(g, h)

print("--- 3. Parentesi: uno solo ---")
print((cinque()))
local i, j = (cinque())
print(i, j)

print("--- 4. Costruttore di tabella ---")
local t1 = {cinque()}
print("in coda:      " .. #t1)
local t2 = {cinque(), cinque()}
print("non in coda:  " .. #t2)
local t3 = {0, cinque()}
print("dopo un altro:" .. #t3)
local t4 = {[1] = cinque()}
print("chiave espl.: " .. #t4)

print("--- 5. Come argomento di un'altra funzione ---")
print(select("#", cinque()))
print(select("#", cinque(), 0))
print(math.max(cinque()))
