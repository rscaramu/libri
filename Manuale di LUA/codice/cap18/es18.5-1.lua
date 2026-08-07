-- ES 18.5 — Da printf a segnaposto con nome
-- Manuale completo di Lua

local function converti(modello, nomi)
  if type(modello) ~= "string" then
    return nil, "atteso una stringa"
  end
  nomi = nomi or {}

  local indice = 0
  local usati = {}
  local errore = nil

  local risultato = modello:gsub("%%(.)",
    function(carattere)
      if carattere == "%" then
        -- La funzione di sostituzione restituisce
        -- testo LETTERALE: qui va un solo percento
        return "%"
      end
      if not carattere:match("[diufeEgGsxXcoq]") then
        errore = errore or ("segnaposto sconosciuto: %"
          .. carattere)
        return nil
      end
      indice = indice + 1
      local nome = nomi[indice]
      if nome == nil then
        errore = errore or string.format(
          "manca il nome per il segnaposto %d", indice)
        return nil
      end
      usati[#usati + 1] = nome
      return "${" .. nome .. "}"
    end)

  if errore then return nil, errore end
  return risultato, usati, indice
end

local casi = {
  {"Ciao %s, hai %d anni", {"nome", "eta"}},
  {"Totale: %.2f euro (%d%%)", {"totale", "sconto"}},
  {"%s", {"solo"}},
  {"nessun segnaposto", {}},
  {"100%% sicuro", {}},
  {"%s e %s", {"uno"}},
  {"%z sconosciuto", {"x"}},
}

for _, c in ipairs(casi) do
  local r, usati, quanti = converti(c[1], c[2])
  if r then
    print(string.format("%-28s -> %s  (%d)",
      "[" .. c[1] .. "]", r, quanti))
  else
    print(string.format("%-28s -> ERRORE: %s",
      "[" .. c[1] .. "]", usati))
  end
end
