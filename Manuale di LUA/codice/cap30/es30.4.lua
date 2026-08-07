-- ES 30.4 — Rilevatore con analizzatore lessicale
-- Manuale completo di Lua

local function tokenizza(sorgente)
  local unita = {}
  local i = 1
  local riga = 1
  local n = #sorgente

  local function avanza(quanti)
    for k = i, math.min(i + quanti - 1, n) do
      if sorgente:sub(k, k) == "\n" then
        riga = riga + 1
      end
    end
    i = i + quanti
  end

  local function livelloParentesiLunghe(da)
    if sorgente:sub(da, da) ~= "[" then return nil end
    local k = da + 1
    local livello = 0
    while sorgente:sub(k, k) == "=" do
      livello = livello + 1
      k = k + 1
    end
    if sorgente:sub(k, k) == "[" then
      return livello, k + 1
    end
    return nil
  end

  local function saltaLungo(inizio, livello)
    local chiusura = "]" .. string.rep("=", livello)
      .. "]"
    local fine = sorgente:find(chiusura, inizio, true)
    if fine == nil then return n + 1 end
    return fine + #chiusura
  end

  while i <= n do
    local c = sorgente:sub(i, i)

    -- commento
    if sorgente:sub(i, i + 1) == "--" then
      local livello, dopo =
        livelloParentesiLunghe(i + 2)
      if livello then
        local fine = saltaLungo(dopo, livello)
        avanza(fine - i)
      else
        local fine = sorgente:find("\n", i, true)
          or (n + 1)
        avanza(fine - i)
      end

    -- stringa lunga
    elseif c == "[" and livelloParentesiLunghe(i) then
      local livello, dopo = livelloParentesiLunghe(i)
      local fine = saltaLungo(dopo, livello)
      avanza(fine - i)

    -- stringa breve
    elseif c == '"' or c == "'" then
      local apice = c
      local k = i + 1
      while k <= n do
        local d = sorgente:sub(k, k)
        if d == "\\" then
          k = k + 2
        elseif d == apice then
          k = k + 1
          break
        else
          k = k + 1
        end
      end
      avanza(k - i)

    -- numero
    elseif c:match("%d") then
      local k = i
      while k <= n
        and sorgente:sub(k, k):match("[%w%.]") do
        k = k + 1
      end
      avanza(k - i)

    -- identificatore
    elseif c:match("[%a_]") then
      local k = i
      while k <= n
        and sorgente:sub(k, k):match("[%w_]") do
        k = k + 1
      end
      unita[#unita + 1] = {
        tipo = "nome",
        testo = sorgente:sub(i, k - 1),
        riga = riga,
      }
      avanza(k - i)

    -- simboli significativi
    elseif sorgente:sub(i, i + 1) == "//"
        or sorgente:sub(i, i + 1) == "<<"
        or sorgente:sub(i, i + 1) == ">>" then
      unita[#unita + 1] = {
        tipo = "operatore",
        testo = sorgente:sub(i, i + 1),
        riga = riga,
      }
      avanza(2)

    elseif c == "&" or c == "|" or c == "~" then
      unita[#unita + 1] = {
        tipo = "operatore", testo = c, riga = riga,
      }
      avanza(1)

    elseif c == "<" then
      -- possibile attributo <const> o <close>
      local nome, fine =
        sorgente:match("^<%s*(%a+)%s*>()", i)
      if nome == "const" or nome == "close" then
        unita[#unita + 1] = {
          tipo = "attributo", testo = nome,
          riga = riga,
        }
        avanza(fine - i)
      else
        avanza(1)
      end

    else
      avanza(1)
    end
  end

  return unita
end

local RIMOSSE = {
  ["module"] = {"5.2", "usa una tabella locale"},
  ["setfenv"] = {"5.2", "usa _ENV"},
  ["getfenv"] = {"5.2", "usa _ENV"},
  ["loadstring"] = {"5.2", "usa load"},
  ["maxn"] = {"5.2", "calcola a mano"},
  ["pow"] = {"5.3", "usa l'operatore ^"},
  ["cosh"] = {"5.3", "formula esplicita"},
}

local INTRODOTTE = {
  ["//"] = "5.3", ["&"] = "5.3", ["|"] = "5.3",
  ["<<"] = "5.3", [">>"] = "5.3",
  ["const"] = "5.4", ["close"] = "5.4",
  ["warn"] = "5.4",
}

local function confronta(a, b)
  local ma, na = a:match("(%d+)%.(%d+)")
  local mb, nb = b:match("(%d+)%.(%d+)")
  ma, na = tonumber(ma), tonumber(na)
  mb, nb = tonumber(mb), tonumber(nb)
  if ma ~= mb then return ma < mb and -1 or 1 end
  if na ~= nb then return na < nb and -1 or 1 end
  return 0
end

local function analizza(sorgente, versione)
  local segnalazioni = {}
  for _, u in ipairs(tokenizza(sorgente)) do
    local rimossa = RIMOSSE[u.testo]
    if u.tipo == "nome" and rimossa
       and confronta(versione, rimossa[1]) >= 0 then
      segnalazioni[#segnalazioni + 1] = string.format(
        "riga %d: %s rimossa in Lua %s (%s)",
        u.riga, u.testo, rimossa[1], rimossa[2])
    end

    local introdotta = INTRODOTTE[u.testo]
    if (u.tipo == "operatore" or u.tipo == "attributo"
        or u.tipo == "nome")
       and introdotta
       and confronta(versione, introdotta) < 0 then
      segnalazioni[#segnalazioni + 1] = string.format(
        "riga %d: %s richiede Lua %s",
        u.riga, u.testo, introdotta)
    end
  end
  return segnalazioni
end

local SORGENTE = [==[
local M = {}
-- questo commento parla di math.pow e non conta
local documentazione = [[
  Anche qui dentro math.pow e setfenv sono testo.
]]
local avviso = "loadstring in una stringa"
function M.calcola(x)
  local y <const> = math.pow(x, 2)
  local z = 17 // 5
  return y & z
end
--[[ commento lungo
     con table.maxn dentro
]]
return M
]==]

for _, versione in ipairs({"5.1", "5.3", "5.4"}) do
  print("=== per Lua " .. versione .. " ===")
  local s = analizza(SORGENTE, versione)
  if #s == 0 then print("  nessun problema") end
  for _, riga in ipairs(s) do print("  " .. riga) end
  print()
end
