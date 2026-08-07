-- ES 17.5 — Parole duplicate consecutive
-- Manuale completo di Lua

local function duplicate(testo)
  local trovate = {}
  local posizione = 1

  while true do
    local inizio, fine, prima, seconda =
      testo:find("()(%a+)%s+(%a+)", posizione)
    if inizio == nil then break end

    local pos, uno, due =
      testo:match("()(%a+)%s+(%a+)", posizione)
    if pos == nil then break end

    if uno:lower() == due:lower() then
      trovate[#trovate + 1] = {
        parola = uno, posizione = pos,
      }
    end

    -- Avanziamo di UNA parola, non di due,
    -- per cogliere "il il il"
    local dopo = testo:find("%a+", pos + #uno)
    if dopo == nil then break end
    posizione = dopo
  end

  return trovate
end

local casi = {
  "il il gatto",
  "il gatto il",
  "il il il cane",
  "la La casa",
  "una parola sola",
  "fine   fine con spazi",
  "",
}

for _, t in ipairs(casi) do
  local r = duplicate(t)
  local pezzi = {}
  for _, d in ipairs(r) do
    pezzi[#pezzi + 1] = d.parola .. "@" .. d.posizione
  end
  print(string.format("%-26s -> %s",
    "[" .. t .. "]",
    #pezzi > 0 and table.concat(pezzi, " ")
      or "nessuna"))
end
