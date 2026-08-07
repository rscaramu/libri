-- ES 28.7 — Candidati alternativi in ordine di preferenza
-- Manuale completo di Lua

local Dipendenze = {}
Dipendenze.__index = Dipendenze

function Dipendenze.nuove()
  return setmetatable({
    risolte = {},
    tentativi = {},
  }, Dipendenze)
end

function Dipendenze:risolvi(nomeLogico, candidati)
  if self.risolte[nomeLogico] ~= nil then
    return self.risolte[nomeLogico].modulo,
           self.risolte[nomeLogico].scelto
  end

  local storia = {}

  for _, c in ipairs(candidati) do
    if c.ricaduta then
      local modulo = c.ricaduta()
      storia[#storia + 1] = {nome = c.nome,
        esito = "ricaduta usata"}
      self.tentativi[nomeLogico] = storia
      self.risolte[nomeLogico] = {modulo = modulo,
        scelto = c.nome}
      return modulo, c.nome
    end

    local ok, modulo = pcall(require, c.nome)

    if not ok then
      storia[#storia + 1] = {nome = c.nome,
        esito = "non installato"}
    elseif type(modulo) == "boolean" then
      storia[#storia + 1] = {nome = c.nome,
        esito = "caricato ma non restituisce nulla"}
    elseif c.verifica then
      local valido, motivo = c.verifica(modulo)
      if valido then
        storia[#storia + 1] = {nome = c.nome,
          esito = "SCELTO"}
        self.tentativi[nomeLogico] = storia
        self.risolte[nomeLogico] = {
          modulo = c.adatta and c.adatta(modulo)
            or modulo,
          scelto = c.nome,
        }
        return self.risolte[nomeLogico].modulo, c.nome
      end
      storia[#storia + 1] = {nome = c.nome,
        esito = "verifica fallita: "
          .. tostring(motivo)}
    else
      storia[#storia + 1] = {nome = c.nome,
        esito = "SCELTO"}
      self.tentativi[nomeLogico] = storia
      self.risolte[nomeLogico] = {
        modulo = c.adatta and c.adatta(modulo)
          or modulo,
        scelto = c.nome,
      }
      return self.risolte[nomeLogico].modulo, c.nome
    end
  end

  self.tentativi[nomeLogico] = storia
  return nil, "nessun candidato disponibile"
end

function Dipendenze:rapporto(nomeLogico)
  local righe = {"risoluzione di '" .. nomeLogico .. "':"}
  for i, t in ipairs(self.tentativi[nomeLogico] or {}) do
    righe[#righe + 1] = string.format("  %d. %-14s %s",
      i, t.nome, t.esito)
  end
  local r = self.risolte[nomeLogico]
  righe[#righe + 1] = "  => " .. (r and r.scelto
    or "NESSUNO")
  return table.concat(righe, "\n")
end

local dip = Dipendenze.nuove()

local json = dip:risolvi("json", {
  {nome = "cjson",
   verifica = function(m)
     if type(m.encode) ~= "function" then
       return false, "manca encode"
     end
     return true
   end},
  {nome = "dkjson",
   verifica = function(m)
     if type(m.encode) ~= "function" then
       return false, "manca encode"
     end
     return true
   end,
   adatta = function(m)
     return {encode = m.encode, decode = m.decode}
   end},
  {nome = "json",
   verifica = function(m)
     return type(m.encode) == "function"
   end},
  {nome = "(interno)",
   ricaduta = function()
     local function codifica(v)
       local t = type(v)
       if v == nil then return "null" end
       if t == "boolean" or t == "number" then
         return tostring(v)
       end
       if t == "string" then
         return '"' .. v:gsub('"', '\\"') .. '"'
       end
       if t ~= "table" then return "null" end
       local n = #v
       local pezzi = {}
       if n > 0 then
         for i = 1, n do pezzi[i] = codifica(v[i]) end
         return "[" .. table.concat(pezzi, ",") .. "]"
       end
       local chiavi = {}
       for k in pairs(v) do chiavi[#chiavi + 1] = k end
       table.sort(chiavi, function(a, b)
         return tostring(a) < tostring(b)
       end)
       for _, k in ipairs(chiavi) do
         pezzi[#pezzi + 1] = codifica(tostring(k))
           .. ":" .. codifica(v[k])
       end
       return "{" .. table.concat(pezzi, ",") .. "}"
     end
     return {encode = codifica, _ricaduta = true}
   end},
})

print(dip:rapporto("json"))
print()
print("uso: " .. json.encode({
  nome = "prova", valori = {1, 2, 3}, attivo = true,
}))
print("e' la ricaduta interna: "
  .. tostring(json._ricaduta == true))
