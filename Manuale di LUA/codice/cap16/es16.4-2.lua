-- ES 16.4 — Modulo di utilità per le stringhe
-- Manuale completo di Lua

package.preload["testo"] = function()
  -- qui andrebbe il modulo sopra
  return require("testo_reale")
end

local testo = require("testo")

print(table.concat(testo.dividi("a,b,c"), "|"))
print(table.concat(testo.dividi("a.b.c", "."), "|"))
print(table.concat(testo.dividi("a,b,c", ",", 2), "|"))
print("[" .. testo.taglia("  ciao  ") .. "]")
print("[" .. testo.taglia("  ciao  ", "sinistra") .. "]")
print(testo.iniziaCon("programmazione", "pro"))
print(testo.finisceCon("file.txt", ".txt"))
print(testo.titolo("mARIO rossi VERDI"))
print("[" .. testo.riempi("ab", 6, ".") .. "]")
print("[" .. testo.riempi("ab", 6, ".", true) .. "]")

print("eSpazio raggiungibile? "
  .. tostring(testo.eSpazio))
print("proteggi raggiungibile? "
  .. tostring(testo.proteggi))
