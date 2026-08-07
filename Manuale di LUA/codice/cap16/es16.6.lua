-- ES 16.6 — Dipendenza circolare a quattro moduli
-- Manuale completo di Lua

-- Situazione di partenza: A -> B -> C -> D -> B
package.preload["a"] = function()
  local b = require("b")
  return {nome = function() return "a+" .. b.nome() end}
end

package.preload["b"] = function()
  local c = require("c")
  return {nome = function() return "b+" .. c.nome() end}
end

package.preload["c"] = function()
  local d = require("d")
  return {nome = function() return "c+" .. d.nome() end}
end

package.preload["d"] = function()
  local b = require("b")   -- CICLO: torna a b
  return {nome = function() return "d+" .. b.nome() end}
end

local ok, errore = pcall(require, "a")
print("con il ciclo: " .. tostring(ok) .. "  "
  .. tostring(errore))

-- Soluzione: estrarre in un quinto modulo cio' che
-- D chiede a B
for _, n in ipairs({"a", "b", "c", "d"}) do
  package.loaded[n] = nil
end

package.preload["comune"] = function()
  return {base = function() return "COMUNE" end}
end

package.preload["b"] = function()
  local c = require("c")
  local comune = require("comune")
  return {
    nome = function()
      return "b+" .. c.nome()
    end,
    base = comune.base,
  }
end

package.preload["d"] = function()
  local comune = require("comune")
  return {
    nome = function() return "d+" .. comune.base() end,
  }
end

local a = require("a")
print("senza il ciclo: " .. a.nome())
