-- ES 4.4 — Le sette operazioni con il tipo del risultato
-- Manuale completo di Lua

local function analizza(a, b)
  local operazioni = {
    {"a + b",  a + b},
    {"a - b",  a - b},
    {"a * b",  a * b},
    {"a / b",  a / b},
    {"a // b", a // b},
    {"a % b",  a % b},
    {"a ^ b",  a ^ b},
  }

  print(string.format("--- a = %s, b = %s ---",
    tostring(a), tostring(b)))
  for _, op in ipairs(operazioni) do
    print(string.format("  %-6s = %-22s %s",
      op[1], tostring(op[2]), math.type(op[2])))
  end
end

analizza(7, 3)
analizza(-7, 3)
analizza(7, -3)
analizza(7.0, 3)
