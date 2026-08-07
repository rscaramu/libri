-- ES 34.6 — Cronologia delle modifiche
-- Manuale completo di Lua

comandi.storia = {
  aiuto = "storia <id>",
  opzioni = {"archivio"},
  esegui = function(contesto)
    local id = contesto.analisi.posizionali[1]
    if id == nil then return nil, "serve un id" end

    local a, errore = contesto.deposito:trova(id)
    if a == nil then return nil, errore end

    local righe = {
      string.format("Storia di #%d: %s", a.id,
        a.titolo),
      string.rep("-", 52),
      string.format("  %-19s creata",
        os.date("%Y-%m-%d %H:%M", a.creata)),
    }

    for _, v in ipairs(a.storia or {}) do
      righe[#righe + 1] = string.format(
        "  %-19s %-10s %s -> %s",
        os.date("%Y-%m-%d %H:%M", v.istante),
        v.campo,
        tostring(v.prima == nil and "(vuoto)"
          or v.prima),
        tostring(v.dopo))
    end

    if a.storia == nil or #a.storia == 0 then
      righe[#righe + 1] = "  (nessuna modifica)"
    end

    return table.concat(righe, "\n")
  end,
}
