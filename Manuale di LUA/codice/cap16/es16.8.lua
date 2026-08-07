-- ES 16.8 — Modulo finto per i test
-- Manuale completo di Lua

-- Il modulo reale, che invia messaggi
package.preload["posta"] = function()
  return {
    invia = function(destinatario, oggetto, corpo)
      -- In produzione qui ci sarebbe una connessione
      error("il modulo reale non deve essere usato "
        .. "nei test", 0)
    end,
  }
end

-- Il codice sotto esame
package.preload["notifiche"] = function()
  local posta = require("posta")
  local M = {}

  function M.benvenuto(utente)
    if type(utente) ~= "table" or not utente.email then
      return nil, "utente senza indirizzo"
    end
    return posta.invia(utente.email,
      "Benvenuto, " .. (utente.nome or "utente"),
      "Grazie per esserti registrato.")
  end

  function M.promemoria(utente, scadenza)
    if not utente.email then
      return nil, "utente senza indirizzo"
    end
    return posta.invia(utente.email,
      "Promemoria",
      "Scadenza: " .. tostring(scadenza))
  end

  return M
end

-- Il modulo finto, installato PRIMA del require
local chiamate = {}

package.loaded["posta"] = {
  invia = function(destinatario, oggetto, corpo)
    chiamate[#chiamate + 1] = {
      destinatario = destinatario,
      oggetto = oggetto,
      corpo = corpo,
    }
    return true
  end,
}

local notifiche = require("notifiche")

notifiche.benvenuto({email = "a@example.com",
  nome = "Anna"})
notifiche.promemoria({email = "b@example.com"},
  "2026-09-01")

local r, e = notifiche.benvenuto({nome = "Senza posta"})
print("senza indirizzo: " .. tostring(r) .. " " .. e)

print("messaggi inviati: " .. #chiamate)
for i, c in ipairs(chiamate) do
  print(string.format("  %d. a=%s oggetto=%s",
    i, c.destinatario, c.oggetto))
end

local atteso = "Benvenuto, Anna"
print("primo oggetto corretto? "
  .. tostring(chiamate[1].oggetto == atteso))
print("il modulo reale non e' mai stato chiamato: "
  .. "confermato dall'assenza di errori")
