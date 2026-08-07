-- ES 5.7 — Parole in ordine inverso
-- Manuale completo di Lua

local function invertiParole(frase)
  if type(frase) ~= "string" then
    return nil, "attesa una stringa"
  end

  local parole = {}
  local corrente = {}

  for i = 1, #frase do
    local c = frase:sub(i, i)
    if c == " " or c == "\t" or c == "\n" then
      if #corrente > 0 then
        parole[#parole + 1] = table.concat(corrente)
        corrente = {}
      end
    else
      corrente[#corrente + 1] = c
    end
  end
  if #corrente > 0 then
    parole[#parole + 1] = table.concat(corrente)
  end

  local invertite = {}
  for i = #parole, 1, -1 do
    invertite[#invertite + 1] = parole[i]
  end

  return table.concat(invertite, " ")
end

local prove = {
  "il gatto sul tetto",
  "Ciao, mondo! Come va?",
  "   spazi    multipli   ",
  "unaSolaParola",
  "",
}

for _, p in ipairs(prove) do
  print("[" .. p .. "]")
  print("  -> [" .. invertiParole(p) .. "]")
end
