-- ES 32.3 — Statistiche della selezione
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
