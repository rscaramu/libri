-- ES 32.5 — luacheck asincrono
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
