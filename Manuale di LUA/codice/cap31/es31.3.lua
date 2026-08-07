-- ES 31.3 — Particelle, nemici e potenziamenti
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local Particelle = {}
Particelle.__index = Particelle

function Particelle.nuovo(massimo)
  return setmetatable({
    vive = {},
    libere = {},
    massimo = massimo or 500,
  }, Particelle)
end

function Particelle:emetti(x, y, quante, colore)
  for _ = 1, quante do
    if #self.vive >= self.massimo then break end
    local p = table.remove(self.libere) or {}
    local angolo = math.random() * math.pi * 2
    local velocita = 50 + math.random() * 200
    p.x, p.y = x, y
    p.vx = math.cos(angolo) * velocita
    p.vy = math.sin(angolo) * velocita
    p.vita = 0.4 + math.random() * 0.6
    p.vitaIniziale = p.vita
    p.raggio = 1 + math.random() * 3
    p.colore = colore
    self.vive[#self.vive + 1] = p
  end
end

function Particelle:aggiorna(dt)
  for i = #self.vive, 1, -1 do
    local p = self.vive[i]
    p.vita = p.vita - dt
    if p.vita <= 0 then
      table.remove(self.vive, i)
      self.libere[#self.libere + 1] = p
    else
      p.x = p.x + p.vx * dt
      p.y = p.y + p.vy * dt
      p.vy = p.vy + 200 * dt        -- gravita'
      p.vx = p.vx * (1 - 2 * dt)    -- attrito
    end
  end
end

function Particelle:disegna()
  for _, p in ipairs(self.vive) do
    local a = p.vita / p.vitaIniziale
    local c = p.colore
    love.graphics.setColor(c[1], c[2], c[3], a)
    love.graphics.circle("fill", p.x, p.y,
      p.raggio * a)
  end
end

local TIPI_NEMICO = {
  dritto = {
    colore = {0.9, 0.3, 0.3},
    raggio = 16,
    punti = 10,
    aggiorna = function(n, dt)
      n.y = n.y + n.velocita * dt
    end,
  },
  ondulato = {
    colore = {0.9, 0.6, 0.2},
    raggio = 14,
    punti = 20,
    aggiorna = function(n, dt)
      n.tempo = n.tempo + dt
      n.y = n.y + n.velocita * dt
      n.x = n.baseX
        + math.sin(n.tempo * 3) * n.ampiezza
    end,
  },
  inseguitore = {
    colore = {0.8, 0.2, 0.8},
    raggio = 12,
    punti = 30,
    aggiorna = function(n, dt, bersaglio)
      n.y = n.y + n.velocita * 0.7 * dt
      local dx = bersaglio.x - n.x
      local direzione = 0
      if dx > 2 then direzione = 1
      elseif dx < -2 then direzione = -1 end
      n.x = n.x + direzione * 120 * dt
    end,
  },
}

local POTENZIAMENTI = {
  fuocoRapido = {
    colore = {0.3, 0.9, 0.9},
    durata = 6,
    applica = function(g) g.ricaricaBase = 0.08 end,
    rimuovi = function(g) g.ricaricaBase = 0.25 end,
  },
  scudo = {
    colore = {0.9, 0.9, 0.3},
    durata = 8,
    applica = function(g) g.invulnerabile = true end,
    rimuovi = function(g) g.invulnerabile = false end,
  },
}

local function creaNemico(tipo, larghezza)
  local modello = TIPI_NEMICO[tipo]
  local raggio = modello.raggio
  local x = math.random(raggio, larghezza - raggio)
  return {
    tipo = tipo,
    modello = modello,
    x = x,
    baseX = x,
    y = -raggio,
    raggio = raggio,
    velocita = 80 + math.random() * 80,
    tempo = 0,
    ampiezza = 40 + math.random() * 60,
  }
end

local function aggiornaPotenziamenti(gioco, dt)
  for nome, attivo in pairs(gioco.potenziamenti) do
    attivo.rimasto = attivo.rimasto - dt
    if attivo.rimasto <= 0 then
      POTENZIAMENTI[nome].rimuovi(gioco)
      gioco.potenziamenti[nome] = nil
    end
  end
end

local function attiva(gioco, nome)
  local p = POTENZIAMENTI[nome]
  if p == nil then return end
  if gioco.potenziamenti[nome] == nil then
    p.applica(gioco)
  end
  gioco.potenziamenti[nome] = {rimasto = p.durata}
end

return {
  Particelle = Particelle,
  TIPI_NEMICO = TIPI_NEMICO,
  POTENZIAMENTI = POTENZIAMENTI,
  creaNemico = creaNemico,
  attiva = attiva,
  aggiornaPotenziamenti = aggiornaPotenziamenti,
}
