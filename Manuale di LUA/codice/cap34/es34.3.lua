-- ES 34.3 — Suite di test per modello e filtri
-- Manuale completo di Lua

local T = require("test")
local gruppo, prova, a = T.gruppo, T.prova, T.assert

local modello = require("src.modello")
local filtri = require("src.filtri")

local OGGI = "2026-08-07"

local function att(dati)
  local x = modello.nuova(dati)
  return x
end

gruppo("modello", function()

  gruppo("validazione del titolo", function()
    prova("titolo obbligatorio", function()
      a.uguale(nil, modello.nuova({}))
    end)
    prova("titolo vuoto rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = ""}))
    end)
    prova("titolo di soli spazi rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "   "}))
    end)
    prova("titolo non stringa rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = 42}))
    end)
    prova("titolo troppo lungo rifiutato", function()
      a.uguale(nil, modello.nuova({
        titolo = string.rep("x", 201)}))
    end)
    prova("titolo al limite accettato", function()
      a.vero(modello.nuova({
        titolo = string.rep("x", 200)}) ~= nil)
    end)
    prova("spazi ai margini rimossi", function()
      a.uguale("prova",
        att({titolo = "  prova  "}).titolo)
    end)
  end)

  gruppo("priorita' e stato", function()
    prova("priorita' predefinita", function()
      a.uguale("media", att({titolo = "x"}).priorita)
    end)
    prova("stato predefinito", function()
      a.uguale("aperta", att({titolo = "x"}).stato)
    end)
    prova("priorita' non valida rifiutata", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        priorita = "altissima"}))
    end)
    prova("stato non valido rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        stato = "quasi"}))
    end)
    prova("tutte le priorita' ammesse", function()
      for _, p in ipairs(modello.PRIORITA) do
        a.vero(modello.nuova({titolo = "x",
          priorita = p}) ~= nil, p)
      end
    end)
  end)

  gruppo("etichette", function()
    prova("da stringa separata da virgole", function()
      a.uguale({"a", "b"},
        att({titolo = "x", etichette = "a,b"}).etichette)
    end)
    prova("normalizzate in minuscolo", function()
      a.uguale({"casa"},
        att({titolo = "x", etichette = "CASA"}).etichette)
    end)
    prova("ordinate", function()
      a.uguale({"a", "m", "z"},
        att({titolo = "x",
          etichette = "z,a,m"}).etichette)
    end)
    prova("spazi rimossi", function()
      a.uguale({"a", "b"},
        att({titolo = "x",
          etichette = " a , b "}).etichette)
    end)
    prova("vuote scartate", function()
      a.uguale({"a"},
        att({titolo = "x",
          etichette = "a,,"}).etichette)
    end)
    prova("assenti danno tabella vuota", function()
      a.uguale({}, att({titolo = "x"}).etichette)
    end)
    prova("haEtichetta e' insensibile al caso",
      function()
        local x = att({titolo = "x",
          etichette = "casa"})
        a.vero(x:haEtichetta("CASA"))
        a.vero(not x:haEtichetta("lavoro"))
      end)
  end)

  gruppo("scadenza", function()
    prova("formato valido accettato", function()
      a.vero(modello.nuova({titolo = "x",
        scadenza = "2026-01-01"}) ~= nil)
    end)
    prova("formato non valido rifiutato", function()
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = "01/01/2026"}))
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = "2026-1-1"}))
      a.uguale(nil, modello.nuova({titolo = "x",
        scadenza = 20260101}))
    end)
    prova("scaduta se precedente a oggi", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-01"})
      a.vero(x:scaduta(OGGI))
    end)
    prova("non scaduta se oggi", function()
      local x = att({titolo = "x", scadenza = OGGI})
      a.vero(not x:scaduta(OGGI))
    end)
    prova("chiusa non e' mai scaduta", function()
      local x = att({titolo = "x",
        scadenza = "2020-01-01", stato = "fatta"})
      a.vero(not x:scaduta(OGGI))
    end)
    prova("senza scadenza non e' scaduta", function()
      a.vero(not att({titolo = "x"}):scaduta(OGGI))
    end)
    prova("giorni alla scadenza", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-10"})
      a.uguale(3, x:giorniAllaScadenza(OGGI))
    end)
    prova("giorni negativi se scaduta", function()
      local x = att({titolo = "x",
        scadenza = "2026-08-01"})
      a.uguale(-6, x:giorniAllaScadenza(OGGI))
    end)
  end)

  gruppo("aggiornamento", function()
    prova("modifica valida applicata", function()
      local x = att({titolo = "x"})
      x:aggiorna({priorita = "alta"})
      a.uguale("alta", x.priorita)
    end)
    prova("modifica non valida NON applicata",
      function()
        local x = att({titolo = "x",
          priorita = "bassa"})
        local ok = x:aggiorna({priorita = "assurda"})
        a.uguale(nil, ok)
        a.uguale("bassa", x.priorita)
      end)
    prova("id non modificabile", function()
      local x = att({titolo = "x", id = 7})
      x:aggiorna({id = 99})
      a.uguale(7, x.id)
    end)
    prova("chiusura registra l'istante", function()
      local x = att({titolo = "x"})
      x:aggiorna({stato = "fatta"})
      a.vero(x.chiusa ~= nil)
    end)
    prova("riapertura azzera l'istante", function()
      local x = att({titolo = "x"})
      x:aggiorna({stato = "fatta"})
      x:aggiorna({stato = "aperta"})
      a.uguale(nil, x.chiusa)
    end)
  end)

  gruppo("metametodi", function()
    prova("uguaglianza per id", function()
      local x = att({titolo = "a", id = 1})
      local y = att({titolo = "b", id = 1})
      a.vero(x == y)
    end)
    prova("ordine per id", function()
      local x = att({titolo = "a", id = 1})
      local y = att({titolo = "b", id = 2})
      a.vero(x < y)
    end)
    prova("tostring contiene id e titolo", function()
      local s = tostring(att({titolo = "prova",
        id = 3}))
      a.vero(s:find("3", 1, true) ~= nil)
      a.vero(s:find("prova", 1, true) ~= nil)
    end)
  end)

end)

gruppo("filtri", function()

  local function insieme()
    return {
      att({titolo = "urgente scaduta", id = 1,
        priorita = "urgente", scadenza = "2026-08-01",
        etichette = "lavoro"}),
      att({titolo = "alta aperta", id = 2,
        priorita = "alta", etichette = "casa"}),
      att({titolo = "media fatta", id = 3,
        priorita = "media", stato = "fatta",
        etichette = "casa,spesa"}),
      att({titolo = "bassa futura", id = 4,
        priorita = "bassa", scadenza = "2026-08-10",
        etichette = "lavoro"}),
      att({titolo = "in corso", id = 5,
        priorita = "alta", stato = "in corso"}),
    }
  end

  gruppo("ordinamento", function()
    prova("per id", function()
      local r = filtri.ordina(insieme(), "id")
      a.uguale({1, 2, 3, 4, 5},
        {r[1].id, r[2].id, r[3].id, r[4].id, r[5].id})
    end)
    prova("per priorita' decrescente", function()
      local r = filtri.ordina(insieme(), "priorita")
      a.uguale("urgente", r[1].priorita)
      a.uguale("bassa", r[5].priorita)
    end)
    prova("parita' risolta per id", function()
      local r = filtri.ordina(insieme(), "priorita")
      a.uguale(2, r[2].id)
      a.uguale(5, r[3].id)
    end)
    prova("senza scadenza in fondo", function()
      local r = filtri.ordina(insieme(), "scadenza")
      a.uguale(1, r[1].id)
      a.uguale(4, r[2].id)
    end)
    prova("criterio sconosciuto rifiutato", function()
      a.uguale(nil, filtri.ordina(insieme(), "colore"))
    end)
    prova("non modifica l'ingresso", function()
      local o = insieme()
      filtri.ordina(o, "priorita")
      a.uguale(1, o[1].id)
    end)
  end)

  gruppo("filtro", function()
    prova("per stato", function()
      local r = filtri.filtra(insieme(),
        {stato = "fatta"})
      a.uguale(1, #r)
      a.uguale(3, r[1].id)
    end)
    prova("aperte comprende 'in corso'", function()
      local r = filtri.filtra(insieme(),
        {aperte = true})
      a.uguale(4, #r)
    end)
    prova("per etichetta", function()
      local r = filtri.filtra(insieme(),
        {etichetta = "casa"})
      a.uguale(2, #r)
    end)
    prova("etichetta insensibile al caso", function()
      local r = filtri.filtra(insieme(),
        {etichetta = "CASA"})
      a.uguale(2, #r)
    end)
    prova("scadute", function()
      local r = filtri.filtra(insieme(),
        {scadute = true, oggi = OGGI})
      a.uguale(1, #r)
      a.uguale(1, r[1].id)
    end)
    prova("entro N giorni", function()
      local r = filtri.filtra(insieme(),
        {entro = 5, oggi = OGGI})
      a.uguale(2, #r)
    end)
    prova("criteri combinati", function()
      local r = filtri.filtra(insieme(), {
        etichetta = "lavoro", aperte = true,
        oggi = OGGI})
      a.uguale(2, #r)
    end)
    prova("nessun criterio restituisce tutto",
      function()
        a.uguale(5, #filtri.filtra(insieme(), {}))
      end)
    prova("criterio impossibile da' vuoto", function()
      a.uguale(0, #filtri.filtra(insieme(),
        {etichetta = "inesistente"}))
    end)
  end)

  gruppo("ricerca", function()
    prova("termine nel titolo", function()
      local r = filtri.cerca(insieme(), "urgente")
      a.vero(#r >= 1)
      a.uguale(1, r[1].id)
    end)
    prova("insensibile al caso", function()
      a.uguale(#filtri.cerca(insieme(), "URGENTE"),
        #filtri.cerca(insieme(), "urgente"))
    end)
    prova("termini multipli in AND", function()
      a.uguale(1, #filtri.cerca(insieme(),
        "urgente scaduta"))
      a.uguale(0, #filtri.cerca(insieme(),
        "urgente inesistente"))
    end)
    prova("cerca anche nelle etichette", function()
      a.vero(#filtri.cerca(insieme(), "spesa") >= 1)
    end)
    prova("testo vuoto rifiutato", function()
      local r, e = filtri.cerca(insieme(), "")
      a.uguale(0, #r)
      a.vero(e ~= nil)
    end)
    prova("il titolo pesa piu' delle etichette",
      function()
        local r = filtri.cerca(insieme(), "casa")
        a.vero(#r >= 1)
      end)
  end)

  gruppo("riepilogo", function()
    prova("totale corretto", function()
      a.uguale(5, filtri.riepiloga(insieme()).totale)
    end)
    prova("conteggio per stato", function()
      local r = filtri.riepiloga(insieme())
      a.uguale(3, r.perStato["aperta"])
      a.uguale(1, r.perStato["fatta"])
      a.uguale(1, r.perStato["in corso"])
    end)
    prova("conteggio per etichetta", function()
      local r = filtri.riepiloga(insieme())
      a.uguale(2, r.perEtichetta["casa"])
      a.uguale(2, r.perEtichetta["lavoro"])
    end)
    prova("scadute contate", function()
      local r = filtri.riepiloga(insieme(), OGGI)
      a.uguale(1, r.scadute)
      a.uguale(2, r.conScadenza)
    end)
    prova("insieme vuoto", function()
      local r = filtri.riepiloga({})
      a.uguale(0, r.totale)
      a.uguale(0, r.scadute)
    end)
  end)

end)

os.exit(T.esegui() and 0 or 1)
