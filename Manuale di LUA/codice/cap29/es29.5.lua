-- ES 29.5 — Framework con setup, teardown e salto
-- Manuale completo di Lua

local Test = {}

local prove = {}
local corrente = nil
local ordine = 0

local function percorsoCorrente(nome)
  local percorso = nome
  local g = corrente
  while g do
    percorso = g.nome .. " > " .. percorso
    g = g.padre
  end
  return percorso
end

local function catenaGanci(quale)
  local ganci = {}
  local g = corrente
  while g do
    if g[quale] then
      table.insert(ganci, 1, g[quale])
    end
    g = g.padre
  end
  return ganci
end

function Test.gruppo(nome, corpo)
  local precedente = corrente
  corrente = {nome = nome, padre = precedente}
  corpo()
  corrente = precedente
end

function Test.primaDiOgnuno(f)
  if corrente == nil then
    error("primaDiOgnuno fuori da un gruppo", 2)
  end
  corrente.primaDiOgnuno = f
end

function Test.dopoOgnuno(f)
  if corrente == nil then
    error("dopoOgnuno fuori da un gruppo", 2)
  end
  corrente.dopoOgnuno = f
end

local function registra(nome, corpo, saltata, motivo)
  ordine = ordine + 1
  prove[#prove + 1] = {
    ordine = ordine,
    nome = percorsoCorrente(nome),
    corpo = corpo,
    saltata = saltata,
    motivo = motivo,
    prima = catenaGanci("primaDiOgnuno"),
    dopo = catenaGanci("dopoOgnuno"),
  }
end

function Test.prova(nome, corpo)
  registra(nome, corpo, false)
end

function Test.salta(nome, corpo, motivo)
  registra(nome, corpo, true, motivo or "saltata")
end

local function confronta(a, b)
  if a == b then return true end
  if type(a) ~= "table" or type(b) ~= "table" then
    return false
  end
  for k, v in pairs(a) do
    if not confronta(v, b[k]) then return false end
  end
  for k in pairs(b) do
    if a[k] == nil then return false end
  end
  return true
end

Test.assert = {}

function Test.assert.uguale(atteso, ottenuto, nota)
  if not confronta(atteso, ottenuto) then
    error(string.format("atteso %s, ottenuto %s%s",
      tostring(atteso), tostring(ottenuto),
      nota and (" (" .. nota .. ")") or ""), 2)
  end
end

function Test.assert.vero(v, nota)
  if not v then
    error("atteso vero, ottenuto " .. tostring(v)
      .. (nota and (" (" .. nota .. ")") or ""), 2)
  end
end

function Test.esegui()
  -- ordine DETERMINISTICO: quello di registrazione
  table.sort(prove, function(a, b)
    return a.ordine < b.ordine
  end)

  local passate, fallite, saltate = 0, 0, 0
  local dettagli = {}

  for _, p in ipairs(prove) do
    if p.saltata then
      saltate = saltate + 1
      io.write("s")
    else
      local contesto = {}

      local ok, messaggio = xpcall(function()
        for _, g in ipairs(p.prima) do g(contesto) end
        p.corpo(contesto)
      end, function(m) return tostring(m) end)

      -- i ganci di pulizia girano SEMPRE, anche
      -- se il test e' fallito
      for i = #p.dopo, 1, -1 do
        pcall(p.dopo[i], contesto)
      end

      if ok then
        passate = passate + 1
        io.write(".")
      else
        fallite = fallite + 1
        io.write("F")
        dettagli[#dettagli + 1] = {nome = p.nome,
          messaggio = messaggio}
      end
    end
  end

  io.write("\n\n")
  for _, d in ipairs(dettagli) do
    print("FALLITA: " .. d.nome)
    print("   " .. d.messaggio)
  end

  for _, p in ipairs(prove) do
    if p.saltata then
      print("SALTATA: " .. p.nome .. " (" .. p.motivo
        .. ")")
    end
  end

  print(string.format(
    "%d passate, %d fallite, %d saltate, %d totali",
    passate, fallite, saltate, #prove))

  return fallite == 0
end

-- Uso
local T = Test
local eventi = {}

T.gruppo("esterno", function()
  T.primaDiOgnuno(function(c)
    eventi[#eventi + 1] = "prima esterno"
    c.risorsaEsterna = "aperta"
  end)
  T.dopoOgnuno(function(c)
    eventi[#eventi + 1] = "dopo esterno"
  end)

  T.prova("nel gruppo esterno", function(c)
    eventi[#eventi + 1] = "  corpo esterno"
    T.assert.uguale("aperta", c.risorsaEsterna)
  end)

  T.gruppo("interno", function()
    T.primaDiOgnuno(function(c)
      eventi[#eventi + 1] = "  prima interno"
      c.risorsaInterna = "aperta"
    end)
    T.dopoOgnuno(function(c)
      eventi[#eventi + 1] = "  dopo interno"
    end)

    T.prova("vede entrambe le risorse", function(c)
      eventi[#eventi + 1] = "    corpo interno"
      T.assert.uguale("aperta", c.risorsaEsterna)
      T.assert.uguale("aperta", c.risorsaInterna)
    end)

    T.prova("fallisce ma la pulizia gira", function(c)
      eventi[#eventi + 1] = "    corpo che fallisce"
      T.assert.uguale(1, 2)
    end)

    T.salta("non ancora implementata", function()
      error("questa non deve girare")
    end, "funzionalita' in sviluppo")
  end)
end)

local esito = T.esegui()

print()
print("sequenza degli eventi:")
for _, e in ipairs(eventi) do print("  " .. e) end
