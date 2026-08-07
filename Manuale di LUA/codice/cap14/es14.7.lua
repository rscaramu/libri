-- ES 14.7 — Temperatura con conversioni via metatabella
-- Manuale completo di Lua

local Temperatura = {}

local CONVERSIONI = {
  kelvin = {
    leggi = function(k) return k end,
    scrivi = function(v) return v end,
  },
  celsius = {
    leggi = function(k) return k - 273.15 end,
    scrivi = function(v) return v + 273.15 end,
  },
  fahrenheit = {
    leggi = function(k)
      return (k - 273.15) * 9 / 5 + 32
    end,
    scrivi = function(v)
      return (v - 32) * 5 / 9 + 273.15
    end,
  },
}

local METODI = {}

function METODI:congelamento()
  return self.celsius <= 0
end

function METODI:ebollizione()
  return self.celsius >= 100
end

local meta = {
  __index = function(t, k)
    local c = CONVERSIONI[k]
    if c then
      return c.leggi(rawget(t, "_kelvin"))
    end
    return METODI[k]
  end,

  __newindex = function(t, k, v)
    local c = CONVERSIONI[k]
    if c == nil then
      error("proprieta' sconosciuta: " .. tostring(k), 2)
    end
    if type(v) ~= "number" then
      error("serve un numero", 2)
    end
    local k2 = c.scrivi(v)
    if k2 < 0 then
      error("sotto lo zero assoluto", 2)
    end
    rawset(t, "_kelvin", k2)
  end,

  __tostring = function(t)
    return string.format("%.2f K / %.2f C / %.2f F",
      t.kelvin, t.celsius, t.fahrenheit)
  end,

  __eq = function(a, b)
    return rawget(a, "_kelvin") == rawget(b, "_kelvin")
  end,

  __lt = function(a, b)
    return rawget(a, "_kelvin") < rawget(b, "_kelvin")
  end,
}

function Temperatura.nuova(valore, scala)
  scala = scala or "celsius"
  local t = setmetatable({_kelvin = 273.15}, meta)
  t[scala] = valore
  return t
end

local t = Temperatura.nuova(25)
print(tostring(t))

t.celsius = 100
print("dopo celsius = 100: " .. tostring(t))
print("bolle? " .. tostring(t:ebollizione()))

t.fahrenheit = 32
print("dopo fahrenheit = 32: " .. tostring(t))
print("congela? " .. tostring(t:congelamento()))

t.kelvin = 300
print("dopo kelvin = 300: " .. tostring(t))

print(pcall(function() t.rankine = 500 end))
print(pcall(function() t.celsius = -300 end))
print(pcall(function() t.celsius = "caldo" end))

local a = Temperatura.nuova(0)
local b = Temperatura.nuova(32, "fahrenheit")
print("0 C == 32 F? " .. tostring(a == b))
