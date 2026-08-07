-- ES 33.5 — Coda con priorità in Redis
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

local INSERISCI = [[ ... primo script ... ]]
local ESTRAI = [[ ... secondo script ... ]]

local function esempio(rossa)
  -- caricamento una volta sola
  local shaInserisci = rossa:script("LOAD", INSERISCI)
  local shaEstrai = rossa:script("LOAD", ESTRAI)

  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "1", "lavoro a bassa priorita'")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "9", "lavoro urgente")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "5", "lavoro normale")
  rossa:evalsha(shaInserisci, 2, "coda", "coda:seq",
    "9", "secondo urgente")

  local r = rossa:evalsha(shaEstrai, 1, "coda", "4")
  -- ordine atteso:
  --   lavoro urgente (9, sequenza 2)
  --   secondo urgente (9, sequenza 4)
  --   lavoro normale (5)
  --   lavoro a bassa priorita' (1)
  return r
end
