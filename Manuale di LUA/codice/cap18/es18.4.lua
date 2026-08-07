-- ES 18.4 — Dividi robusta
-- Manuale completo di Lua

local function proteggi(s)
  return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1"))
end

local function dividi(s, separatore)
  if type(s) ~= "string" then
    return nil, "primo argomento non e' una stringa"
  end
  separatore = separatore or ","
  if type(separatore) ~= "string" or separatore == "" then
    return nil, "separatore non valido"
  end

  local pezzi = {}
  local pattern = proteggi(separatore)
  local posizione = 1

  while true do
    local inizio, fine = s:find(pattern, posizione)
    if inizio == nil then
      pezzi[#pezzi + 1] = s:sub(posizione)
      break
    end
    pezzi[#pezzi + 1] = s:sub(posizione, inizio - 1)
    posizione = fine + 1
  end

  return pezzi
end

local casi = {
  {"a,b,c", ",", {"a", "b", "c"}},
  {"", ",", {""}},
  {"abc", ",", {"abc"}},
  {",a", ",", {"", "a"}},
  {"a,", ",", {"a", ""}},
  {",", ",", {"", ""}},
  {"a,,b", ",", {"a", "", "b"}},
  {"a--b--c", "--", {"a", "b", "c"}},
  {"a.b.c", ".", {"a", "b", "c"}},
  {"a+b", "+", {"a", "b"}},
  {"a%b", "%", {"a", "b"}},
  {"aXXbXXc", "XX", {"a", "b", "c"}},
}

for _, c in ipairs(casi) do
  local r = dividi(c[1], c[2])
  local uguale = #r == #c[3]
  if uguale then
    for i = 1, #r do
      if r[i] ~= c[3][i] then uguale = false end
    end
  end
  print(string.format("%-12s sep=%-4s -> [%s] %s",
    "[" .. c[1] .. "]", "[" .. c[2] .. "]",
    table.concat(r, "|"),
    uguale and "ok" or "ERRORE"))
end

print(dividi("abc", ""))
print(dividi(42, ","))
