-- ES 18.7 — Proteggere la stringa di sostituzione
-- Manuale completo di Lua

local function proteggiSostituzione(s)
  return (s:gsub("%%", "%%%%"))
end

local TESTO = "Lo sconto e' del VALORE."

local sostituzioni = {
  "20%",
  "50%% (doppio)",
  "%1 riferimento",
  "%0 intera",
  "normale",
}

for _, sost in ipairs(sostituzioni) do
  io.write(string.format("%-18s ", "[" .. sost .. "]"))

  local ok, risultato = pcall(function()
    return (TESTO:gsub("VALORE", sost))
  end)

  if ok then
    io.write("senza protezione: " .. risultato)
  else
    io.write("senza protezione: ERRORE")
  end
  io.write("\n")

  io.write(string.rep(" ", 19))
  local protetto = TESTO:gsub("VALORE",
    proteggiSostituzione(sost))
  io.write("con protezione:   " .. protetto .. "\n")
end

print()
print("Alternativa: usare una funzione, che non")
print("interpreta nulla.")
local conFunzione = TESTO:gsub("VALORE", function()
  return "20%"
end)
print("  " .. conFunzione)
