-- ES 31.4 — Telecamera con inseguimento morbido
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local Telecamera = {}
Telecamera.__index = Telecamera

function Telecamera.nuova(opzioni)
  opzioni = opzioni or {}
  return setmetatable({
    x = opzioni.x or 0,
    y = opzioni.y or 0,
    zoom = opzioni.zoom or 1,
    morbidezza = opzioni.morbidezza or 5,
    limiti = opzioni.limiti,
    tremolio = 0,
    intensitaTremolio = 0,
    scostamentoX = 0,
    scostamentoY = 0,
  }, Telecamera)
end

function Telecamera:segui(bersaglio, dt)
  local larghezza = love.graphics.getWidth()
  local altezza = love.graphics.getHeight()

  local desiderataX = bersaglio.x - larghezza
    / (2 * self.zoom)
  local desiderataY = bersaglio.y - altezza
    / (2 * self.zoom)

  -- Interpolazione indipendente dal frame rate:
  -- NON self.x + (desiderata - self.x) * 0.1,
  -- che dipenderebbe dai fotogrammi al secondo.
  local fattore = 1 - math.exp(-self.morbidezza * dt)
  self.x = self.x + (desiderataX - self.x) * fattore
  self.y = self.y + (desiderataY - self.y) * fattore

  if self.limiti then
    local L = self.limiti
    local visibileL = larghezza / self.zoom
    local visibileA = altezza / self.zoom

    if L.destra - L.sinistra < visibileL then
      self.x = (L.sinistra + L.destra - visibileL) / 2
    else
      if self.x < L.sinistra then self.x = L.sinistra end
      if self.x > L.destra - visibileL then
        self.x = L.destra - visibileL
      end
    end

    if L.basso - L.alto < visibileA then
      self.y = (L.alto + L.basso - visibileA) / 2
    else
      if self.y < L.alto then self.y = L.alto end
      if self.y > L.basso - visibileA then
        self.y = L.basso - visibileA
      end
    end
  end
end

function Telecamera:trema(intensita, durata)
  self.intensitaTremolio =
    math.max(self.intensitaTremolio, intensita)
  self.tremolio = math.max(self.tremolio, durata)
end

function Telecamera:aggiorna(dt)
  if self.tremolio > 0 then
    self.tremolio = self.tremolio - dt
    local scala = self.intensitaTremolio
      * math.max(0, self.tremolio)
    self.scostamentoX = (math.random() * 2 - 1) * scala
    self.scostamentoY = (math.random() * 2 - 1) * scala
    if self.tremolio <= 0 then
      self.scostamentoX = 0
      self.scostamentoY = 0
      self.intensitaTremolio = 0
    end
  end
end

function Telecamera:applica()
  love.graphics.push()
  love.graphics.scale(self.zoom)
  love.graphics.translate(
    -math.floor(self.x + self.scostamentoX),
    -math.floor(self.y + self.scostamentoY))
end

function Telecamera:rilascia()
  love.graphics.pop()
end

function Telecamera:schermoAMondo(sx, sy)
  return sx / self.zoom + self.x,
         sy / self.zoom + self.y
end

return Telecamera
