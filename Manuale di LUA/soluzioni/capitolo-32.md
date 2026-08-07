# Capitolo 32 — Configurare ed estendere Neovim in Lua

Soluzioni degli esercizi proposti del *Manuale completo di Lua*.

[← Capitolo 31](capitolo-31.md) · [Indice](README.md) · [Capitolo 33 →](capitolo-33.md)

---

Anche queste soluzioni non sono eseguibili fuori da Neovim. Il codice
segue l’API della versione 0.10 ed è verificato sintatticamente.

**ES 32.3 — Statistiche della selezione**

*Estendi il plugin del paragrafo 32.6 con una modalità che mostri le
statistiche solo della selezione visuale invece dell’intero buffer,
e con il conteggio dei caratteri escludendo gli spazi.*

```lua
local M = {}

local PREDEFINITI = {
  larghezza = 60,
  bordo = "rounded",
  escludiSpazi = true,
}

local configurazione = nil

local function testoSelezionato()
  local modo = vim.fn.mode()
  local buf = vim.api.nvim_get_current_buf()

  -- I marcatori < e > sono aggiornati all'uscita
  -- dal modo visuale, quindi usciamo prima.
  if modo:match("^[vV\22]") then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(
        "<Esc>", true, false, true), "nx", false)
  end

  local inizio = vim.api.nvim_buf_get_mark(buf, "<")
  local fine = vim.api.nvim_buf_get_mark(buf, ">")

  if inizio[1] == 0 or fine[1] == 0 then
    return nil
  end

  local righe = vim.api.nvim_buf_get_lines(
    buf, inizio[1] - 1, fine[1], false)

  if #righe == 0 then return nil end

  -- Ritaglio delle colonne sulla prima e ultima riga
  if #righe == 1 then
    righe[1] = righe[1]:sub(inizio[2] + 1,
      math.min(fine[2] + 1, #righe[1]))
  else
    righe[1] = righe[1]:sub(inizio[2] + 1)
    righe[#righe] = righe[#righe]:sub(1,
      math.min(fine[2] + 1, #righe[#righe]))
  end

  return righe, inizio[1], fine[1]
end

local function conta(righe)
  local parole, caratteri, senzaSpazi = 0, 0, 0
  local frasi = 0

  for _, riga in ipairs(righe) do
    caratteri = caratteri + vim.fn.strchars(riga)
    local pulita = riga:gsub("%s", "")
    senzaSpazi = senzaSpazi + vim.fn.strchars(pulita)
    for _ in riga:gmatch("%S+") do
      parole = parole + 1
    end
    for _ in riga:gmatch("[%.%!%?]") do
      frasi = frasi + 1
    end
  end

  return {
    righe = #righe,
    parole = parole,
    caratteri = caratteri,
    senzaSpazi = senzaSpazi,
    frasi = frasi,
  }
end

local function apriFinestra(testo)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, testo)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local larghezza = configurazione.larghezza
  local altezza = #testo

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = larghezza,
    height = altezza,
    row = math.floor((vim.o.lines - altezza) / 2),
    col = math.floor((vim.o.columns - larghezza) / 2),
    style = "minimal",
    border = configurazione.bordo,
  })

  vim.keymap.set("n", "q", "<cmd>close<cr>",
    {buffer = buf, nowait = true})
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>",
    {buffer = buf, nowait = true})
end

local function mostra(righe, etichetta)
  local s = conta(righe)
  local testo = {
    " Statistiche: " .. etichetta,
    " " .. string.rep("-",
      configurazione.larghezza - 2),
    string.format(" Righe:              %d", s.righe),
    string.format(" Parole:             %d", s.parole),
    string.format(" Caratteri:          %d",
      s.caratteri),
    string.format(" Senza spazi:        %d",
      s.senzaSpazi),
    string.format(" Frasi (stima):      %d", s.frasi),
    " ",
    " Premi q per chiudere",
  }
  apriFinestra(testo)
end

function M.buffer()
  if configurazione == nil then M.setup({}) end
  local buf = vim.api.nvim_get_current_buf()
  local righe = vim.api.nvim_buf_get_lines(
    buf, 0, -1, false)
  mostra(righe, "intero buffer")
end

function M.selezione()
  if configurazione == nil then M.setup({}) end
  local righe, da, a = testoSelezionato()
  if righe == nil then
    vim.notify("nessuna selezione",
      vim.log.levels.WARN)
    return
  end
  mostra(righe, string.format("righe %d-%d", da, a))
end

function M.setup(opzioni)
  opzioni = opzioni or {}
  configurazione = {}
  for k, v in pairs(PREDEFINITI) do
    configurazione[k] = v
  end
  for k, v in pairs(opzioni) do
    if PREDEFINITI[k] == nil then
      error("opzione sconosciuta: " .. tostring(k), 2)
    end
    configurazione[k] = v
  end

  vim.api.nvim_create_user_command("Statistiche",
    function(o)
      if o.range > 0 then
        M.selezione()
      else
        M.buffer()
      end
    end, {range = true,
      desc = "Statistiche del buffer o della selezione"})

  vim.keymap.set("n", "<leader>s", M.buffer,
    {desc = "Statistiche del buffer"})
  vim.keymap.set("v", "<leader>s", ":Statistiche<cr>",
    {desc = "Statistiche della selezione"})

  return M
end

return M
```

Due dettagli specifici di Neovim meritano attenzione.

I marcatori `<` e `>` che delimitano la selezione visuale sono aggiornati
**all’uscita** dal modo visuale, non durante. Un comando invocato mentre
la selezione è attiva legge quindi i marcatori della selezione
**precedente**. La soluzione adottata è uscire dal modo visuale con
`nvim_feedkeys` prima di leggerli; l’alternativa più pulita è associare
il comando con `:` invece che con una funzione, perché Vim esce dal modo
visuale automaticamente.

`vim.fn.strchars` invece di `#` conta i **caratteri** e non i byte, come
nell’ES 19.7. Su testo italiano con accenti la differenza è immediata.

**ES 32.4 — Selettore di buffer**

*Scrivi un comando che apra una finestra fluttuante con l’elenco dei
buffer aperti e permetta di sceglierne uno con i tasti direzionali e
Invio, chiudendo la finestra alla selezione.*

```lua
local M = {}

local function bufferAperti()
  local elenco = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b)
       and vim.bo[b].buflisted then
      local nome = vim.api.nvim_buf_get_name(b)
      local breve = nome
      if nome == "" then
        breve = "[senza nome]"
      else
        breve = vim.fn.fnamemodify(nome, ":~:.")
      end
      elenco[#elenco + 1] = {
        numero = b,
        nome = breve,
        modificato = vim.bo[b].modified,
        corrente = b == vim.api.nvim_get_current_buf(),
      }
    end
  end
  table.sort(elenco, function(a, b)
    return a.numero < b.numero
  end)
  return elenco
end

function M.apri()
  local elenco = bufferAperti()
  if #elenco == 0 then
    vim.notify("nessun buffer", vim.log.levels.WARN)
    return
  end

  local righe = {}
  for i, b in ipairs(elenco) do
    righe[i] = string.format(" %s%s %3d  %s",
      b.corrente and ">" or " ",
      b.modificato and "+" or " ",
      b.numero, b.nome)
  end

  local larghezza = 0
  for _, r in ipairs(righe) do
    if #r > larghezza then larghezza = #r end
  end
  larghezza = math.max(larghezza + 4, 40)
  larghezza = math.min(larghezza, vim.o.columns - 8)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, righe)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "selettorebuffer"

  local altezza = math.min(#righe, vim.o.lines - 8)

  local finestra = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = larghezza,
    height = altezza,
    row = math.floor((vim.o.lines - altezza) / 2),
    col = math.floor((vim.o.columns - larghezza) / 2),
    style = "minimal",
    border = "rounded",
    title = " buffer ",
    title_pos = "center",
  })

  vim.wo[finestra].cursorline = true

  -- posiziona il cursore sul buffer corrente
  for i, b in ipairs(elenco) do
    if b.corrente then
      vim.api.nvim_win_set_cursor(finestra, {i, 0})
      break
    end
  end

  local function chiudi()
    if vim.api.nvim_win_is_valid(finestra) then
      vim.api.nvim_win_close(finestra, true)
    end
  end

  local function scegli()
    local riga = vim.api.nvim_win_get_cursor(
      finestra)[1]
    local scelto = elenco[riga]
    chiudi()
    if scelto then
      vim.api.nvim_set_current_buf(scelto.numero)
    end
  end

  local function elimina()
    local riga = vim.api.nvim_win_get_cursor(
      finestra)[1]
    local scelto = elenco[riga]
    if scelto == nil then return end
    if scelto.modificato then
      vim.notify("buffer modificato, salvalo prima",
        vim.log.levels.WARN)
      return
    end
    chiudi()
    vim.api.nvim_buf_delete(scelto.numero, {})
    M.apri()
  end

  local opzioni = {buffer = buf, nowait = true}
  vim.keymap.set("n", "<cr>", scegli, opzioni)
  vim.keymap.set("n", "q", chiudi, opzioni)
  vim.keymap.set("n", "<Esc>", chiudi, opzioni)
  vim.keymap.set("n", "d", elimina, opzioni)

  -- chiusura se la finestra perde il focus
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = chiudi,
  })
end

function M.setup()
  vim.api.nvim_create_user_command("Buffer", M.apri,
    {desc = "Selettore di buffer"})
  vim.keymap.set("n", "<leader>b", M.apri,
    {desc = "Elenco dei buffer"})
  return M
end

return M
```

I dettagli che distinguono un selettore usabile da uno approssimativo.

Il **cursore parte sul buffer corrente**, non sulla prima riga: chi apre
l’elenco vuole quasi sempre spostarsi a un vicino.

La **larghezza si adatta** al nome più lungo, con un minimo e un massimo:
una finestra fissa taglierebbe i percorsi lunghi o sprecherebbe spazio.

Il **buffer modificato viene segnalato con `+`** e la sua eliminazione
rifiutata: cancellare un buffer con modifiche non salvate perderebbe
lavoro.

La chiusura su `BufLeave` con `once = true` evita di lasciare la finestra
fluttuante aperta se l’utente cambia finestra in altro modo.

**ES 32.5 — luacheck asincrono**

*Implementa un comando automatico che, salvando un file Lua, esegua
`luacheck` in modo asincrono con `vim.system` e mostri le
segnalazioni nella lista di diagnostica di Neovim.*

```lua
local M = {}

local spazio = vim.api.nvim_create_namespace(
  "luacheck-asincrono")

local CODICI_ERRORE = {
  ["0"] = vim.diagnostic.severity.ERROR,
  ["1"] = vim.diagnostic.severity.WARN,
  ["2"] = vim.diagnostic.severity.WARN,
  ["5"] = vim.diagnostic.severity.WARN,
  ["6"] = vim.diagnostic.severity.HINT,
}

local function gravita(codice)
  local primo = tostring(codice):sub(1, 1)
  return CODICI_ERRORE[primo]
    or vim.diagnostic.severity.WARN
end

local function analizzaUscita(testo, buf)
  local diagnostiche = {}

  for riga in (testo .. "\n"):gmatch("(.-)\n") do
    -- formato: file:riga:colonna: (Wnnn) messaggio
    local numeroRiga, colonna, codice, messaggio =
      riga:match("^[^:]*:(%d+):(%d+):%s*%((%a%d+)%)%s*(.*)$")

    if numeroRiga == nil then
      numeroRiga, colonna, messaggio =
        riga:match("^[^:]*:(%d+):(%d+):%s*(.*)$")
      codice = nil
    end

    if numeroRiga then
      diagnostiche[#diagnostiche + 1] = {
        bufnr = buf,
        lnum = tonumber(numeroRiga) - 1,
        col = tonumber(colonna) - 1,
        severity = codice and gravita(codice:sub(2))
          or vim.diagnostic.severity.WARN,
        source = "luacheck",
        code = codice,
        message = messaggio,
      }
    end
  end

  return diagnostiche
end

function M.controlla(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local percorso = vim.api.nvim_buf_get_name(buf)
  if percorso == "" then return end
  if vim.bo[buf].filetype ~= "lua" then return end

  if vim.fn.executable("luacheck") ~= 1 then
    vim.notify("luacheck non trovato nel PATH",
      vim.log.levels.WARN)
    return
  end

  vim.system(
    {"luacheck", "--formatter", "plain", "--codes",
     "--ranges", percorso},
    {text = true},
    vim.schedule_wrap(function(risultato)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local uscita = (risultato.stdout or "")
        .. (risultato.stderr or "")
      local diagnostiche = analizzaUscita(uscita, buf)
      vim.diagnostic.set(spazio, buf, diagnostiche)

      if #diagnostiche == 0 then
        vim.notify("luacheck: nessuna segnalazione",
          vim.log.levels.INFO)
      end
    end))
end

function M.pulisci(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(spazio, buf)
end

function M.setup(opzioni)
  opzioni = opzioni or {}

  local gruppo = vim.api.nvim_create_augroup(
    "LuacheckAsincrono", {clear = true})

  if opzioni.alSalvataggio ~= false then
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = gruppo,
      pattern = "*.lua",
      callback = function(evento)
        M.controlla(evento.buf)
      end,
    })
  end

  vim.api.nvim_create_autocmd("BufDelete", {
    group = gruppo,
    pattern = "*.lua",
    callback = function(evento)
      M.pulisci(evento.buf)
    end,
  })

  vim.api.nvim_create_user_command("Luacheck",
    function() M.controlla() end,
    {desc = "Esegue luacheck sul buffer"})

  return M
end

return M
```

Quattro punti tecnici.

`vim.system` è la funzione moderna e sostituisce l’uso diretto di
`vim.loop.spawn` mostrato nel paragrafo 32.8: gestisce i canali, la
raccolta dell’output e la terminazione.

`vim.schedule_wrap` sulla callback è **obbligatorio**, per la ragione del
paragrafo 32.8: le funzioni dell’API di Neovim non si possono chiamare
dal ciclo di eventi. Ometterlo produce l’errore *E5560*, e il codice
generato dai modelli lo omette regolarmente.

La verifica `nvim_buf_is_valid` prima di usare il buffer è necessaria:
fra l’avvio del processo e il suo termine l’utente può aver chiuso il
file.

L’uso di un **namespace dedicato** per le diagnostiche permette di
pulirle senza toccare quelle di altri strumenti, per esempio il server di
linguaggio.

**ES 32.6 — Misurare il tempo di avvio per plugin**

*Scrivi una funzione che misuri il tempo di avvio di Neovim
scomponendolo per plugin, e confronta il risultato con quello
riportato da `nvim --startuptime`.*

```lua
local M = {}

local misure = {}
local requireOriginale = nil
local profondita = 0

local function adesso()
  return (vim.uv or vim.loop).hrtime()
end

function M.avvia()
  if requireOriginale ~= nil then return end
  requireOriginale = require

  _G.require = function(nome)
    -- gia' caricato: costo nullo, non si misura
    if package.loaded[nome] ~= nil then
      return requireOriginale(nome)
    end

    profondita = profondita + 1
    local livello = profondita
    local inizio = adesso()

    local ok, risultato = pcall(requireOriginale, nome)

    local durata = (adesso() - inizio) / 1e6
    profondita = profondita - 1

    misure[#misure + 1] = {
      nome = nome,
      durata = durata,
      livello = livello,
      ok = ok,
      ordine = #misure + 1,
    }

    if not ok then error(risultato, 0) end
    return risultato
  end
end

function M.ferma()
  if requireOriginale == nil then return end
  _G.require = requireOriginale
  requireOriginale = nil
end

function M.rapporto(quanti)
  quanti = quanti or 20

  -- il costo PROPRIO e' la durata totale meno
  -- quella dei moduli caricati al suo interno
  local propri = {}
  for i, m in ipairs(misure) do
    local figlie = 0
    for j = i + 1, #misure do
      if misure[j].livello <= m.livello then break end
      if misure[j].livello == m.livello + 1 then
        figlie = figlie + misure[j].durata
      end
    end
    propri[#propri + 1] = {
      nome = m.nome,
      totale = m.durata,
      proprio = m.durata - figlie,
      livello = m.livello,
      ok = m.ok,
    }
  end

  table.sort(propri, function(a, b)
    return a.proprio > b.proprio
  end)

  local righe = {
    string.format("%-38s %9s %9s", "MODULO",
      "PROPRIO", "TOTALE"),
    string.rep("-", 58),
  }

  local sommaProprio = 0
  for _, p in ipairs(propri) do
    sommaProprio = sommaProprio + p.proprio
  end

  for i = 1, math.min(quanti, #propri) do
    local p = propri[i]
    righe[#righe + 1] = string.format(
      "%-38s %8.2f %8.2f%s",
      p.nome:sub(1, 38), p.proprio, p.totale,
      p.ok and "" or "  ERRORE")
  end

  righe[#righe + 1] = string.rep("-", 58)
  righe[#righe + 1] = string.format(
    "%d moduli, %.2f ms complessivi",
    #propri, sommaProprio)

  return table.concat(righe, "\n")
end

function M.mostra()
  local testo = vim.split(M.rapporto(25), "\n")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, testo)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local altezza = math.min(#testo, vim.o.lines - 6)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 62,
    height = altezza,
    row = math.floor((vim.o.lines - altezza) / 2),
    col = math.floor((vim.o.columns - 62) / 2),
    style = "minimal",
    border = "rounded",
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>",
    {buffer = buf, nowait = true})
end

function M.setup()
  vim.api.nvim_create_user_command("AvvioRapporto",
    M.mostra, {desc = "Tempo di avvio per modulo"})

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function() M.ferma() end,
  })

  return M
end

return M
```

Il modulo va caricato **come prima riga** di `init.lua`, chiamando
`M.avvia()` prima di qualunque altro `require`.

Il calcolo del **costo proprio** è la parte che rende utile il rapporto:
un modulo che ne carica altri dieci ha un tempo totale enorme, ma il
tempo che consuma davvero è la differenza. Ordinare per il totale
metterebbe sempre in cima il modulo radice, che non dice nulla.

Il confronto con `nvim --startuptime` mostra due differenze.

`--startuptime` misura **tutto**, comprese le fasi di Vim che non
riguardano Lua: lettura delle opzioni, apertura dei file, inizializzazione
dei plugin nel linguaggio storico. Questo profilatore vede solo i
`require`.

`--startuptime` ha una **granularità per file sorgente**, mentre questo
lavora per modulo logico. Un plugin che carica venti file Lua appare come
venti righe in `--startuptime` e come venti moduli qui, ma con
l’attribuzione gerarchica che permette di sommarli.

La conclusione pratica: usate `--startuptime` per capire se il problema
è nei plugin Lua o altrove, e questo profilatore per capire **quale**
plugin, una volta stabilito che il problema è lì.

**ES 32.7 — Rapporto delle scorciatoie**

*Scrivi un comando che riporti tutte le scorciatoie definite dalla
tua configurazione, raggruppate per modo e ordinate, segnalando
quelle prive del campo `desc` e quelle che ne ridefiniscono una
precedente.*

```lua
local M = {}

local MODI = {
  n = "normale", i = "inserimento", v = "visuale",
  x = "visuale a blocchi", s = "selezione",
  o = "operatore", t = "terminale",
  c = "riga di comando",
}

local function raccogli()
  local tutte = {}

  for lettera in pairs(MODI) do
    local associazioni = vim.api.nvim_get_keymap(lettera)
    for _, a in ipairs(associazioni) do
      tutte[#tutte + 1] = {
        modo = lettera,
        tasti = a.lhs,
        destinazione = a.rhs
          or (a.callback and "<funzione Lua>")
          or "?",
        descrizione = a.desc,
        buffer = false,
      }
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  for lettera in pairs(MODI) do
    local associazioni = vim.api.nvim_buf_get_keymap(
      buf, lettera)
    for _, a in ipairs(associazioni) do
      tutte[#tutte + 1] = {
        modo = lettera,
        tasti = a.lhs,
        destinazione = a.rhs
          or (a.callback and "<funzione Lua>")
          or "?",
        descrizione = a.desc,
        buffer = true,
      }
    end
  end

  return tutte
end

function M.rapporto(opzioni)
  opzioni = opzioni or {}
  local tutte = raccogli()

  local perModo = {}
  local senzaDesc = 0
  local viste = {}
  local doppie = {}

  for _, a in ipairs(tutte) do
    perModo[a.modo] = perModo[a.modo] or {}
    table.insert(perModo[a.modo], a)

    if a.descrizione == nil or a.descrizione == "" then
      senzaDesc = senzaDesc + 1
    end

    local chiave = a.modo .. "\0" .. a.tasti
      .. "\0" .. tostring(a.buffer)
    if viste[chiave] then
      doppie[#doppie + 1] = a
    end
    viste[chiave] = true
  end

  local righe = {"SCORCIATOIE DEFINITE", string.rep("=", 58)}

  local lettere = {}
  for m in pairs(perModo) do lettere[#lettere + 1] = m end
  table.sort(lettere)

  for _, m in ipairs(lettere) do
    local elenco = perModo[m]
    table.sort(elenco, function(a, b)
      if a.buffer ~= b.buffer then return not a.buffer end
      return a.tasti < b.tasti
    end)

    righe[#righe + 1] = ""
    righe[#righe + 1] = string.format("-- modo %s (%d) --",
      MODI[m] or m, #elenco)

    for _, a in ipairs(elenco) do
      if opzioni.soloSenzaDesc
         and a.descrizione ~= nil then
        -- salta
      else
        righe[#righe + 1] = string.format(
          " %s %-22s %s", a.buffer and "b" or " ",
          a.tasti,
          a.descrizione or "(SENZA DESCRIZIONE)")
      end
    end
  end

  righe[#righe + 1] = ""
  righe[#righe + 1] = string.rep("-", 58)
  righe[#righe + 1] = string.format(
    "%d scorciatoie, %d senza descrizione, %d "
    .. "ridefinizioni", #tutte, senzaDesc, #doppie)

  for _, d in ipairs(doppie) do
    righe[#righe + 1] = string.format(
      "  ridefinita: [%s] %s", d.modo, d.tasti)
  end

  return table.concat(righe, "\n")
end

function M.mostra(opzioni)
  local testo = vim.split(M.rapporto(opzioni), "\n")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, testo)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0,
    math.min(#testo, math.floor(vim.o.lines / 2)))

  vim.keymap.set("n", "q", "<cmd>close<cr>",
    {buffer = buf, nowait = true})
end

function M.setup()
  vim.api.nvim_create_user_command("Scorciatoie",
    function(o)
      M.mostra({soloSenzaDesc = o.bang})
    end, {bang = true,
      desc = "Rapporto delle scorciatoie"})
  return M
end

return M
```

Il rilevamento delle **ridefinizioni** merita una precisazione. Neovim
non conserva la storia delle associazioni: quando una scorciatoia ne
sostituisce un’altra, la precedente sparisce e `nvim_get_keymap`
restituisce solo quella attuale. Le «doppie» che il codice trova sono
quindi solo le collisioni fra ambito globale e ambito di buffer, che
convivono.

Per rilevare le vere ridefinizioni servirebbe intercettare
`vim.keymap.set` con un involucro installato all’inizio della
configurazione, come nel profilatore dell’ES 32.6. È un’estensione
naturale, e la lascio come nota invece di raddoppiare il codice.

Le scorciatoie **senza descrizione** sono la segnalazione più utile:
molti plugin di aiuto interattivo le mostrano, e una configurazione senza
`desc` è una configurazione che non si documenta da sola.

**ES 32.8 — Salvare e ripristinare la disposizione**

*Implementa un modulo che salvi e ripristini la disposizione delle
finestre e dei buffer di una sessione, senza usare il meccanismo
delle sessioni di Vim, e gestisci il caso di un file non più
esistente al ripristino.*

```lua
local M = {}

local PERCORSO = vim.fn.stdpath("data")
  .. "/disposizione.lua"

local function serializza(v, livello)
  livello = livello or 0
  local t = type(v)
  if t == "number" or t == "boolean" then
    return tostring(v)
  end
  if t == "string" then return string.format("%q", v) end
  if t ~= "table" then return "nil" end

  local dentro = string.rep("  ", livello + 1)
  local pezzi = {}
  for i = 1, #v do
    pezzi[#pezzi + 1] = dentro
      .. serializza(v[i], livello + 1)
  end
  local chiavi = {}
  for k in pairs(v) do
    if type(k) ~= "number" or k < 1 or k > #v then
      chiavi[#chiavi + 1] = k
    end
  end
  table.sort(chiavi, function(a, b)
    return tostring(a) < tostring(b)
  end)
  for _, k in ipairs(chiavi) do
    pezzi[#pezzi + 1] = dentro .. tostring(k) .. " = "
      .. serializza(v[k], livello + 1)
  end
  if #pezzi == 0 then return "{}" end
  return "{\n" .. table.concat(pezzi, ",\n") .. "\n"
    .. string.rep("  ", livello) .. "}"
end

local function raccogliFinestre(scheda)
  local finestre = {}
  for _, w in ipairs(
      vim.api.nvim_tabpage_list_wins(scheda)) do
    local buf = vim.api.nvim_win_get_buf(w)
    local nome = vim.api.nvim_buf_get_name(buf)
    local config = vim.api.nvim_win_get_config(w)

    -- si saltano le finestre fluttuanti
    if config.relative == "" then
      finestre[#finestre + 1] = {
        file = nome ~= "" and vim.fn.fnamemodify(nome,
          ":p") or nil,
        larghezza = vim.api.nvim_win_get_width(w),
        altezza = vim.api.nvim_win_get_height(w),
        cursore = vim.api.nvim_win_get_cursor(w),
        corrente = w == vim.api.nvim_get_current_win(),
      }
    end
  end
  return finestre
end

function M.salva()
  local schede = {}
  for _, s in ipairs(vim.api.nvim_list_tabpages()) do
    schede[#schede + 1] = {
      finestre = raccogliFinestre(s),
      corrente = s == vim.api.nvim_get_current_tabpage(),
    }
  end

  local dati = {
    versione = 1,
    salvatoIl = os.time(),
    cartella = vim.fn.getcwd(),
    schede = schede,
  }

  local f, errore = io.open(PERCORSO, "w")
  if f == nil then
    vim.notify("salvataggio fallito: "
      .. tostring(errore), vim.log.levels.ERROR)
    return false
  end
  f:write("return ", serializza(dati), "\n")
  f:close()

  vim.notify(string.format(
    "disposizione salvata: %d schede", #schede))
  return true
end

function M.ripristina()
  local f = io.open(PERCORSO, "r")
  if f == nil then
    vim.notify("nessuna disposizione salvata",
      vim.log.levels.WARN)
    return false
  end
  local testo = f:read("a")
  f:close()

  local chunk, errore = load(testo, "disposizione",
    "t", {})
  if chunk == nil then
    vim.notify("file corrotto: " .. errore,
      vim.log.levels.ERROR)
    return false
  end
  local ok, dati = pcall(chunk)
  if not ok or type(dati) ~= "table" then
    vim.notify("file malformato", vim.log.levels.ERROR)
    return false
  end

  if dati.cartella and dati.cartella ~= vim.fn.getcwd()
  then
    vim.notify("attenzione: salvata da "
      .. dati.cartella, vim.log.levels.WARN)
  end

  local mancanti = {}

  vim.cmd("silent! tabonly")
  vim.cmd("silent! only")

  for indiceScheda, scheda in ipairs(dati.schede or {}) do
    if indiceScheda > 1 then vim.cmd("tabnew") end

    local prima = true
    local daAttivare = nil

    for _, fin in ipairs(scheda.finestre or {}) do
      if not prima then
        vim.cmd("vsplit")
      end
      prima = false

      if fin.file then
        if vim.fn.filereadable(fin.file) == 1 then
          vim.cmd("edit " .. vim.fn.fnameescape(fin.file))
          pcall(vim.api.nvim_win_set_cursor, 0,
            fin.cursore)
        else
          mancanti[#mancanti + 1] = fin.file
          vim.cmd("enew")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "File non piu' esistente:",
            "  " .. fin.file,
          })
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
        end
      end

      if fin.corrente then
        daAttivare = vim.api.nvim_get_current_win()
      end
    end

    if daAttivare then
      pcall(vim.api.nvim_set_current_win, daAttivare)
    end
  end

  if #mancanti > 0 then
    vim.notify(string.format(
      "%d file non piu' esistenti", #mancanti),
      vim.log.levels.WARN)
  else
    vim.notify("disposizione ripristinata")
  end

  return true
end

function M.setup(opzioni)
  opzioni = opzioni or {}

  vim.api.nvim_create_user_command("DisposizioneSalva",
    M.salva, {desc = "Salva la disposizione"})
  vim.api.nvim_create_user_command(
    "DisposizioneRipristina", M.ripristina,
    {desc = "Ripristina la disposizione"})

  if opzioni.automatico then
    local gruppo = vim.api.nvim_create_augroup(
      "Disposizione", {clear = true})
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = gruppo,
      callback = function() M.salva() end,
    })
  end

  return M
end

return M
```

Quattro decisioni progettuali.

Le **finestre fluttuanti sono escluse**: sono transitorie per natura, e
ripristinarle produrrebbe finestre orfane senza il plugin che le aveva
create. Il filtro è `config.relative == ""`.

Il **file non più esistente** non fa fallire il ripristino: apre un
buffer temporaneo con il messaggio, così che la disposizione resti
riconoscibile e l’utente sappia che cosa manca. Saltarlo silenziosamente
cambierebbe la geometria; fallire perderebbe tutto il resto.

La **cartella di lavoro** viene registrata e confrontata: ripristinare
una disposizione salvata altrove produce percorsi relativi sbagliati, e
un avviso costa una riga.

Il file usa `load` con **ambiente vuoto**, secondo la regola del Capitolo
20: è un file nella cartella dati dell’utente, e non deve poter eseguire
codice.

Il limite dichiarato: la ricostruzione usa solo `vsplit`, quindi
disposizioni con divisioni orizzontali annidate non vengono riprodotte
fedelmente. Per la geometria esatta servirebbe registrare l’albero delle
divisioni con `vim.fn.winlayout`, che restituisce una struttura annidata
di `row`, `col` e `leaf`: è l’estensione naturale, e il motivo per cui
Vim ha un meccanismo di sessioni proprio.

---

[Indice delle soluzioni](README.md) · [Archivio](../README.md)
