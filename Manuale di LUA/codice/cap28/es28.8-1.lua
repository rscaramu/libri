-- ES 28.8 — Progetto con busted, luacheck e luacov
-- Manuale completo di Lua

std = "lua54"
max_line_length = 79
codes = true

files["spec/**/*.lua"] = {
  std = "+busted",
}

exclude_files = {
  "moduli/**",
  ".luarocks/**",
}
