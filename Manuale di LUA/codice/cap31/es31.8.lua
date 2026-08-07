-- ES 31.8 — Allocazioni del modulo vettore
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local V = {}
V.__index = V

local function nuovo(x, y)
  return setmetatable({x = x or 0, y = y or 0}, V)
end

V.__add = function(a, b) return nuovo(a.x + b.x,
  a.y + b.y) end
V.__mul = function(a, k)
  if type(a) == "number" then return nuovo(a * k.x,
    a * k.y) end
  return nuovo(a.x * k, a.y * k)
end

function V:normalizzato()
  local l = math.sqrt(self.x * self.x
    + self.y * self.y)
  if l == 0 then return nuovo(0, 0) end
  return nuovo(self.x / l, self.y / l)
end

function V:aggiungiSuPosto(altro, scala)
  scala = scala or 1
  self.x = self.x + altro.x * scala
  self.y = self.y + altro.y * scala
  return self
end

function V:normalizza()
  local l = math.sqrt(self.x * self.x
    + self.y * self.y)
  if l > 0 then
    self.x = self.x / l
    self.y = self.y / l
  end
  return self
end

local ENTITA = 1000
local FOTOGRAMMI = 1000
local DT = 1 / 60

local function creaEntita()
  local e = {}
  math.randomseed(999)
  for i = 1, ENTITA do
    e[i] = {
      posizione = nuovo(math.random() * 800,
        math.random() * 600),
      velocita = nuovo(math.random() * 100 - 50,
        math.random() * 100 - 50),
      bersaglio = nuovo(400, 300),
    }
  end
  return e
end

local function misura(nome, aggiorna)
  local entita = creaEntita()
  collectgarbage("collect")
  collectgarbage("collect")

  local prima = collectgarbage("count")
  local raccolte = 0
  local contatore = 0

  local inizio = os.clock()
  for _ = 1, FOTOGRAMMI do
    aggiorna(entita, DT)
    contatore = contatore + 1
    if contatore % 100 == 0 then
      local adesso = collectgarbage("count")
      if adesso < prima then raccolte = raccolte + 1 end
      prima = adesso
    end
  end
  local durata = os.clock() - inizio

  collectgarbage("collect")
  local dopo = collectgarbage("count")

  print(string.format(
    "%-24s %.4f s  raccolte osservate: %d  "
    .. "memoria finale %.0f KB",
    nome, durata, raccolte, dopo))
end

misura("con allocazioni", function(entita, dt)
  for i = 1, ENTITA do
    local e = entita[i]
    local verso = nuovo(
      e.bersaglio.x - e.posizione.x,
      e.bersaglio.y - e.posizione.y)
    local direzione = verso:normalizzato()
    e.velocita = e.velocita + direzione * (200 * dt)
    e.posizione = e.posizione + e.velocita * dt
  end
end)

local temporaneo = nuovo(0, 0)

misura("sul posto", function(entita, dt)
  for i = 1, ENTITA do
    local e = entita[i]
    temporaneo.x = e.bersaglio.x - e.posizione.x
    temporaneo.y = e.bersaglio.y - e.posizione.y
    temporaneo:normalizza()
    e.velocita:aggiungiSuPosto(temporaneo, 200 * dt)
    e.posizione:aggiungiSuPosto(e.velocita, dt)
  end
end)
