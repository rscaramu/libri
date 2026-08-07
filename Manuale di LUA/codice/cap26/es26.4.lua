-- ES 26.4 — Sostituzione letterale
-- Manuale completo di Lua

local t = require("testo2")

local casi = {
  {"abcabc", "b", "X"},
  {"abcabc", "abc", "-"},
  {"aaaa", "aa", "b"},
  {"niente", "x", "y"},
  {"a.b.c", ".", "/"},
  {"a%b", "%", "%%"},
  {"prefisso", "pre", ""},
  {"", "x", "y"},
  {"aaa", "a", "aa"},
}

for _, c in ipairs(casi) do
  local r, n = t.sostituisci(c[1], c[2], c[3])
  print(string.format("%-10s %-6s -> %-6s = %-12s (%d)",
    "[" .. c[1] .. "]", "[" .. c[2] .. "]",
    "[" .. c[3] .. "]", "[" .. r .. "]", n))
end

print(t.sostituisci("aaaa", "a", "X", 2))
print(pcall(t.sostituisci, "abc", "", "x"))
