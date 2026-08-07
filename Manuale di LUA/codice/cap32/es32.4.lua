-- ES 32.4 — Selettore di buffer
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
