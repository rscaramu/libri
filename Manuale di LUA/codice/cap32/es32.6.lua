-- ES 32.6 — Misurare il tempo di avvio per plugin
-- Manuale completo di Lua
-- Richiede Neovim: non eseguibile con l'interprete
-- Lua da solo.

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
