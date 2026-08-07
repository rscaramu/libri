-- ES 33.8 — Sequenziale, parallelo, con limite complessivo
-- Manuale completo di Lua
-- Richiede OpenResty: non eseguibile con l'interprete
-- Lua da solo.

local M = {}

-- Le tre strategie, scritte contro un'astrazione del
-- trasporto per poterle provare fuori da OpenResty.

function M.sequenziale(chiamate, ambiente)
  local risultati = {}
  local inizio = ambiente.adesso()

  for i, c in ipairs(chiamate) do
    local ok, valore = ambiente.chiama(c)
    risultati[i] = {ok = ok, valore = valore,
      nome = c.nome}
  end

  return risultati, ambiente.adesso() - inizio
end

function M.parallelo(chiamate, ambiente)
  local inizio = ambiente.adesso()
  local fili = {}

  for i, c in ipairs(chiamate) do
    fili[i] = ambiente.avvia(c)
  end

  local risultati = {}
  for i, f in ipairs(fili) do
    local ok, valore = ambiente.attendi(f)
    risultati[i] = {ok = ok, valore = valore,
      nome = chiamate[i].nome}
  end

  return risultati, ambiente.adesso() - inizio
end

function M.paralleloConLimite(chiamate, ambiente,
                              limite)
  local inizio = ambiente.adesso()
  local fili = {}

  for i, c in ipairs(chiamate) do
    fili[i] = ambiente.avvia(c)
  end

  -- un filo aggiuntivo fa da sveglia
  local sveglia = ambiente.avviaSveglia(limite)

  local risultati = {}
  local scaduto = false

  for i, f in ipairs(fili) do
    if scaduto then
      ambiente.uccidi(f)
      risultati[i] = {ok = false,
        valore = "limite complessivo superato",
        nome = chiamate[i].nome}
    else
      local rimasto = limite
        - (ambiente.adesso() - inizio)
      local ok, valore = ambiente.attendiEntro(f,
        rimasto)
      if ok == nil then
        scaduto = true
        ambiente.uccidi(f)
        risultati[i] = {ok = false,
          valore = "limite complessivo superato",
          nome = chiamate[i].nome}
      else
        risultati[i] = {ok = ok, valore = valore,
          nome = chiamate[i].nome}
      end
    end
  end

  ambiente.uccidi(sveglia)
  return risultati, ambiente.adesso() - inizio
end

-- Ambiente simulato: il tempo avanza a scatti
local function ambienteSimulato()
  local orologio = 0
  return {
    adesso = function() return orologio end,
    chiama = function(c)
      orologio = orologio + c.durata
      if c.guasto then return false, "irraggiungibile" end
      return true, c.nome .. ": ok"
    end,
    avvia = function(c)
      return {chiamata = c, avviatoA = orologio}
    end,
    attendi = function(f)
      local fine = f.avviatoA + f.chiamata.durata
      if fine > orologio then orologio = fine end
      if f.chiamata.guasto then
        return false, "irraggiungibile"
      end
      return true, f.chiamata.nome .. ": ok"
    end,
    attendiEntro = function(f, quanto)
      local fine = f.avviatoA + f.chiamata.durata
      if fine - f.avviatoA > quanto then
        orologio = f.avviatoA + quanto
        return nil
      end
      if fine > orologio then orologio = fine end
      if f.chiamata.guasto then
        return false, "irraggiungibile"
      end
      return true, f.chiamata.nome .. ": ok"
    end,
    avviaSveglia = function() return {} end,
    uccidi = function() end,
  }
end

local SCENARI = {
  {nome = "entrambi rapidi",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 60}}},
  {nome = "uno lento",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 900}}},
  {nome = "uno irraggiungibile",
   chiamate = {
     {nome = "A", durata = 50},
     {nome = "B", durata = 2000, guasto = true}}},
}

print(string.format("%-22s %-14s %7s  %s",
  "SCENARIO", "STRATEGIA", "TEMPO", "ESITI"))

for _, sc in ipairs(SCENARI) do
  for _, st in ipairs({
      {"sequenziale", M.sequenziale, nil},
      {"parallela", M.parallelo, nil},
      {"con limite 500", M.paralleloConLimite, 500}}) do
    local amb = ambienteSimulato()
    local r, tempo
    if st[3] then
      r, tempo = st[2](sc.chiamate, amb, st[3])
    else
      r, tempo = st[2](sc.chiamate, amb)
    end
    local esiti = {}
    for _, x in ipairs(r) do
      esiti[#esiti + 1] = x.nome .. "="
        .. (x.ok and "ok" or "KO")
    end
    print(string.format("%-22s %-14s %5dms  %s",
      sc.nome, st[1], tempo, table.concat(esiti, " ")))
  end
end

return M
