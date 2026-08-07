-- ES 8.4 — Concatenare stringhe con separatore
-- Manuale completo di Lua

local function unisci(separatore, ...)
  if type(separatore) ~= "string" then
    return nil, "il separatore deve essere una stringa"
  end

  local argomenti = table.pack(...)
  local pezzi = {}

  for i = 1, argomenti.n do
    local v = argomenti[i]
    if v == nil then
      pezzi[#pezzi + 1] = ""
    elseif type(v) == "string" or type(v) == "number" then
      pezzi[#pezzi + 1] = tostring(v)
    else
      return nil, string.format(
        "argomento %d di tipo %s non ammesso",
        i, type(v))
    end
  end

  return table.concat(pezzi, separatore)
end

print("[" .. unisci(", ", "a", "b", "c") .. "]")
print("[" .. unisci(", ") .. "]")
print("[" .. unisci("-", "solo") .. "]")
print("[" .. unisci("|", "a", nil, "c") .. "]")
print("[" .. unisci("", 1, 2, 3) .. "]")
print(unisci(",", "a", {}, "c"))
print(unisci(42, "a"))
