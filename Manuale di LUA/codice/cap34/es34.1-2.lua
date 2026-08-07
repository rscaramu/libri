-- ES 34.1 — Il comando `rinvia`
-- Manuale completo di Lua

comandi.rinvia = {
  aiuto = "rinvia <id> [<id> ...] --giorni N",
  opzioni = {"giorni", "archivio"},
  esegui = function(contesto)
    local ids = contesto.analisi.posizionali
    if #ids == 0 then return nil, "serve almeno un id" end

    local giorni, errore = cli.numero(contesto.opzioni,
      "giorni")
    if giorni == nil then
      return nil, errore or "serve --giorni N"
    end

    local righe = {}
    for _, id in ipairs(ids) do
      local a, err = contesto.deposito:trova(id)
      if a == nil then return nil, err end

      local nuova, precedente = a:rinvia(giorni)
      if nuova == nil then
        return nil, string.format("#%s: %s", id,
          precedente)
      end

      righe[#righe + 1] = string.format(
        "#%d %s: %s -> %s", a.id, a.titolo,
        precedente or "(nessuna scadenza)", nuova)
    end

    contesto.deposito.modificato = true
    contesto.deposito:salva()
    return "Rinviate:\n  " .. table.concat(righe,
      "\n  ")
  end,
}
