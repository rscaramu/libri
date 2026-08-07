-- ES 34.2 — Sottoattività
-- Manuale completo di Lua

comandi.fatta = {
  aiuto = "fatta <id> [<id> ...] [--forza]",
  opzioni = {"archivio", "forza"},
  esegui = function(contesto)
    local ids = contesto.analisi.posizionali
    if #ids == 0 then return nil, "serve almeno un id" end
    local forza = cli.booleana(contesto.opzioni, "forza")

    local fatte = {}
    for _, id in ipairs(ids) do
      if not forza then
        local ok, aperte =
          contesto.deposito:puoChiudere(id)
        if not ok then
          local elenco = {}
          for _, n in ipairs(aperte) do
            elenco[#elenco + 1] = "#" .. n
          end
          return nil, string.format(
            "#%s ha sottoattivita' aperte: %s "
            .. "(usa --forza per chiudere comunque)",
            id, table.concat(elenco, ", "))
        end
      end

      local a, errore = contesto.deposito:modifica(id,
        {stato = "fatta"})
      if a == nil then return nil, errore end
      fatte[#fatte + 1] = tostring(a)
    end

    contesto.deposito:salva()
    return "Completate:\n  "
      .. table.concat(fatte, "\n  ")
  end,
}
