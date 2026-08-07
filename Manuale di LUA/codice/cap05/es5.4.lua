-- ES 5.4 — Prefisso e suffisso senza pattern
-- Manuale completo di Lua

local function iniziaCon(s, prefisso)
  if type(s) ~= "string" or type(prefisso) ~= "string" then
    return nil, "attese due stringhe"
  end
  if #prefisso > #s then return false end
  if #prefisso == 0 then return true end
  return s:sub(1, #prefisso) == prefisso
end

local function finisceCon(s, suffisso)
  if type(s) ~= "string" or type(suffisso) ~= "string" then
    return nil, "attese due stringhe"
  end
  if #suffisso > #s then return false end
  if #suffisso == 0 then return true end
  return s:sub(-#suffisso) == suffisso
end

local prove = {
  {"programmazione", "pro", true, false},
  {"programmazione", "one", false, true},
  {"pro", "programmazione", false, false},
  {"abc", "", true, true},
  {"", "", true, true},
  {"", "x", false, false},
  {"abc", "abc", true, true},
}

for _, p in ipairs(prove) do
  local i = iniziaCon(p[1], p[2])
  local f = finisceCon(p[1], p[2])
  print(string.format("%-16s %-16s inizia=%-5s "
    .. "finisce=%-5s %s",
    "[" .. p[1] .. "]", "[" .. p[2] .. "]",
    tostring(i), tostring(f),
    (i == p[3] and f == p[4]) and "ok" or "ERRORE"))
end
