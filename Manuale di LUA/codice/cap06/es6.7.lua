-- ES 6.7 — Albero decisionale, due versioni
-- Manuale completo di Lua

local RISPOSTE = {"si", "no"}

local ESITI = {
  ["si-si-si"]  = "profilo A: esperto entusiasta",
  ["si-si-no"]  = "profilo B: esperto prudente",
  ["si-no-si"]  = "profilo C: pratico curioso",
  ["si-no-no"]  = "profilo D: pratico conservatore",
  ["no-si-si"]  = "profilo E: novizio motivato",
  ["no-si-no"]  = "profilo F: novizio cauto",
  ["no-no-si"]  = "profilo G: osservatore",
  ["no-no-no"]  = "profilo H: non interessato",
}

local function conIf(a, b, c)
  if a == "si" then
    if b == "si" then
      if c == "si" then return "profilo A: esperto "
        .. "entusiasta" end
      return "profilo B: esperto prudente"
    end
    if c == "si" then return "profilo C: pratico "
      .. "curioso" end
    return "profilo D: pratico conservatore"
  end
  if b == "si" then
    if c == "si" then return "profilo E: novizio "
      .. "motivato" end
    return "profilo F: novizio cauto"
  end
  if c == "si" then return "profilo G: osservatore" end
  return "profilo H: non interessato"
end

local function conTabella(a, b, c)
  return ESITI[a .. "-" .. b .. "-" .. c]
    or "risposte non valide"
end

for _, a in ipairs(RISPOSTE) do
  for _, b in ipairs(RISPOSTE) do
    for _, c in ipairs(RISPOSTE) do
      local x = conIf(a, b, c)
      local y = conTabella(a, b, c)
      print(string.format("%s %s %s -> %-32s %s",
        a, b, c, y, x == y and "ok" or "DIVERSI"))
    end
  end
end

print(conTabella("forse", "si", "no"))
