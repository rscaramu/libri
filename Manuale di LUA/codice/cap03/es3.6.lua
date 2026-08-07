-- ES 3.6 — L’assegnazione multipla valuta prima
-- Manuale completo di Lua

local a, b = 1, 2

-- Se l'assegnazione fosse sequenziale, a diventerebbe 2
-- e poi b riceverebbe il NUOVO valore di a, cioe' 2:
-- il risultato sarebbe 2, 2.
a, b = b, a
print(a, b)   --> 2  1

-- Caso piu' netto, con tre variabili in rotazione
local x, y, z = "primo", "secondo", "terzo"
x, y, z = z, x, y
print(x, y, z)   --> terzo  primo  secondo

-- Se fosse sequenziale: x diventa "terzo",
-- poi y riceve il nuovo x, cioe' "terzo",
-- poi z riceve il nuovo y, cioe' "terzo":
-- il risultato sarebbe terzo, terzo, terzo.

-- Anche con gli indici di tabella
local t = {10, 20}
local i = 1
i, t[i] = 2, 99
print(i, t[1], t[2])   --> 2  99  20

-- L'indice t[i] usa il valore di i PRIMA
-- dell'assegnazione, quindi scrive in t[1] e non in t[2].
