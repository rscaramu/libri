-- ES 6.5 — Cinque condizioni diverse in Python
-- Manuale completo di Lua

local casi = {
  {"0", 0},
  {"stringa vuota", ""},
  {"tabella vuota", {}},
  {"stringa '0'", "0"},
  {"0.0", 0.0},
}

for _, c in ipairs(casi) do
  local vero = c[2] and "vero" or "falso"
  print(string.format("%-16s in Lua: %s", c[1], vero))
end
