-- ES 32.7 — Rapporto delle scorciatoie
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
