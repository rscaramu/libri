-- ES 32.8 — Salvare e ripristinare la disposizione
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
