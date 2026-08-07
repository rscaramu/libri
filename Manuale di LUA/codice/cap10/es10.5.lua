-- ES 10.5 — Copia superficiale contro profonda
-- Manuale completo di Lua

local function superficiale(t)
  local n = {}
  for k, v in pairs(t) do n[k] = v end
  return n
end

local function profonda(t, viste)
  if type(t) ~= "table" then return t end
  viste = viste or {}
  if viste[t] then return viste[t] end
  local n = {}
  viste[t] = n
  for k, v in pairs(t) do
    n[profonda(k, viste)] = profonda(v, viste)
  end
  return n
end

local originale = {
  nome = "radice",
  livello2 = {
    nome = "secondo",
    livello3 = {
      nome = "terzo",
      dati = {1, 2, 3},
    },
  },
}

local sup = superficiale(originale)
local pro = profonda(originale)

sup.livello2.livello3.nome = "MODIFICATO DA SUP"
print("dopo modifica via copia superficiale:")
print("  originale: "
  .. originale.livello2.livello3.nome)

pro.livello2.livello3.nome = "MODIFICATO DA PRO"
print("dopo modifica via copia profonda:")
print("  originale: "
  .. originale.livello2.livello3.nome)
print("  copia:     "
  .. pro.livello2.livello3.nome)

print()
print("--- con riferimento circolare ---")
local ciclica = {nome = "ciclo"}
ciclica.se_stessa = ciclica
ciclica.figlio = {padre = ciclica}

local supC = superficiale(ciclica)
print("superficiale: riuscita, ma se_stessa punta")
print("  all'originale: "
  .. tostring(supC.se_stessa == ciclica))

local proC = profonda(ciclica)
print("profonda: riuscita, se_stessa punta alla copia: "
  .. tostring(proC.se_stessa == proC))
print("  e non all'originale: "
  .. tostring(proC.se_stessa ~= ciclica))
print("  anche il figlio: "
  .. tostring(proC.figlio.padre == proC))
