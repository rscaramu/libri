-- ES 29.4 — Suite per il modulo statistiche
-- Manuale completo di Lua

local T = require("test")
local gruppo, prova, a = T.gruppo, T.prova, T.assert

-- Il modulo da testare, in versione ridotta
local st = {}

local function valida(v, nome)
  if type(v) ~= "table" then
    return nil, nome .. ": attesa una tabella"
  end
  local n = #v
  if n == 0 then return nil, nome .. ": sequenza vuota" end
  for i = 1, n do
    if type(v[i]) ~= "number" then
      return nil, nome .. ": elemento " .. i
        .. " non numerico"
    end
  end
  return n
end

function st.media(v)
  local n, e = valida(v, "media")
  if not n then return nil, e end
  local s = 0
  for i = 1, n do s = s + v[i] end
  return s / n
end

function st.mediana(v)
  local n, e = valida(v, "mediana")
  if not n then return nil, e end
  local c = {}
  table.move(v, 1, n, 1, c)
  table.sort(c)
  if n % 2 == 1 then return c[(n + 1) // 2] end
  return (c[n // 2] + c[n // 2 + 1]) / 2
end

function st.varianza(v, campionaria)
  local n, e = valida(v, "varianza")
  if not n then return nil, e end
  if campionaria and n < 2 then
    return nil, "varianza: servono almeno due valori"
  end
  local m = st.media(v)
  local s = 0
  for i = 1, n do
    local d = v[i] - m
    s = s + d * d
  end
  return s / (campionaria and (n - 1) or n)
end

function st.percentile(v, p)
  local n, e = valida(v, "percentile")
  if not n then return nil, e end
  if type(p) ~= "number" or p < 0 or p > 100 then
    return nil, "percentile: p fra 0 e 100"
  end
  local c = {}
  table.move(v, 1, n, 1, c)
  table.sort(c)
  if n == 1 then return c[1] end
  local pos = (p / 100) * (n - 1) + 1
  local basso = math.floor(pos)
  local alto = basso + 1
  if alto > n then return c[n] end
  return c[basso] + (pos - basso) * (c[alto] - c[basso])
end

local function vicino(atteso, ottenuto, tolleranza)
  tolleranza = tolleranza or 1e-9
  return math.abs(atteso - ottenuto) < tolleranza
end

gruppo("statistiche", function()

  gruppo("casi degeneri", function()
    prova("sequenza vuota rifiutata", function()
      a.uguale(nil, st.media({}))
      a.uguale(nil, st.mediana({}))
      a.uguale(nil, st.varianza({}))
    end)

    prova("non tabella rifiutata", function()
      a.uguale(nil, st.media("x"))
      a.uguale(nil, st.media(42))
      a.uguale(nil, st.media(nil))
    end)

    prova("elemento non numerico rifiutato", function()
      a.uguale(nil, st.media({1, "due", 3}))
      a.uguale(nil, st.media({1, {}, 3}))
      a.uguale(nil, st.media({1, true}))
    end)
  end)

  gruppo("un solo elemento", function()
    prova("media di un elemento", function()
      a.uguale(5, st.media({5}))
    end)
    prova("mediana di un elemento", function()
      a.uguale(5, st.mediana({5}))
    end)
    prova("varianza di popolazione e' zero", function()
      a.uguale(0, st.varianza({5}))
    end)
    prova("varianza campionaria rifiutata", function()
      a.uguale(nil, st.varianza({5}, true))
    end)
    prova("percentile di un elemento", function()
      a.uguale(5, st.percentile({5}, 0))
      a.uguale(5, st.percentile({5}, 50))
      a.uguale(5, st.percentile({5}, 100))
    end)
  end)

  gruppo("valori tutti uguali", function()
    prova("media", function()
      a.uguale(7, st.media({7, 7, 7, 7}))
    end)
    prova("mediana", function()
      a.uguale(7, st.mediana({7, 7, 7, 7}))
    end)
    prova("varianza nulla", function()
      a.uguale(0, st.varianza({7, 7, 7, 7}))
      a.uguale(0, st.varianza({7, 7, 7, 7}, true))
    end)
  end)

  gruppo("mediana", function()
    prova("numero dispari di elementi", function()
      a.uguale(3, st.mediana({1, 3, 5}))
      a.uguale(3, st.mediana({5, 1, 3}))
    end)
    prova("numero pari e' la media dei centrali",
      function()
        a.uguale(3, st.mediana({1, 2, 4, 6}))
      end)
    prova("non modifica l'ingresso", function()
      local v = {3, 1, 2}
      st.mediana(v)
      a.uguale({3, 1, 2}, v)
    end)
    prova("valori negativi", function()
      a.uguale(-2, st.mediana({-5, -2, 1}))
    end)
  end)

  gruppo("varianza", function()
    prova("popolazione", function()
      -- {2,4,4,4,5,5,7,9}: media 5, varianza 4
      a.vero(vicino(4,
        st.varianza({2,4,4,4,5,5,7,9})))
    end)
    prova("campionaria e' maggiore", function()
      local v = {2,4,4,4,5,5,7,9}
      a.vero(st.varianza(v, true) > st.varianza(v))
    end)
    prova("due valori", function()
      a.uguale(0.25, st.varianza({1, 2}))
      a.uguale(0.5, st.varianza({1, 2}, true))
    end)
  end)

  gruppo("percentile", function()
    prova("p=0 e' il minimo", function()
      a.uguale(1, st.percentile({1, 2, 3, 4}, 0))
    end)
    prova("p=100 e' il massimo", function()
      a.uguale(4, st.percentile({1, 2, 3, 4}, 100))
    end)
    prova("p=50 coincide con la mediana", function()
      local v = {1, 2, 3, 4, 5}
      a.uguale(st.mediana(v), st.percentile(v, 50))
    end)
    prova("interpolazione fra due valori", function()
      a.vero(vicino(1.5, st.percentile({1, 2}, 50)))
    end)
    prova("p fuori intervallo rifiutato", function()
      a.uguale(nil, st.percentile({1, 2}, -1))
      a.uguale(nil, st.percentile({1, 2}, 101))
      a.uguale(nil, st.percentile({1, 2}, "meta'"))
    end)
    prova("ordine dell'ingresso irrilevante",
      function()
        local ordinata = st.percentile({1,2,3,4,5}, 25)
        local mescolata =
          st.percentile({3,1,5,2,4}, 25)
        a.uguale(ordinata, mescolata)
      end)
  end)

  gruppo("valori speciali", function()
    prova("negativi", function()
      a.uguale(-2, st.media({-1, -2, -3}))
    end)
    prova("misti positivi e negativi", function()
      a.uguale(0, st.media({-5, 0, 5}))
    end)
    prova("float", function()
      a.vero(vicino(1.5, st.media({1.0, 2.0})))
    end)
    prova("zero non e' trattato come assente",
      function()
        a.uguale(0, st.media({0, 0, 0}))
      end)
  end)

end)

os.exit(T.esegui() and 0 or 1)
