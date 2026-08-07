-- ES 3.7 — Cinque modi di ottenere `nil`
-- Manuale completo di Lua

local casi = {}

-- 1. Variabile globale mai dichiarata
casi[#casi + 1] = {"globale inesistente", mai_definita}

-- 2. Campo inesistente di una tabella
local t = {a = 1}
casi[#casi + 1] = {"campo assente", t.b}

-- 3. tonumber su testo non numerico
casi[#casi + 1] = {"tonumber('ciao')", tonumber("ciao")}

-- 4. Indice oltre la fine di una sequenza
local s = {"x", "y"}
casi[#casi + 1] = {"indice fuori", s[10]}

-- 5. Funzione che non restituisce nulla
local function niente() end
casi[#casi + 1] = {"funzione vuota", niente()}

-- 6. Variabile locale dichiarata e non assegnata
local dichiarata
casi[#casi + 1] = {"local non assegnata", dichiarata}

-- 7. Argomento non passato
local function f(a, b) return b end
casi[#casi + 1] = {"argomento mancante", f(1)}

for i = 1, #casi do
  local nome = casi[i][1]
  local valore = casi[i][2]
  print(string.format("%-22s %-6s %s", nome,
    type(valore), tostring(valore)))
end
