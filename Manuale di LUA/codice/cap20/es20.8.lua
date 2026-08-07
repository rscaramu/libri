-- ES 20.8 — CSV con intestazione
-- Manuale completo di Lua

local function analizzaRighe(testo, separatore)
  separatore = separatore or ","
  local righe, campi, campo = {}, {}, {}
  local dentro = false
  local i, n = 1, #testo

  local function chiudiCampo()
    campi[#campi + 1] = table.concat(campo)
    campo = {}
  end

  local function chiudiRiga()
    chiudiCampo()
    righe[#righe + 1] = campi
    campi = {}
  end

  while i <= n do
    local c = testo:sub(i, i)
    if dentro then
      if c == '"' then
        if testo:sub(i + 1, i + 1) == '"' then
          campo[#campo + 1] = '"'
          i = i + 2
        else
          dentro = false
          i = i + 1
        end
      else
        campo[#campo + 1] = c
        i = i + 1
      end
    elseif c == '"' and #campo == 0 then
      dentro = true
      i = i + 1
    elseif c == separatore then
      chiudiCampo()
      i = i + 1
    elseif c == "\r" then
      i = i + 1
    elseif c == "\n" then
      chiudiRiga()
      i = i + 1
    else
      campo[#campo + 1] = c
      i = i + 1
    end
  end

  if dentro then return nil, "virgolette non chiuse" end
  if #campo > 0 or #campi > 0 then chiudiRiga() end
  return righe
end

local function leggiRecord(testo, separatore)
  local righe, errore = analizzaRighe(testo, separatore)
  if righe == nil then return nil, errore end
  if #righe == 0 then return {}, {} end

  local intestazione = righe[1]
  local attese = #intestazione

  local visti = {}
  for i, nome in ipairs(intestazione) do
    if nome == "" then
      return nil, "colonna " .. i .. " senza nome"
    end
    if visti[nome] then
      return nil, "colonna duplicata: " .. nome
    end
    visti[nome] = true
  end

  local record = {}
  local problemi = {}

  for r = 2, #righe do
    local riga = righe[r]
    if #riga ~= attese then
      problemi[#problemi + 1] = string.format(
        "riga %d: %d campi invece di %d",
        r, #riga, attese)
    else
      local rec = {}
      for c = 1, attese do
        rec[intestazione[c]] = riga[c]
      end
      rec._riga = r
      record[#record + 1] = rec
    end
  end

  return record, problemi, intestazione
end

local SORGENTE =
  'nome,citta,eta\n'
  .. '"Rossi, Mario",Roma,34\n'
  .. 'Bianchi,Milano,28\n'
  .. 'Corta,Torino\n'
  .. 'Lunga,Napoli,50,extra\n'
  .. 'Verdi,"Reggio\nEmilia",41\n'

local record, problemi, intestazione =
  leggiRecord(SORGENTE)

print("colonne: " .. table.concat(intestazione, ", "))
print("record validi: " .. #record)
for _, r in ipairs(record) do
  print(string.format("  riga %d: %-14s %-14s %s",
    r._riga, r.nome, r.citta, r.eta))
end

print("problemi: " .. #problemi)
for _, p in ipairs(problemi) do
  print("  " .. p)
end

print()
print(leggiRecord("a,a\n1,2\n"))
print(leggiRecord("a,,c\n1,2,3\n"))
