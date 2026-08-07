-- ES 34.4 — Esportazione JSON
-- Manuale completo di Lua

comandi.esporta = {
  aiuto = "esporta [--formato csv|json] [--leggibile]",
  opzioni = {"formato", "leggibile", "archivio"},
  esegui = function(contesto)
    local f = cli.stringa(contesto.opzioni, "formato",
      "csv")
    local ordinate = filtri.ordina(
      contesto.deposito:tutte(), "id")

    if f == "csv" then
      return formato.csv(ordinate)
    end

    if f == "json" then
      local grezze = {}
      for i, a in ipairs(ordinate) do
        grezze[i] = a:comeTabella()
      end
      local testo, errore = json.codifica({
        generato = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        quante = #grezze,
        attivita = grezze,
      }, {leggibile = cli.booleana(contesto.opzioni,
        "leggibile")})
      if testo == nil then
        return nil, "esportazione fallita: " .. errore
      end
      return testo
    end

    return nil, "formato non supportato: " .. f
  end,
}
