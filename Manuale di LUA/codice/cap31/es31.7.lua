-- ES 31.7 — Tre modi di disegnare diecimila elementi
-- Manuale completo di Lua
-- Richiede LOVE 2D: non eseguibile con l'interprete
-- Lua da solo.

local N = 10000

local strategie = {}

strategie.individuale = {
  nome = "draw individuali",
  prepara = function(stato)
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
  end,
  disegna = function(stato)
    for i = 1, N do
      local e = stato.elementi[i]
      love.graphics.draw(stato.immagine, e.x, e.y,
        e.r, 1, 1, 8, 8)
    end
  end,
}

strategie.batchOgniVolta = {
  nome = "SpriteBatch ricostruito",
  prepara = function(stato)
    stato.elementi = strategie.individuale
      .prepara and {} or {}
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
    stato.batch = love.graphics.newSpriteBatch(
      stato.immagine, N)
  end,
  disegna = function(stato)
    stato.batch:clear()
    for i = 1, N do
      local e = stato.elementi[i]
      stato.batch:add(e.x, e.y, e.r, 1, 1, 8, 8)
    end
    love.graphics.draw(stato.batch)
  end,
}

strategie.batchStatico = {
  nome = "SpriteBatch statico",
  prepara = function(stato)
    stato.elementi = {}
    for i = 1, N do
      stato.elementi[i] = {
        x = math.random() * 800,
        y = math.random() * 600,
        r = math.random() * math.pi * 2,
      }
    end
    stato.batch = love.graphics.newSpriteBatch(
      stato.immagine, N, "static")
    for i = 1, N do
      local e = stato.elementi[i]
      stato.batch:add(e.x, e.y, e.r, 1, 1, 8, 8)
    end
  end,
  disegna = function(stato)
    love.graphics.draw(stato.batch)
  end,
}

local corrente = "individuale"
local stato = {}
local misure = {}

function love.load()
  love.window.setMode(800, 600)

  local dati = love.image.newImageData(16, 16)
  dati:mapPixel(function(x, y)
    local d = math.sqrt((x - 8) ^ 2 + (y - 8) ^ 2)
    if d < 7 then return 1, 1, 1, 1 end
    return 0, 0, 0, 0
  end)
  stato.immagine = love.graphics.newImage(dati)

  math.randomseed(12345)
  strategie[corrente].prepara(stato)
end

function love.update(dt)
  local s = misure[corrente]
  if s == nil then
    s = {fotogrammi = 0, tempo = 0, fps = 0}
    misure[corrente] = s
  end
  s.fotogrammi = s.fotogrammi + 1
  s.tempo = s.tempo + dt
  if s.tempo >= 1 then
    s.fps = s.fotogrammi / s.tempo
    s.fotogrammi = 0
    s.tempo = 0
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 0.6)
  strategie[corrente].disegna(stato)

  love.graphics.setColor(1, 1, 0)
  love.graphics.print("strategia: "
    .. strategie[corrente].nome, 10, 10)
  love.graphics.print(string.format("%d elementi", N),
    10, 30)
  love.graphics.print("premi 1, 2, 3 per cambiare",
    10, 50)

  local y = 80
  for chiave, s in pairs(misure) do
    love.graphics.print(string.format("%-26s %6.1f fps",
      strategie[chiave].nome, s.fps), 10, y)
    y = y + 20
  end
end

function love.keypressed(tasto)
  local mappa = {
    ["1"] = "individuale",
    ["2"] = "batchOgniVolta",
    ["3"] = "batchStatico",
  }
  if mappa[tasto] then
    corrente = mappa[tasto]
    math.randomseed(12345)
    strategie[corrente].prepara(stato)
  elseif tasto == "escape" then
    love.event.quit()
  end
end
